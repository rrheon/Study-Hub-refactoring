//
//  DeleteAccountViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/20/24.
//

import Foundation

import RxRelay

final class DeleteAccountViewModel: CommonViewModel {
  let commonNetworking = CommonNetworking.shared
  
  let password = BehaviorRelay<String>(value: "")
  let isValidPassword = PublishRelay<Bool>()
  let isSuccessToDeleteAccount = PublishRelay<Bool>()
  
  func checkValidPassword(){
    let password = password.value
    commonNetworking.moyaNetworking(
      networkingChoice: .verifyPassword(_password: password)
    ) { result in
      switch result {
      case .success(let response):
        // 성공시 - 확인 버튼 활성화, 실패 시 - 토스트 팝업 띄우기케이스를 나눠야할듯 200
        switch response.statusCode{
        case 200:
          self.isValidPassword.accept(true)
        default:
          self.isValidPassword.accept(false)
        }
      case .failure(let response):
        self.isValidPassword.accept(false)
      }
    }
  }
  
  func deleteAccount(){
    commonNetworking.moyaNetworking(networkingChoice: .deleteID) { result in
      switch result {
      case .success(let response):
        self.isSuccessToDeleteAccount.accept(true)
      case .failure(let response):
        self.isSuccessToDeleteAccount.accept(false)
      }
    }
  }
}
