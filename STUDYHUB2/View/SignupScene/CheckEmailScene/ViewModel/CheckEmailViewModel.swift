//
//  CheckEmailViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/27/24.
//

import Foundation

import RxSwift
import RxRelay

final class CheckEmailViewModel: CommonViewModel {
  let editUserManager = EditUserInfoManager.shared
  
  let email = BehaviorRelay(value: "")
  let isEmailDuplication = PublishRelay<Bool>()
  let isValidCode = PublishRelay<String>()
  
  var resend: Bool = false

  func checkEmailDuplication(_ email: String) {
    editUserManager.checkEmailDuplication(email: email) {
      self.isEmailDuplication.accept($0)
    }
  }
  
  func sendEmailCode(_ email: String, completion: @escaping () -> Void){
    editUserManager.sendEmailCode(email: email) {
      completion()
    }
  }
  
  func checkValidCode(code: String, email: String) {
    editUserManager.checkValidCode(code: code, email: email) {
      self.isValidCode.accept($0)
    }
  }
  
  func changeStatus(){
    resend.toggle()
  }
}
