//
//  TokenManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/06.
//

import Foundation
import Security

final class TokenManager {
  
  // MARK: Shared instance
  static let shared = TokenManager()
  private init() { }
  
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
  
  func saveTokens(accessToken: String, refreshToken: String) -> Bool {
    guard let service = self.service,
          let accessTokenData = accessToken.data(using: .utf8),
          let refreshTokenData = refreshToken.data(using: .utf8) else { return false }
    
    let accessTokenQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: accessTokenAccount,
      kSecValueData: accessTokenData
    ]
    
    let refreshTokenQuery: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: refreshTokenAccount,
      kSecValueData: refreshTokenData
    ]
    
    // Keychain에 access token과 refresh token을 저장합니다.
    return SecItemAdd(accessTokenQuery as CFDictionary, nil) == errSecSuccess &&
           SecItemAdd(refreshTokenQuery as CFDictionary, nil) == errSecSuccess
  }
  
  func loadAccessToken() -> String? {
    guard let service = self.service,
          let query = accessTokenQuery else { return nil }
    
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
    
    guard let data = item as? Data,
          let accessToken = String(data: data, encoding: .utf8) else { return nil }
    
    return accessToken
  }
  
  func loadRefreshToken() -> String? {
    guard let service = self.service,
          let query = refreshTokenQuery else { return nil }
    
    var item: CFTypeRef?
    if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
    
    guard let data = item as? Data,
          let refreshToken = String(data: data, encoding: .utf8) else { return nil }
    
    return refreshToken
  }
  
  func deleteTokens() -> Bool {
    guard let service = self.service,
          let accessTokenQuery = accessTokenQuery,
          let refreshTokenQuery = refreshTokenQuery else { return false }
    
    let deleteAccessTokenResult = SecItemDelete(accessTokenQuery as CFDictionary)
    let deleteRefreshTokenResult = SecItemDelete(refreshTokenQuery as CFDictionary)
    
    return deleteAccessTokenResult == errSecSuccess && deleteRefreshTokenResult == errSecSuccess
  }
}
