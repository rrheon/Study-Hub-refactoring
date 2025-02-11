//
//  EnterDepartmentViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/1/24.
//

import Foundation

import RxCocoa
import RxSwift
import RxFlow

/// 학과 입력 ViewModel
final class EnterMajorViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  static let shared = EnterMajorViewModel()

  
  /// 회원가입 정보
  var email: String? = nil
  var gender: String? = nil
  var nickname: String? = nil
  var password: String? = nil
  
  /// 입력된 학과
  let enteredMajor: PublishRelay<String> = PublishRelay<String>()
  
  /// 입력된 학과와 매칭되는 학과들
  let matchedMajors: PublishRelay<[String]> = PublishRelay<[String]>()
  
  /// 계정생성 성공여부
  let isSuccessCreateAccount: PublishRelay<Bool> = PublishRelay<Bool>()

  
  /// PList에서 학과 가져오기
  /// - Parameter major: 학과
  func searchMajorFromPlist(_ major: String){
    loadMajors(major)
    enteredMajor.accept(major)
  }
  
  /// 학과 가져오기
  /// - Parameter enteredMajor: 입력된 학과
  private func loadMajors(_ enteredMajor: String) {
    
    if let majors = DataLoaderFromPlist.loadMajorsWithCodes() {
      let filteredMajors = majors.filter { (key, value) -> Bool in
        key.contains(enteredMajor)
      }
      matchedMajors.accept(filteredMajors.keys.map({ $0 }))
    }
  }

  
  /// 계정 생성하기
  /// - Parameter major: 학과
  func createAccount(_ major: String){
    guard let email = email,
          let gender = gender,
          let nickname = nickname,
          let password = password,
          let major = Utils.convertMajor(major, toEnglish: true) else { return }
    let userInfo = CreateAccount(
      email: email,
      gender: gender,
      major: major,
      nickname: nickname,
      password: password
    )
    UserAuthManager.shared.createNewAccount(accountData: userInfo) { result in
      self.isSuccessCreateAccount.accept(result)
    }

  }
}
