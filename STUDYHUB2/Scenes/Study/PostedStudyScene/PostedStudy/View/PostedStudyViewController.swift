
import UIKit

import SnapKit
import RxCocoa
import RxSwift

/// 스터디 상세 VC
final class PostedStudyViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: PostedStudyViewModel
  
  /// 메인 component - 게시일, 관련 학과, 제목, 팀원수, 벌금, 성별
  private var mainComponent: PostedStudyMainComponent?
  
  /// 디테일 component - 스터디소개, 기간, 벌금, 대면여부, 관련 학과
  private var detailInfoComponent: PostedStudyDetailInfoComponent?
  
  /// 작성자 component
  private var writerComponent: PostedStudyWriterComponent?
  
  /// 댓글 component
  private var commentComponent: PostedStudyCommentComponent?
  
  /// 유사한 스터디 component
  private var similarStudyComponent: SimilarStudyComponent?
  
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  init(with viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    //    viewModel.isNeedFetch?.accept(true)
  }
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationbar()
    
    view.backgroundColor = .white
    
    setupBindings()
    
    setUpLayout()
    makeUI()
  } // viewDidLoad

  
  /// 화면을 구성하는 components 생성
  private func setupComponents(with data: PostDetailData?) {
    guard let data = data else { return }
    mainComponent = PostedStudyMainComponent(with: data)
    detailInfoComponent = PostedStudyDetailInfoComponent(with: data)
    writerComponent = PostedStudyWriterComponent(with: data)
    commentComponent = PostedStudyCommentComponent(with: viewModel)
    similarStudyComponent = SimilarStudyComponent(with: viewModel)
        
    setupDelegate()
  }
  
  /// 네비게이션 바 세팅
  func setupNavigationbar(){
    leftButtonSetting()
    self.navigationController?.navigationBar.isTranslucent = false
    
    /// 작성자가의 포스트인 경우 오른쪽 버튼 - 바텀시트 작업
    if let isUsersPost = viewModel.postDatas.value?.usersPost {
      rightButtonSetting(imgName: "RightButtonImg")
    }
  }
  
  /// 네비게이션 바 왼쪽 아이템 터치 - 현재 화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: true))
  }
  
  // MARK: - setUpLayout
  
  /// layout 설정
  func setUpLayout(){
    [
      mainComponent,
      detailInfoComponent,
      writerComponent,
      commentComponent,
      similarStudyComponent
    ].compactMap { $0 }
      .forEach { pageStackView.addArrangedSubview($0)}
    
    scrollView.addSubview(pageStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  
  /// UI 설정
  private func makeUI() {
    guard let mainComponent = mainComponent,
          let detailInfoComponent = detailInfoComponent,
          let writerComponent = writerComponent,
          let commentComponent = commentComponent,
          let similarStudyComponent = similarStudyComponent else { return }
    
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
      $0.height.equalTo(350)
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
  
  
  /// 바인딩
  func setupBindings(){
    /// 스터디 디테일 데이터
    viewModel.postDatas
      .withUnretained(self)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { (vc, data) in
        vc.setupComponents(with: data)
        vc.setUpLayout()
        vc.makeUI()
      })
      .disposed(by: disposeBag)

    //    viewModel.postDatas
    //      .subscribe(onNext: { [weak self] in
    //        if $0?.usersPost == false {
    //          self?.navigationItem.rightBarButtonItem = nil
    //        }
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.dataFromPopupView
    //      .subscribe(onNext: { [weak self] action in
    //        guard let self = self else { return }
    //        switch action {
    //        case .deletePost:
    //          viewModel.deleteMyPost {
    //            self.navigationController?.popViewController(animated: false)
    //            self.showToast(message: "삭제가 완료됐어요.")
    //          }
    //        case .editPost:
    //          let postData = viewModel.postDatas
    //          let modifyVC = CreateStudyViewController(postedData: postData, mode: .PUT)
    //          self.moveToOtherVCWithSameNavi(vc: modifyVC, hideTabbar: true)
    //        case .deleteComment: break
    ////          viewModel.commentManager.deleteComment(commentID: viewModel.postOrCommentID) {
    ////            if $0 {
    ////              self.viewModel.fetchCommentDatas()
    ////            }
    ////          }
    //        case .editComment:
    //          commentComponent.commentButton.setTitle("수정", for: .normal)
    //        }
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.singlePostData
    //      .subscribe(onNext: { [weak self] in
    //        let loginStatus = self?.viewModel.isUserLogined
    //        let postData = PostedStudyData(isUserLogin: loginStatus ?? false, postDetailData: $0)
    //        let postedStudyVC = PostedStudyViewController(postData)
    //        self?.moveToOtherVCWithSameNavi(vc: postedStudyVC, hideTabbar: true)
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.isActivateParticipate
    //      .subscribe(onNext: { [weak self] in
    //        guard let postData = self?.viewModel.postDatas else { return }
    //        $0 ? self?.goToParticipateVC(postData) : self?.goToLoginVC()
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.showToastMessage
    //      .asDriver(onErrorJustReturn: "")
    //      .drive(onNext: { [weak self] in
    //        self?.showToast(message: $0, imageCheck: false)
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.showBottomSheet
    //      .asDriver(onErrorJustReturn: 0)
    //      .drive(onNext: { [weak self]  in
    //        let bottomSheetVC = BottomSheet(postID: $0, checkPost: false)
    //        bottomSheetVC.delegate = self
    //
    //        self?.showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    //        self?.present(bottomSheetVC, animated: true, completion: nil)
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.moveToCommentVC
    //      .subscribe(onNext: { [weak self] in
    //        self?.navigationController?.pushViewController($0, animated: true)
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.moveToLoginVC
    //      .subscribe(onNext: { [weak self] _ in
    //        self?.goToLoginVC()
    //      })
    //      .disposed(by: disposeBag)
    //
    //    viewModel.moveToParticipateVC
    //      .subscribe(onNext: { [weak self] _ in
    //        guard let self = self else { return }
    //        self.goToParticipateVC(viewModel.postDatas)
    //      })
    //      .disposed(by: disposeBag)
  }
  
  /// delegate 설정
  private func setupDelegate() {
    guard let commentComponent = commentComponent,
          let similarStudyComponent = similarStudyComponent else { return }
    
    /// 댓글 테이블뷰
    commentComponent.commentTableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    commentComponent.commentTableView.register(
      CommentCell.self,
      forCellReuseIdentifier: CommentCell.cellID
    )
    
    /// 유사한 스터디 컬랙션 뷰
    similarStudyComponent.similarCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    similarStudyComponent.similarCollectionView.register(
      SimilarPostCell.self,
      forCellWithReuseIdentifier: SimilarPostCell.cellID
    )
  }
  
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    //    guard let postID = viewModel.postDatas.value?.postID else { return }
    //    let bottomSheetVC = BottomSheet(
    //      postID: postID,
    //      checkMyPost: true,
    //      firstButtonTitle: "삭제하기",
    //      secondButtonTitle: "수정하기",
    //      checkPost: true
    //    )
    //    bottomSheetVC.delegate = self
    //
    //    showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    //    present(bottomSheetVC, animated: true, completion: nil)
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

// MARK: - 댓글 , 게시글 편집 bottomSheet Delegate
// 터치하면 화면 내리기, 토스트팝업
extension PostedStudyViewController: BottomSheetDelegate {
  
  /// BottomSheet의 첫 번째 버튼 탭 - 댓글 삭제
  /// - Parameter postOrCommentID: commentID
  func firstButtonTapped(postOrCommentID: Int) {
    viewModel.deleteComment(with: postOrCommentID)
  }
  
  /// BottomSheet의 두 번째 버튼 탭 - 댓글 수정
  /// - Parameter postOrCommentID: commentID
  func secondButtonTapped(postOrCommentID: Int) {
    // 현재 화면 내리기
    viewModel.steps.accept(AppStep.dismissCurrentScreen)

    commentComponent?.commentButton.setTitle("수정", for: .normal)
    viewModel.commentID = postOrCommentID
  }

  
  func goToParticipateVC(_ postData: BehaviorRelay<PostDetailData?>){
    let participateVC = ParticipateVC(postData)
    self.navigationController?.pushViewController(participateVC, animated: true)
  }
  
  func goToLoginVC(){
    //    DispatchQueue.main.async {
    //      let popupVC = PopupViewController(
    //        title: "로그인이 필요해요",
    //        desc: "계속하려면 로그인을 해주세요!",
    //        rightButtonTilte: "로그인"
    //      )
    //      self.present(popupVC, animated: true)
    //
    //      popupVC.popupView.rightButtonAction = {
    //        self.dismiss(animated: true) {
    //          if let navigationController = self.navigationController {
    //            navigationController.popToRootViewController(animated: false)
    //
    //            let loginVC = LoginViewController()
    //
    //            loginVC.modalPresentationStyle = .overFullScreen
    //            navigationController.present(loginVC, animated: true, completion: nil)
    //          }
    //        }
    //      }
    //    }
  }
}

extension PostedStudyViewController: ShowBottomSheet {}
extension PostedStudyViewController: CreateUIprotocol {}
