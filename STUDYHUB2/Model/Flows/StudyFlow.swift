//
//  StudyFlow.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/6/25.
//

import UIKit

import RxFlow
import RxSwift
import RxRelay

/// 홈 화면 Step
enum StudyStep: Step {
  case studyIsRequired        // 전체 스터디 검색화면
  case enterSearchIsRequired   // 검색화면
  case resultSearchIsRequired  // 검색결과화면
  case popScreenIsRequired     // 현재화면 pop
}


/// 홈 화면 Flow
class StudyFlow: Flow {
  let viewModel: StudyViewModel
  
  var root: any RxFlow.Presentable {
    return self.rootViewController
  }
  
  
  lazy var rootViewController: UINavigationController = {
    let nav = UINavigationController()
//    nav.configurationNavigationBar()
    return nav
  }()
  
  init(){
    self.viewModel = StudyViewModel.shared
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? StudyStep else { return .none }
    
    switch step {
    case .studyIsRequired:
      return setStudyScreen()
    case .enterSearchIsRequired:
      return navToEnterSearchScreen()
    case .resultSearchIsRequired:
      return navToResultSearchScreen()
    case .popScreenIsRequired:
      return popCurrentScreen()
    }
  }
  
  
  /// 스터디화면 셋팅
  private func setStudyScreen() -> FlowContributors {
    let vc = StudyViewController()
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

/// StudyStepper - 리모컨
class StudyStepper: Stepper {
  let steps: PublishRelay<Step> = PublishRelay()
  
  /// 로그인 여부에 따라 초기 화면 설정
  var initialStep: Step {
    return StudyStep.studyIsRequired
  }
  
  func navigate(to step: AppStep) {
    self.steps.accept(step)
  }
}
