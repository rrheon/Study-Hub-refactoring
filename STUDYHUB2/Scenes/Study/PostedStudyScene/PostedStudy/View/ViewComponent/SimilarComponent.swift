
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 유사한 스터디 component
final class SimilarStudyComponent: UIView {
  let disposeBag: DisposeBag = DisposeBag()
  var viewModel: PostedStudyViewModel

  /// 유사한 스터디 제목 라벨
  private lazy var similarPostLabel: UILabel = UILabel().then {
    $0.text = "이 글과 비슷한 스터디예요"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
  }
  
  /// 유사한 스터디 collectinoview
  lazy var similarCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  /// 유사한 스터디 스택뷰
  lazy var similarPostStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 20)
  
  /// 북마크 ,참여하기버튼  스택뷰
  private lazy var bottomButtonStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  
  /// 북마크 버튼
  lazy var bookmarkButton: UIButton = UIButton().then{
    $0.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
  }

  /// 참여하기 버튼
  lazy var participateButton = StudyHubButton(title: "참여하기")
  
  // MARK: - init
  
  init(with viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    
    super.init(frame: .zero)
    
    setupLayout()
    makeUI()
    setupBinding()
    setupActions()
    
    similarCollectionView.showsVerticalScrollIndicator = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 설정
  private func setupLayout() {
    similarPostStackView.addArrangedSubview(similarPostLabel)
    similarPostStackView.addArrangedSubview(similarCollectionView)
    
    bottomButtonStackView.addArrangedSubview(bookmarkButton)
    bottomButtonStackView.addArrangedSubview(participateButton)
    
    addSubview(similarPostStackView)
    addSubview(bottomButtonStackView)
  }
  
  // MARK: - makeUI
  
  /// UI 설정
  private func makeUI() {
    similarPostStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 10)
    similarPostStackView.isLayoutMarginsRelativeArrangement = true
    
    similarCollectionView.snp.makeConstraints {
      $0.height.equalTo(171)
    }
    
    bottomButtonStackView.distribution = .fillProportionally
    bottomButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
    bottomButtonStackView.isLayoutMarginsRelativeArrangement = true
  
    similarPostStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    if let isUsersPost = viewModel.postDatas.value?.usersPost, !isUsersPost {
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
      
      bottomButtonStackView.snp.makeConstraints {
        $0.top.equalTo(similarPostStackView.snp.bottom).offset(10)
        $0.leading.trailing.equalToSuperview()
      }
    }
  }
  
  // MARK: - setupBinding
  
  /// 바인딩
  func setupBinding(){
    
    /// 포스트 데이터
    viewModel.postDatas
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, nil))
      .drive(onNext: { (component, data) in
        
        // 유사한 스터디 체크
        if data?.relatedPost.count == 0 {
          component.similarPostLabel.isHidden = true
          component.similarCollectionView.isHidden = true
          component.snp.remakeConstraints {
            $0.height.equalTo(108)
          }
        }
     
        // 스터디 마감 여부 체크
        if data?.close == true {
          component.participateButton.unableButton(false, backgroundColor: .o30 ,titleColor: .white)
          component.participateButton.setTitle("마감된 스터디에요", for: .normal)
        }
        
        // 지원한 스터디 체크
        if data?.apply == true {
          component.participateButton.unableButton(false, backgroundColor: .o30 ,titleColor: .white)
          component.participateButton.setTitle("수락 대기 중", for: .normal)
        }
       
        // 북마크한 스터디 체크
        let bookmarkImg = data?.bookmarked ?? false ? "BookMarkChecked" : "BookMarkLightImg"
        component.bookmarkButton.setImage(UIImage(named: bookmarkImg), for: .normal)
      })
      .disposed(by: disposeBag)
    
    /// 유사한 스터디 데이터
    viewModel.postDatas
      .compactMap { Array($0?.relatedPost ?? []) }
      .bind(to: similarCollectionView.rx.items(
        cellIdentifier: SimilarPostCell.cellID,
        cellType: SimilarPostCell.self)) { index, content, cell in
          cell.model = content
        }
      .disposed(by: disposeBag)

  }
  
  // MARK: -  setupActions
  
  /// Actions 설정
  func setupActions(){
    // 북마크 터치 시
    bookmarkButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let postID = self?.viewModel.postDatas.value?.postID else { return }
        BookmarkManager.shared.bookmarkTapped(with: postID) {
          self?.viewModel.bookmarkToggle()
        }
      })
      .disposed(by: disposeBag)
    
    /// 유사한 스터디 셀.터치 시 해당 스터디 화면으로 이동
    similarCollectionView.rx.modelSelected(RelatedPost.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { (component, cellData) in
        let postID = cellData.postID
        component.viewModel.steps.accept(AppStep.studyDetailScreenIsRequired(postID: postID))
      })
      .disposed(by: disposeBag)
    
    // 참여하기 버튼 터치 시
    participateButton.rx.tap
      .asDriver()
      .throttle(.seconds(1))
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
//        self.viewModel.participateButtonTapped(completion: { action in
//          DispatchQueue.main.async {
//            switch action {
//            case .closed:
//              self.viewModel.showToastMessage.accept("이미 마감된 스터디예요")
//            case .goToLoginVC:
//              self.viewModel.moveToLoginVC.accept(true)
//            case .goToParticipateVC:
//              let studyID = self.viewModel.postedStudyData.postDetailData.studyID
//              self.viewModel.moveToParticipateVC.accept(studyID)
//            case .limitedGender:
//              self.viewModel.showToastMessage.accept("이 스터디는 성별 제한이 있는 스터디예요")
//            }
//          }
//        })
      })
      .disposed(by: disposeBag)
  }
}

