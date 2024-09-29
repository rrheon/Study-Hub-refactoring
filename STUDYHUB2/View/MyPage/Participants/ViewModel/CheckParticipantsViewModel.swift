//
//  CheckParticipantsViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/28/24.
//

import Foundation

import RxRelay

final class CheckParticipantsViewModel: CommonViewModel {
  let participateManager = ParticipateManager.shared
  let myReqeustManager = MyRequestManager.shared
  
  var studyID: Int
  var setting: SettinInspection = .standby
  lazy var settingValue = setting.description
  
  var applyUserData = PublishRelay<[ApplyUserContent]>()
  var totalCount = PublishRelay<Int>()
  
  init(_ studyID: Int) {
    self.studyID = studyID
    super.init()
    getParticipateInfo(type: self.settingValue.description)
  }
  
  // MARK: - 참여자 데이터 가져오기
  
  func getParticipateInfo(type: String){
    participateManager.getApplyUserData(inspection: type, page: 0, size: 50, studyID) { result in
      self.applyUserData.accept(result.applyUserData.content)
      self.totalCount.accept(result.applyUserData.number)
    }
  }
}

