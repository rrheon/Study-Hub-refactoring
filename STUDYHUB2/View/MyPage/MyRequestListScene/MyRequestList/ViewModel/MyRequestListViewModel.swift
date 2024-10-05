

import Foundation

import RxRelay

final class MyRequestListViewModel: EditUserInfoViewModel {
  var myRequestListManger = MyRequestManager.shared
  
  var requestStudyList = BehaviorRelay<[RequestStudyContent]>(value: [])
  var countPostNumber = BehaviorRelay<Int>(value: 0)
  var isSuccessToDelete = PublishRelay<Bool>()
  var rejectReason = PublishRelay<RejectReason>()
  
  init(_ userData: BehaviorRelay<UserDetailData?>) {
    if let applyCount = userData.value?.applyCount {
      self.countPostNumber.accept(applyCount)
    } else {
      self.countPostNumber.accept(0)
    }
    super.init(userData: userData)
    getRequestList()
  }
  
  func getRequestList() {
    myRequestListManger.getMyRequestStudyList { [weak self] result in
      self?.requestStudyList.accept(result.requestStudyData.content)
      self?.countPostNumber.accept(result.requestStudyData.numberOfElements)
    }
  }
  
  func deleteMyReuest(_ studyID: Int){
    myRequestListManger.deleteRequestStudy(studyId: studyID) {
      self.isSuccessToDelete.accept($0)
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
  
  func getRejectReason(_ studyID: Int) {
    myRequestListManger.getMyRejectReason(studyId: studyID) {
      self.rejectReason.accept($0)
    }
//    let testReason = RejectReason(reason: "test", studyTitle: "test")
//    self.rejectReason.accept(testReason)
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
