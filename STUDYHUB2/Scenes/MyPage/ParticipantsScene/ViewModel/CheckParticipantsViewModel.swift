//
//  CheckParticipantsViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/28/24.
//

import Foundation

import RxRelay

enum ParticipateStatus {
  case standby
}

final class CheckParticipantsViewModel {
  
  var studyID: Int
  var buttonStatus: ParticipateStatus = .standby
  
  var waitingUserData = PublishRelay<[ApplyUserContent]>()
  var participateUserData = PublishRelay<[ApplyUserContent]>()
  var refuseUserData = PublishRelay<[ApplyUserContent]>()
  var totalCount = PublishRelay<Int>()
  
  init(_ studyID: Int) {
    self.studyID = studyID
    getParticipateInfo(type: self.buttonStatus)
  }
  
  // MARK: - 참여자 데이터 가져오기
  
  func getParticipateInfo(type: ParticipateStatus){
    buttonStatus = type
    
//    participateManager.getApplyUserData(
//      inspection: type.description,
//      page: 0,
//      size: 50,
//      studyID
//    ) { result in
//      switch type {
//      case .standby:
//        self.waitingUserData.accept(result.applyUserData.content)
//      case .accept:
//        self.participateUserData.accept(result.applyUserData.content)
//      case .reject:
//        self.refuseUserData.accept(result.applyUserData.content)
//      }
//      
//      self.totalCount.accept(result.applyUserData.numberOfElements)
//    }
  }
}
