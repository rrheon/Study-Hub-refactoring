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
  case homeIsRequired
  
  /*
  필요한 화면
   
   검색화면
   검색결과화면
  */
}


/// 홈 화면 Flow
class HomeFlow: Flow {
  let viewModel: HomeViewModel
  
  var root: any RxFlow.Presentable {
    return self.rootViewController
  }
  
  lazy var rootViewController: UINavigationController = {
    let nav = UINavigationController()
    nav.configurationNavigationBar()
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
    }
  }
 
  /// 홈 화면 셋팅
  private func setHomeScreen() -> FlowContributors {
    let vc = HomeViewController()
    self.rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
}
