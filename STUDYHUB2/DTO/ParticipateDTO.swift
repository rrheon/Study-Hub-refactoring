//
//  ParticipateDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/28.
//

import Foundation

// MARK: - 내가 참여한 스터디 정보DTO
struct TotalParticipateStudyData: Codable {
  let participateStudyData: ParticipateStudyData
  let totalCount: Int
}

// MARK: - ParticipateStudyData
struct ParticipateStudyData: Codable {
  let content: [ParticipateContent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: Pageable
  let size: Int
  let sort: Sort
}

// MARK: - Content
struct ParticipateContent: Codable {
  let chatURL, content, inspection, major: String
  let postID: Int
  let studyID: Int
  let title: String
  
  enum CodingKeys: String, CodingKey {
    case chatURL = "chatUrl"
    case content, inspection, major
    case postID = "postId"
    case studyID = "studyId"
    case title
  }
}

// MARK: - 스터디 신청자 정보 DTO
struct TotalApplyUserData: Codable {
  let totalCount: Int
  let applyUserData: ApplyUserData
}

// MARK: - ApplyUserData
struct ApplyUserData: Codable {
  let content: [ApplyUserContent]
  let pageable: Pageable
  let size, number: Int
  let sort: Sort
  let numberOfElements: Int
  let first, last, empty: Bool
}

// MARK: - Content
struct ApplyUserContent: Codable {
  let id: Int
  let nickname, major: String
  let imageURL: String
  let introduce: String
  let createdDate: [Int]
  let inspection: String
  
  enum CodingKeys: String, CodingKey {
    case id, nickname, major
    case imageURL = "imageUrl"
    case introduce, createdDate, inspection
  }
}

// MARK: - 스터디 참여 신청 수락
struct AcceptStudy: Codable {
  let rejectedUserId: Int
  let studyId: Int
}

// MARK: - 스터디 참여 신청 것절
struct RejectStudy: Codable {
  let rejectReason: String
  let rejectedUserId: Int
  let studyId: Int
}


// MARK: - 내가 신청한 스터디 정보
struct MyRequestList: Codable {
    let requestStudyData: RequestStudyData
    let totalCount: Int
}

// MARK: - RequestStudyData
struct RequestStudyData: Codable {
    let content: [RequestStudyContent]
    let empty, first, last: Bool
    let number, numberOfElements: Int
    let pageable: Pageable
    let size: Int
    let sort: Sort
}

// MARK: - Content
struct RequestStudyContent: Codable {
  let inspection, introduce: String
  let studyID: Int
  let studyTitle: String
  
  enum CodingKeys: String, CodingKey {
    case inspection, introduce
    case studyID = "studyId"
    case studyTitle
  }
}

// MARK: - 스터디 거절 사유
struct RejectReason: Codable {
  let reason, studyTitle: String
}
