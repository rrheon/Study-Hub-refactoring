//
//  CommonNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

import Moya
import UIKit

protocol CheckLoginDelegate: AnyObject {
  func checkLoginPopup()
}

final class CommonNetworking {
  static let shared = CommonNetworking()
  let loginManager = LoginManager.shared
  
  weak var delegate: CheckLoginDelegate?
  
  func moyaNetworking(networkingChoice: networkingAPI,
                      needCheckToken: Bool = false,
                      completion: @escaping (Result<Response, MoyaError>) -> Void) {
  
    if needCheckToken {
      checkingAccessToken { checkingToken in
        print("토큰 체크:\(checkingToken)")
        switch checkingToken {
        case true:
          let provider = MoyaProvider<networkingAPI>()
          provider.request(networkingChoice) { result in
            completion(result)
          }
        case false:
          return
        }
      }
    } else {
      let provider = MoyaProvider<networkingAPI>()
      provider.request(networkingChoice) { result in
        completion(result)
      }
    }
  }
  
  func checkingAccessToken(presentVC: UIViewController? = nil,
                           completion: @escaping (Bool) -> Void){
    loginManager.refreshAccessToken { result in
      switch result {
      case true:
        print("네트워킹 ㄱㄱ")
        completion(true)
      case false:
        print("로그인만료")
        self.delegate?.checkLoginPopup()
      }
    }
  }
}
