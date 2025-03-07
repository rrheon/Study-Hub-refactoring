//
//  UITabbarController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/7/25.
//

import UIKit


extension UITabBarController {
  /// TabBar UI 설정
  func setupTabBarControllerUI(){
    self.tabBar.backgroundColor = .white
    self.tabBar.tintColor = .o50
    self.tabBar.layer.borderColor = UIColor.white.cgColor
    self.tabBar.layer.borderWidth = 0.5
    
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    appearance.shadowColor = .clear
    
    self.tabBar.standardAppearance = appearance
    
    if #available(iOS 15.0, *) {
      self.tabBar.scrollEdgeAppearance = appearance
    } else {
      // Fallback on earlier versions
    }
    
    
    // 그림자 효과 추가 (탭바 상단)
    self.tabBar.layer.shadowColor = UIColor.black.cgColor
    self.tabBar.layer.shadowOpacity = 0.1
    self.tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
    self.tabBar.layer.shadowRadius = 5
    self.tabBar.layer.masksToBounds = false
    
  }
}
