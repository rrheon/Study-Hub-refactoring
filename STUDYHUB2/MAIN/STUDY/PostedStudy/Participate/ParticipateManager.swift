//
//  ParticipateManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/27.
//

import Foundation

final class ParticipateManager{
  
  static let shared = ParticipateManager()
  
  let commonNetworing = CommonNetworking.shared
  
  func participateStudy(introduce: String, studyId: Int){
    commonNetworing.moyaNetworking(networkingChoice: .participateStudy(introduce: introduce,
                                                                       studyId: studyId)) { result in
      switch result {
      case .success(let response):
        print(response.response)
      case .failure(let response):
        print(response.response)
      }
    }
  }
}
