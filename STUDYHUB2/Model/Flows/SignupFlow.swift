//
//  SignupFlow.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/8/25.
//

import UIKit
import SafariServices

import RxFlow
import RxCocoa
import RxSwift
import RxRelay

/// 회원가입 Step
enum SignupStep: Step {
  case agreementScreenIsReuqired            // 이용약관 동의화면
  case enterEmailScreenIsRequired           // 이메일 입력화면
  case enterPasswordScreenIsRequired        // 비밀번호 입력화면
  case enterNicknameScreenIsRequired        // 닉네임 입력화면
  case enterMajorScreenIsRequired           // 학과입력화면
  case completeSignupIsRequired             // 회원가입완료화면
  case safariIsRequired(url: URL)           // 사파리 화면으로 이동
  case popIsRequired                        // 현재 화면 pop
  case dismissIsRequired                    // 현재 Flow 내리기

}


/// 회원가입 Flow
class SignupFlow: Flow {
  
  var root: Presentable {
    return self.rootViewController
  }
  
  lazy var rootViewController: UINavigationController = {
    let nav = UINavigationController()
    nav.setNavigationBarHidden(false, animated: false)
    return nav
  }()
  
  /// 로그인 상태
  var isLoginStatus: Bool = false
  
  init(){
    print(#fileID, #function, #line," - ")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? SignupStep else { return .none }
    
    switch step {
    case .agreementScreenIsReuqired:
      return setAgreementScreen()
    case .enterEmailScreenIsRequired:
      return navToEmailScreen()
    case .enterPasswordScreenIsRequired:
      return navToPasswordScreen()
    case .enterNicknameScreenIsRequired:
      return navToNicknameScreen()
    case .enterMajorScreenIsRequired:
      return navToMajorScreen()
    case .completeSignupIsRequired:
      return navToCompletedSignupScreen()
    case .dismissIsRequired:
      return dismissFlow()
    case .safariIsRequired(let url):
      return presentSafariScreen(with: url)
    case .popIsRequired:
      return popScreen()
    }
  }
 
  /// 회원가입 화면 셋팅
  private func setAgreementScreen() -> FlowContributors {
    let viewModel: AgreementViewModel = AgreementViewModel()
    let vc = AgreementViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
  }
  
  
  /// 이메일 입력화면으로 이동
  func navToEmailScreen() -> FlowContributors {
    let viewModel: CheckEmailViewModel = CheckEmailViewModel()
    let vc = CheckEmailViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
  }
  
  /// 비밀번호  입력화면으로 이동
  func navToPasswordScreen() -> FlowContributors {
    let viewModel: EnterPasswordViewModel = EnterPasswordViewModel()
    let vc = EnterPasswordViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
  }
  
  /// 닉네임 입력화면으로 이동
  func navToNicknameScreen() -> FlowContributors {
    let viewModel: EnterNicknameViewModel = EnterNicknameViewModel()
    let vc = EnterNicknameViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
  }
  
  /// 학과 입력화면으로 이동
  func navToMajorScreen() -> FlowContributors {
    let viewModel: EnterMajorViewModel = EnterMajorViewModel()
    let vc = EnterMajorViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
  }
  
  /// 이메일 입력화면으로 이동
  func navToCompletedSignupScreen() -> FlowContributors {
    let vc = CompletedSignupViewController()
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc))
  }
  
  
  /// 사파리 화면으로 이동
  /// - Parameter url: 이동할 url
  func presentSafariScreen(with url: URL) -> FlowContributors {
    let urlView = SFSafariViewController(url: url)
    self.rootViewController.present(urlView, animated: true)
    return .none
  }

  
  /// 화면 pop
  func popScreen() -> FlowContributors{
    self.rootViewController.popViewController(animated: true)
    return .none
  }
  
  /// 현재 Flow 내리기
  func dismissFlow() -> FlowContributors {
    self.rootViewController.dismiss(animated: true)
    return .none
  }
}

/// SignupStepper - 리모컨
class SignupStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  
  /// 로그인 여부에 따라 초기 화면 설정
  var initialStep: Step {
    return SignupStep.agreementScreenIsReuqired
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
}
