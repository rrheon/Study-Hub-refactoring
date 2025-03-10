//
//  CheckEmailViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/27/24.
//

import Foundation

import RxSwift
import RxRelay
import RxFlow

/// 이메일 확인 ViewModel
final class CheckEmailViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  
  /// 이메일
  let email: PublishRelay<String> = PublishRelay<String>()
  
  /// 이메일 인증코드
  let code: PublishRelay<String> = PublishRelay<String>()
  
  /// 이메일 중복 여부
  let isEmailDuplication: PublishRelay<Bool> = PublishRelay<Bool>()
  
  /// 유효한 이메일인증코드 여부
  let isValidCode: PublishRelay<String> = PublishRelay<String>()
  
  /// 다음버튼 활성화여부
  var nextButtonStatus: Observable<Bool> {
    return Observable.combineLatest(email, code).map { !$0.isEmpty && !$1.isEmpty }
  }
  
  
  /// 인증코드 다시 보내기
  var resend: Bool = false

  
  /// 이메일 중복여부 체크 후 전달
  /// - Parameter email: 확인할 이메일
  func checkEmailDuplication(_ email: String) {
    UserAuthManager.shared.checkEmailDuplication(email: email) { result in
      self.isEmailDuplication.accept(result)
      
      if result { EnterMajorViewModel.shared.email = email }
    }
  }
  
  
  /// 이메일로 인증코드 보내기
  /// - Parameters:
  ///   - email: 보낼 이메일 주소
  ///   - completion: 콜백함수
  func sendEmailCode(_ email: String, completion: @escaping () -> Void){
    UserAuthManager.shared.sendEmailCode(email: email) { _ in
      completion()
    }
  }
  
  
  /// 인증코드 유효여부 체크
  /// - Parameters:
  ///   - code: 인증코드
  ///   - email: 이메일
  func checkValidCode(code: String, email: String) {
    UserAuthManager.shared.checkValidCode(code: code, email: email) { result in
      self.isValidCode.accept(result)
    }
  }

}
