//
//  PostDetailManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/19.
//
import Foundation

import Moya

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class PostDetailInfoManager {
  static let shared = PostDetailInfoManager()
  
  let commonNetwork = CommonNetworking.shared
  
  private init() {}
  
  private var postDetailData: PostDetailData?
  
  func getPostDetailData() -> PostDetailData? {
    return postDetailData
  }
  
  func searchSinglePostData(
    postId: Int,
    loginStatus: Bool,
    completion: @escaping (PostDetailData) -> Void
  ){
    commonNetwork.moyaNetworking(
      networkingChoice: .searchSinglePost(postId),
      needCheckToken: loginStatus
    ) { result in
      switch result {
      case .success(let response):
        do {
          let postDataContent = try JSONDecoder().decode(PostDetailData.self, from: response.data)
          self.postDetailData = postDataContent
          guard let postDetailData = self.postDetailData else { return }
          completion(postDetailData)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let response):
        print(response)
      }
    }
  }
  
  private var commentList: GetCommentList?
  
  func getCommentList() -> GetCommentList? {
    return commentList
  }
  
  func getCommentList(postId: Int, page: Int, size: Int, completion: @escaping (GetCommentList) -> Void) {
    commonNetwork.moyaNetworking(networkingChoice: .getCommentList(
      postId: postId,
      page: page,
      size: size)) { result in
        switch result {
        case .success(let response):
          do {
            let commentContent = try JSONDecoder().decode(GetCommentList.self, from: response.data)
            self.commentList = commentContent
            completion(commentContent)
          } catch {
            print("Failed to decode JSON: \(error)")
          }
          
        case .failure(let response):
          print(response)
        }
      }
  }
  
  func getCommentPreview(postId: Int, completion: @escaping ([CommentConetent]) -> Void){
    commonNetwork.moyaNetworking(networkingChoice: .getPreviewCommentList(postId)) { result in
      switch result {
      case .success(let response):
        do {
          let commentContent = try JSONDecoder().decode([CommentConetent].self, from: response.data)
          completion(commentContent)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        
      case .failure(let response):
        print(response.response)
      }
    }
  }
}



