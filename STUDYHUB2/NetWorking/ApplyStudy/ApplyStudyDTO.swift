//
//  ApplyStudyDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//

import Foundation


/// 스터디 참여 신청 정보 조회 DTO
struct StudyApplyUserInfos{
  let inspection: String
  let page, size, studyId: Int
}

//// MARK: - 내가 참여한 스터디 정보DTO
//struct TotalParticipateStudyData: Codable {
//  let participateStudyData: ParticipateStudyData
//  let totalCount: Int
//}
//
//// MARK: - ParticipateStudyData
//struct ParticipateStudyData: Codable {
//  let content: [ParticipateContent]
//  let empty, first, last: Bool
//  let number, numberOfElements: Int
//  let pageable: Pageable
//  let size: Int
//  let sort: Sort
//}
//
//struct Pageable: Codable {
//  let sort: Sort
//  let pageNumber, pageSize, offset: Int
//  let unpaged, paged: Bool
//}
//
//// MARK: - Sort
//
//struct Sort: Codable {
//  let empty, sorted, unsorted: Bool
//}

//// MARK: - 스터디 신청자 정보 DTO
//struct TotalApplyUserData: Codable {
//  let totalCount: Int
//  let applyUserData: ApplyUserData
//}
//
//// MARK: - ApplyUserData
//struct ApplyUserData: Codable {
//  let content: [ApplyUserContent]
//  let pageable: Pageable
//  let size, number: Int
//  let sort: Sort
//  let numberOfElements: Int
//  let first, last, empty: Bool
//}
//
//// MARK: - 스터디 참여 신청 수락
//struct AcceptStudy: Codable {
//  let rejectedUserId: Int
//  let studyId: Int
//}
//
//// MARK: - 스터디 참여 신청 것절
//struct RejectStudy: Codable {
//  let rejectReason: String
//  let rejectedUserId: Int
//  let studyId: Int
//}
//// MARK: - 내가 신청한 스터디 정보
//struct MyRequestList: Codable {
//    let requestStudyData: RequestStudyData
//    let totalCount: Int
//}
//
//// MARK: - RequestStudyData
//struct RequestStudyData: Codable {
//    let content: [RequestStudyContent]
//    let empty, first, last: Bool
//    let number, numberOfElements: Int
//    let pageable: Pageable
//    let size: Int
//    let sort: Sort
//}
//// MARK: - 스터디 거절 사유
//struct RejectReason: Codable {
//  let reason, studyTitle: String
//}
