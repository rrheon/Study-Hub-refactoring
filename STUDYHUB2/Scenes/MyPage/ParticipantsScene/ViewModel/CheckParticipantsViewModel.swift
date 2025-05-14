//
//  CheckParticipantsViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/28/24.
//

import Foundation

import RxSwift
import RxFlow
import RxRelay

/// 참여 신청한 사용자들의 상태
enum ParticipateStatus {
  case standby
  case accept
  case reject
  
  var content: String {
    switch self {
      case .standby:    return "STANDBY"
      case .accept:     return "ACCEPT"
      case .reject:     return "REJECT"
    }
  }
}

/// 스터디 참여신청한 참여자 관리 viewModel
final class CheckParticipantsViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  let disposeBag: DisposeBag = DisposeBag()

  /// 수락 / 거절 할 사용자 ID
  var userID: Int? = nil
  
  /// 스터디 ID
  var studyID: Int
  
  /// 터치한 버튼에 따른 참여자들 상태
  var buttonStatus: ParticipateStatus = .standby
  
  /// 대기인원 데이터
  var studyUserData = PublishRelay<[ApplyUserContent]>()
  
  /// 전체 갯수
  var totalCount = PublishRelay<Int>()
  
  init(_ studyID: Int) {
    self.studyID = studyID
    getParticipateInfo(type: self.buttonStatus)
  }
  
  // MARK: - 참여자 데이터 가져오기
  
  
  /// 참여자 데이터 가져오기
  /// - Parameter type: 참여자의 타입
  func getParticipateInfo(type: ParticipateStatus){
    buttonStatus = type
    
    ApplyStudyManager.shared
      .getApplyUserDataWithRx(inspection: buttonStatus.content, page: 0, size: 50, studyId: studyID)
      .subscribe(onNext: { [weak self] applyUsers in
        self?.studyUserData.accept(applyUsers.applyUserData.content)
        self?.totalCount.accept(applyUsers.applyUserData.numberOfElements)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
    
//    
//    ApplyStudyManager.shared.getApplyUserData(inspection: buttonStatus.content,
//                                              page: 0,
//                                              size: 50,
//                                              studyId: studyID) { result in
//      self.studyUserData.accept(result.applyUserData.content)
//      self.totalCount.accept(result.applyUserData.numberOfElements)
//    }
  }
  
  
  /// 신청한 유저 수락하기

  func acceptPerson(completion: @escaping () -> Void){
    guard let userID = userID else { return }
    let personData = AcceptStudy(rejectedUserId: userID , studyId: studyID)

    ApplyStudyManager.shared.acceptApplyUserWithRx(personData: personData)
      .subscribe( onNext: { _ in
        ToastPopupManager.shared.showToast(message: "수락이 완료됐어요")
        completion()
      },onError: { _ in
        ToastPopupManager.shared.showToast(message: "수락에 실패했습니다. 다시 시도해주세요!")
      })
      .disposed(by: disposeBag)
      
//    ApplyStudyManager.shared.acceptApplyUser(personData: personData) {
//      completion()
//    }
  }
  
  /// 신청한 인원 거절하기
  func rejectPerson(reason: String, completion: @escaping () -> Void){
    guard let userID = userID else { return }

    let personData = RejectStudy(rejectReason: reason, rejectedUserId: userID, studyId: studyID)
    
    ApplyStudyManager.shared.rejectApplyUser(personData: personData)
      .subscribe(onNext: { _ in
        ToastPopupManager.shared.showToast(message: "거절이 완료됐어요")
        completion()
      },onError: { _ in
        ToastPopupManager.shared.showToast(message: "거절에 실패했습니다. 다시 시도해주세요!")
      })
      .disposed(by: disposeBag)
    
//    ApplyStudyManager.shared.rejectApplyUser(personData: personData) {
//      completion()
//    }
  }
}
