//
//  AppFlow.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/6/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay
import SafariServices


// MARK: - step


/// App 전체 화면이동
enum AppStep: Step {
  
  
  /// 탭바 화면 타입
  enum SceneType {
    case home
    case study
    case mypage
    
    /// 탭바 아이템
    var tabItem: UITabBarItem {
      switch self {
      case .home:
        return UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
      case .study:
        return UITabBarItem(title: "스터디", image: UIImage(systemName: "book"), tag: 1)
      case .mypage:
        return UITabBarItem(title: "마이페이지",image: UIImage(systemName:"person"), tag: 2)
      }
    }
  }
  
  /// 메인탭바
  case mainTabIsRequired
  
  
  // MARK: - Auth (인증 관련)
  
  
  /// 로그인 화면
  case loginScreenIsRequired
  
  /// 회원가입 Flow
  case signupIsRequired
  
  /// 유저 프로필 편집화면
  case editUserProfileIsRequired(userData: BehaviorRelay<UserDetailData?>,
                                 profile: BehaviorRelay<UIImage?>)
  
  /// 닉네임 수정화면 이동
  case editNicknameScreenIsRequired(userData: BehaviorRelay<UserDetailData?>)

  /// 이메일 유효성 확인
  case confrimEmailScreenIsRequired
  
  /// 이메일 검증 코드 입력
  case enterEmailCodeScreenIsRequired(email: String)
  
  /// 비밀번호 확인화면으로 이동
  case confirmPasswordScreenIsRequired(email: String)
  
  /// 비밀번호 수정화면으로 이동
  case editPasswordScreenIsRequired(email: String)
  
  /// 학과 수정화면 이동
  case editMajorScreenIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  /// 탈퇴하기 확인 화면으로 이동
  case confirmDeleteAccountScreenIsRequired
  
  /// 탈퇴하기 화면으로 이동
  case deleteAccountScreenIsRequired
  
  
  // MARK: - Study (스터디 관련)

  
  /// 북마크 화면
  case bookmarkScreenIsRequired
  
  /// 이용방법 화면
  case howToUseScreenIsRequired
  
  /// 스터디 상세 화면
  case studyDetailScreenIsRequired(postID: Int)
  
  /// 댓글 전체화면
  case commentDetailScreenIsRequired(postID: Int)
  
  
  /// 스터디 신청 화면
  case applyStudyScreenIsRequired(data: BehaviorRelay<PostDetailData?>)
  
  
  // MARK: - Study Management (스터디 관리)

  
  /// 스터디 생성,수정 화면
  case studyFormScreenIsRequired(data: PostDetailData?)
  
  /// 학과 선택화면
  case selectMajorScreenIsRequired(seletedMajor: BehaviorRelay<String?>)
  
  /// 캘린더화면
  case calendarIsRequired(viewModel: CreateStudyViewModel, selectType: Bool)
  
  /// 내가 작성한 스터디 리스트 화면
  case myStudyPostIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  /// 내가 참여한 스터디 리스트 화면
  case myParticipateStudyIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  /// 내가 신청한 스터디 리스트 화면
  case myRequestStudyIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  /// 거절사유 bottomshett
  case refuseBottomSheetIsRequired(userId: Int)
  
  /// 거절 사유 작성 화면
  case writeRefuseReasoneScreenIsReuqired(userId: Int)
  
  /// 자세한 거절사유 화면으로 이동
  case detailRejectReasonScreenIsRequired(reason: RejectReason)
  
  
  // MARK: - Service (서비스 관련)

  
  /// 공지사항 화면으로 이동
  case noticeScreenIsRequired
  
  /// 문의하기 화면으로 이동
  case inquiryScreenIsRequired
  
  /// 사파리 화면 띄우기
  case safariScreenIsReuiqred(url: String)
  

  // MARK: - Navigation (화면 이동)

  
  /// 팝업화면 띄우기
  case popupScreenIsRequired(popupCase: PopupCase)
  
  /// 현재화면 pop
  case popCurrentScreen(navigationbarHidden: Bool, animate: Bool)
  
  /// 현재화면 dismiss
  case dismissCurrentScreen
  
  /// 현재 flow 닫기
  case dismissCurrentFlow
  
  /// BottomSheet
  case bottomSheetIsRequired(postOrCommnetID: Int, type: BottomSheetCase)
 
}

// MARK: - Flow


/// App 전체 Flow
class AppFlow: Flow {
  var root: any Presentable {
    return self.rootViewController
  }
  
  lazy var rootViewController: UINavigationController = {
    let nav = UINavigationController()
    return nav
  }()
  
  var tabBarController: UITabBarController = UITabBarController()
  
  func navigate(to step: any Step) -> FlowContributors {
    guard let step = step as? AppStep else { return .none }
    
    switch step {
      
    // MARK: - Main
      
      
    case .mainTabIsRequired:
      return setupMainTabbar()
      
    // MARK: - Auth
      
      
    case .loginScreenIsRequired:
      return presentLoginScreen()
    case .signupIsRequired:
      return presentSignupScreen()
    case .editUserProfileIsRequired(let userData, let profile):
      return navToEditUserProfileScreen(userData: userData, profile: profile)
    case .editNicknameScreenIsRequired(let userData):
      return navToEditNicknameScreen(with: userData)
    case .editPasswordScreenIsRequired(let email):
      return navToEditpasswordScreen(with: email)
    case .editMajorScreenIsRequired(let userData):
      return navToEditmajorScreen(with: userData)
    case .confirmPasswordScreenIsRequired(let email):
      return navToConfirmpasswordScreen(with: email)
    case .confrimEmailScreenIsRequired:
      return navToConfirmEmailScreen()
    case .enterEmailCodeScreenIsRequired(let email):
      return navToEmailCodeScreen(with: email)
    case .confirmDeleteAccountScreenIsRequired:
      return navToConfirmDeleteAccountScreen()
    case .deleteAccountScreenIsRequired:
      return navToDeleteAccountScreen()
      
  // MARK: - Study
      
      
    case .bookmarkScreenIsRequired:
      return navToBookmarkScreen()
    case .howToUseScreenIsRequired:
      return navToHowToUseScreen()
    case .studyDetailScreenIsRequired(let postID):
      return navToStudyDetailScreen(postID: postID)
    case .commentDetailScreenIsRequired(let postID):
      return navToCommentDetailScreen(postID: postID)
    case .applyStudyScreenIsRequired(let data):
      return navToApplyStudy(with: data)
      
  // MARK: - Study Management
      
      
    case .studyFormScreenIsRequired(let data):
      return navTostudyFormScreen(data: data)
    case .selectMajorScreenIsRequired(let seletedMajor):
      return navToSelectMajorScreen(major: seletedMajor)
    case .calendarIsRequired(let viewModel, let selectType):
      return presentCalendarScreen(viewModel: viewModel, selectType: selectType)
    case .myStudyPostIsRequired(let userData):
      return navToMyPostScreen(with: userData)
    case .myParticipateStudyIsRequired(let userData):
      return navToMyParticipateScreen(with: userData)
    case .myRequestStudyIsRequired(let userData):
      return navToMyRequestListScreen(with: userData)
    case .refuseBottomSheetIsRequired(let userId):
      return presentRefuseBottomSheet(userId: userId)
    case .writeRefuseReasoneScreenIsReuqired(let userId):
      return navToWriteRefusereaonScreen(userID: userId)
    case .detailRejectReasonScreenIsRequired(let reason):
      return navToRejectReasonScreen(rejectReason: reason)
      
  // MARK: - Service
      
      
    case .noticeScreenIsRequired:
      return navToNoticeScreen()
    case .inquiryScreenIsRequired:
      return navToInquiryScreen()
    case .safariScreenIsReuiqred(let url):
      return presentSafariScreen(url: url)
      
      
  // MARK: - Navigation
      
      
    case .popupScreenIsRequired(let popupCase):
      return presentPopupScreen(wtih: popupCase)
    case .bottomSheetIsRequired(let postOrCommentID, let type):
      return presentBottomSheet(postOrCommentID: postOrCommentID, type: type)
    case .popCurrentScreen(let navigationbarHidden, let animate):
      return popCurrentScreen(navigationbarHidden: navigationbarHidden, animate: animate)
    case .dismissCurrentScreen:
      self.rootViewController.dismiss(animated: true)
      return .none
    case .dismissCurrentFlow:
      return presentLoginScreen()
    }
  }
  
  
  /// 메인 탭바 설정
  func setupMainTabbar() -> FlowContributors {
    let homeFlow: HomeFlow = HomeFlow()
    let studyFlow: StudyFlow = StudyFlow()
    let mypageFlow: MypageFlow = MypageFlow()
    
    Flows.use(homeFlow, studyFlow, mypageFlow, when: .ready) { [unowned self] root1, root2, root3 in
      root1.tabBarItem = AppStep.SceneType.home.tabItem
      root2.tabBarItem = AppStep.SceneType.study.tabItem
      root3.tabBarItem = AppStep.SceneType.mypage.tabItem
      
      tabBarController.viewControllers = [root1, root2, root3]
      tabBarController.tabBar.backgroundColor = .white
      tabBarController.tabBar.tintColor = .o50
      tabBarController.tabBar.layer.borderColor = UIColor.white.cgColor
      tabBarController.tabBar.layer.borderWidth = 0.5
      tabBarController.selectedIndex = 0
      
      rootViewController.setViewControllers([tabBarController], animated: false)
      rootViewController.navigationBar.isHidden = true
    }
    
    return .multiple(flowContributors: [
      .contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: HomeStep.homeIsRequired)),
      .contribute(withNextPresentable: studyFlow, withNextStepper: OneStepper(withSingleStep: StudyStep.studyIsRequired)),
      .contribute(withNextPresentable: mypageFlow, withNextStepper: OneStepper(withSingleStep: MypageStep.mypageIsRequired))
    ])
  }
  
  
  /// 로그인 화면 표시
  func presentLoginScreen() -> FlowContributors {
    let viewModel: LoginViewModel = LoginViewModel()
    let vc = LoginViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = true
    self.rootViewController.setViewControllers([vc], animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 회원가입 Flow 띄우기
  func presentSignupScreen() -> FlowContributors {
    let signupFlow = SignupFlow()
    
    Flows.use(signupFlow, when: .ready) { [unowned self] root in
      root.modalPresentationStyle = .fullScreen
      self.rootViewController.present(root, animated: true)
    }
    
    return .one(flowContributor: .contribute(
      withNextPresentable: signupFlow,
      withNextStepper: OneStepper(withSingleStep: SignupStep.agreementScreenIsReuqired)
    ))
  }
  
  
  /// 북마크 화면으로 이동
  private func navToBookmarkScreen() -> FlowContributors {
    let viewModel: BookmarkViewModel = BookmarkViewModel()
    let vc = BookmarkViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 스터디 신청하기 화면으로 이동
  private func navToApplyStudy(with data: BehaviorRelay<PostDetailData?>) -> FlowContributors {
    let viewModel: ApplyStudyViewModel = ApplyStudyViewModel(data)
    let vc = ApplyStudyViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 이용방법 화면으로 이동
  private func navToHowToUseScreen() -> FlowContributors {
#warning("vc에 로그인 상태를 주입하지 말고 작성하기 버튼을 누를 때 로그인 여부를 판단해야함")
    let vc = HowToUseViewController(false)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
  
  
  /// 스터디 디테일 화면으로 이동
  private func navToStudyDetailScreen(postID: Int) -> FlowContributors {
    let viewModel: PostedStudyViewModel = PostedStudyViewModel(with: postID)
    let vc = PostedStudyViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 전체댓글 화면으로 이동
  /// - Parameter postID: 스터디의 postID
  private func navToCommentDetailScreen(postID: Int) -> FlowContributors {
    let viewModel: CommentViewModel = CommentViewModel(with: postID)
    let vc = CommentViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 스터디 생성 / 수정 화면으로 이동
  /// - Parameter data: 스터디 데이터 - nil -> 스터디 생성 , 데이터 존재 -> 스터디 수정
  private func navTostudyFormScreen(data: PostDetailData? = nil) -> FlowContributors {
    let viewModel: CreateStudyViewModel = CreateStudyViewModel(data: data)
    let vc = CreateStudyViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 학과 선택 화면으로 이동
  /// - Parameter major: 선택된 학과가 있는 경우
  private func navToSelectMajorScreen(major: BehaviorRelay<String?>) -> FlowContributors {
    let viewModel: SeletMajorViewModel = SeletMajorViewModel(enteredMajor: major)
    let vc = SeletMajorViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// BottomSheet 띄우기
  /// - Parameters:
  ///   - postOrCommentID: postID 혹은 댓글ID
  ///   - type: 종류 - 게시글 수정 및 삭제 / 댓글 수정 및 삭제
  private func presentBottomSheet(postOrCommentID: Int, type: BottomSheetCase) -> FlowContributors {
    let vc = BottomSheet(with: postOrCommentID, type: type)
    showBottomSheet(bottomSheetVC: vc, size: 228.0)
    
    if let topVC = self.rootViewController.viewControllers.last as? BottomSheetDelegate {
      vc.delegate = topVC
    }
    
    self.rootViewController.present(vc, animated: true)
    return .none
  }
  
  
  /// 캘린더 띄우기
  /// - Parameter viewModel: 스터디 생성 viewModel
  /// - Parameter selectType: 선택타입 - true - 시작날짜 선택 / false - 종료날짜 선택
  private func presentCalendarScreen(
    viewModel: CreateStudyViewModel,
    selectType: Bool = true
  ) -> FlowContributors {
    let calendarVC = CalendarViewController(viewModel: viewModel, selectStartData: selectType)
    showBottomSheet(bottomSheetVC: calendarVC, size: 400.0)
    self.rootViewController.present(calendarVC, animated: true)
    return .none
  }
  
  
  /// 유저 프로필 수정화면으로 이동
  /// - Parameters:
  ///   - userData: 유저 데이터
  ///   - profile: 프로필
  private func navToEditUserProfileScreen(
    userData: BehaviorRelay<UserDetailData?>,
    profile: BehaviorRelay<UIImage?>
  ) -> FlowContributors {
    let viewModel = MyInfomationViewModel(userData, userProfile: profile)
    let vc = MyInformViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 내가 작성한 스터디 리스트 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  private func navToMyPostScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = MyPostViewModel(userData: userData)
    let vc = MyPostViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 내가 참여한 스터디 리스트 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  private func navToMyParticipateScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = MyParticipateStudyViewModel(with: userData)
    let vc = MyParticipateStudyVC(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 내가 신청한 스터디 리스트 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  private func navToMyRequestListScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = MyRequestListViewModel(with: userData)
    let vc = MyRequestListViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  

  /// 공지사항 화면으로 이동
  private func navToNoticeScreen() -> FlowContributors {
    let viewModel = NotificationViewModel()
    let vc = NotificationViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 문의하기 화면으로 이동
  private func navToInquiryScreen() -> FlowContributors {
    let viewModel = InquiryViewModel()
    let vc = InquiryViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 사파리 화면 띄우기
  /// - Parameter url: 이동할 url
  private func presentSafariScreen(url: String) -> FlowContributors {
    if let url = URL(string: url) {
      let urlView = SFSafariViewController(url: url)
      self.rootViewController.present(urlView, animated: true)
      return .none
    }
    return .none
  }
  
  /// 닉네임 수정 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  private func navToEditNicknameScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = EditNicknameViewModel(userData: userData)
    let vc = EditnicknameViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 이메일 유효성 확인 화면으로 이동
  func navToConfirmEmailScreen() -> FlowContributors {
    let viewModel = ConfirmEmailViewModel()
    let vc = ConfirmEmailViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 이메일 인증코드 입력 화면으로 이동
  func navToEmailCodeScreen(with email: String) -> FlowContributors {
    let viewModel = EnterValidCodeViewModel(email)
    let vc = EnterValidCodeViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 비밀번호 확인 화면으로 이동
  /// - Parameter userData: 사용자의 이메일
  func navToConfirmpasswordScreen(with email: String) -> FlowContributors {
    let viewModel = ConfirmPasswordViewModel(userEmail: email)
    let vc = ConfirmPasswordViewController(wtih: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 비밀번호 수정 화면으로 이동
  /// - Parameter userData:사용자의 이메일
  func navToEditpasswordScreen(with email: String) -> FlowContributors {
    let viewModel = EditPasswordViewModel(userEmail: email)
    let vc = EditPasswordViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 학과 수정 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  func navToEditmajorScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = EditMajorViewModel(userData: userData)
    let vc = EditMajorViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 탈퇴하기 확인 화면으로 이동
  private func navToConfirmDeleteAccountScreen() -> FlowContributors {
    let vc = ConfirmDeleteViewController()
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
  
  /// 탈퇴하기 화면으로 이동
  private func navToDeleteAccountScreen() -> FlowContributors {
    let viewModel = DeleteAccountViewModel()
    let vc = DeleteAccountViewController(viewModel: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 팝업 뷰 띄우기
  /// - Parameter popupCase: 팝업의 종류
  private func presentPopupScreen(wtih popupCase: PopupCase) -> FlowContributors {
    let popupVC = PopupViewController(popupCase: popupCase)
    
    if let selectedNav = tabBarController.selectedViewController as? UINavigationController,
       let topVC = selectedNav.viewControllers.last as? PopupViewDelegate {
        popupVC.popupView.delegate = topVC
    } else if let topVC = rootViewController.viewControllers.last as? PopupViewDelegate {
        popupVC.popupView.delegate = topVC
    } else if let topVC = rootViewController as? PopupViewDelegate {
        popupVC.popupView.delegate = topVC
    }

    
    popupVC.modalPresentationStyle = .overFullScreen
    self.rootViewController.present(popupVC, animated: false)
    return .none
  }
  
  /// 현재화면 pop
  /// - Parameter navigationbarHidden: 상단 네비게이션 바 숨기기 여부
  private func popCurrentScreen(navigationbarHidden: Bool = true,
                                animate: Bool = true) -> FlowContributors {
    self.rootViewController.navigationBar.isHidden = navigationbarHidden
    self.rootViewController.popViewController(animated: animate)
    return .none
  }
  
  
  /// 신청한 인원 거절 사유 선택 bottomSheet
  /// - Parameter userId: 거절할 user의 id
  private func presentRefuseBottomSheet(userId: Int) -> FlowContributors {
    let vc = RefuseBottomSheet(userId: userId)
    
    if let topVC = self.rootViewController.viewControllers.last as? RefuseBottomSheetDelegate {
      vc.delegate = topVC
    }
    self.rootViewController.present(vc, animated: true)
    return .none
  }
  
  
  /// 거절사유 작성 화면으로 이동
  /// - Parameter userID: 거절할 user의 id
  private func navToWriteRefusereaonScreen(userID: Int) -> FlowContributors {
    let vc = WriteRefuseReasonVC(userId: userID)
    
    if let topVC = self.rootViewController.viewControllers.last as? WriteRefuseReasonVCDelegate {
      vc.delegate = topVC
    }
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
  
  
  /// 거절 사유확인 화면으로 이동
  /// - Parameter rejectReason: 거절사유
  private func navToRejectReasonScreen(rejectReason: RejectReason) -> FlowContributors {
    let vc = DetailRejectReasonViewController(rejectData: rejectReason)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
}

// MARK: - Stepper

/// 전체 AppStepper - 리모컨
class AppStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  private let disposBag = DisposeBag()

  /// 로그인 상태 확인
  var isUserLoginStatus: Bool {
    return TokenManager.shared.loadRefreshToken()?.first != nil 
  }
  
  /// 로그인 여부에 따라 초기 화면 설정
  var initialStep: Step {
    return isUserLoginStatus ? AppStep.mainTabIsRequired : AppStep.loginScreenIsRequired
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
  
  func readyToEmitSteps() {
    Observable.merge(
      /// 북마크 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToBookmarkScreen)
        .map{ _ in AppStep.bookmarkScreenIsRequired },
      
      /// 이용방법 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToHowToUseScreen)
        .map { _ in AppStep.howToUseScreenIsRequired },
      
      /// 현재 flow 닫기
      NotificationCenter.default
        .rx
        .notification(.dismissCurrentFlow)
        .map { _ in AppStep.dismissCurrentFlow },
      
      /// 공지사항 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToNoticeScreen)
        .map { _ in AppStep.noticeScreenIsRequired },
      
      /// 문의사항 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToInquiryScreen)
        .map { _ in AppStep.inquiryScreenIsRequired },
      
      /// 스터디 상세화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToStudyDetailScrenn)
        .compactMap { notification in
        guard let postID = notification.userInfo?["postID"] as? Int else { return nil}
        return AppStep.studyDetailScreenIsRequired(postID: postID)
      },
      
      /// 스터디 생성 및 수정 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToCreateOrModifyScreen)
        .map({ notification in
          let postData = notification.userInfo?["postData"] as? PostDetailData?
          return AppStep.studyFormScreenIsRequired(data: postData ?? nil)
        }),
      
      /// 유저 프로필 수정 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToEditUserProfileScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?>,
                let userPrfileImage = notification.userInfo?["userProfile"] as? BehaviorRelay<UIImage?> else {
            return AppStep.dismissCurrentFlow
          }
          
          return AppStep.editUserProfileIsRequired(userData: userData, profile: userPrfileImage)
        }),
      
      /// 작성한 글 리스트 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToMyStudyPostScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?> else {
            return AppStep.popupScreenIsRequired(popupCase: .requireLogin)
          }
          
          return AppStep.myStudyPostIsRequired(userData: userData)
        }),
      
      /// 참여한 스터디 리스트 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToMyParticipatePostScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?> else {
            return AppStep.popupScreenIsRequired(popupCase: .requireLogin)
          }
          
          return AppStep.myParticipateStudyIsRequired(userData: userData)
        }),
      
      /// 신청 스터디 리스트 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToMyRequestPostScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?> else {
            return AppStep.popupScreenIsRequired(popupCase: .requireLogin)
          }
          
          return AppStep.myRequestStudyIsRequired(userData: userData)
        }),
      
      /// 사파리 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToSafariScreen)
        .map({ notification in
          guard let url = notification.userInfo?["url"] as? String else {
            return AppStep.dismissCurrentFlow
          }
          
          return AppStep.safariScreenIsReuiqred(url: url)
        })
    )
    .bind(to: self.steps)
    .disposed(by: disposBag)
    
  }
}

extension AppFlow: ShowBottomSheet {}
