//
//  ApplyStudyManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//

import Foundation

import RxSwift
import RxMoya
import Moya


/// 스터디 신청 관련 네트워킹
class ApplyStudyManager: StudyHubCommonNetworking {
  static let shared = ApplyStudyManager()
  
  let provider = MoyaProvider<ApplyStudyNetworking>()
  
  // MARK: - 스터디 신청
  
  /// 스터디 신청하기
  /// - Parameters:
  ///   - introduce: 자기소개
  ///   - studyId: 해당 스터디 아이디
  ///   - completion: 결과갑 반환
  func participateStudy(introduce: String, studyId: Int, completion: @escaping (Bool) -> Void){
    provider.request(.participateStudy(introduce: introduce, studyId: studyId)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion(true)
      case .failure(let response):
        print(response.response)
        completion(false)
      }
    }
  }
  
  func participateStudyWithRx(introduce: String, studyId: Int) -> Observable<Bool> {
    return provider.rx.request(.participateStudy(introduce: introduce, studyId: studyId))
          .asObservable()
          .map { response in
            return (200...299).contains(response.statusCode)
          }
          .catchAndReturn(false)
//    provider.request(.participateStudy(introduce: introduce, studyId: studyId)) { result in
//      switch result {
//      case .success(let response):
//        print(response.response)
//        completion(true)
//      case .failure(let response):
//        print(response.response)
//        completion(false)
//      }
//    }
  }
  
  // MARK: - 내가 참여한 스터디 목록조회
  
  /// 내가 참여한 스터디 목록조회
  /// - Parameters:
  ///   - page: 목록페이지
  ///   - size: 스터디 갯수
  ///   - completion: 결과값 반환
  func getMyParticipateList(
    page: Int = 0,
    size: Int = 5,
    completion: @escaping (TotalParticipateStudyData) -> Void
  ){
    provider.request(.getMyParticipateList(page: page, size: size)) { result in
      print(#fileID, #function, #line," - \(result)")

      self.commonDecodeNetworkResponse(with: result,
                                       decode: TotalParticipateStudyData.self) { decodedData in
        completion(decodedData)
      }
    }
  }
  
  /// 내가 참여한 스터디 목록조회 with Rx
  /// - Parameters:
  ///   - page: 목록페이지
  ///   - size: 스터디 갯수
  ///   - completion: 결과값 반환
  func getMyParticipateListWithRx(page: Int = 0,
                                  size: Int = 5) -> Observable<TotalParticipateStudyData> {
    return provider.rx
          .request(.getMyParticipateList(page: page, size: size))
          .asObservable()
          .flatMap { response -> Observable<TotalParticipateStudyData> in
            self.commonDecodeNetworkResponse(with: response, decode: TotalParticipateStudyData.self)
          }
  }
  
  // MARK: - 신청한 유저 정보 가져오기
  
  /// 스터디 신청한 유저정보 가져오기
  /// - Parameters:
  ///   - inspection: 상태정보 -  ACCEPT 승인 , REJECT : 거절 ,STANDBY : 대기
  ///   - page: 목록 페이지
  ///   - size: 유저 갯수
  ///   - studyId: 해당 스터디의 Id
  ///   - completion: 결과값 반환
  func getApplyUserData(
    inspection: String,
    page: Int,
    size: Int,
    studyId: Int,
    completion: @escaping (TotalApplyUserData) -> Void
  ){
    let data: StudyApplyUserInfos = StudyApplyUserInfos(
      inspection: inspection,
      page: page,
      size: size,
      studyId: studyId
    )
    
    provider.request(.searchParticipateInfo(data: data)) { result in
      self.commonDecodeNetworkResponse(with: result,
                                       decode: TotalApplyUserData.self
      ) { decodedData in
        completion(decodedData)
      }
    }
  }
  
  /// 스터디 신청한 유저정보 가져오기
  /// - Parameters:
  ///   - inspection: 상태정보 -  ACCEPT 승인 , REJECT : 거절 ,STANDBY : 대기
  ///   - page: 목록 페이지
  ///   - size: 유저 갯수
  ///   - studyId: 해당 스터디의 Id
  ///   - completion: 결과값 반환
  func getApplyUserDataWithRx(inspection: String,
                              page: Int,
                              size: Int,
                              studyId: Int) -> Observable<TotalApplyUserData>{
    
    let data: StudyApplyUserInfos = StudyApplyUserInfos(
      inspection: inspection,
      page: page,
      size: size,
      studyId: studyId
    )
    
    return provider.rx
          .request(.searchParticipateInfo(data: data))
          .asObservable()
          .flatMap { resposne -> Observable<TotalApplyUserData> in
            self.commonDecodeNetworkResponse(with: resposne, decode: TotalApplyUserData.self)
          }
  }
  
  
  // MARK: - 스터디 참여 신청 수락
  
  /// 스터디 신청 수락
  /// - Parameters:
  ///   - personData: 해당 사람의 정보
  ///   - completion: 콜백함수
  func acceptApplyUser(personData: AcceptStudy, completion: @escaping () -> Void){
    provider.request(.acceptParticipate(acceptPersonData: personData)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  /// 스터디 신청 수락 with RX
  /// - Parameters:
  ///   - personData: 해당 사람의 정보
  func acceptApplyUserWithRx(personData: AcceptStudy) -> Observable<Bool> {
    return provider.rx
          .request(.acceptParticipate(acceptPersonData: personData))
          .asObservable()
          .map { response in
            return (200...299).contains(response.statusCode)
          }
          .catchAndReturn(false)
  }
  
  // MARK: - 스터디 참여 신청 거절
  
  /// 스터디 신청 거절
  /// - Parameters:
  ///   - personData: 해당 사람의 정보
  ///   - completion: 콜백함수
  func rejectApplyUser(personData: RejectStudy, completion: @escaping () -> Void){
    provider.request(.rejectParticipate(rejectPersonData: personData)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  /// 스터디 신청 거절 with Rx
  /// - Parameters:
  ///   - personData: 해당 사람의 정보
  ///   - completion: 콜백함수
  func rejectApplyUser(personData: RejectStudy) -> Observable<Int> {
    return provider.rx
          .request(.rejectParticipate(rejectPersonData: personData))
          .asObservable()
          .map { $0.statusCode }
  }
  
  // MARK: - 내가 신청한 스터디 요청 내역 가져오기
  
  /// 내가 신청한 스터디 요청내역 가져오기
  /// - Parameter completion: 콜백함수
  func getMyRequestStudyList(page: Int, size: Int, completion: @escaping (MyRequestList) -> Void){
    // 무한스크롤로 늘려야함
    provider.request(.getMyReqeustList(page: page, size: size)) { result in
      self.commonDecodeNetworkResponse(with: result,
                                       decode: MyRequestList.self) { decodedData in
        completion(decodedData)
      }
    }
  }
  
  /// 내가 신청한 스터디 요청내역 가져오기 with Rx
  func getMyRequestStudyListWithRx(page: Int, size: Int) -> Observable<MyRequestList>{
    return provider.rx
          .request(.getMyReqeustList(page: page, size: size))
          .asObservable()
          .flatMap { response -> Observable<MyRequestList> in
            self.commonDecodeNetworkResponse(with: response, decode: MyRequestList.self)
          }
  }
  
  // MARK: - 거절이유 가져오기
  
  /// 거절 사유 가져오기
  /// - Parameters:
  ///   - studyId: 가져올 스터디의 Id
  ///   - completion: 콜백함수
  func getMyRejectReason(studyId: Int, completion: @escaping (RejectReason) -> Void){
    provider.request(.getRejectReason(studyId)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: RejectReason.self) { decodedData in
        completion(decodedData)
      }
    }
  }
  
  /// 거절 사유 가져오기 with Rx
  /// - Parameters:
  ///   - studyId: 가져올 스터디의 Id
  func getMyRejectReasonWithRx(studyId: Int) -> Observable<RejectReason>{
    return provider.rx
          .request(.getRejectReason(studyId))
          .asObservable()
          .flatMap { response -> Observable<RejectReason> in
            self.commonDecodeNetworkResponse(with: response, decode: RejectReason.self)
          }
  }
  
  
  // MARK: - 신청한 스터디삭제
  
  /// 신청한 스터디 요청 삭제하기
  /// - Parameters:
  ///   - studyId: 삭제할 스터디의 Id
  ///   - comletion: 콜백함수
  func deleteRequestStudy(studyId: Int, comletion: @escaping (Bool) -> Void) {
    provider.request(.deleteMyRequest(studyId: studyId)) { result in
      print(result)
      switch result {
      case .success(let response):
        print(response.response)
        comletion(true)
      case .failure(let response):
        print(response.response)
        comletion(false)
      }
    }
  }
  
  /// 신청한 스터디 요청 삭제하기 with Rx
  /// - Parameters:
  ///   - studyId: 삭제할 스터디의 Id
  func deleteRequestStudyWithRx(studyId: Int) -> Observable<Bool> {
    return provider.rx
          .request(.deleteMyRequest(studyId: studyId))
          .asObservable()
          .map { response in
            return (200...299).contains(response.statusCode)
          }
          .catchAndReturn(false)
  }
}
