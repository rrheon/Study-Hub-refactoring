//
//  CommonNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

import Moya


///  공용 네트워킹
class CommonNetworking {
  
  static let shared = CommonNetworking()
  
  /// 토큰 관리
  let tokenManager = TokenManager.shared
  
  weak var delegate: CheckLoginDelegate?
  
  func moyaNetworking(
    networkingChoice: networkingAPI,
    needCheckToken: Bool = false,
    completion: @escaping (Result<Response, MoyaError>) -> Void
  ) {
    if needCheckToken {
      checkingAccessToken { checkingToken in
        print("토큰 체크:\(checkingToken)")
        switch checkingToken {
        case true:
          let provider = MoyaProvider<networkingAPI>()
          provider.request(networkingChoice) { completion($0) }
        case false:
          return
        }
      }
    } else {
      let provider = MoyaProvider<networkingAPI>()
      provider.request(networkingChoice) { completion($0) }
    }
  }
  
  func checkingAccessToken(presentVC: UIViewController? = nil,
                           completion: @escaping (Bool) -> Void){
    
    let checkLogin = tokenManager.loadAccessToken() == nil ? false : true
    if checkLogin {
      refreshAccessToken { result in
        switch result {
        case true:
          completion(true)
        case false:
          self.delegate?.checkLoginPopup(checkUser: checkLogin)
        }
      }
    } else {
      self.delegate?.checkLoginPopup(checkUser: checkLogin)
    }
  }
  
  func refreshAccessToken(completion: @escaping (Bool) -> Void) {
    guard let refreshToken = tokenManager.loadRefreshToken() else {
      completion(false)
      return
    }
    
    moyaNetworking(networkingChoice: .refreshAccessToken(refreshToken)) { result in
      switch result {
      case .success(let response):
        do {
          if response.statusCode == 200 {
            let refreshResult = try JSONDecoder().decode(
              AccessTokenResponse.self,
              from: response.data
            )
            self.tokenManager.deleteTokens()
            
            let saveResult = self.tokenManager.saveTokens(
              accessToken: refreshResult.accessToken!,
              refreshToken: refreshResult.refreshToken!
            )
            completion(true)
          } else {
            completion(false)
          }
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let error):
        completion(false)
        print(#fileID, #function, #line," - 에러")
      }
    }
  }
}
