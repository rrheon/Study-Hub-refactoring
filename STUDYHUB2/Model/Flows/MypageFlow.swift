//
//  MypageFlow.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/6/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay

/// 홈 화면 Step
enum MypageStep: Step {
  case mypageIsRequired
  
}


/// 홈 화면 Flow
class MypageFlow: Flow {
  let viewModel: MyPageViewModel
  
  var root: any RxFlow.Presentable {
    return self.rootViewController
  }
  
  lazy var rootViewController: UINavigationController = {
    let nav = UINavigationController()
//    nav.configurationNavigationBar()
    return nav
  }()
  
  init(){
    self.viewModel = MyPageViewModel.shared
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? MypageStep else { return .none }
    
    switch step {
    case .mypageIsRequired:
      return setMypageScreen()
    }
  }
  
  /// 마이페이지 설정
  private func setMypageScreen() -> FlowContributors {
    let vc = MyPageViewController()
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
}
