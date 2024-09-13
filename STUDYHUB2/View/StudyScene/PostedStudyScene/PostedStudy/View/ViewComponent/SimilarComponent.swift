import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SimilarStudyComponent: UIView {
  let viewModel: PostedStudyViewModel
  
  private lazy var similarPostLabel: UILabel = createLabel(
    title: "이 글과 비슷한 스터디예요",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 18
  )
  
  lazy var similarCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  lazy var similarPostStackView: UIStackView = createStackView(axis: .vertical, spacing: 20)
  private lazy var bottomButtonStackView: UIStackView = createStackView(
    axis: .horizontal,
    spacing: 10
  )
  
  lazy var bookmarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    return button
  }()
  
  lazy var participateButton = StudyHubButton(title: "참여하기")
  
  // MARK: - init
  
  init(_ viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupLayout()
    makeUI()
    setupBinding()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    similarPostStackView.addArrangedSubview(similarPostLabel)
    similarPostStackView.addArrangedSubview(similarCollectionView)
    
    bottomButtonStackView.addArrangedSubview(bookmarkButton)
    bottomButtonStackView.addArrangedSubview(participateButton)
    
    addSubview(similarPostStackView)
    addSubview(bottomButtonStackView)
  }
  
  // MARK: - makeUI
  
  
  private func makeUI() {
    similarPostStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 10)
    similarPostStackView.isLayoutMarginsRelativeArrangement = true
    
    similarCollectionView.snp.makeConstraints {
      $0.height.equalTo(171)
    }
    
    bottomButtonStackView.distribution = .fillProportionally
    bottomButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
    bottomButtonStackView.isLayoutMarginsRelativeArrangement = true
    
    bookmarkButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(45)
      $0.height.equalTo(55)
    }
    
    participateButton.snp.makeConstraints {
      $0.top.equalTo(bookmarkButton)
      $0.leading.equalTo(bookmarkButton.snp.trailing).offset(40)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
    
    similarPostStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    bottomButtonStackView.snp.makeConstraints {
      $0.top.equalTo(similarPostStackView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  // MARK: - setupBinding
  
  
  func setupBinding(){
    viewModel.postDatas
      .subscribe(onNext: { [weak self] in
        if $0?.close == true {
          self?.participateButton.unableButton(false, backgroundColor: .o30 ,titleColor: .white)
          self?.participateButton.setTitle("마감된 스터디에요", for: .normal)
        }
        
        if $0?.apply == true {
          self?.participateButton.unableButton(false, backgroundColor: .o30 ,titleColor: .white)
          self?.participateButton.setTitle("수락 대기 중", for: .normal)
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.relatedPostDatas
      .map { Array($0.prefix(3)) }
      .bind(to: similarCollectionView.rx.items(
        cellIdentifier:SimilarPostCell.id,
        cellType: SimilarPostCell.self)) { index, content, cell in
          cell.model = content
        }
        .disposed(by: viewModel.disposeBag)
    
    viewModel.countRelatedPost
      .subscribe(onNext: { [weak self] in
        if $0 == 0 {
          self?.similarPostLabel.isHidden = true
          self?.similarCollectionView.isHidden = true
          self?.snp.remakeConstraints {
            $0.height.equalTo(108)
          }
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isBookmarked
      .asDriver()
      .drive(onNext: { [weak self] in
        let bookmarkImg = $0 ? "BookMarkChecked" : "BookMarkLightImg"
        self?.bookmarkButton.setImage(UIImage(named: bookmarkImg), for: .normal)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: -  setupActions
  
  
  func setupActions(){
    bookmarkButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let postID = self?.viewModel.postDatas.value?.postID else { return }
        self?.viewModel.bookmarkTapped(postId: postID)
        self?.viewModel.bookmarkToggle()
      })
      .disposed(by: viewModel.disposeBag)
    
    similarCollectionView.rx.modelSelected(RelatedPost.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        let postID = item.postID
        self?.viewModel.similarCellTapped(postID)
      })
      .disposed(by: viewModel.disposeBag)
  }
}

extension SimilarStudyComponent: CreateUIprotocol {}
