//
//  CommentNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import Foundation

import Moya

/// 이메일관련 네트워킹
enum CommentNetworking{
  case getCommentList(postId: Int, page: Int, size: Int)         // 댓글 리스즈 조회
  case writeComment(content: String, postId: Int)                // 댓글 작성
  case deleteComment(commentId: Int)                             // 댓글 삭제
  case modifyComment(commentId: Int, content: String)            // 댓글 수정
  case getPreviewCommentList(postId: Int)                        // 댓글 미리보기
}

extension CommentNetworking: TargetType, CommonBaseURL {
  
  /// API 별 요청 path
  var path: String {
    switch self {
    case .writeComment(_, _):                    return "/v1/comments"
    case .getCommentList(let postId, _, _):      return "/v1/comments/\(postId)"
    case .deleteComment(let commentId):          return "/v1/comments/\(commentId)"
    case .modifyComment(_ ,_):                   return "/v1/comments"
    case .getPreviewCommentList(let postId):     return "/v1/comments/\(postId)/preview"
    }
  }
  
  
  /// API 별 메소드
  var method: Moya.Method {
    switch self{
    case .writeComment(_, _):
      return .post
      
    case .modifyComment(_, _):
      return .put
      
    case .getPreviewCommentList(_),
        .getCommentList(_, _, _):
      return .get
      
    case .deleteComment(_):
      return .delete
    }
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .writeComment(let content, let postId):
      let params: [String : Any] = [ "content": content, "postId": postId]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    case .getCommentList(postId: _, let page, let size):
      let params: [String : Any] = [ "page": page, "size": size]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .modifyComment(let commentId, let content):
      let params: [String : Any] = [ "commentId": commentId, "content": content]
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      
    default:
      return .requestPlain
    }
    
  }
  
  
  /// API 별 헤더
  var headers: [String : String]? {
    let accessToken = TokenManager.shared.loadAccessToken()
#warning("accessToken이 만료된 경우 refresh로 갱신 후 다시 요청해야하는데 이걸 어떻게 할까")
    switch self {
    case .deleteComment(_):
      return ["Authorization": "\(accessToken ?? "")"]
    case .writeComment(_, _),
        .modifyComment(_, _),
        .getPreviewCommentList(_):
      return [ "Content-Type" : "application/json",
               "Authorization": "\(accessToken ?? "")" ]
      
    default:
      return ["Content-type": "application/json"]
    }
  }
  

}
  
