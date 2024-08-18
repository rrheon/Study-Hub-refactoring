//
//  PostedStudyViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/30.
//

import UIKit

import SnapKit
import RxCocoa

final class PostedStudyViewController: NaviHelper, CreateDividerLine, CommentCellDelegate {
  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
    print("test")
  }
  
  let viewModel: PostedStudyViewModel
  
  private var mainComponent: PostedStudyMainComponent
  
  private lazy var aboutStudyLabel = createLabel(
    title: "소개",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var aboutStudyDeatilLabel = createLabel(
    title: "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var aboutStudyStackView = createStackView(axis: .vertical, spacing: 10)
  private var detailInfoComponent: PostedStudyDetailInfoConponent
  
  private lazy var divideLineTopWriterInfo = createDividerLine(height: 8.0)
  private lazy var divideLineUnderWriterInfo = createDividerLine(height: 8.0)
  private var writerComponent: PostedStudyWriterComponent
  
  private lazy var commentComponent = PostedStudyCommentComponent()
  
  private lazy var similarPostLabel = createLabel(
    title: "이 글과 비슷한 스터디예요",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 18
  )
  
  private lazy var similarCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var similarPostStackView = createStackView(axis: .vertical, spacing: 20)
  
  private lazy var bookmarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    //    button.addAction(UIAction { _ in
    //      self.bookmarkButtonTappedAtPostedVC()
    //    } , for: .touchUpInside)
    return button
  }()
  
  private lazy var participateButton = StudyHubButton(title: "참여하기")
  
  private lazy var bottomButtonStackView = createStackView(axis: .horizontal, spacing: 10)
  
  // 전체 요소를 담는 스택
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  
  private lazy var scrollView: UIScrollView = UIScrollView()
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  
  init(_ postDatas: PostDetailData) {
    self.viewModel = PostedStudyViewModel(postDatas)
    
    self.mainComponent = PostedStudyMainComponent(postDatas)
    self.detailInfoComponent = PostedStudyDetailInfoConponent(postDatas)
    self.writerComponent = PostedStudyWriterComponent(postDatas)
    
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItemSetting()
    
    view.backgroundColor = .white

    setupDelegate()
    setupBindings()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    let grayDividerLine = createDividerLine(height: 1.0)
    
    [
      aboutStudyLabel,
      aboutStudyDeatilLabel,
      grayDividerLine
    ].forEach {
      aboutStudyStackView.addArrangedSubview($0)
    }
        
    [
      similarPostLabel,
      similarCollectionView
    ].forEach {
      similarPostStackView.addArrangedSubview($0)
    }
    
    [
      bookmarkButton,
      participateButton
    ].forEach {
      bottomButtonStackView.addArrangedSubview($0)
    }
    
    [
      mainComponent,
      aboutStudyStackView,
      detailInfoComponent,
      divideLineTopWriterInfo,
      writerComponent,
      divideLineUnderWriterInfo,
      commentComponent,
      similarPostStackView,
      bottomButtonStackView
    ].forEach {
      pageStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(pageStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  private func makeUI() {
    mainComponent.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    aboutStudyStackView.backgroundColor = .white
    aboutStudyDeatilLabel.numberOfLines = 0
    aboutStudyStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10)
    aboutStudyStackView.isLayoutMarginsRelativeArrangement = true
    
    detailInfoComponent.snp.makeConstraints {
      $0.top.equalTo(aboutStudyStackView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    divideLineTopWriterInfo.snp.makeConstraints {
      $0.top.equalTo(detailInfoComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    writerComponent.snp.makeConstraints {
      $0.top.equalTo(divideLineTopWriterInfo.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    divideLineUnderWriterInfo.snp.makeConstraints {
      $0.top.equalTo(writerComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    commentComponent.snp.makeConstraints {
      $0.top.equalTo(divideLineUnderWriterInfo.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    similarPostStackView.layoutMargins = UIEdgeInsets(top: 40, left: 20, bottom: 30, right: 10)
    similarPostStackView.isLayoutMarginsRelativeArrangement = true
    
    similarCollectionView.snp.makeConstraints {
      $0.height.equalTo(171)
    }
    
    bottomButtonStackView.distribution = .fillProportionally
    bottomButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    bottomButtonStackView.isLayoutMarginsRelativeArrangement = true
    
    participateButton.snp.makeConstraints {
      $0.height.equalTo(55)
    }
    
    pageStackView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.contentLayoutGuide)
      make.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }
  
  func setupBindings(){
    viewModel.postDatas
      .subscribe(onNext: { [weak self] in
        self?.aboutStudyDeatilLabel.text = $0?.content
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.countComment
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        self?.commentComponent.snp.makeConstraints {
          $0.height.equalTo(count * 86 + 74)
        }
        
        self?.commentComponent.countComment = count
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentDatas
      .bind(to: commentComponent.commentTableView.rx.items(
        cellIdentifier: CommentCell.cellId,
        cellType: CommentCell.self)) { index, content, cell in
          cell.model = content
          cell.delegate = self
        }
        .disposed(by: viewModel.disposeBag)

    viewModel.relatedPostDatas
      .map { Array($0.prefix(3)) }
      .bind(to: similarCollectionView.rx.items(
        cellIdentifier:SimilarPostCell.id,
        cellType: SimilarPostCell.self)) { index, content, cell in
          cell.model = content
        }
        .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - collectionview 관련
  private func setupDelegate() {
    commentComponent.commentTableView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    
    similarCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    
    similarCollectionView.register(
      SimilarPostCell.self,
      forCellWithReuseIdentifier: SimilarPostCell.id
    )
    
    commentComponent.commentTableView.register(
      CommentCell.self,
      forCellReuseIdentifier: CommentCell.cellId
    )
  }
}

extension PostedStudyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 250, height: collectionView.frame.height)
  }
}

extension PostedStudyViewController: UITableViewDelegate  {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
}
