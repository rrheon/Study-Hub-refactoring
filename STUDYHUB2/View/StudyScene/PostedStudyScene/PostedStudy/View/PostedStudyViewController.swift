
import UIKit

import SnapKit
import RxCocoa
import RxSwift

// 각 요소들 바인딩 제대로 하기, 데이터가 들어왔을 때
final class PostedStudyViewController: CommonNavi{
  let viewModel: PostedStudyViewModel
  
  private var mainComponent: PostedStudyMainComponent
  private var detailInfoComponent: PostedStudyDetailInfoComponent
  private var writerComponent: PostedStudyWriterComponent
  private var commentComponent: PostedStudyCommentComponent
  private var similarStudyComponent: SimilarStudyComponent
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  init(_ data: PostedStudyViewData) {
    self.viewModel = PostedStudyViewModel(data)
    
    mainComponent = PostedStudyMainComponent(viewModel)
    detailInfoComponent = PostedStudyDetailInfoComponent(viewModel)
    writerComponent = PostedStudyWriterComponent(viewModel)
    commentComponent = PostedStudyCommentComponent(viewModel)
    similarStudyComponent = SimilarStudyComponent(viewModel)
    
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
    
    setUpLayout()
    makeUI()
  }
  
  func setupNavigation(){
    leftButtonSetting()
    rightButtonSetting(imgName: "RightButtonImg")
  }
  
  // MARK: - setUpLayout
  
  func setUpLayout(){
    [
      mainComponent,
      detailInfoComponent,
      writerComponent,
      commentComponent,
      similarStudyComponent
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
    
    detailInfoComponent.snp.makeConstraints {
      $0.top.equalTo(mainComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    writerComponent.snp.makeConstraints {
      $0.top.equalTo(detailInfoComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    commentComponent.snp.makeConstraints {
      $0.top.equalTo(writerComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    similarStudyComponent.snp.makeConstraints {
      $0.top.equalTo(commentComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(408)
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
        if $0?.usersPost == false {
          self?.navigationItem.rightBarButtonItem = nil
        }
      })
      .disposed(by: viewModel.disposeBag)
        
    viewModel.dataFromPopupView
      .subscribe(onNext: { [weak self] action in
        guard let self = self else { return }
        switch action {
        case .deletePost:
          viewModel.deleteMyPost {
            self.navigationController?.popViewController(animated: false)
            self.showToast(message: "삭제가 완료됐어요.")
          }
        case .editPost:
          let postData = viewModel.postDatas
          let modifyVC = CreateStudyViewController(postData)
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
    
    viewModel.showToastMessage
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] in
        self?.showToast(message: $0, imageCheck: false)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.showBottomSheet
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self]  in
        let bottomSheetVC = BottomSheet(postID: $0, checkPost: false)
        bottomSheetVC.delegate = self
        
        self?.showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
        self?.present(bottomSheetVC, animated: true, completion: nil)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.moveToCommentVC
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController($0, animated: true)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.moveToLoginVC
      .subscribe(onNext: { [weak self] _ in
        self?.goToLoginVC()
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.moveToParticipateVC
      .subscribe(onNext: { [weak self] in
        self?.goToParticipateVC(studyID: $0)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  private func setupDelegate() {
    commentComponent.commentTableView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    
    commentComponent.commentTableView.register(
      CommentCell.self,
      forCellReuseIdentifier: CommentCell.cellId
    )
    
    similarStudyComponent.similarCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    
    similarStudyComponent.similarCollectionView.register(
      SimilarPostCell.self,
      forCellWithReuseIdentifier: SimilarPostCell.id
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
}

// MARK: - extension

extension PostedStudyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
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
      let popupVC = PopupViewController(
        title: "로그인이 필요해요",
        desc: "계속하려면 로그인을 해주세요!",
        rightButtonTilte: "로그인"
      )
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
