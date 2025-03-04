

import Foundation

import RxFlow
import RxRelay

/// 신청한 스터디 관리 ViewModel
final class MyRequestListViewModel: EditUserInfoViewModel, Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  /// 선택된 신청한 스터디ID
  var selectedPostID: Int?
  
  /// 신청한 스터디 리스트
  var requestStudyList = BehaviorRelay<[RequestStudyContent]>(value: [])
  
  /// 스터디 갯수
  var countPostNumber = BehaviorRelay<Int>(value: 0)
  
  /// 삭제 성공여부
  var isSuccessToDelete = PublishRelay<Bool>()
  
  /// 거절 사유
  var rejectReason = PublishRelay<RejectReason>()
  
  init(with userData: BehaviorRelay<UserDetailData?>) {
    if let applyCount = userData.value?.applyCount {
      self.countPostNumber.accept(applyCount)
    } else {
      self.countPostNumber.accept(0)
    }
    super.init(userData: userData)
    getRequestList()
  }
  
  
  /// 신청한 스터디 리스트 가져오기
  func getRequestList() {
    ApplyStudyManager.shared.getMyRequestStudyList { result in
      self.requestStudyList.accept(result.requestStudyData.content)
      self.countPostNumber.accept(result.requestStudyData.numberOfElements)
    }
  }
  
  
  /// 신청한 스터디 삭제하기
  /// - Parameter studyID: 스터디ID
  func deleteMyReuest(_ studyID: Int){
    ApplyStudyManager.shared.deleteRequestStudy(studyId: studyID) { result in
      self.isSuccessToDelete.accept(result)
      self.updateMyRequestList(studyID)
    }
  }
  
  func updateMyRequestList(_ studyID: Int){
    var currentValue = requestStudyList.value
    currentValue.removeAll { $0.studyID == studyID }
    requestStudyList.accept(currentValue)
    
    updateUserData(applyCount: countPostNumber.value - 1)
    countPostNumber.accept(countPostNumber.value - 1)
  }

  
  /// 거절 사유 가져오기
  func getRejectReason(_ studyID: Int) {
    ApplyStudyManager.shared.getMyRejectReason(studyId: studyID) { result in
      self.rejectReason.accept(result)
    }
  }
  
  func test(){
    let testDatas = [ 
      RequestStudyContent(inspection: "STANDBY", introduce: "test1", studyID: 1, studyTitle: "test1"),
      RequestStudyContent(inspection: "REJECT", introduce: "test2", studyID: 2, studyTitle: "test2")
    ]
    requestStudyList.accept(testDatas)
    countPostNumber.accept(testDatas.count)
  }
}
