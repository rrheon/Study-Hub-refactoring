//
//  MyRequestManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/15.
//

import Foundation

final class MyRequestManager {
  
  static let shared = MyRequestManager()
  
  let commonNetwork = CommonNetworking.shared
  
  func getMyRequestStudyList(completion: @escaping (MyRequestList) -> Void){
    commonNetwork.moyaNetworking(networkingChoice: .getMyReqeustList(page: 0,
                                                                     size: 5)
                                 ,needCheckToken: true) { result in
      switch result {
      case .success(let response):
        do {
          let searchResult = try JSONDecoder().decode(MyRequestList.self,
                                                      from: response.data)
          print(searchResult)
          print(response.response)
          completion(searchResult)
        } catch {
          print(response.response)
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  func getMyRejectReason(studyId: Int,
                         completion: @escaping (RejectReason) -> Void){
    commonNetwork.moyaNetworking(networkingChoice: .getRejectReason(studyId),
                                 needCheckToken: true) { result in
      switch result{
      case .success(let response):
        do {
          let searchResult = try JSONDecoder().decode(RejectReason.self,
                                                      from: response.data)
          completion(searchResult)
        } catch {
          print(response.response)
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let response):
        print(response.response)
      }
    }
  }
}
