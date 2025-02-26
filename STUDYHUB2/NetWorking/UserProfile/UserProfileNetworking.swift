//
//  UserProfileNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import UIKit

import Moya

/// 유저프로필  관련 네트워킹
enum UserProfileNetworking{
  case loadUserInfo                                     // 회원정보 조회
  case editUserNickName(nickname: String)               // 유저 닉네임 수정
  case editUserMajor(major: String)                     // 유저 학과 수정
  case editUserPassword(data: EditUserPasswordDTO)      // 유저 비밀번호 수정
  case deleteUserAccount                                // 유저 계정 삭제하기
  case storeUserProfileImage(image: UIImage)            // 유저 프로필 저장
  case deleteUserProfileImage                           // 유저 프로필 삭제
  case checkNicknameDuplication(nickname: String)         // 닉네임 중복검사
}

extension UserProfileNetworking: TargetType, CommonBaseURL {
  
  /// API 별 요청 path
  var path: String {
    switch self {
    case .loadUserInfo:                   return "/v1/users"
    case .editUserNickName(_):            return "/v1/users/nickname"
    case .editUserMajor(_):               return "/v1/users/major"
    case .editUserPassword(_):            return "/v2/users/password"
    case .deleteUserAccount:              return "/v1/users"
    case .storeUserProfileImage(_):       return "/v1/users/image"
    case .deleteUserProfileImage:         return "/v1/users/image"
    case .checkNicknameDuplication(_:):   return "/v1/users/duplication-nickname"

    }
  }
  
  
  /// API 별 메소드
  var method: Moya.Method {
    switch self{
    case .loadUserInfo,
        .checkNicknameDuplication(_):
      return .get
      
    case .deleteUserAccount,
        .deleteUserProfileImage:
      return .delete
      
    default:
      return .put
    }
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .editUserNickName(let nickname):
      let params: [String: Any] = ["nickname": nickname]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .editUserMajor(let major):
      let params: [String: Any] = ["major": major]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .editUserPassword(let data):
      return .requestJSONEncodable(data)
      
    case .deleteUserAccount:
      return .requestPlain
      
    case .storeUserProfileImage(let image):
      let imageData = image.jpegData(compressionQuality: 0.5)
      
      let formData = MultipartFormData(
        provider: .data(imageData!),
        name: "image",
        fileName: "image.jpg",
        mimeType: "image/jpeg")
      return .uploadMultipart([formData])
      
    case .checkNicknameDuplication(let nickname):
      let params: [String: Any] = ["nickname": nickname]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    default:
      return .requestPlain
    }
  }
  
  
  /// API 별 헤더
  var headers: [String : String]? {
    switch self {
    case .editUserMajor(_),
        .editUserPassword(_),
        .editUserNickName(_),
        .deleteUserAccount,
        .deleteUserProfileImage:
      return ["Authorization": "\(TokenManager.shared.loadAccessToken() ?? "")"]
      
    case .loadUserInfo:
      return ["Content-type": "application/json",
              "Authorization": "\(TokenManager.shared.loadAccessToken() ?? "")"]
      
    case .storeUserProfileImage(_):
      return [ "Content-Type" : "multipart/form-data",
               "Authorization": "\(TokenManager.shared.loadAccessToken() ?? "")"]
    default:
      return .none
    }
  }
}
