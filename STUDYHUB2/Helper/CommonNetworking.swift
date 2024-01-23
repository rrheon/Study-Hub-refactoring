//
//  CommonNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

import Moya

final class CommonNetworking {
  static let shared = CommonNetworking()
  
  func moyaNetworking(networkingChoice: networkingAPI,
                      completion: @escaping (Result<Response, MoyaError>) -> Void) {
    let provider = MoyaProvider<networkingAPI>()
    provider.request(networkingChoice) { result in
      completion(result)
    }
  }
  
}
