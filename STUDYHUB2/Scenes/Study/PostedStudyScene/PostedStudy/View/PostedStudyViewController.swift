
import UIKit

import SnapKit
import RxCocoa
import RxSwift

/// StudyHub - front - StudyDetailScreen
/// - 스터디 상세 화면

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
  
  private lazy var pageStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  init(with viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.fetchCommentDatas(with: viewModel.postID)
  }
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationbar()
    
    view.backgroundColor = .white
    
    setupBindings()
    
    setUpLayout()
    makeUI()
    
//    registerKeyboard()
    registerTapGesture()
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
    
    settingNavigationbar()
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  /// 네비게이션 바 왼쪽 아이탬 터치 - 현재 화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
  
  /// 네비게이션 바 오른쪽 아이탬 터치 - 본인 게시글일 경우 수정 및 삭제
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    guard let postID = viewModel.postDatas.value?.postId else { return }

    viewModel.steps.accept(AppStep.navigation(.bottomSheetIsRequired(postOrCommentID: postID,
                                                                     type: .managementPost)))
  }
  
  // MARK: - setUpLayout
  
  /// layout 설정
  func setUpLayout(){
    [ mainComponent,
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
        
        /// 사용자가 작성한 게시글일 경우
        if data?.usersPost == true {
          self.rightButtonSetting(imgName: "RightButtonImg")
        }
      })
      .disposed(by: disposeBag)

  }
  
  /// delegate 설정
  private func setupDelegate() {
    guard let commentComponent = commentComponent,
          let similarStudyComponent = similarStudyComponent else { return }
    
    /// 댓글 테이블뷰
    commentComponent.commentTableView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    commentComponent.commentTableView
      .register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellID)
    
    /// 유사한 스터디 컬랙션 뷰
    similarStudyComponent.similarCollectionView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    similarStudyComponent.similarCollectionView
      .register(SimilarPostCell.self, forCellWithReuseIdentifier: SimilarPostCell.cellID)
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
  
  
  /// BottomSheet의 첫 번째 버튼 탭
  /// - Parameter postOrCommentID: commentID
  func firstButtonTapped(postOrCommentID: Int, bottomSheetCase: BottomSheetCase) {
    switch bottomSheetCase {
    case .managementPost:
      
      viewModel.steps.accept(AppStep.navigation(.dismissCurrentScreen))
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        // 게시글 삭제 팝업 띄우기
        self.viewModel.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .deleteStudyPost)))
      }
      
    case .managementComment:
      // 댓글 삭제하기
      viewModel.deleteComment(with: postOrCommentID)
    default: return
    }
  }
  
  /// BottomSheet의 두 번째 버튼 탭 - 댓글 수정
  /// - Parameter postOrCommentID: commentID
  func secondButtonTapped(postOrCommentID: Int, bottomSheetCase: BottomSheetCase) {
    // 현재 화면 내리기
    viewModel.steps.accept(AppStep.navigation(.dismissCurrentScreen))
    
    switch bottomSheetCase {
    case .managementPost:
      // 게시글 수정
      
      viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: false)))
      
      NotificationCenter.default.post(name: .navToCreateOrModifyScreen,
                                      object: nil,
                                      userInfo: ["postData": viewModel.postDatas.value ?? nil])
    case .managementComment:
      // 댓글 수정
      commentComponent?.commentButton.setTitle("수정", for: .normal)
      viewModel.commentID = postOrCommentID
    default: return
    }
   
  }
}

// MARK: - popupView Actions


extension PostedStudyViewController: PopupViewDelegate {
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    
    // 내가 작성한 게시글 삭제
    if popupCase == .deleteStudyPost {
      defaultBtnAction()
      viewModel.deleteMyPost(with: viewModel.postID)
    }
    
    // 비로그인 시 로그인 화면으로 이도
    if popupCase == .requiredLogin {
      defaultBtnAction()
      NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
    }
  }
}

extension PostedStudyViewController: KeyboardProtocol {}
