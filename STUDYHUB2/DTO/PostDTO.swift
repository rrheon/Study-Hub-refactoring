//
//  PostDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

// MARK: - 추천 검색어
struct RecommendList: Codable {
  let recommendList: [String]
}

// MARK: - 포스트 전체조회
struct PostDataContent: Codable {
  var postDataByInquiries: PostDataByInquiries
  let totalCount: Int
}

struct PostDataByInquiries: Codable {
  let content: [Content]
  let pageable: Pageable
  let size, number: Int
  let sort: Sort
  let numberOfElements: Int
  let first, last, empty: Bool
}

// 포스트 전체조회 content
struct Content: Codable {
  let postID: Int
  let major, title: String
  let studyStartDate, studyEndDate, createdDate: [Int]
  let studyPerson: Int
  let filteredGender: String
  let penalty: Int
  let penaltyWay: String
  let remainingSeat: Int
  let close: Bool
  let userData: UserData
  let bookmarked: Bool
  
  enum CodingKeys: String, CodingKey {
    case postID = "postId"
    case major, title, studyStartDate, studyEndDate, createdDate,
         studyPerson, filteredGender, penalty, penaltyWay, remainingSeat, close, userData, bookmarked
  }
}


// MARK: - 게시글 단건조회
struct PostDetailData: Codable {
  let postID: Int
  let title: String
  let createdDate: [Int]
  let content, major: String
  let studyPerson: Int
  let filteredGender, studyWay: String
  let penalty: Int
  let penaltyWay: String
  let studyStartDate, studyEndDate: [Int]
  let remainingSeat: Int
  let chatURL: String
  let studyID: Int
  let postedUser: PostedUser
  let relatedPost: [RelatedPost]
  let close, apply, usersPost, bookmarked: Bool
  
  enum CodingKeys: String, CodingKey {
    case postID = "postId"
    case title, createdDate, content, major, studyPerson, filteredGender, studyWay, penalty, penaltyWay, studyStartDate, studyEndDate, remainingSeat
    case chatURL = "chatUrl"
    case studyID = "studyId"
    case postedUser, relatedPost, close, apply, usersPost, bookmarked
  }
}

// 단건조회 시 해당 포스트 유저에 대한 정보
struct PostedUser: Codable {
  let userID: Int
  let major, nickname: String
  let imageURL: String
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case major, nickname
    case imageURL = "imageUrl"
  }
}

// 단건조회 시 해당 포스트와 유사한 게시글의 정보
struct RelatedPost: Codable {
  let postID: Int
  let title, major: String
  let remainingSeat: Int
  let userData: PostedUser
  
  enum CodingKeys: String, CodingKey {
    case postID = "postId"
    case title, major, remainingSeat, userData
  }
}


// MARK: - 게시글 생성 시
struct CreateStudyRequest: Codable {
  var chatUrl: String
  var close: Bool
  var content, gender, major: String
  var penalty: Int
  let penaltyWay: String?
  var studyEndDate: String
  var studyPerson: Int
  var studyStartDate, studyWay, title: String
}

// MARK: - 게시글 수정 시
struct UpdateStudyRequest: Codable {
  let chatUrl: String
  let close: Bool
  let content, gender, major: String
  let penalty: Int
  let penaltyWay: String?
  let postId: Int
  let studyEndDate: String
  let studyPerson: Int
  let studyStartDate, studyWay, title: String
}


// MARK: - 내가 쓴 게시글
struct MyPostData: Codable {
  let posts: Posts
  let totalCount: Int
}

// MARK: - Posts
struct Posts: Codable {
  let myPostcontent: [MyPostcontent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: Pageable
  let size: Int
  let sort: Sort
  
  enum CodingKeys: String, CodingKey {
    case myPostcontent = "content"
    case empty, first, last, number, numberOfElements, pageable, size, sort
  }
}

// MARK: - MyPostcontent
struct MyPostcontent: Codable {
  let close: Bool
  let content, major: String
  let postID, remainingSeat, studyId: Int
  let title: String
  
  enum CodingKeys: String, CodingKey {
    case close, content, major
    case postID = "postId"
    case remainingSeat, title, studyId
  }
}

// MARK: - Pageable
struct Pageable: Codable {
  let sort: Sort
  let pageNumber, pageSize, offset: Int
  let unpaged, paged: Bool
}

// MARK: - Sort
struct Sort: Codable {
  let empty, sorted, unsorted: Bool
}

struct PostResponse: Codable {
  let response: String
}
