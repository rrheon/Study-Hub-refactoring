//
//  StudyPostDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//

import Foundation

// MARK: -  study DTO

/// 스터디 모두 조회 DTO
struct SearchAllPostDTO: Codable {
  let hot, text, titleAndMajor: String
  let page, size: Int
}


/// 게시글 DTO
struct StudyDTO: Codable {
  var chatUrl,content, gender, major,studyEndDate,studyStartDate, studyWay, title: String
  var close: Bool
  var penalty, studyPerson: Int
  let penaltyWay: String?
}

/// 게시글 수정 DTO
struct UpdateStudyDTO: Codable {
  let postId: Int // 수정 요청에만 필요한 속성
  let studyRequest: StudyDTO
}

/// 게시글 생성 DTO
struct CreateStudyDTO: Codable {
  let studyRequest: StudyDTO
}


//// MARK: - 게시글 생성 시
//
//struct CreateStudyRequest: Codable {
//  var chatUrl: String
//  var close: Bool
//  var content, gender, major: String
//  var penalty: Int
//  let penaltyWay: String?
//  var studyEndDate: String
//  var studyPerson: Int
//  var studyStartDate, studyWay, title: String
//}
//
//
//// MARK: - 게시글 수정 시
//
//struct UpdateStudyRequest: Codable {
//  let chatUrl: String
//  let close: Bool
//  let content, gender, major: String
//  let penalty: Int
//  let penaltyWay: String?
//  let postId: Int
//  let studyEndDate: String
//  let studyPerson: Int
//  let studyStartDate, studyWay, title: String
//}
