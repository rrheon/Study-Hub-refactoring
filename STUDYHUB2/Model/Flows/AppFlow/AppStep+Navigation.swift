//
//  AppStep+Navigation.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/27/25.
//

import UIKit

import RxFlow
import RxRelay

/// 네비게이션 관련 화면 이동
enum NavigationStep {
  // 팝업화면 띄우기
  case popupScreenIsRequired(popupCase: PopupCase)
  
  // 현재화면 pop
  case popCurrentScreen(animate: Bool)
  
  // 현재화면 dismiss
  case dismissCurrentScreen

  // 현재 flow 닫기
  case dismissCurrentFlow
  
  // BottomSheet 띄우기
  case bottomSheetIsRequired(postOrCommentID: Int, type: BottomSheetCase)
  
  // 특정 vc까지 pop
  case popToVC(type: AnyClass)
}

extension AppFlow{
  func navigateNavigation(step: NavigationStep) -> FlowContributors {
    switch step {
    case .popupScreenIsRequired(let popupCase):
      return presentPopupScreen(with: popupCase)
    case .bottomSheetIsRequired(let postOrCommentID, let type):
      return presentBottomSheet(postOrCommentID: postOrCommentID, type: type)
    case .popCurrentScreen(let animate):
      return popCurrentScreen(animate: animate)
    case .dismissCurrentScreen:
      self.rootViewController.dismiss(animated: true)
      return .none
    case .dismissCurrentFlow:
      return presentLoginScreen()
    case .popToVC(let type):
      return popToViewController(ofType: type)
    }
  }
  
  /// BottomSheet 띄우기
  /// - Parameters:
  ///   - postOrCommentID: postID 혹은 댓글ID
  ///   - type: 종류 - 게시글 수정 및 삭제 / 댓글 수정 및 삭제
  func presentBottomSheet(postOrCommentID: Int, type: BottomSheetCase) -> FlowContributors {
    let vc = BottomSheet(with: postOrCommentID, type: type)
    showBottomSheet(bottomSheetVC: vc, size: 228.0)
    
    if let topVC = self.rootViewController.viewControllers.last as? BottomSheetDelegate {
      vc.delegate = topVC
    }
    
    self.rootViewController.present(vc, animated: true)
    return .none
  }
  
  
  /// 캘린더 띄우기
  /// - Parameter viewModel: 스터디 생성 viewModel
  /// - Parameter selectType: 선택타입 - true - 시작날짜 선택 / false - 종료날짜 선택
  func presentCalendarScreen(
    viewModel: CreateStudyViewModel,
    selectType: Bool = true
  ) -> FlowContributors {
    let calendarVC = CalendarViewController(viewModel: viewModel, selectStartData: selectType)
    showBottomSheet(bottomSheetVC: calendarVC, size: 400.0)
    self.rootViewController.present(calendarVC, animated: true)
    return .none
  }
  
  
  /// 팝업 뷰 띄우기
  /// - Parameter popupCase: 팝업의 종류
  func presentPopupScreen(with popupCase: PopupCase) -> FlowContributors {
    let popupVC = PopupViewController(popupCase: popupCase)
    
    if let topVC = topMostViewController(), let delegateVC = topVC as? PopupViewDelegate {
      popupVC.popupView.delegate = delegateVC
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.rootViewController.present(popupVC, animated: false)
    return .none
  }
  
  /// 현재화면 pop
  /// - Parameter navigationbarHidden: 상단 네비게이션 바 숨기기 여부
  func popCurrentScreen(animate: Bool = true) -> FlowContributors {
    
    let vcCount = self.rootViewController.viewControllers.count
    self.rootViewController.navigationBar.isHidden = vcCount < 3 ? true : false
    self.rootViewController.popViewController(animated: animate)
    return .none
  }
  
  /// 특정 VC까지 pop
  /// - Parameter type: 특정 VC
  func popToViewController(ofType type: AnyClass) -> FlowContributors{
    if let navigationController = rootViewController as? UINavigationController {
      for controller in navigationController.viewControllers {
        if controller.isKind(of: type) {
          navigationController.popToViewController(controller, animated: true)
          return .none
        }
      }
    }
    return .none
  }
}
