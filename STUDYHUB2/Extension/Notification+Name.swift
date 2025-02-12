//
//  Notification+Name.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//

import UIKit

extension Notification.Name {
  
  /// 북마크 화면으로 이동
  static let navToBookmarkScreen = Notification.Name("navToBookmarkScreen")
  
  /// 이용방법 화면으로 이동
  static let navToHowToUseScreen = Notification.Name("navToHowToUseScreen")
  
  /// 스터디 디테일 화면으로 이동
  static let navToStudyDetailScrenn = Notification.Name("navToStudyDetailScrenn")
}
