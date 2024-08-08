//
//  EnterDepartmentViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/1/24.
//

import Foundation

import RxCocoa
import RxSwift

final class EnterDepartmentViewModel: SignupViewModel {
  let createAccountManager = CreateAccountManager.shared
  
  let enteredMajor = PublishRelay<String>()
  let matchedMajors = PublishRelay<[String]>()
  let isSuccessCreateAccount = PublishRelay<Bool>()
  
  func searchMajorFromPlist(_ major: String){
    loadMajors(major)
    enteredMajor.accept(major)
  }
  
  private func loadMajors(_ enteredMajor: String) {
    let majorDatas = DataLoaderFromPlist()
    if let majors = majorDatas.loadMajorsWithCodes() {
      let filteredMajors = majors.filter { (key, value) -> Bool in
        key.contains(enteredMajor)
      }
      matchedMajors.accept(filteredMajors.keys.map({ $0 }))
    }
  }
  
  private func convertMajorToEnglish(_ major: String) -> String? {
    let majorDatas = DataLoaderFromPlist()
    guard let majors = majorDatas.loadMajorsWithCodes() else { return nil }
    let filteredMajors = majors.filter { (key, _) -> Bool in
      key.contains(major)
    }
    
    return filteredMajors.values.first
  }

  func createAccount(_ major: String){
    guard let email = email,
          let gender = gender,
          let nickname = nickname,
          let password = password,
          let major = convertMajorToEnglish(major) else { return }
    let userInfo = CreateAccount(email: email,
                                 gender: gender,
                                 major: major,
                                 nickname: nickname,
                                 password: password)
    createAccountManager.createNewAccount(accountData: userInfo) {
      self.isSuccessCreateAccount.accept($0)
    }
  }
}
