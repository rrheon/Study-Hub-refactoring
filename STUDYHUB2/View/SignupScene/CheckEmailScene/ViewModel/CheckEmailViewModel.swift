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
  
  let email = PublishRelay<String>()
  let code = PublishRelay<String>()
  let isEmailDuplication = PublishRelay<Bool>()
  let isValidCode = PublishRelay<String>()
  
  var nextButtonStatus: Observable<Bool> {
    return Observable.combineLatest(email, code).map { !$0.isEmpty && !$1.isEmpty }
  }
  
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
    self.resend = true
  }
}
