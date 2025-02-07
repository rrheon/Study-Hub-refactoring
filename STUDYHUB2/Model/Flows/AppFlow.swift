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
  
  case mainTabIsRequired    // 메인탭바
  case loginScreenIsRequired // 로그인 화면
  
  /*
   필요한 화면
   
   회원가입 flow
   캘린더
   팝업 - toast / 일반
   이용약관
   스터디 상세화면
   댓글화면
   참여하기
   스터디 생성
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


/// App 전체 Flow
class AppFlow: Flow {
  var root: any Presentable {
    return self.rootViewController
  }
  
  var rootViewController: UINavigationController = UINavigationController()
  var tabBarController: UITabBarController = UITabBarController()
  
  func navigate(to step: any Step) -> FlowContributors {
    guard let step = step as? AppStep else { return .none }
    
    switch step {
    case .mainTabIsRequired:
      return setupMainTabbar()
    case .loginScreenIsRequired:
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
    let vc = LoginViewController()
    self.rootViewController.pushViewController(vc, animated: false)
    return .none
  }
}


/// 전체 AppStepper - 리모컨
class AppStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  
  /// 로그인 상태 확인
  var isUserLoginStatus: Bool {
    return TokenManager.shared.loadAccessToken()?.first != nil
  }
  
  /// 로그인 여부에 따라 초기 화면 설정
  var initialStep: Step {
    return isUserLoginStatus ? AppStep.mainTabIsRequired : AppStep.loginScreenIsRequired
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
}
