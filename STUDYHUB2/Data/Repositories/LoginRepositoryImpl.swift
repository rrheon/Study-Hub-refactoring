//
//  LoginImpl.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/20/25.
//

import Foundation

import RxSwift


/// 로그인 Impl
final class LoginRepositoryImpl: LoginRepository {
  private let apiService: UserAuthManager
  
  init(apiService: UserAuthManager) {
    self.apiService = apiService
  }
  
  func loginWithEmail(loginData: LoginEntity) -> Single<AccessTokenResponse> {
    return apiService.loginToStudyHubWithRx(email: loginData.email, password: loginData.password)
  }
}
