//
//  DeleteAccountViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/20/24.
//

import Foundation

import RxFlow
import RxRelay


/// 탈퇴하기 ViewModel
final class DeleteAccountViewModel: Stepper{
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  let password = BehaviorRelay<String>(value: "")
  let isValidPassword = PublishRelay<Bool>()
  let isSuccessToDeleteAccount = PublishRelay<Bool>()
  
  
  /// 비밀번호 유효성 체크
  func checkValidPassword(){
    let password = password.value
    UserAuthManager.shared.verifyPassword(password: password) { result in
      self.isValidPassword.accept(result)
    }
  }
  
  /// 계정 삭제하기
  func deleteAccount(){
    UserProfileManager.shared.deleteAccount { result in
      self.isSuccessToDeleteAccount.accept(result)
    }
  }
}
