//
//  HomeFlow.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/6/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay

/// 홈 화면 Step
enum HomeStep: Step {
  case homeIsRequired          // 홈화면
  case enterSearchIsRequired   // 검색화면
  case resultSearchIsRequired  // 검색결과화면
  case popScreenIsRequired     // 현재화면 pop
}


/// 홈 화면 Flow
class HomeFlow: Flow {
  let viewModel: HomeViewModel
  
  var root: any RxFlow.Presentable {
    return self.rootViewController
  }
  
  lazy var rootViewController: UINavigationController = {
    let nav = UINavigationController()
    return nav
  }()

  
  /// 로그인 상태
  var isLoginStatus: Bool = false
  
  init(){
    print(#fileID, #function, #line," - ")
    self.viewModel = HomeViewModel.shared
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? HomeStep else { return .none }
    
    switch step {
    case .homeIsRequired:
      return setHomeScreen()
    case .enterSearchIsRequired:
      return navToEnterSearchScreen()
    case .resultSearchIsRequired:
      return navToResultSearchScreen()
    case .popScreenIsRequired:
      return popCurrentScreen()
    }
  }
 
  /// 홈 화면 셋팅
  private func setHomeScreen() -> FlowContributors {
    let vc = HomeViewController()
    self.rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 검색어 입력 화면으로 이동
  private func navToEnterSearchScreen() -> FlowContributors {
    let viewModel: SearchViewModel = SearchViewModel.shared
    let vc = EnterSearchViewController(viewModel: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 검색어 결과 화면으로 이동
  private func navToResultSearchScreen() -> FlowContributors {
    let viewModel: SearchViewModel = SearchViewModel.shared
    let vc = ResultSearchViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 현재화면 pop
  private func popCurrentScreen() -> FlowContributors {
    self.rootViewController.popViewController(animated: true)
    return .none
  }
}

/// HomeStepper - 리모컨
class HomeStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  
  /// 로그인 여부에 따라 초기 화면 설정
  var initialStep: Step {
    return HomeStep.homeIsRequired
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
}
