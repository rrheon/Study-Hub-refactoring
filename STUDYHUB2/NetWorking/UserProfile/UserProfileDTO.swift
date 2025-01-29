//
//  UserProfileDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import Foundation


/// 유저 비밀번호 변경DTO
struct EditUserPasswordDTO: Codable {
  let checkPassword: Bool
  let email: String, password: String
}

//// MARK: - 내정보
//struct UserDetailData: Codable {
//  var applyCount: Int?
//  var email, gender, imageURL, major: String?
//  var nickname: String?
//  var participateCount, postCount: Int?
//  
//  enum CodingKeys: String, CodingKey {
//    case applyCount, email, gender
//    case imageURL = "imageUrl"
//    case major, nickname, participateCount, postCount
//  }
//}
