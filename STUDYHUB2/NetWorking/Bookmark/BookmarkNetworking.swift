//
//  BookmarkNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//

import Foundation

import Moya

/// 북마크관련 네트워킹
enum BookmarkNetworking{
  case changeBookMarkStatus(postId: Int)                        // 북마크 저장 및 삭제
  case searchSingleBookMarked(postId: Int, userId: Int)         // 단일 게시글에 대해 북마크여부 조회
  case searchBookMarkList(page: Int, size: Int)                 // 북마크한 리스트 가져오기
  case deleteAllBookMark                                        // 모든 북마크 삭제하기
}

extension BookmarkNetworking: TargetType, CommonBaseURL {
  
  /// API 별 요청 path
  var path: String {
    switch self {
    case .changeBookMarkStatus(let postId):           return "/v1/bookmark/\(postId)"
    case .searchSingleBookMarked(let postId, _):      return "/v1/bookmark/\(postId)"
    case .searchBookMarkList(_, _):                   return "/v1/study-posts/bookmarked"
    case .deleteAllBookMark:                          return "/v1/bookmark"
      
    }
  }
  
  
  /// API 별 메소드
  var method: Moya.Method {
    switch self {
    case .searchSingleBookMarked(_, _),
        .searchBookMarkList(_, _):
      return .get
      
    case .changeBookMarkStatus(_):
      return .post
      
    case .deleteAllBookMark:
      return .delete
    }
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .searchSingleBookMarked(_, let userId):
      let params: [String: Any] = ["userId": userId]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .searchBookMarkList(let page, let size):
      let parmas: [String: Any] = ["page": page, "size": size]
      return .requestParameters(parameters: parmas, encoding: URLEncoding.queryString)
      
    default:
      return .requestPlain
    }
  }
  
  
  /// API 별 헤더
  var headers: [String : String]? {
    switch self {
    case .deleteAllBookMark:
      return [ "Authorization": "\(TokenManager.shared.loadAccessToken() ?? "")"]
    default:
      return ["Content-type": "application/json",
              "Authorization": "\(TokenManager.shared.loadAccessToken() ?? "")"]
    }
  }
  
  
  
}
