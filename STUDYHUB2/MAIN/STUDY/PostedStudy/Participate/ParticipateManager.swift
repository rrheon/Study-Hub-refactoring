//
//  ParticipateManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/27.
//

import Foundation

enum SettinInspection: CustomStringConvertible {
  case accept
  case reject
  case standby
  
  var description: String {
    switch self {
    case .accept:
      return "ACCEPT"
    case .reject:
      return "REJECT"
    case .standby:
      return "STANDBY"
    }
  }
}

final class ParticipateManager{
  
  static let shared = ParticipateManager()
  
  let commonNetworing = CommonNetworking.shared
  
  // MARK: - 스터디 신청
  func participateStudy(introduce: String,
                        studyId: Int,
                        completion: @escaping () -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .participateStudy(introduce: introduce,
                                                                       studyId: studyId),
                                   needCheckToken: true) { result in
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
                            completion: @escaping (TotalParticipateStudyData) -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .getMyParticipateList(page: page,
                                                                           size: size),
                                   needCheckToken: true) { result in
      switch result {
      case .success(let response):
        do {
          
          let searchResult = try JSONDecoder().decode(TotalParticipateStudyData.self,
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
  
  // MARK: - 신청한 유저 정보 가져오기
  func getApplyUserData(inspection: String,
                        page: Int,
                        size: Int,
                        _ studyId: Int,
                        completion: @escaping (TotalApplyUserData) -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .searchParticipateInfo(
      inspection: inspection,
      page: page,
      size: size,
      studyId: studyId),needCheckToken: true) { result in
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
  
  // MARK: - 스터디 참여 신청 수락
  func acceptApplyUser(personData: AcceptStudy,
                       completion: @escaping () -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .acceptParticipate(acceptPersonData: personData),needCheckToken: true) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 스터디 참여 신청 거절
  func rejectApplyUser(personData: RejectStudy,
                       completion: @escaping () -> Void){
    commonNetworing.moyaNetworking(networkingChoice: .rejectParticipate(rejectPersonData: personData),needCheckToken: true) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }
}
