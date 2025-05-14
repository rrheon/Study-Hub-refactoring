import Foundation
import UIKit

import RxSwift
import RxRelay
import RxFlow

/// 스터디 생성 ViewModel
final class StudyFormViewModel: Stepper {
  static let shared = StudyFormViewModel()
  
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  /// 스터디 수정 시 게시글 데이터
  var postedData = BehaviorRelay<PostDetailData?>(value: nil)
  
  /// 스터디 생성 데이터
  var createStudyData: BehaviorRelay<CreateStudyRequest?> =
  BehaviorRelay<CreateStudyRequest?>(value: CreateStudyRequest())
  
  /// 선택된 학과
  var selectedMajor = BehaviorRelay<String?>(value: nil)
  
  /// 스터디인원
  lazy var studyMemberValue = BehaviorRelay<Int?>(value: nil)
  
  /// 선택된 성별버튼
  var selectedGenderButton = BehaviorRelay<UIButton?>(value: nil)

 /// 선택된 스터디 방식 버튼
  var selectedStudyWayValue = BehaviorRelay<UIButton?>(value: nil)
  
  /// 벌금 선택 여부
  var isFineButton = BehaviorRelay<Bool?>(value: nil)
  
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
    
    /// 벌금이 없는 경우
    if updatedData?.penaltyWay == nil {
      updatedData?.penalty = 0
      updatedData?.penaltyWay = ""
    }
    
    self.createStudyData.accept(updatedData)
    
    guard let data = createStudyData.value else { return }

    /// close - false,   벌금은 nil
    StudyPostManager.shared.createNewPostWithRx(with: data)
      .subscribe(onNext: { [weak self] postID in
        if let _postID = postID {
          /// 생성 후 회면 내리기
          self?.steps.accept(AppStep.navigation(.popCurrentScreen(animate: false)))
          
          /// 생성한 게시글로 이동
          self?.steps.accept(AppStep.study(.studyDetailScreenIsRequired(postID: _postID)))
          
          ToastPopupManager.shared.showToast(message: "게시글이 작성됐어요.")
        }
        
      }, onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      }).disposed(by: disposeBag)
//    
//    /// close - false,   벌금은 nil
//    StudyPostManager.shared.createNewPost(with: data) { postID in
//      if let _postID = postID {
//        /// 생성 후 회면 내리기
//        self.steps.accept(AppStep.navigation(.popCurrentScreen(animate: false)))
//        
//        /// 생성한 게시글로 이동
//        self.steps.accept(AppStep.study(.studyDetailScreenIsRequired(postID: _postID)))
//        
//        ToastPopupManager.shared.showToast(message: "게시글이 작성됐어요.")
//      }
//    }
  }
  
  /// 게시글 수정
  func modifyStudyPost(){
    /// 게시글 상세 -> 수정의 경우 데이터가 비어있지 않으면 생성
    guard let postedData = postedData.value else {
      createNewStudyPost()
      return
    }
    
    if let data = createStudyData.value {
      let modifyData = UpdateStudyRequest(from: data, postId: postedData.postId)
      
      StudyPostManager.shared.modifyPostWithRx(with: modifyData)
        .subscribe(onNext: { [weak self] postID in
          self?.steps.accept(AppStep.navigation(.popCurrentScreen(animate: false)))

          ToastPopupManager.shared.showToast(message: "글이 수정됐어요.")
        },onError: { err in
          self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
        })
        .disposed(by: disposeBag)
    }
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

  func changeDate(_ date: [Int]) -> String{
    let convertedDate = "\(date[0])-\(date[1])-\(date[2])"
    let changedDate = convertedDate.convertDateString(from: .format3, to: "yyyy-MM-dd")
    return changedDate
  }
}

extension StudyFormViewModel: ManagementDate {}
