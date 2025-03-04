//
//  StudyHubCommonNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/27/25.
//

import Foundation

import Moya

// MARK: - common base url
#warning("전부 다 분류 후 다시 분류가 필요")
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
  /// 타이머
  var timer: Timer?
  
  /// 로그인 상태
  var loginStatus: Bool = false
  
  init(){
    print(#fileID, #function, #line," - test")
        
    // 5분 간격으로 AccessToken 다시 받아오기
    registerCheckValidAccessToken()
  }
  
  
  /// 주기적으로 AccessToken 갱신 - 5분간격
  func registerCheckValidAccessToken(){
    timer = Timer.scheduledTimer(timeInterval: 300.0,
                                 target: self,
                                 selector: #selector(fetchAccessToken),
                                 userInfo: nil,
                                 repeats: true)
  }
  
  
  /// AccessToken 다시 받아오기
  @objc func fetchAccessToken(){
    guard let refreshToken = TokenManager.shared.loadRefreshToken() else {
      loginStatus = false
      return
    }
    UserAuthManager.shared.refreshAccessToken(refreshToken: refreshToken) { tokens in
      if let accessToken = tokens?.accessToken,
         let refreshToken = tokens?.refreshToken {
        self.loginStatus = TokenManager.shared.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
      } else {
        self.loginStatus = false
      }
    }
  }
  
  /// API 통신 후 결과처리 - 디코딩
  /// - Parameters:
  ///   - apiResult: api 통신 결과
  ///   - type: 디코딩할 타입
   func commonDecodeNetworkResponse<T: Decodable>(
    with apiResult : Result<Response, MoyaError>,
    decode type: T.Type,
    completion: @escaping (T) -> Void
  ){
    switch apiResult {
    case let .success(response):
      print(response.statusCode)

      do {
        let decodedData = try JSONDecoder().decode(type, from: response.data)
        print(decodedData)
        completion(decodedData)
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
  
  func commonDecodeNetworkResponse<T: Decodable>(
    with apiResult: Result<Response, MoyaError>,
    decode type: T.Type
  ) async throws -> T {
    switch apiResult {
    case let .success(response):
      print("Status Code: \(response.statusCode)")
      
      do {
        let decodedData = try JSONDecoder().decode(type, from: response.data)
        print("Decoded Data: \(decodedData)")
        return decodedData
      } catch {
        print("Decoding Error: \(error.localizedDescription)")
        ApiError.managementError(error: .decodingError) // 로깅
        throw ApiError.decodingError
      }
      
    case let .failure(err):
      print("Network Error: \(err.localizedDescription)")
      
      if case .statusCode(let response) = err {
        ApiError.managementError(error: .badStatus(code: response.statusCode)) // 로깅
        throw ApiError.badStatus(code: response.statusCode)
      } else {
        throw err
      }
    }
  }

}

// MARK: - Moya Request 변환

extension MoyaProvider {
  
  /// completion -> async로 변환
  func request(_ target: Target) async -> Result<Response, MoyaError> {
    await withCheckedContinuation { continuation in
      self.request(target) { result in
        continuation.resume(returning: result)
      }
    }
  }
}
