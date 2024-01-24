//
//  UserDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/23.
//

import Foundation

// MARK: - 게시글에서 해당 유저 Data
struct UserData: Codable {
  let userID: Int
  let major, nickname: String
  let imageURL: String
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case major, nickname
    case imageURL = "imageUrl"
  }
}

// MARK: - 내정보
struct UserDetailData: Codable {
  var bookmarkCount: Int?
  var email, gender, imageURL, major: String?
  var nickname: String?
  var participateCount, postCount: Int?
  
  enum CodingKeys: String, CodingKey {
    case bookmarkCount, email, gender
    case imageURL = "imageUrl"
    case major, nickname, participateCount, postCount
  }
}

// MARK: - 유저정보 수정
// 유저 프로필 저장
struct StoreImage: Codable {
  let image: String
}

// 중복 확인
struct DuplicationResponse: Codable {
  let status: String
  let message: String
}

// 닉네임 수정
struct EditNickName: Codable {
  let nickname: String
}

// 학과 수정
struct EditMajor: Codable {
  let major: String
}

// 비밀번호 수정
struct EditPassword: Codable {
  let auth: Bool
  let password: String
}

// 비밀번호 검증
struct VerifyPassword: Codable {
  let password: String
}

// 이메일 검증
struct VerifyEmail: Codable {
  let authCode: String
  let email: String
}

// 이메일 중복 확인
struct CheckEmailDuplication: Codable {
  let email: String
}