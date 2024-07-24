//
//  CommnetManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/23.
//

import Foundation

final class CommentManager {
  
  let commonNetworking = CommonNetworking.shared
  static let shared = CommentManager()
  
  // MARK: - 댓글 작성하기
  func createComment(content: String,
                     postId: Int,
                     completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .writeComment(_content: content,
                                                                    _postId: postId),
                                    needCheckToken: true) {
      switch $0 {
      case .success(let response):
        completion()
        return print(response.response)
      case .failure(let response):
        return print(response)
      }
    }
  }
  
  // MARK: - 댓글 수정하기
  func modifyComment(commentId: Int,
                     content: String,
                     completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .modifyComment(_commentId: commentId,
                                                                     _content: content),
                                    needCheckToken: true) {
      switch $0 {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 댓글삭제
  func deleteComment(commentId: Int, completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .deleteComment(_commentId: commentId),
                                    needCheckToken: true) { 
      switch $0 {
      case .success(let response):
        print(response)
        completion()
       
      case .failure(let response):
        print(response.response)
      }
    }
  }
}
