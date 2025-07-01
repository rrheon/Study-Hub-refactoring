//
//  TokenManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/06.
//

import Foundation
import Security


/// 토큰 관련 매니저
final class TokenManager {
  
  
  static let shared = TokenManager()
  
  // MARK: Keychain
  
  private let accessTokenAccount = "accessToken"
  private let refreshTokenAccount = "refreshToken"
  private let service = Bundle.main.bundleIdentifier
  
  private lazy var accessTokenQuery: [CFString: Any]? = {
    guard let service = self.service else { return nil }
    return [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accessTokenAccount,
      kSecReturnData: true
    ]
  }()
  
  private lazy var refreshTokenQuery: [CFString: Any]? = {
    guard let service = self.service else { return nil }
    return [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: refreshTokenAccount,
      kSecReturnData: true
    ]
  }()
  
  
  /// 토큰 저장
  /// - Parameters:
  ///   - accessToken: 저장할 accessToken
  ///   - refreshToken: 저장할 refreshToken
  /// - Returns: 저장 성공여부
  func saveTokens(accessToken: String, refreshToken: String) -> Bool {
    guard let service = self.service,
          let accessTokenData = accessToken.data(using: .utf8),
          let refreshTokenData = refreshToken.data(using: .utf8) else { return false }
    
    let accessTokenQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accessTokenAccount
    ]
    
    let refreshTokenQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: refreshTokenAccount
    ]
    
    let updateAttributes: [CFString: Any] = [kSecValueData: accessTokenData]
    let refreshUpdateAttributes: [CFString: Any] = [kSecValueData: refreshTokenData]
    
    // 기존 토큰이 존재하는지 확인
    if SecItemUpdate(accessTokenQuery as CFDictionary, updateAttributes as CFDictionary) == errSecSuccess,
       SecItemUpdate(refreshTokenQuery as CFDictionary, refreshUpdateAttributes as CFDictionary) == errSecSuccess {
      return true
    }
    
    // 기존 토큰이 없으면 새로 추가
    let newAccessTokenQuery = accessTokenQuery.merging(updateAttributes) { (_, new) in new }
    let newRefreshTokenQuery = refreshTokenQuery.merging(refreshUpdateAttributes) { (_, new) in new }
    
    let accessTokenResult = SecItemAdd(newAccessTokenQuery as CFDictionary, nil)
    let refreshTokenResult = SecItemAdd(newRefreshTokenQuery as CFDictionary, nil)
    
    return accessTokenResult == errSecSuccess && refreshTokenResult == errSecSuccess
  }

  
  /// access token 가져오기
  /// - Returns: access token
  func loadAccessToken() -> String? {
    guard let service = self.service,
          let query = accessTokenQuery else { return nil }
    
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return "" }
    
    guard let data = item as? Data,
          let accessToken = String(data: data, encoding: .utf8) else { return "" }
    
    return accessToken
  }
  
  
  /// refresh token 가져오기
  /// - Returns: refresh token
  func loadRefreshToken() -> String? {
    guard let service = self.service,
          let query = refreshTokenQuery else { return nil }
    
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
    
    guard let data = item as? Data,
          let refreshToken = String(data: data, encoding: .utf8) else { return nil }
    
    return refreshToken
  }
  
  
  /// JWT Token 가져오기
  /// - Parameter type: 가져올 Token의 종류
  /// - Returns: Token반환
  func loadToken(type: TokenType) -> String? {
    let _type = type == .access ? accessTokenQuery : refreshTokenQuery
    guard let service = self.service,
          let query = _type else { return nil }
    
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
    
    guard let data = item as? Data,
          let refreshToken = String(data: data, encoding: .utf8) else { return nil }
    
    return refreshToken
  }
  
  
  /// 토큰 삭제하기
  /// - Returns: 삭제완료 여부
  func deleteTokens() -> Bool {
    guard let service = self.service,
          let accessTokenQuery = accessTokenQuery,
          let refreshTokenQuery = refreshTokenQuery else { return false }
    
    let deleteAccessTokenResult = SecItemDelete(accessTokenQuery as CFDictionary)
    let deleteRefreshTokenResult = SecItemDelete(refreshTokenQuery as CFDictionary)
    
    return deleteAccessTokenResult == errSecSuccess && deleteRefreshTokenResult == errSecSuccess
  }
}
