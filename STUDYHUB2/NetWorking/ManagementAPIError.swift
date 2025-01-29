//
//  ManagementAPIError.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/27/25.
//

import Foundation

/// 에러타입
enum ApiError: Error {
  case noContent
  case decodingError
  case notAllowedUrl
  case jsonEncoding
  case badStatus(code: Int)
  case unAuthorize
  case unKnownError(_ err: Error?)
  
  
  var info: String{
    switch self {
    case .noContent:                        return "데이터가 없습니다"
    case .decodingError:                    return "디코딩 에러입니다"
    case .badStatus(let code):              return "에러상태코드\(code)"
    case .unAuthorize:                      return "인증되지 않은 사용자입니다"
    case .notAllowedUrl:                    return "올바른 url형색이 아닙니다"
    case .jsonEncoding:                     return "유효한 json이 아닙니다"
    case .unKnownError(let err):            return "알 수 없는 에러입니다. \(err)"
    }
  }
  
  
  /// API 에러 처리
  /// - Parameter error: 발생한 API 에러
  static func managementError(error: Self) {
      // 에러 메시지를 출력하거나 특정 처리를 수행
      print("API Error: \(error.info)")
      
      // 추가적인 에러 처리 로직을 여기에 추가할 수 있습니다.
      switch error {
      case .unAuthorize:
          // 인증 실패 시 로그아웃 처리 등의 추가 로직
          print("사용자를 로그아웃 처리합니다.")
      case .badStatus(let code):
          // 상태 코드에 따라 추가 행동
          if code == 404 {
              print("페이지를 찾을 수 없습니다.")
          }
      default:
          break
      }
  }
}
