//
//  AppStep+StudyManagement.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/27/25.
//

import UIKit
import RxFlow
import RxRelay

/// 스터디 관리 관련 화면 이동
enum StudyManagementStep {
  // 스터디 생성, 수정 화면
  case studyFormScreenIsRequired(data: PostDetailData?)
  
  // 학과 선택 화면
  case selectMajorScreenIsRequired(seletedMajor: BehaviorRelay<String?>)
  
  // 스터디 생성 / 수정 시 날짜선택(캘린더) 화면
  case calendarIsRequired(viewModel: StudyFormViewModel, selectType: Bool)
  
  // 내가 작성한 스터디 리스트 화면
  case myStudyPostIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  // 내가 참여한 스터디 리스트 화면
  case myParticipateStudyIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  // 내가 신청한 스터디 리스트 화면
  case myRequestStudyIsRequired(userData: BehaviorRelay<UserDetailData?>)
  
  // 참여자 확인하기 화면
  case managementAttendeeIsRequired(studyID: Int)
  
  // 거절사유 bottomSheet
  case refuseBottomSheetIsRequired(userId: Int)
  
  // 거절 사유 작성 화면
  case writeRefuseReasonScreenIsRequired(userId: Int)
  
  // 자세한 거절사유 화면으로 이동
  case detailRejectReasonScreenIsRequired(reason: RejectReason)
}

extension AppFlow {
  func navigateStudyManagement(step: StudyManagementStep) -> FlowContributors {
    switch step {
    case .studyFormScreenIsRequired(let data):
      return navTostudyFormScreen(data: data)
    case .selectMajorScreenIsRequired(let selectedMajor):
      return navToSelectMajorScreen(major: selectedMajor)
    case .calendarIsRequired(let viewModel, let selectType):
      return presentCalendarScreen(viewModel: viewModel, selectType: selectType)
    case .myStudyPostIsRequired(let userData):
      return navToMyPostScreen(with: userData)
    case .myParticipateStudyIsRequired(let userData):
      return navToMyParticipateScreen(with: userData)
    case .myRequestStudyIsRequired(let userData):
      return navToMyRequestListScreen(with: userData)
    case .managementAttendeeIsRequired(let studyID):
      return navToManagementAttendeeScreen(studyID: studyID)
    case .refuseBottomSheetIsRequired(let userId):
      return presentRefuseBottomSheet(userId: userId)
    case .writeRefuseReasonScreenIsRequired(let userId):
      return navToWriteRefusereaonScreen(userID: userId)
    case .detailRejectReasonScreenIsRequired(let reason):
      return navToRejectReasonScreen(rejectReason: reason)
    }
  }
  
  /// 스터디 생성 / 수정 화면으로 이동
  /// - Parameter data: 스터디 데이터 - nil -> 스터디 생성 , 데이터 존재 -> 스터디 수정
  func navTostudyFormScreen(data: PostDetailData? = nil) -> FlowContributors {
    let viewModel: StudyFormViewModel = StudyFormViewModel(data: data)
    let vc = StudyFormViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 학과 선택 화면으로 이동
  /// - Parameter major: 선택된 학과가 있는 경우
  func navToSelectMajorScreen(major: BehaviorRelay<String?>) -> FlowContributors {
    let viewModel: SeletMajorViewModel = SeletMajorViewModel(enteredMajor: major)
    let vc = SeletMajorViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 내가 작성한 스터디 리스트 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  func navToMyPostScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = MyPostViewModel(userData: userData)
    let vc = MyPostViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 내가 참여한 스터디 리스트 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  func navToMyParticipateScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = MyParticipateStudyViewModel(with: userData)
    let vc = MyParticipateStudyVC(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  
  /// 내가 신청한 스터디 리스트 화면으로 이동
  /// - Parameter userData: 유저 프로필 데이터
  func navToMyRequestListScreen(with userData: BehaviorRelay<UserDetailData?>) -> FlowContributors {
    let viewModel = MyRequestListViewModel(with: userData)
    let vc = MyRequestListViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 신청한 인원 거절 사유 선택 bottomSheet
  /// - Parameter userId: 거절할 user의 id
  func presentRefuseBottomSheet(userId: Int) -> FlowContributors {
    let vc = SelectStudyRefuseViewController(userId: userId)
    showBottomSheet(bottomSheetVC: vc, size: 387.0)
    
    if let topVC = self.rootViewController.viewControllers.last as? RefuseBottomSheetDelegate {
      vc.delegate = topVC
    }
    self.rootViewController.present(vc, animated: true)
    return .none
  }
  
  
  /// 거절사유 작성 화면으로 이동
  /// - Parameter userID: 거절할 user의 id
  func navToWriteRefusereaonScreen(userID: Int) -> FlowContributors {
    let vc = WriteRefuseReasonVC(userId: userID)
    
    if let topVC = self.rootViewController.viewControllers.last as? WriteRefuseReasonVCDelegate {
      vc.delegate = topVC
    }
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
  
  
  /// 거절 사유확인 화면으로 이동
  /// - Parameter rejectReason: 거절사유
  func navToRejectReasonScreen(rejectReason: RejectReason) -> FlowContributors {
    let vc = DetailRejectReasonViewController(rejectData: rejectReason)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
  
  
  /// 참여자 관리 화면으로 이동
  /// - Parameter studyID: StudyID
  func navToManagementAttendeeScreen(studyID: Int) -> FlowContributors {
    let viewModel = CheckParticipantsViewModel(studyID)
    let vc = CheckParticipantsViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
}
