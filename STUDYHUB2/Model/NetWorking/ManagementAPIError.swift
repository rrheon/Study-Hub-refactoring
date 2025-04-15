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
    case .notAllowedUrl:                    return "올바른 url형식이 아닙니다"
    case .jsonEncoding:                     return "유효한 json이 아닙니다"
    case .unKnownError(let err):            return "알 수 없는 에러입니다. \(err)"
    }
  }
  
  
  /// API 에러 처리
  /// - Parameter error: 발생한 API 에러
  static func managementError(error: Self) -> String {
    switch error {
    case .unAuthorize: return "인증 실패: 다시 로그인해주세요."
      
    case .badStatus(let code):
      switch code {
      case 400: return ApiError.decodingError.info
      case 401: return "인증되지 않은 요청입니다. 다시 로그인하세요."
      case 403: return "접근이 거부되었습니다."
      case 404: return "요청한 페이지를 찾을 수 없습니다."
      case 500: return "로그인 정보가 만료되었습니다."
      default: return "서버 오류 발생 (코드: \(code))"
      }
    default:
      return error.info
    }
  }
  
  /// 서버 응답 처리하기
  /// - Parameter statusCode: 상태코드
  /// - Returns: 에러 및 응답 반환
  func handleResponse(statusCode: Int) -> Result<Void, ApiError> {
    switch statusCode {
    case 200...299:
      return .success(())
    case 400:
      return .failure(.badStatus(code: 400))
    case 401:
      return .failure(.unAuthorize)
    case 403:
      return .failure(.badStatus(code: 403))
    case 404:
      return .failure(.badStatus(code: 404))
    case 500:
      return .failure(.badStatus(code: 500))
    default:
      return .failure(.unKnownError(nil))
    }
  }
}
