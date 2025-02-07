//
//  EditPasswordViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/20/24.
//

import Foundation

import RxRelay

final class ConfirmPasswordViewModel {
  
  let userEmail: String
  let currentPassword = BehaviorRelay<String>(value: "")
  let isValidPassword = PublishRelay<Bool>()
  
  init(userEmail: String) {
    self.userEmail = userEmail
  }
  
  func nextButtonTapped(_ password: String){
//    commonNetworking.moyaNetworking(
//      networkingChoice: .verifyPassword(password)) { result in
//        switch result {
//        case .success(let response):
//          switch response.statusCode{
//          case 200:
//            self.isValidPassword.accept(true)
//          default:
//            self.isValidPassword.accept(false)
//          }
//        case .failure(let response):
//          self.isValidPassword.accept(false)
//        }
//      }
  }
}
