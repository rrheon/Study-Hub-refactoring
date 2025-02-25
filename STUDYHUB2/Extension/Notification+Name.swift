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
  
  /// 스터디 생성 및 수정 화면으로 이동
  static let navToCreateOrModifyScreen = Notification.Name("navToCreateOrModifyScreen")
  
  /// 학과선택 화면으로 이동
  static let navToSelectMajorScreen = Notification.Name("navToSelectMajorScreen")
}
