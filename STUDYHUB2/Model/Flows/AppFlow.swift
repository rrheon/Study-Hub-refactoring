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
  
  case mainTabIsRequired                                                       // 메인탭바
  case loginScreenIsRequired                                                  // 로그인 화면
  case signupIsRequired                                                       // 회원가입 Flow
  case bookmarkScreenIsRequired                                                // 북마크 화면
  case howToUseScreenIsRequired                                               // 이용방법 화면
  case studyDetailScreenIsRequired(postID: Int)                               // 스터디 상세 화면
  case commentDetailScreenIsRequired(postID: Int)                           // 댓글 전체화면
  case studyFormScreenIsRequired(data: PostDetailData?)                     // 스터디 생성,수정 화면
  case selectMajorScreenIsRequired(seletedMajor: BehaviorRelay<String?>)    // 학과 선택화면
  case bottomSheetIsRequired(postOrCommnetID: Int, type: BottomSheetCase)   // BottomSheet
  case calendarIsRequired(viewModel: CreateStudyViewModel, selectType: Bool)  // 캘린더화면
  case popCurrentScreen(navigationbarHidden: Bool)                           // 현재화면 pop
  case dismissCurrentScreen                                                 // 현재화면 dismiss
  /*
   필요한 화면
   
   캘린더
   팝업 - toast / 일반
   이용약관
   스터디 상세화면
   댓글화면
   참여하기
   스터디 생성 flow
   학과검색
   프로필 화면
   닉네임/ 학과/비밀번호 변경화면
   비밀번호 찾기 flow
   탈퇴하기
   작성한 글
   참여자화면
   거절화면
   신청내역화면
   북마크화면
   공지사항
   서비스이용약관
   개인정보처리방침
   */
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
    case .mainTabIsRequired:
      return setupMainTabbar()
    case .loginScreenIsRequired:
      return presentLoginScreen()
    case .signupIsRequired:
      return presentSignupScreen()
    case .bookmarkScreenIsRequired:
      return navToBookmarkScreen()
    case .popCurrentScreen(let navigationbarHidden):
      return popCurrentScreen(navigationbarHidden: navigationbarHidden)
    case .howToUseScreenIsRequired:
      return navToHowToUseScreen()
    case .studyDetailScreenIsRequired(let postID):
      return navToStudyDetailScreen(postID: postID)
    case .bottomSheetIsRequired(let postOrCommentID, let type):
      return presentBottomSheet(postOrCommentID: postOrCommentID, type: type)
    case .dismissCurrentScreen:
      self.rootViewController.dismiss(animated: true)
      return .none
    case .commentDetailScreenIsRequired(let postID):
      return navToCommentDetailScreen(postID: postID)
    case .studyFormScreenIsRequired(let data):
      return navTostudyFormScreen(data: data)
    case .selectMajorScreenIsRequired(let seletedMajor):
      return navToSelectMajorScreen(major: seletedMajor)
    case .calendarIsRequired(let viewModel, let selectType):
      return presentCalendarScreen(viewModel: viewModel, selectType: selectType)
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
  private func presentCalendarScreen(viewModel: CreateStudyViewModel,
                                     selectType: Bool = true) -> FlowContributors {
    let calendarVC = CalendarViewController(viewModel: viewModel, selectStartData: selectType)
    showBottomSheet(bottomSheetVC: calendarVC, size: 400.0)
    self.rootViewController.present(calendarVC, animated: true)
    return .none
  }
  
  /// 현재화면 pop
  /// - Parameter navigationbarHidden: 상단 네비게이션 바 숨기기 여부
  private func popCurrentScreen(navigationbarHidden: Bool = true) -> FlowContributors {
    self.rootViewController.navigationBar.isHidden = navigationbarHidden
    self.rootViewController.popViewController(animated: true)
    return .none
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
        .map { _ in AppStep.howToUseScreenIsRequired},
      
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
        })
    )
    .bind(to: self.steps)
    .disposed(by: disposBag)
    
  }
}

extension AppFlow: ShowBottomSheet {}
