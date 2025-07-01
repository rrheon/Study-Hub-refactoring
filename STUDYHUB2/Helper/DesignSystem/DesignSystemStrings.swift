//
//  DesignSystemStrings.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/20/25.
//

import Foundation


/// 버튼 타이틀
enum BtnTitle {
  static let next = "다음"
  
  static let login = "로그인하기"
  static let signup = "회원가입"
  static let forgotPassword = "비밀번호가 기억나지 않으시나요?"
  static let explore = "둘러보기"
  
  static let allAgreement = "전체동의"
  static let serviceAgreement = "[필수] 서비스 이용약관 동의"
  static let personalInfoAgreement = "[필수] 개인정보 수집 및 이용 동의"
}


/// 라벨 타이틀
enum LabelTitle {
  
  // 로그인화면
  static let email = "이메일"
  static let emailAlert = "잘못된 주소예요. 다시 입력해주세요"
  static let password = "비밀번호"
  static let passwordAlert = "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
  
  // 약관동의화면
  static let pageNum1 = "1/5"
  static let agreementTitle = "이용약관에 동의해주세요"
  static let agreementInfo = "서비스 이용을 위해서 약관 동의가 필요해요"
}

/// TextField의 PlaceHolder
enum TextFieldPlaceholder {
  static let email = "이메일 주소를 입력해주세요 (@inu.ac.kr)"
  static let password = "비밀번호를 입력해주세요"
}

/// ToastPopup의 메세지
enum ToastPopupMessage {
  static let loginWithEmptyValues = "이메일과 비밀번호를 모두 작성해주세요."
}


/// 네비게이션바 타이틀
enum NavigationTitle {
  static let signup = "회원가입"
}
