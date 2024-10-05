//
//  ManagementComment.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/20/24.
//

import Foundation

import Moya

final class CommentManager {
  static let shared = CommentManager()
  
  func createComment(content: String, postID: Int, completion: @escaping (Bool) -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.writeComment(content: content, postId: postID)) {
      switch $0 {
      case .success(let response):
        completion(true)
      case .failure(let response):
        completion(false)
      }
    }
  }
  
  // MARK: - 댓글 수정하기
  func modifyComment(content: String, commentID: Int, completion: @escaping (Bool) -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.modifyComment(commentId: commentID, content: content)) {
      switch $0 {
      case .success(let response):
        completion(true)
      case .failure(let response):
        completion(false)
      }
    }
  }
  
  // MARK: - 댓글 삭제하기
  func deleteComment(commentID: Int, completion: @escaping (Bool) -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.deleteComment(commentID)) {
      switch $0 {
      case .success(let response):
        completion(true)
        
      case .failure(let response):
        completion(false)
      }
    }
  }
}
