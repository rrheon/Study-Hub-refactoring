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


/// App 전체 화면 이동을 관리하는 Step
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
  
  /// 메인탭 이동
  case mainTabIsRequired
  
  /// 인증 관련
  case auth(AuthStep)
  
  /// 스터디 관련
  case study(StudyPostStep)
  
  /// 스터디 관리 관련
  case studyManagement(StudyManagementStep)
  
  /// 서비스 관련
  case service(ServiceStep)
  
  /// 네비게이션 관련
  case navigation(NavigationStep)
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
      /// 메인 탭바
    case .mainTabIsRequired:
      return setupMainTabbar()
      
      /// 사용자 인증 관련
    case .auth(let authStep):
      return navigateAuth(step: authStep)
      
      /// 스터디 관련
    case .study(let studyStep):
      return navigateStudy(step: studyStep)
      
      /// 스터디 관리 관련
    case .studyManagement(let studyManagementStep):
      return navigateStudyManagement(step: studyManagementStep)
      
      /// 서비스관련
    case .service(let serviceStep):
      return navigateService(step: serviceStep)
      
      /// 화면이동 관련
    case .navigation(let navigationStep):
      return navigateNavigation(step: navigationStep)
    }
  }
  
  /// 메인 탭바 설정
  func setupMainTabbar() -> FlowContributors {
    let homeFlow: HomeFlow = HomeFlow()
    let studyFlow: StudyFlow = StudyFlow()
    let mypageFlow: MypageFlow = MypageFlow()
    
    tabBarController.setupTabBarControllerUI()
    
    Flows.use(homeFlow, studyFlow, mypageFlow, when: .ready) { [unowned self] root1, root2, root3 in
      root1.tabBarItem = AppStep.SceneType.home.tabItem
      root2.tabBarItem = AppStep.SceneType.study.tabItem
      root3.tabBarItem = AppStep.SceneType.mypage.tabItem
      
      tabBarController.viewControllers = [root1, root2, root3]
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
}

// MARK: - Stepper

/// 전체 AppStepper - 리모컨
class AppStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  let disposBag = DisposeBag()
  
  /// 로그인 상태 확인
  var isUserLoginStatus: Bool {
    LoginStatusManager.shared.fetchAccessToken()

    return LoginStatusManager.shared.loginStatus
  }
  
  /// 로그인 여부에 따라 초기 화면 설정
  var initialStep: Step {
    return isUserLoginStatus ? AppStep.mainTabIsRequired : AppStep.auth(.loginScreenIsRequired)
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
  
//  func checkRefreshToken(){
//    LoginStatusManager.shared.fetchAccessToken()
//  }
  func readyToEmitSteps() {
    Observable.merge(
      /// 북마크 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToBookmarkScreen)
        .map{ _ in AppStep.study(.bookmarkScreenIsRequired) },
      
      /// 이용방법 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToHowToUseScreen)
        .map { _ in AppStep.study(.howToUseScreenIsRequired) },
      
      /// 현재 flow 닫기
      NotificationCenter.default
        .rx
        .notification(.dismissCurrentFlow)
        .map { _ in AppStep.navigation(.dismissCurrentFlow) },
      
      /// 공지사항 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToNoticeScreen)
        .map { _ in AppStep.service(.noticeScreenIsRequired) },
      
      /// 문의사항 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToInquiryScreen)
        .map { _ in AppStep.service(.inquiryScreenIsRequired) },
      
      /// 스터디 상세화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToStudyDetailScrenn)
        .compactMap { notification in
          guard let postID = notification.userInfo?["postID"] as? Int else { return nil}
          return AppStep.study(.studyDetailScreenIsRequired(postID: postID))
        },
      
      /// 스터디 생성 및 수정 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToCreateOrModifyScreen)
        .map({ notification in
          let postData = notification.userInfo?["postData"] as? PostDetailData?
          return AppStep.studyManagement(.studyFormScreenIsRequired(data: postData ?? nil))
        }),
      
      /// 유저 프로필 수정 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToEditUserProfileScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?>,
                let userPrfileImage = notification.userInfo?["userProfile"] as? BehaviorRelay<UIImage?> else {
            return AppStep.navigation(.dismissCurrentFlow)
          }
          
          return AppStep.auth(.editUserProfileIsRequired(userData: userData, profile: userPrfileImage))
        }),
      
      /// 작성한 글 리스트 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToMyStudyPostScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?> else {
            return AppStep.navigation(.popupScreenIsRequired(popupCase: .requiredLogin))
          }
          
          return AppStep.studyManagement(.myStudyPostIsRequired(userData: userData))
        }),
      
      /// 참여한 스터디 리스트 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToMyParticipatePostScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?> else {
            return AppStep.navigation(.popupScreenIsRequired(popupCase: .requiredLogin))
          }
          
          return AppStep.studyManagement(.myParticipateStudyIsRequired(userData: userData))
        }),
      
      /// 신청 스터디 리스트 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToMyRequestPostScreen)
        .map({ notification in
          guard let userData = notification.userInfo?["userData"] as? BehaviorRelay<UserDetailData?> else {
            return AppStep.navigation(.popupScreenIsRequired(popupCase: .requiredLogin))
          }
          
          return AppStep.studyManagement(.myRequestStudyIsRequired(userData: userData))
        }),
      
      /// 사파리 화면으로 이동
      NotificationCenter.default
        .rx
        .notification(.navToSafariScreen)
        .map({ notification in
          guard let url = notification.userInfo?["url"] as? String else {
            return AppStep.navigation(.dismissCurrentFlow)
          }
          
          return AppStep.service(.safariScreenIsRequired(url: url))
        }),
      
      /// popupView 띄우기
      NotificationCenter.default
        .rx
        .notification(.presentPopupScreen)
        .compactMap { notification in
          guard let popupCase = notification.userInfo?["popupCase"] as? PopupCase else { return nil}
          return AppStep.navigation(.popupScreenIsRequired(popupCase: popupCase))
        }
    )
    .bind(to: self.steps)
    .disposed(by: disposBag)
    
  }
}

extension AppFlow: ShowBottomSheet {}
