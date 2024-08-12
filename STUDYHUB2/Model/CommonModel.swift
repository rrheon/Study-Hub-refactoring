//
//  CommonModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/12/24.
//

import Foundation

protocol CommonProtocol {
  var commonNetworking: CommonNetworking { get }
}

extension CommonProtocol {
  var commonNetworking: CommonNetworking {
    return CommonNetworking.shared
  }
}

