//
//  EnterValidCodeViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/25/24.
//

import Foundation

import RxRelay

final class EnterValidCodeViewModel {
  
  let email: String
  
  let validCode = BehaviorRelay<String>(value: "")
  let isCodeSended = PublishRelay<Bool>()
  let isValidCode = PublishRelay<Bool>()
  
  init(_ email: String) {
    self.email = email
  }
  
  func sendEmailValidCode(){
//    editUserInfoManager.sendEmailCode(email: email) { }
  }
  
  func resendEmailValidCode(){
    sendEmailValidCode()
    self.isCodeSended.accept(true)
  }
  
  
  // MARK: - 전송받은 코드 유효성 확인
  
  
  @objc func checkValidCode(){
//    editUserInfoManager.checkValidCode(code: validCode.value, email: email) { result in
//      switch result {
//      case "true":
//        self.isValidCode.accept(true)
//      default:
//        self.isValidCode.accept(false)
//      }
//    }
  }
}
