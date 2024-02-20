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
  
  func searchSinglePostData(postId: Int,
                            loginStatus: Bool,
                            completion: @escaping () -> Void){
    commonNetwork.moyaNetworking(networkingChoice: .searchSinglePost(_postId: postId),
                                 needCheckToken: loginStatus) { result in
      switch result {
      case .success(let response):
        do {
          let postDataContent = try JSONDecoder().decode(PostDetailData.self, from: response.data)
          self.postDetailData = postDataContent
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        //        let res = String(data: response.data, encoding: .utf8) ?? "No data"
        //        print(res)
        //        print(response)
        
        completion()
      case .failure(let response):
        print(response)
        
      }
    }
  }
  
  
  private var commentList: GetCommentList?
  
  func getCommentList() -> GetCommentList? {
    return commentList
  }
  
  func getCommentList(postId: Int, page: Int, size: Int, completion: @escaping () -> Void) {
    commonNetwork.moyaNetworking(networkingChoice: .getCommentList(_postId: postId,
                                                                   _page: page,
                                                                   _size: size)) { result in
      switch result {
      case .success(let response):
        do {
          let commentContent = try JSONDecoder().decode(GetCommentList.self, from: response.data)
          self.commentList = commentContent
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        
        completion()
      case .failure(let response):
        print(response)
      }
    }
  }
  
  func getCommentPreview(postId: Int,
                         completion: @escaping ([CommentConetent]) -> Void){
    commonNetwork.moyaNetworking(networkingChoice: .getPreviewCommentList(_postid: postId)) { result in
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



