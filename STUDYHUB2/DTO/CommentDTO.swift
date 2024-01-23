//
//  DTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

// MARK: - 댓글정보
struct GetCommentList: Codable {
  let content: [CommentConetent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let size: Int
}

// 댓글의 Content
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

// 댓글의 UserData
struct CommentedUserData: Codable {
  let imageURL, major, nickname: String
  let userID: Int
  
  enum CodingKeys: String, CodingKey {
    case imageURL = "imageUrl"
    case major, nickname
    case userID = "userId"
  }
}

// MARK: - 댓글작성
struct WriteComment: Codable {
  let content: String
  let postId: Int
}

// MARK: - 댓글 수정
struct ModifyComment: Codable {
  let commentId: Int
  let content: String
}
