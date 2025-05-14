//
//  CommentManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import Foundation

import RxSwift
import RxMoya
import Moya

/// 네트워킹 작업 전에 토큰을 재발급 받아서 들고가기 , 일단 네트워킹 하고 에러나면 재요청 -> 401 만료 , 500 로그인 x
/// 댓글 관련 네트워킹
class CommentManager: StudyHubCommonNetworking {
  static let shared = CommentManager()

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
        print(response.statusCode)
        completion(true)
      case .failure(let response):

        completion(false)
      }
    }
  }
  
  func createCommentWithRx(content: String, postID: Int) -> Observable<Int>{
    return provider.rx
      .request(.writeComment(content: content, postId: postID))
      .asObservable()
      .map { $0.statusCode}
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
  
  func modifyCommentWithRx(content: String, commentID: Int) -> Observable<Int>{
    return provider.rx
      .request(.modifyComment(commentId: commentID, content: content))
      .asObservable()
      .map { $0.statusCode}
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
  
  
  func deleteCommentWithRx(commentID: Int) -> Observable<Int>{
    return provider.rx
      .request(.deleteComment(commentId: commentID))
      .asObservable()
      .map { $0.statusCode}
  }
  
  
  /// 댓글리스트 가져오기
  /// - Parameters:
  ///   - postId: 스터디의 postId
  ///   - page: 페이지
  ///   - size: 댓글 갯수
  ///   - completion: 콜백함수
  func getCommentList(postId: Int, page: Int, size: Int, completion: @escaping (GetCommentList) -> Void) {
    let loginStatus = LoginStatusManager.shared.loginStatus
    provider.request(.getCommentList(postId: postId, page: page, size: size, loginStatus: loginStatus)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: GetCommentList.self) { decodedData in
        completion(decodedData)
      }
    }
  }
  
  func getCommentListWithRx(postId: Int, page: Int, size: Int) -> Observable<GetCommentList>{
    let loginStatus = LoginStatusManager.shared.loginStatus
    
    return provider.rx
      .request(.getCommentList(postId: postId, page: page, size: size, loginStatus: loginStatus))
      .asObservable()
      .flatMap { response -> Observable<GetCommentList> in
        self.commonDecodeNetworkResponse(with: response, decode: GetCommentList.self)
      }
  }

  
  
  /// 댓글 미리보기 가져오기
  /// - Parameters:
  ///   - postId:스터디의 postId
  ///   - completion: 콜백함수
  func getCommentPreview(postId: Int) async throws -> [CommentConetent] {
    let loginStatus = LoginStatusManager.shared.loginStatus
    let result = await provider.request(.getPreviewCommentList(postId: postId, loginStatus: loginStatus))
    return try await self.commonDecodeNetworkResponse(with: result, decode: [CommentConetent].self)

  }
  
  func getCommentPreviewWithRx(postId: Int) -> Observable<[CommentConetent]> {
    let loginStatus = LoginStatusManager.shared.loginStatus
    
    return provider.rx
      .request(.getPreviewCommentList(postId: postId, loginStatus: loginStatus))
      .asObservable()
      .flatMap { response -> Observable<[CommentConetent]> in
        self.commonDecodeNetworkResponse(with: response, decode: [CommentConetent].self)
      }
  }
}
