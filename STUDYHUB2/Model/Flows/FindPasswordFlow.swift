//
//  FindPasswordFlow.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/7/25.
//


import UIKit

import RxFlow
import RxSwift
import RxRelay

/// 비밀번호찾기 Step
enum FindPasswordStep: Step {
  
  /// 초기화면 - 이메일 입력
  case confirmEmailIsRequired
  
  /// 현재 Flow 종료
  case dismissCurrentFlow
  
  /// 현재화면 pop
  case popCurrentScreen(animate: Bool)
  
  /// 이메일 검증 코드 입력
  case enterEmailCodeScreenIsRequired(email: String)
  
  /// 비밀번호 수정화면으로 이동
  case editPasswordScreenIsRequired(email: String)
}


/// 비밀번호찾기 Flow
class FindPasswordFlow: Flow {
  let viewModel = ConfirmEmailViewModel.shared
  
  var root: any RxFlow.Presentable {
    return self.rootViewController
  }
  
  lazy var rootViewController: UINavigationController = {
    let nav = UINavigationController()
    return nav
  }()
  
  init(){
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? FindPasswordStep else { return .none }
    
    switch step {
    case .confirmEmailIsRequired:
      return setConrfirmEmailScreen()
    case .enterEmailCodeScreenIsRequired(let email):
      return navToEmailCodeScreen(with: email)
    case .editPasswordScreenIsRequired(let email):
      return navToEditpasswordScreen(with: email)
    case .dismissCurrentFlow:
      rootViewController.dismiss(animated: true)
      return .none
    case .popCurrentScreen(let animate):
      self.rootViewController.popViewController(animated: animate)
      return .none
    }
  }
  
  /// 초기화면 - 이메일 입력 화면
  private func setConrfirmEmailScreen() -> FlowContributors {
    let vc = ConfirmEmailViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 이메일 인증코드 입력 화면으로 이동
  func navToEmailCodeScreen(with email: String) -> FlowContributors {
    let viewModel = EnterValidCodeViewModel(email)
    let vc = EnterValidCodeViewController(with: viewModel)
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
  
}

/// FindPasswordStepper - 리모컨
class FindPasswordStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  
  var initialStep: Step {
    return FindPasswordStep.confirmEmailIsRequired
  }
  
  func navigate(to step: FindPasswordStep) {
    self.steps.accept(step)
  }
}
