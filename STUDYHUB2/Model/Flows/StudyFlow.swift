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
  case studyIsRequired
}


/// 홈 화면 Flow
class StudyFlow: Flow {
  let viewModel: StudyViewModel
  
  var root: any RxFlow.Presentable {
    return self.rootViewController
  }
  
  var rootViewController: UINavigationController = UINavigationController()
  
  init(){
    self.viewModel = StudyViewModel.shared
  }
  
  func navigate(to step: any RxFlow.Step) -> RxFlow.FlowContributors {
    guard let step = step as? StudyStep else { return .none }
    
    switch step {
    case .studyIsRequired:
      return setStudyScreen()
    }
  }
  
  
  /// 스터디화면 셋팅
  private func setStudyScreen() -> FlowContributors {
    let vc = StudyViewController()
    self.rootViewController.pushViewController(vc, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
}
