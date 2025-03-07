//
//  MyParticipateStudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 10/1/24.
//

import Foundation

import RxFlow
import RxRelay

/// 내가 참여한 스터디 ViewModel
final class MyParticipateStudyViewModel: EditUserInfoViewModel, Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  /// 선택된 게시글 ID
  var selectedPostID: Int?
  
  /// 참여한 스터디 정보
  var participateInfo = BehaviorRelay<[ParticipateContent]>(value: [])
  
  /// 스터디 총 갯수
  var countPostNumber = BehaviorRelay<Int>(value: 0)
  
  /// 삭제 성공 여부
  var isSuccessToDelete = PublishRelay<Bool>()
  
  var page: Int = 0
  
  var isInfiniteScroll: Bool = true
  
  init(with userData: BehaviorRelay<UserDetailData?>) {
    if let participateCount = userData.value?.participateCount {
      self.countPostNumber.accept(participateCount)
    } else {
      self.countPostNumber.accept(0)
    }
    super.init(userData: userData)
    
    getParticipatedList()
  }
  
  
  /// 참여한  스터디 리스트 가져오기
  func getParticipatedList() {
    ApplyStudyManager.shared.getMyParticipateList(page: page) { result in
      
      var currentDatas = self.participateInfo.value
      
      if self.page == 0 {
        currentDatas = result.participateStudyData.content
      }else{
        var newDatas = result.participateStudyData.content
        currentDatas.append(contentsOf: newDatas)
      }
      
      self.participateInfo.accept(currentDatas)
      self.page += 1
      self.isInfiniteScroll = result.participateStudyData.last
      self.countPostNumber.accept(result.participateStudyData.numberOfElements)
    }
  }
  
  
  /// 참여한 스터디 개별삭제
  /// - Parameter studyID: 삭제할 스터디 ID
  func deleteParticipateList(studyID: Int){
    ApplyStudyManager.shared.deleteRequestStudy(studyId: studyID) { result in
      self.isSuccessToDelete.accept(result)
      
      switch result {
      case true:
        self.updateParticipateCount()
        self.updateParticipateContent(studyID: studyID)
      case false:
        return
      }
    }
  }
  
  /// 모든 내역 삭제
  func deleteAllParticipateList(){
    let content = participateInfo.value
    content.forEach {
      deleteParticipateList(studyID: $0.studyID ?? 0)
    }
    participateInfo.accept(content)
  }
  
  /// 참여 한 스터디 내역 업데이트
  func updateParticipateCount(){
    let count = countPostNumber.value
    let newCount = count - 1
    self.countPostNumber.accept(newCount)
    updateUserData(participateCount: newCount)
  }
  
  
  /// 참여 한 스터디 내역 업데이트
  func updateParticipateContent(deleteAll: Bool = false, studyID: Int){
    var content = participateInfo.value
    
    content.removeAll { $0.studyID == studyID }
    
    if !deleteAll { participateInfo.accept(content) }
  }
}
