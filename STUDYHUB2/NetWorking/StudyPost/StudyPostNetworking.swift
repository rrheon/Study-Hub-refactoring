//
//  StudyPostNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/23/25.
//

import Foundation

import Moya


// MARK: - networking

/// 스터디 관련 네트워킹
enum StudyPostNetworking {
  case deleteAllPost                                       // 내가 쓴 게시글 전체 삭제
  case recommendSearch(keyword: String)                   // 검색어 추천
  case modifyPost(modifiedData: UpdateStudyRequest)       // 게시글 수정
  case createNewPost(newData: CreateStudyRequest)         // 게시글 생성
  case closePost(postId: Int)                             // 스터디 게시글 마감
  case deletePost(postId: Int)                            // 스터디 게시글 삭제
  case searchMyPost(page: Int, size: Int)              // 작성한 스터디 조회
  case searchAllPost(searchData: SearchAllPostDTO)    // 스터디 전체 조회
  case searchSinglePost(postId: Int)                   // 스터디 단건조회
}


extension StudyPostNetworking: TargetType, CommonBaseURL {

  
  /// API 별 path
  var path: String {
    switch self {
    case .deleteAllPost:                      return "/v1/all/study-post"
    case .recommendSearch:                    return "/v1/study-post/recommend"
    case .modifyPost:                         return "/v1/study-posts"
    case .createNewPost:                      return "/v1/study-posts"
    case .closePost(let postId):              return "/v1/study-posts/\(postId)/close"
    case .deletePost(let postId):             return "/v1/study-posts/\(postId)"
    case .searchMyPost:                       return "/v1/study-posts/mypost"
    case .searchAllPost:                      return "/v2/study-posts"
    case .searchSinglePost(let postId):       return "/v2/study-posts/\(postId)"
    }
  }
  
  /// API 별 method
  var method: Moya.Method {
    switch self {
      
    case .createNewPost:
      return .post
      
    case .recommendSearch,
        .searchMyPost,
        .searchAllPost,
        .searchSinglePost:
      return .get
      
    case .modifyPost,
        .closePost:
      return .put
      
    case .deleteAllPost,
        .deletePost:
      return .delete
    }
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .recommendSearch(let keyword):
      let params: [String : Any] = ["keyword" : keyword]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .modifyPost(let modifiedData):
      return .requestJSONEncodable(modifiedData)
      
    case .createNewPost(let newData):
      return .requestJSONEncodable(newData)
      
    case .searchMyPost(let page, let size):
      let params: [String : Any] = ["page": page, "size": size]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .searchAllPost(let searchData):
      let parmas: [String: Any] = [
        "hot" : searchData.hot,
        "text" : searchData.text,
        "page": searchData.page,
        "size": searchData.size,
        "titleAndMajor": searchData.titleAndMajor
      ]
      return .requestParameters(parameters: parmas, encoding: URLEncoding.queryString)
      
    default:
      return .requestPlain
    }
  }
  
  /// API 별 헤더 설정
  var headers: [String : String]? {
    TokenManager.shared.loadAccessToken()
    switch self {
    case .searchMyPost(_, _),
        .createNewPost(_),
        .deletePost(_),
        .modifyPost(_),
        .closePost(_),
        .deleteAllPost:
      return ["Content-type": "application/json",
              "Authorization": "\(TokenManager.shared.loadAccessToken())"]
    default:
      return ["Content-type": "application/json"]
    }
  }
}

