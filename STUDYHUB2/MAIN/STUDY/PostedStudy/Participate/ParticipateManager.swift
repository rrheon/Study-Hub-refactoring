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
  
  // MARK: - 스터디 신청
  func participateStudy(introduce: String,
                        studyId: Int,
                        completion: @escaping () -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .participateStudy(introduce: introduce,
                                                                       studyId: studyId)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 내가 참여한 스터디 목록조회
  func getMyParticipateList(_ page: Int,
                            _ size: Int,
                            completion: @escaping () -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .getMyParticipateList(page: page,
                                                                           size: size)) { result in
      switch result {
      case .success(let response):
        do {
          
          let searchResult = try JSONDecoder().decode(TotalParticipateStudyData.self,
                                                      from: response.data)
          print(searchResult)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }

  func getApplyUserData(page: Int,
                        size: Int,
                        _ studyId: Int,
                        completion: @escaping (TotalApplyUserData) -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .searchParticipateInfo(
      page: page,
      size: size,
      studyId: studyId)) { result in
        switch result {
        case .success(let response):
          do {
            
            let searchResult = try JSONDecoder().decode(TotalApplyUserData.self,
                                                        from: response.data)
            completion(searchResult)
          } catch {
            print("Failed to decode JSON: \(error)")
          }
        case .failure(let response):
          print(response.response)
        }
      }
  }
}
