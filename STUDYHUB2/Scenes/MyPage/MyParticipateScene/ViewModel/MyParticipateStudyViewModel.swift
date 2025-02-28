//
//  MyParticipateStudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 10/1/24.
//

import Foundation

import RxFlow
import RxRelay

final class MyParticipateStudyViewModel: EditUserInfoViewModel, Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  

  
  var participateInfo = BehaviorRelay<[ParticipateContent]>(value: [])
  var countPostNumber = BehaviorRelay<Int>(value: 0)
  var isSuccessToDelete = PublishRelay<Bool>()
  
  init(with userData: BehaviorRelay<UserDetailData?>) {
    if let participateCount = userData.value?.participateCount {
      self.countPostNumber.accept(participateCount)
    } else {
      self.countPostNumber.accept(0)
    }
    super.init(userData: userData)
    
    getRequestList()
  }
  
  
  func getRequestList() {
//    participateManager.getMyParticipateList(0, 5) { result in
//      self.participateInfo.accept(result.participateStudyData.content)
//      self.countPostNumber.accept(result.participateStudyData.numberOfElements)
//    }
  }
  
  func deleteParticipateList(studyID: Int){
//    myRequestListManger.deleteRequestStudy(studyId: studyID) { result in
//      self.isSuccessToDelete.accept(result)
//      
//      switch result {
//      case true:
//        self.updateParticipateCount()
//        self.updateParticipateContent(studyID: studyID)
//      case false:
//        return
//      }
//    }
  }
  
  func deleteAllParticipateList(){
    let content = participateInfo.value
    content.forEach {
      deleteParticipateList(studyID: $0.studyID)
    }
    participateInfo.accept(content)
  }
  
  func updateParticipateCount(){
    let count = countPostNumber.value
    let newCount = count - 1
    self.countPostNumber.accept(newCount)
    updateUserData(participateCount: newCount)
  }
  
  func updateParticipateContent(deleteAll: Bool = false, studyID: Int){
    var content = participateInfo.value
    
    content.removeAll { $0.studyID == studyID }
    
    if !deleteAll { participateInfo.accept(content) }
  }
}
