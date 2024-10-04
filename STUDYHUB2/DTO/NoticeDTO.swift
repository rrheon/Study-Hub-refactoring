//
//  NoticeDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/22.
//

import Foundation


// MARK: - NoticeData


struct NoticeData: Codable {
  let content: [NoticeContent]
  let pageable: Pageable
  let size, number: Int
  let sort: Sort
  let numberOfElements: Int
  let first, last, empty: Bool
}

// MARK: - Content


struct NoticeContent: Codable {
  let noticeID: Int
  let title, content: String
  let createdDate: [Int]
  
  enum CodingKeys: String, CodingKey {
    case noticeID = "noticeId"
    case title, content, createdDate
  }
}

// MARK: - Notice + 확장여부

struct ExpandedNoticeContent: Codable {
  var noticeContent: NoticeContent
  var isExpanded: Bool = false
}
