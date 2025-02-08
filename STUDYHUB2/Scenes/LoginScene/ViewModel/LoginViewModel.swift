//
//  File.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import Foundation

import RxFlow
import RxCocoa
import RxSwift
import RxRelay

/// 로그인 ViewModel
class LoginViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()

  /// 유효한 계정 여부
  let isValidAccount: PublishRelay<Bool> = PublishRelay<Bool>()
  
  /// 로그인하기
  /// - Parameters:
  ///   - email: 사용자의 email
  ///   - password: 사용자 password
  func loginToStudyHub(email: String, password: String){
    UserAuthManager.shared.loginToStudyHub(email: email, password: password) { tokens in
      // 기존의 토큰 삭제
      _ = TokenManager.shared.deleteTokens()
      
      // 새로운 토큰 저장
      guard let accessToken = tokens.accessToken,
            let refreshToken = tokens.refreshToken else {
        self.isValidAccount.accept(false)
        return
      }
      
      let saveResult = TokenManager.shared.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
      
      // 로그인 성공
      self.isValidAccount.accept(saveResult)
    }
  }
}

