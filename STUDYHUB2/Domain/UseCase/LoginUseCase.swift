//
//  SignupUseCase.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/20/25.
//

import Foundation

import RxSwift


/// 사용자 회원가입 UseCase
protocol LoginUseCase {
  func execute(loginData: LoginEntity) -> Single<AccessTokenResponse>
}

final class LoginUseCaseImpl: LoginUseCase {
  private let repository: LoginRepository
  
  init(repository: LoginRepository) {
    self.repository = repository
  }
  
  func execute(loginData: LoginEntity) -> Single<AccessTokenResponse> {
    return repository.loginWithEmail(loginData: loginData)
  }
}
