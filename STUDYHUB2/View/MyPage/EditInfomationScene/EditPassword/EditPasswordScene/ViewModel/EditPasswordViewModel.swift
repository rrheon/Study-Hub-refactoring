//
//  EditPasswordViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/24/24.
//

import Foundation

import RxRelay

final class EditPasswordViewModel: CommonViewModel {
  let commonNetworking = CommonNetworking.shared
  
  let userEmail: String
  
  let firstPassword = BehaviorRelay<String>(value: "")
  let secondPassword = BehaviorRelay<String>(value: "")
  
  let isSuccessChangePassword = PublishRelay<Bool>()
 
  init(userEmail: String) {
    self.userEmail = userEmail
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
  
  // 왜 안될까남
  func storePasswordToServer(){
    commonNetworking.moyaNetworking(
      networkingChoice: .editUserPassword(
        _checkPassword: true,
        email: userEmail,
        _password: secondPassword.value
      )
    ) { result in
      switch result {
      case .success(let response):
        print(response.response?.statusCode)
        self.isSuccessChangePassword.accept(true)
      case .failure(let respose):
        self.isSuccessChangePassword.accept(false)
      }
    }
  }
}

