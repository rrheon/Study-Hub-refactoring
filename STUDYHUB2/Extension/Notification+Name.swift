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
  
  /// 유저 정보 편집화면으로 이동
  static let navToEditUserProfileScreen = Notification.Name("navToEditUserProfileScreen")
  
  /// 내가 작성한 스터디 리스트 화면으로 이동
  static let navToMyStudyPostScreen = Notification.Name("navToMyStudyPostScreen")
  
  /// 내가 참여한 스터디 리스트 화면으로 이동
  static let navToMyParticipatePostScreen = Notification.Name("navToMyParticipatePostScreen")
  
  /// 내가 신청한 스터디 리스트 화면으로 이동
  static let navToMyRequestPostScreen = Notification.Name("navToMyRequestPostScreen")
  
  /// 공지사항  화면으로 이동
  static let navToNoticeScreen = Notification.Name("navToNoticeScreen")
  
  /// 문의사항  화면으로 이동
  static let navToInquiryScreen = Notification.Name("navToInquiryScreen")
  
  /// 사파리  화면으로 이동
  static let navToSafariScreen = Notification.Name("navToSafariScreen")
  
  /// 현재 flow 닫기
  static let dismissCurrentFlow = Notification.Name("dismissCurrentFlow")
  
  /// popup 띄우기
  static let presentPopupScreen = Notification.Name("presentPopupScreen")

}
