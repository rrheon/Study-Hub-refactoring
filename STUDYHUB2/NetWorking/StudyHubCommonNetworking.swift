//
//  StudyHubCommonNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/27/25.
//

import Foundation

import Moya

// MARK: - common base url
#warning("jwt- controller, notice, user, user-image, comment, 전부 다 분류 후 다시 분류가 필요")
/// 베이스 URL
protocol CommonBaseURL {
  var baseURL: URL { get }
}

extension CommonBaseURL {
  var baseURL: URL {
    return URL(string: "https://studyhub.shop:443/api")!
  }
}

/// 공용 네트워킹
class StudyHubCommonNetworking {
    
  /// AccessToken 가져오기
  /// - Returns: Access Token
  func loadAccessToken() -> String?  {
    return TokenManager.shared.loadAccessToken()
  }
  
  /// API 통신 후 결과처리 - 디코딩
  /// - Parameters:
  ///   - apiResult: api 통신 결과
  ///   - type: 디코딩할 타입
   func commonDecodeNetworkResponse<T: Decodable >(
    with apiResult : Result<Response, MoyaError>,
    decode type: T.Type,
    completion: @escaping (T.Type) -> Void
  ){
    switch apiResult {
    case let .success(response):
      print(response.statusCode)

      do {
        let decodedData = try JSONDecoder().decode(type, from: response.data)
        print(decodedData)
        completion(T.self)
      } catch(_) {
        // 디코딩에러
        ApiError.managementError(error: .decodingError)
      }
      
    case let .failure(err):
      print(err.localizedDescription)
      switch err {
      case .statusCode(let response):
        ApiError.badStatus(code: response.statusCode)
      default:
        return
      }
    }
  }
}
