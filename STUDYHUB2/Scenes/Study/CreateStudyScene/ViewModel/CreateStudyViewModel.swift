import Foundation
import UIKit

import RxSwift
import RxRelay
import RxFlow

/// 스터디 생성 ViewModel
final class CreateStudyViewModel: Stepper {
  static let shared = CreateStudyViewModel()
  
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  /// 스터디 수정 시 게시글 데이터
  var postedData = BehaviorRelay<PostDetailData?>(value: nil)
  
  /// 스터디 생성 데이터
  var createStudyData: BehaviorRelay<CreateStudyRequest?> = BehaviorRelay<CreateStudyRequest?>(value: CreateStudyRequest())
  
  /// 선택된 학과
  var selectedMajor = BehaviorRelay<String?>(value: nil)
  
  /// 스터디인원
  lazy var studyMemberValue = BehaviorRelay<Int?>(value: nil)
  
  /// 선택된 성별버튼
  var selectedGenderButton = BehaviorRelay<UIButton?>(value: nil)

 /// 선택된 스터디 방식 버튼
  var selectedStudyWayValue = BehaviorRelay<UIButton?>(value: nil)
  
  /// 벌금 선택 여부
  var isFineButton = PublishRelay<Bool>()
  
  /// 스터디 시작날짜
  var startDate = BehaviorRelay<String>(value: "선택하기")
  
  /// 스터디 종료날짜
  var endDate = BehaviorRelay<String>(value: "선택하기")
  
  var isSuccessCreateStudy = PublishRelay<Bool>()
  var isSuccessModifyStudy = PublishRelay<Bool>()
  
  init(data: PostDetailData? = nil) {
    /// 스터디 수정 시 데이터 넣어주기
    if let data = data {
      self.postedData.accept(data)
    }
  }
  
  
  /// 새로운 스터디 생성하기
  func createNewStudyPost(){
    var updatedData = self.createStudyData.value
    updatedData?.close = false
    updatedData?.penalty = 0
    updatedData?.penaltyWay = ""
    self.createStudyData.accept(updatedData)
    
    guard let data = createStudyData.value else { return }

    print(data)
    /// close - false,   벌금은 nil
    StudyPostManager.shared.createNewPost(with: data)
  }
  
  
  /// 스터디 생성가능 여부 체크
  /// - Parameter data: 생성할 스터디 데이터
  /// - Returns: 생성가능 여부
  func checkValidCreateStudyData(with data: CreateStudyRequest?) -> Bool {
      guard let data = data else { return false }

      return !(data.chatUrl.isEmpty) &&
             !(data.content.isEmpty) &&
             !(data.gender.isEmpty) &&
             !(data.major.isEmpty) &&
             !(data.studyEndDate.isEmpty) &&
             (data.studyPerson != 0) &&
             !(data.studyStartDate.isEmpty) &&
             !(data.studyWay.isEmpty) &&
             !(data.title.isEmpty)
  }


  

  func createOrModifyPost(){
//    switch mode {
//    case .POST:
//      let value = createPostValue()
//    
//  
//      return createPost(value) { postID in
//        guard let convertedPostID = Int(postID) else { return }
//        self.isSuccessCreateStudy.accept(true)
//        self.fetchSinglePostDatas(convertedPostID) { updatedPostValue in
//        self.postedData.accept(updatedPostValue)
//        }
//      }
//      
//    case .PUT:
//      let updateRequestValue = updatePostValue()
//      return modifyMyPost(updateRequestValue) {
//        self.isSuccessModifyStudy.accept($0)
//        self.fetchSinglePostDatas(updateRequestValue.postId) { updatedPostValue in
//          self.postedData.accept(updatedPostValue)
//        }
//      }
//    }
  }
  
  func changeDate(_ date: [Int]) -> String{
    let convertedDate = "\(date[0])-\(date[1])-\(date[2])"
    let changedDate = convertedDate.convertDateString(from: .format3, to: "yyyy-MM-dd")
    return changedDate
  }
//  
//  func comparePostData() -> Bool{
////    let request = createPostValue()
//    let detail = postedData.value
//    
//    return request == detail?.toCreateStudyRequest()
//  }
}

extension CreateStudyViewModel: ManagementDate {}
