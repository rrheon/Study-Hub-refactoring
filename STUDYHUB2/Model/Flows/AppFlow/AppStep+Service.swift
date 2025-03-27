//
//  AppStep+Service.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/27/25.
//

import UIKit

import RxFlow
import RxRelay
import SafariServices

/// 서비스 관련 화면 이동
enum ServiceStep {
  // 공지사항 화면으로 이동
  case noticeScreenIsRequired

  //문의하기 화면으로 이동
  case inquiryScreenIsRequired
  
  // 사파리 화면 띄우기
  case safariScreenIsRequired(url: String)
}

extension AppFlow{
  func navigateService(step: ServiceStep) -> FlowContributors {
    switch step {
    case .noticeScreenIsRequired:
      return navToNoticeScreen()
    case .inquiryScreenIsRequired:
      return navToInquiryScreen()
    case .safariScreenIsRequired(let url):
      return presentSafariScreen(url: url)
    }
  }
  
  /// 공지사항 화면으로 이동
  func navToNoticeScreen() -> FlowContributors {
    let viewModel = NotificationViewModel()
    let vc = NotificationViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 문의하기 화면으로 이동
  func navToInquiryScreen() -> FlowContributors {
    let viewModel = InquiryViewModel()
    let vc = InquiryViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 사파리 화면 띄우기
  /// - Parameter url: 이동할 url
  func presentSafariScreen(url: String) -> FlowContributors {
    if let url = URL(string: url) {
      let urlView = SFSafariViewController(url: url)
      self.rootViewController.present(urlView, animated: true)
      return .none
    }
    return .none
  }
}
