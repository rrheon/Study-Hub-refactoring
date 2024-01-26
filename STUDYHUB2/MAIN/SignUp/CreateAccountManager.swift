//
//  CreateAccountManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/26.
//

import Foundation

final class CreateAccountManager {
  static let shared = CreateAccountManager()
  let commonNetworking = CommonNetworking.shared
  
  func createNewAccount(accountData: CreateAccount,
                        completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .createNewAccount(accountData: accountData)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }
}
