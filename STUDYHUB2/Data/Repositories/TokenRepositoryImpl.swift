//
//  TokenRepositoryImpl.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/23/25.
//

import Foundation

import RxSwift

/// JWT Token Impl
final class TokenRepositoryImpl: TokenRepository {
  private let apiService: TokenManager
  
  init(apiService: TokenManager) {
    self.apiService = apiService
  }
  
  /// JWT 토큰 저장하기
  /// - Parameter tokens: Tokens
  /// - Returns: 저장 성공 여부
  func save(tokens: AccessTokenResponse) -> Bool {
    guard let accessToken = tokens.accessToken,
          let refreshToken = tokens.refreshToken else {
      return false
    }
    let result = apiService.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
    
    return true
  }
  
  
  /// JWT 토큰 가져오기
  /// - Parameter type: 가져올 토큰의 종류
  /// - Returns: 토큰
  func fetch(type: TokenType) -> String {
    guard let token = apiService.loadToken(type: type) else {
      return ""
    }

    return token
  }
  
  
  /// JWT 토큰 삭제하기
  /// - Returns: 삭제결과
  func delete() -> Bool {
    apiService.deleteTokens()
  }  
}
