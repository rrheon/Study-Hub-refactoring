//
//  TokenDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

// access토큰 재발급 시
struct RefreshAccessToken: Codable {
  let refreshToken: String
}

// 로그인, 토크 갱신할 때 서버로 부터의 응답
struct AccessTokenResponse: Codable {
  let accessToken: String
  let refreshToken: String
}
