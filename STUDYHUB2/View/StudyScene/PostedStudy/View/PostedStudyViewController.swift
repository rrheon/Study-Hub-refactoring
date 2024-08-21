
import UIKit

import SnapKit
import RxCocoa
import RxSwift

// 해야할 거 -> 수정하기 이동 시 데이터 안받아짐, 삭제하기 북마크 작동 후 이전페이지 작업, 댓글페이지
final class PostedStudyViewController: CommonNavi{
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
  
  init(_ data: PostedStudyViewData) {
    self.viewModel = PostedStudyViewModel(data)
    
    mainComponent = PostedStudyMainComponent(data.postDetailData)
    detailInfoComponent = PostedStudyDetailInfoConponent(data.postDetailData)
    writerComponent = PostedStudyWriterComponent(data.postDetailData)
    
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    viewModel.isNeedFetch?.accept(true)
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
    
    pageStackView.snp.makeConstraints {
      $0.top.equalTo(scrollView.contentLayoutGuide)
      $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view)
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
    
    viewModel.countComment
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        let value = count <= 8 ? count : 8
        self?.commentComponent.snp.remakeConstraints {
          $0.height.equalTo(value * 86 + 160)
        }
        
        self?.commentComponent.commentTableView.snp.remakeConstraints {
          $0.height.equalTo(value * 86)
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
          cell.userNickname = self.viewModel.userNickanme
          cell.selectionStyle = .none
          cell.contentView.isUserInteractionEnabled = false
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
    
    viewModel.countRelatedPost
      .subscribe(onNext: { [weak self] in
        if $0 == 0 {
          self?.similarPostStackView.isHidden = true
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

    // 게시글 삭제 후 나가고 토스트 팝업 띄우면 될듯 어떻게하실?

    viewModel.dataFromPopupView
      .subscribe(onNext: { [weak self] action in
        guard let self = self else { return }
        switch action {
        case .deletePost:
          viewModel.deleteMyPost {
            self.navigationController?.popViewController(animated: true)
          }
        case .editPost:
          guard let postID = viewModel.postDatas.value?.postID else { return }
          let modifyVC = CreateStudyViewController(postID: postID)
          modifyVC.hidesBottomBarWhenPushed = true
          navigationController?.pushViewController(modifyVC, animated: true)
        case .deleteComment:
          viewModel.commentManager.deleteComment(commentID: viewModel.postOrCommentID) {
            if $0 {
              self.viewModel.fetchCommentDatas()
            }
          }
        case .editComment:
          commentComponent.commentButton.setTitle("수정", for: .normal)
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    commentComponent.commentTextField.rx.text.orEmpty
      .bind(to: viewModel.commentTextFieldValue)
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentTextFieldValue
      .subscribe(onNext: { [weak self] in
        self?.commentComponent.commentButton.unableButton(
          !$0.isEmpty,
          backgroundColor: .o30,
          titleColor: .white
        )
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.singlePostData
      .subscribe(onNext: { [weak self] in
        let loginStatus = self?.viewModel.isUserLogined
        let postData = PostedStudyData(isUserLogin: loginStatus ?? false, postDetailData: $0)
        let postedStudyVC = PostedStudyViewController(postData)
        postedStudyVC.hidesBottomBarWhenPushed = true
        self?.navigationController?.pushViewController(postedStudyVC, animated: true)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isActivateParticipate
      .subscribe(onNext: { [weak self] in
        guard let studyID = self?.viewModel.postedStudyData.postDetailData.studyID else { return }
        $0 ? self?.goToParticipateVC(studyID: studyID) : self?.goToLoginVC()
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
    
    similarCollectionView.rx.modelSelected(RelatedPost.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        let postID = item.postID
        self?.viewModel.similarCellTapped(postID)
      })
      .disposed(by: viewModel.disposeBag)

    commentComponent.commentButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let postID = self?.viewModel.postDatas.value?.postID,
              let content = self?.viewModel.commentTextFieldValue.value,
              let commentID = self?.viewModel.postOrCommentID else { return }
        let title = self?.commentComponent.commentButton.currentTitle
        
        switch title {
        case "수정":
          self?.modifyComment(content: content, commentID: commentID)
        case "등록":
          self?.createComment(content: content, postID: postID)
        case .none:
          return
        case .some(_):
          return
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    commentComponent.moveToCommentViewButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let postID = self?.viewModel.postDatas.value?.postID else { return }
        let commentVC = CommentViewController(postID: postID)
        commentVC.hidesBottomBarWhenPushed = true
        self?.navigationController?.pushViewController(commentVC, animated: true)
      })
      .disposed(by: viewModel.disposeBag)
    
    participateButton.rx.tap
      .asDriver()
      .throttle(.seconds(1))
      .drive(onNext: { [weak self] in
        self?.viewModel.participateButtonTapped(completion: { action in
          DispatchQueue.main.async {
            switch action {
            case .closed:
              self?.showToast(message: "이미 마감된 스터디예요", alertCheck: false)
            case .goToLoginVC:
              self?.goToLoginVC()
            case .goToParticipateVC:
              guard let studyID = self?.viewModel.postedStudyData.postDetailData.studyID else { return }
              self?.goToParticipateVC(studyID: studyID)
            case .limitedGender:
              self?.showToast(message: "이 스터디는 성별 제한이 있는 스터디예요", alertCheck: false)
            }
          }
        })
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
      secondButtonTitle: "수정하기",
      checkPost: true
    )
    bottomSheetVC.delegate = self
    
    showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    present(bottomSheetVC, animated: true, completion: nil)
  }
  
  func deleteMyPost(){
    guard let postID = self.viewModel.postDatas.value?.postID else { return }
    viewModel.deleteMyPost(postID) { _ in
      self.dismiss(animated: true)
    }
  }
  
  func createComment(content: String, postID: Int) {
    viewModel.commentManager.createComment(
      content: content,
      postID: postID
    ) { [weak self] success in
      guard success else { return }
      self?.settingComment(mode: "생성")
    }
  }
  
  func modifyComment(content: String, commentID: Int) {
    viewModel.commentManager.modifyComment(
      content: content,
      commentID: commentID
    ) { [weak self] success in
      self?.settingComment(mode: "수정")
    }
  }
  
  func settingComment(mode: String){
    viewModel.fetchCommentDatas()
    let message = mode == "생성" ? "댓글이 작성됐어요" : "댓글이 수정됐어요"
    self.showToast(message: message,imageCheck: false)
    
    commentComponent.commentButton.setTitle("등록", for: .normal)
    commentComponent.commentTextField.text = nil
    commentComponent.commentTextField.resignFirstResponder()
  }
}

// MARK: - extension

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
  func firstButtonTapped(postID: Int, checkPost: Bool) {
    viewModel.postOrCommentID = postID
    let action: PopupActionType = checkPost ? .deletePost : .deleteComment
    let title = action == .deletePost ? "글을 삭제할까요?" : "댓글을 삭제할까요?"
    let popupVC = PopupViewController(
      title: title,
      dataStream: viewModel.dataFromPopupView,
      selectAction: action)
    
    popupVC.modalPresentationStyle = .overFullScreen
    
    self.present(popupVC, animated: true)
  }
  
  func secondButtonTapped(postID: Int, checkPost: Bool) {
    viewModel.postOrCommentID = postID
    let action: PopupActionType = checkPost ? .editPost : .editComment
    if action == .editPost {
    let popupVC = PopupViewController(
      title: "글을 수정할까요?",
      leftButtonTitle: "아니요",
      rightButtonTilte: "네",
      dataStream: viewModel.dataFromPopupView,
      selectAction: .editPost)
    popupVC.modalPresentationStyle = .overFullScreen
    
    self.present(popupVC, animated: true)
    } else {
      commentComponent.commentButton.setTitle("수정", for: .normal)
    }
  }
  
  func goToParticipateVC(studyID: Int){
    let participateVC = ParticipateVC()
    participateVC.studyId = studyID
    participateVC.beforeVC = self
    self.navigationController?.pushViewController(participateVC, animated: true)
  }
  
  func goToLoginVC(){
    DispatchQueue.main.async {
        let popupVC = PopupViewController(title: "로그인이 필요해요",
                                          desc: "계속하려면 로그인을 해주세요!",
                                          rightButtonTilte: "로그인")
        self.present(popupVC, animated: true)
       
        popupVC.popupView.rightButtonAction = {
          self.dismiss(animated: true) {
            if let navigationController = self.navigationController {
              navigationController.popToRootViewController(animated: false)
              
              let loginVC = LoginViewController()
              
              loginVC.modalPresentationStyle = .overFullScreen
              navigationController.present(loginVC, animated: true, completion: nil)
            }
          }
        }
      }
  }
}

extension PostedStudyViewController: CreateDividerLine {}
extension PostedStudyViewController: ShowBottomSheet {}
extension PostedStudyViewController: CommentCellDelegate {
  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
    let bottomSheetVC = BottomSheet(postID: commentId, checkPost: false)
    bottomSheetVC.delegate = self
    
    showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    present(bottomSheetVC, animated: true, completion: nil)
  }
}


