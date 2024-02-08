//
//  CommonNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

import Moya
import UIKit


final class CommonNetworking {
  static let shared = CommonNetworking()
  let loginManager = LoginManager.shared
  
  func moyaNetworking(networkingChoice: networkingAPI,
                      completion: @escaping (Result<Response, MoyaError>) -> Void) {
  
    checkingAccessToken { checkingToken in
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
    
  }
  
  func checkingAccessToken(presentVC: UIViewController? = nil,
                           completion: @escaping (Bool) -> Void){
    loginManager.refreshAccessToken { result in
      switch result {
      case true:
        completion(true)
      case false:
        let popupVC = PopupViewController(
          title: "재로그인이 필요해요",
          desc: "보안을 위해 자동 로그아웃됐어요.\n다시 로그인해주세요.",
          leftButtonTitle: "나중에",
          rightButtonTilte: "로그인")
        
        popupVC.modalPresentationStyle = .overFullScreen
        presentVC?.present(popupVC, animated: false)
      }
    }
  }
}
