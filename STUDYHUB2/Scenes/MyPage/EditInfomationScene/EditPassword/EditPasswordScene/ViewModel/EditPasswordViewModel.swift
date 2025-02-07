//
//  EditPasswordViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/24/24.
//

import Foundation

import RxRelay

final class EditPasswordViewModel {
  
  let userEmail: String
  let loginStatus: Bool
  
  let firstPassword = BehaviorRelay<String>(value: "")
  let secondPassword = BehaviorRelay<String>(value: "")
  
  let isSuccessChangePassword = PublishRelay<Bool>()
 
  init(userEmail: String, loginStatus: Bool = true) {
    self.userEmail = userEmail
    self.loginStatus = loginStatus
  }

  func isValidPassword(_ password: String) -> Bool {
    let passwordRegex = "(?=.*[a-zA-Z0-9])(?=.*[^a-zA-Z0-9]).{10,}"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
  }
  
  func checkSamePassword() -> Bool{
    let firstPassword = firstPassword.value
    let secondPassword = secondPassword.value
    return firstPassword == secondPassword
  }
  
  func storePasswordToServer(){
//    commonNetworking.moyaNetworking(
//      networkingChoice: .editUserPassword(
//        checkPassword: true,
//        email: userEmail,
//        password: secondPassword.value
//      )
//    ) { result in
//      switch result {
//      case .success(let response):
//        print(response.response?.statusCode)
//        self.isSuccessChangePassword.accept(true)
//      case .failure(let respose):
//        self.isSuccessChangePassword.accept(false)
//      }
//    }
  }
}

