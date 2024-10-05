//
//  BookmarkDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/01.
//

import Foundation

// MARK: - bookmarkDTO
struct BookmarkDatas: Codable {
  let getBookmarkedPostsData: GetBookmarkedPostsData
  let totalCount: Int
}

// MARK: - GetBookmarkedPostsData
struct GetBookmarkedPostsData: Codable {
  let content: [BookmarkContent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: Pageable
  let size: Int
  let sort: Sort
}

// MARK: - Content
struct BookmarkContent: Codable {
  let close: Bool
  let content, major: String
  let postID, remainingSeat, studyID: Int
  let title: String
  
  enum CodingKeys: String, CodingKey {
    case close, content, major
    case postID = "postId"
    case remainingSeat
    case studyID = "studyId"
    case title
  }

}

struct CheckSingleBookmark: Codable {
  let bookmarked: Bool
}
