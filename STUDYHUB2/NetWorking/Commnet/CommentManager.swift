//
//  CommentManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import Foundation

import Moya


/// 댓글 관련 네트워킹
class CommentManager1: StudyHubCommonNetworking {
  static let shared = CommentManager1()

  let provider = MoyaProvider<CommentNetworking>()
  
  
  /// 댓글 작성하기
  /// - Parameters:
  ///   - content: 댓글 내용
  ///   - postID: 스터디의 postID
  ///   - completion: 콜백함수
  func createComment(content: String, postID: Int, completion: @escaping (Bool) -> Void){
    provider.request(.writeComment(content: content, postId: postID)) { result in
      switch result {
      case .success(let response):
        completion(true)
      case .failure(let response):
        completion(false)
      }
    }
  }

  // MARK: - 댓글 수정하기
  
  /// 댓글 수정하기
  /// - Parameters:
  ///   - content: 수정할 내용
  ///   - commentID: 댓글 ID
  ///   - completion: 콜백함수
  func modifyComment(content: String, commentID: Int, completion: @escaping (Bool) -> Void){
    provider.request(.modifyComment(commentId: commentID, content: content)) { result in
      switch result {
      case .success(let response):
        completion(true)
      case .failure(let response):
        completion(false)
      }
    }
  }

  // MARK: - 댓글 삭제하기
  
  /// 댓글 삭제하기
  /// - Parameters:
  ///   - commentID: 댓글 ID
  ///   - completion: 콜백함수
  func deleteComment(commentID: Int, completion: @escaping (Bool) -> Void){
    provider.request(.deleteComment(commentId: commentID)) { result in
      switch result {
      case .success(let response):
        completion(true)
      case .failure(let response):
        completion(false)
      }
    }
  }
  
  
  /// 댓글리스트 가져오기
  /// - Parameters:
  ///   - postId: 스터디의 postId
  ///   - page: 페이지
  ///   - size: 댓글 갯수
  ///   - completion: 콜백함수
  func getCommentList(postId: Int, page: Int, size: Int, completion: @escaping (GetCommentList) -> Void) {
    provider.request(.getCommentList(postId: postId, page: page, size: size)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: GetCommentList.self) { decodedData in
        print(decodedData)
      }
    }
  }

  
  
  /// 댓글 미리보기 가져오기
  /// - Parameters:
  ///   - postId:스터디의 postId
  ///   - completion: 콜백함수
  func getCommentPreview(postId: Int, completion: @escaping ([CommentConetent]) -> Void){
    provider.request(.getPreviewCommentList(postId: postId)){ result in
      self.commonDecodeNetworkResponse(with: result, decode: [CommentConetent].self) { decodedData in
        print(decodedData)
      }
    }
  }
}
