//
//  AuthRepositories.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/20/25.
//

import Foundation

import RxSwift


/// 로그인 Repository
protocol LoginRepository {
  func loginWithEmail(loginData: LoginEntity) -> Single<AccessTokenResponse>
}


/// JWT 토큰의 타일
enum TokenType {
  case access
  case refresh
}

/// JWT 토큰 Repository
protocol TokenRepository {
  func save(tokens: AccessTokenResponse) -> Bool
  func fetch(type: TokenType) -> String
  func delete() -> Bool
}
