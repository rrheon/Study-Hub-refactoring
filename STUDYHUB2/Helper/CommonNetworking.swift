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
  func checkLoginPopup(checkUser: Bool)
}

final class CommonNetworking {
  static let shared = CommonNetworking()
  let loginManager = LoginManager.shared
  let tokenManager = TokenManager.shared
  
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
  
    let checkLogin = tokenManager.loadAccessToken() == nil ? false : true
    if checkLogin {
      loginManager.refreshAccessToken { result in
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
}
