//
//  AppStep+Ext.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/27/25.
//

import UIKit

import RxFlow
import RxRelay

/// 인증 관련 화면 이동
enum AuthStep {
  // 로그인 화면
  case loginScreenIsRequired
  
  // 회원가입 flow
  case signupIsRequired
  
  // 사용자 프로필 편집화면
  case editUserProfileIsRequired(userData: BehaviorRelay<UserDetailData?>,
                                 profile: BehaviorRelay<UIImage?>)
  
  // 닉네임 수정화면 이동
  case editNicknameScreenIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  // 이메일 유효성환인
  case confirmEmailScreenIsRequired
  
  // 이메일 검증 코드 입력
  case enterEmailCodeScreenIsRequired(email: String)
  
  // 비밀번호 확인화면으로 이동
  case confirmPasswordScreenIsRequired(email: String)
  
  // 비밀번호 수정화면 이동
  case editPasswordScreenIsRequired(email: String)
  
  // 학과 수정화면 이동
  case editMajorScreenIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  // 탈퇴하기 확인 화면으로 이동
  case confirmDeleteAccountScreenIsRequired
  
  // 탈퇴하기 화면으로 이동
  case deleteAccountScreenIsRequired
}

extension AppFlow {
  func navigateAuth(step: AuthStep) -> FlowContributors {
    switch step {
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
    case .confirmEmailScreenIsRequired:
      return presentToConfirmEmailScreen()
    case .enterEmailCodeScreenIsRequired(let email):
      return navToEmailCodeScreen(with: email)
    case .confirmDeleteAccountScreenIsRequired:
      return navToConfirmDeleteAccountScreen()
    case .deleteAccountScreenIsRequired:
      return navToDeleteAccountScreen()
    }
  }
  
  /// 로그인 화면 표시
  func presentLoginScreen() -> FlowContributors {
    let viewModel: LoginViewModel = AuthDIContainer.makeLoginViewModel()
    let vc = LoginViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = true
    self.rootViewController.setViewControllers([vc], animated: false)
    return .one(flowContributor: .contribute(withNext: vc))
//    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
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
  
  /// 유저 프로필 수정화면으로 이동
  /// - Parameters:
  ///   - userData: 유저 데이터
  ///   - profile: 프로필
  func navToEditUserProfileScreen(
    userData: BehaviorRelay<UserDetailData?>,
    profile: BehaviorRelay<UIImage?>
  ) -> FlowContributors {
    let viewModel = MyInfomationViewModel(userData, userProfile: profile)
    let vc = MyInformViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 닉네임 수정 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  func navToEditNicknameScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = EditNicknameViewModel(userData: userData)
    let vc = EditnicknameViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  /// 이메일 유효성 확인 화면으로 이동
  func presentToConfirmEmailScreen() -> FlowContributors {
    let findPasswordFlow = FindPasswordFlow()
    
    Flows.use(findPasswordFlow, when: .ready) { [unowned self] root in
      root.modalPresentationStyle = .fullScreen
      self.rootViewController.present(root, animated: true)
    }
    
    return .one(flowContributor: .contribute(
      withNextPresentable: findPasswordFlow,
      withNextStepper: OneStepper(withSingleStep: FindPasswordStep.confirmEmailIsRequired)))
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
  func navToConfirmDeleteAccountScreen() -> FlowContributors {
    let vc = ConfirmDeleteViewController()
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
  
  /// 탈퇴하기 화면으로 이동
  func navToDeleteAccountScreen() -> FlowContributors {
    let viewModel = DeleteAccountViewModel()
    let vc = DeleteAccountViewController(viewModel: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
}
