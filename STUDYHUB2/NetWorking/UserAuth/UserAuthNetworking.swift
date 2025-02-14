//
//  UserAuthNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import UIKit

import Moya

/// 유저 인증관련 네트워킹
enum UserAuthNetworking{
  case loginToStudyHub(email: String, password: String)   //  로그인
  case createNewAccount(accountData: CreateAccount)       // 회원가입
  case verifyPassword(password: String)                   // 비밀번호 검증
  case refreshAccessToken(refreshToken: String)           // accessToken 발행
  case sendEmailCode(email: String)                       // 이메일 인증코드 전송
  case checkEmailDuplication(email: String)               // 이메일 중복검사
//  case sendEmailForVerifyPassword(email: String)          // 비밀번호 검증용 이메일 인증코드 전송
  case verifyEmailAndCode(code: String, email: String)    // 이메일 인증코드 검증
}

extension UserAuthNetworking: TargetType, CommonBaseURL {
  
  /// API 별 요청 path
  var path: String {
    switch self {
    case .loginToStudyHub(_, _):            return "/v1/users/login"
    case .createNewAccount(_):              return "/v1/users/signup"
    case .verifyPassword(_):                return "/v1/users/password/verify"
    case .refreshAccessToken(_):            return "/jwt/v1/accessToken"
    case .sendEmailCode(_):                 return "/v1/email"
    case .checkEmailDuplication(_):         return "/v1/email/duplication"
//    case .sendEmailForVerifyPassword(_):    return "/v1/users/password"
    case .verifyEmailAndCode(_, _):         return "/v1/email/verify"
    }
  }
  
  
  /// API 별 메소드
  var method: Moya.Method {
    return .post
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .verifyEmailAndCode(let code, let email):
      let params: [String: Any] = ["authCode": code, "email": email]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)

    case .checkEmailDuplication(let email):
      let params: [String: Any] = ["email": email]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    case .sendEmailCode(let email):
      let params: [String: Any] = ["email": email]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
//    case .sendEmailForVerifyPassword(let email):
//      let params: [String: Any] = ["email": email]
//      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
//      
    case .loginToStudyHub(let email, let password):
      let params: [String: Any] = ["email": email, "password": password]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    case .createNewAccount(let accountData):
      return .requestJSONEncodable(accountData)
      
    case .verifyPassword(let password):
      let params: [String: Any] = ["password": password]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    case .refreshAccessToken(let refreshToken):
      let params: [String: Any] = ["refreshToken": refreshToken]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
  }
  
  
  /// API 별 헤더
  var headers: [String : String]? {
    
    switch self {
    case .verifyEmailAndCode(_, _):
      return ["Accept" : "application/json"]
    
    case .verifyPassword(_):
      return ["Authorization": "\(TokenManager.shared.loadAccessToken() ?? "")"]

    default:
      return ["Content-type": "application/json"]
    }
  }
}
