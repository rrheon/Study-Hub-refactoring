//
//  DTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

// MARK: - GetCommentList
struct GetCommentList: Codable {
  let content: [CommentConetent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let size: Int
}

// MARK: - Content
struct CommentConetent: Codable {
  let commentID: Int
  let commentedUserData: CommentedUserData
  let content:String
  let createdDate:  [Int]
  let usersComment: Bool
  
  enum CodingKeys: String, CodingKey {
    case commentID = "commentId"
    case commentedUserData, content, createdDate, usersComment
  }
}

// MARK: - CommentedUserData
struct CommentedUserData: Codable {
  let imageURL, major, nickname: String
  let userID: Int
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "imageUrl"
    case major, nickname
    case userID = "userId"
  }
}
