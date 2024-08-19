
import UIKit

import SnapKit
import RxCocoa

final class PostedStudyViewController: CommonNavi{
  
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
    return button
  }()
  
  private lazy var participateButton = StudyHubButton(title: "참여하기")
  private lazy var bottomButtonStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  
  private lazy var scrollView: UIScrollView = UIScrollView()
  
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
    setupNavigation()
    
    view.backgroundColor = .white
    
    setupDelegate()
    setupBindings()
    addActions()
    
    setUpLayout()
    makeUI()
  }
  
  func setupNavigation(){
    leftButtonSetting()
    rightButtonSetting(imgName: "RightButtonImg")
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
    
    similarPostStackView.layoutMargins = UIEdgeInsets(top: 100, left: 20, bottom: 30, right: 10)
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
  
  // MARK: - setupBindings
  
  
  func setupBindings(){
    viewModel.postDatas
      .subscribe(onNext: { [weak self] in
        self?.aboutStudyDeatilLabel.text = $0?.content
        if $0?.usersPost == false {
          self?.navigationItem.rightBarButtonItem = nil
        }
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
    
    viewModel.isBookmarked
      .asDriver()
      .drive(onNext: { [weak self] in
        let bookmarkImg = $0 ? "BookMarkChecked" : "BookMarkLightImg"
        self?.bookmarkButton.setImage(UIImage(named: bookmarkImg), for: .normal)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.dataFromPopupView
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        $0 == "삭제" ? deleteMyPost() : showModifyView(vc: self)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - addActions
  
  func addActions(){
    bookmarkButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let postID = self?.viewModel.postDatas.value?.postID else { return }
        self?.viewModel.bookmarkTapped(postId: postID)
        self?.viewModel.bookmarkToggle()
      })
      .disposed(by: viewModel.disposeBag)
  }
  
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
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    guard let postID = viewModel.postDatas.value?.postID else { return }
    let bottomSheetVC = BottomSheet(
      postID: postID,
      checkMyPost: true,
      firstButtonTitle: "삭제하기",
      secondButtonTitle: "수정하기"
    )
    bottomSheetVC.delegate = self
    
    showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    present(bottomSheetVC, animated: true, completion: nil)
  }
  
  func deleteMyPost(){
    guard let postID = self.viewModel.postDatas.value?.postID else { return }
    
    deleteMyPost(postID) { _ in
      self.dismiss(animated: true)
    }
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

extension PostedStudyViewController: BottomSheetDelegate {
  func firstButtonTapped(postID: Int) {
    let popupVC = PopupViewController(
      title: "글을 삭제할까요?",
      dataStream: viewModel.dataFromPopupView)
    
    popupVC.modalPresentationStyle = .overFullScreen
    
    self.present(popupVC, animated: true)
  }
  
  func secondButtonTapped(postID: Int){
    let popupVC = PopupViewController(
      title: "글을 수정할까요?",
      leftButtonTitle: "아니요",
      rightButtonTilte: "네",
      dataStream: viewModel.dataFromPopupView)
    popupVC.modalPresentationStyle = .overFullScreen
    
    self.present(popupVC, animated: true)
  }
}

extension PostedStudyViewController: CreateDividerLine {}
extension PostedStudyViewController: ShowBottomSheet, StudyBottomSheet {}
extension PostedStudyViewController: CommentCellDelegate {}
