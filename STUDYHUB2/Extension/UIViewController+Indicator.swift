//
//  UIViewController+Indicator.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/1/25.
//

import UIKit

import SnapKit

/// 인디케이터 extension
extension UIViewController {
  private struct LoadingIndicator {
    static var activityIndicator: UIActivityIndicatorView?
  }
  
  /// 로딩 인디케이터 표시
  func showLoading() {
    // 중복 방지
    guard LoadingIndicator.activityIndicator == nil else { return }
    
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .gray
    indicator.hidesWhenStopped = true
    
    view.addSubview(indicator)
    
    indicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    indicator.startAnimating()
    LoadingIndicator.activityIndicator = indicator
  }
  
  /// 로딩 인디케이터 숨기기
  func hideLoading() {
    LoadingIndicator.activityIndicator?.stopAnimating()
    LoadingIndicator.activityIndicator?.removeFromSuperview()
    LoadingIndicator.activityIndicator = nil
  }
}
