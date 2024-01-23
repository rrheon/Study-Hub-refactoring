//
//  PostDataManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/15.
//

import Foundation

import Moya

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class PostDataManager {
  
  static let shared = PostDataManager()
  private init() {}
  
  let networkingShared = Networking.networkinhShared
  
  // MARK: - new 모집 중인 스터디
  private var newPostDatas: PostDataContent?
  
  func getNewPostDatas() -> PostDataContent? {
    if let data = newPostDatas {
      return data
    } else {
      // 처리할 값이 없는 경우에 대한 처리를 수행합니다.
      return nil
    }
  }

  func getPostData(hot: String,
                   text: String? = nil,
                   page: Int,
                   size: Int,
                   titleAndMajor: String,
                   completion: @escaping (PostDataContent) -> Void) {
    fectchPostData(hot: hot,
                   text: text,
                   page: page,
                   size: size,
                   titleAndMajor: titleAndMajor) {
      guard let data = self.newPostDatas else { return }
      completion(data)
    }
  }
  
  private func fectchPostData(hot: String,
                   text: String? = nil,
                   page: Int,
                   size: Int,
                   titleAndMajor: String,
                   completion: @escaping () -> Void){
    
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.searchPostList(_hot: hot,
                                     text: text ?? "",
                                     page: page,
                                     size: size,
                                     titleAndMajor: titleAndMajor)) { result in
      switch result {
      case.success(let response):
        do {
          let searchResult = try JSONDecoder().decode(PostDataContent.self, from: response.data)
          self.newPostDatas = searchResult
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        print(response.response)
      case .failure(let response):
        print(response.response)
      }
      completion()
    }
  }
  
  func getNewPostData(completion: @escaping() -> Void){
    let queryItems = [URLQueryItem(name: "hot", value: "false"),
                      URLQueryItem(name: "page", value: "0"),
                      URLQueryItem(name: "size", value: "5"),
                      URLQueryItem(name: "titleAndMajor", value: "false")]
    
    networkingShared.fetchData(type: "GET",
                               apiVesrion: "v2",
                               urlPath: "/study-posts",
                               queryItems: queryItems,
                               tokenNeed: false,
                               createPostData: nil) { (result: Result<PostDataContent,
                                                          NetworkError>) in
      switch result {
      case .success(let postData):
        self.newPostDatas = postData
        completion()
      case .failure(let error):
        print("에러:", error)
      }
    }
  }
  
  // MARK: - 마감이 임박한 스터디
  private var deadlinePostDatas: PostDataContent?
  
  func getDeadLinePostDatas() -> PostDataContent? {
    if let data = newPostDatas {
      return data
    } else {
      return nil
    }
  }
  
  func getDeadLinePostData(completion: @escaping() -> Void){
    let queryItems = [URLQueryItem(name: "hot", value: "true"),
                      URLQueryItem(name: "page", value: "0"),
                      URLQueryItem(name: "size", value: "4"),
                      URLQueryItem(name: "titleAndMajor", value: "true")]
    networkingShared.fetchData(type: "GET",
                               apiVesrion: "v2",
                               urlPath: "/study-posts",
                               queryItems: queryItems,
                               tokenNeed: false,
                               createPostData: nil) { (result: Result<PostDataContent,
                                                          NetworkError>) in
      switch result {
      case .success(let postData):
        self.newPostDatas = postData
        completion()
      case .failure(let error):
        print("에러:", error)
      }
    }
  }
  
  // MARK: - 스터디 최신순 전체조회
  private var recentPostDatas: PostDataContent?
  
  func getRecentPostDatas() -> PostDataContent? {
    if let data = newPostDatas {
      return data
    } else {
      return nil
    }
  }
  
  func getRecentPostDatas(hotType: String,
                          page: Int = 0,
                          size: Int = 5,
                          completion: @escaping () -> Void) {
    let queryItems = [URLQueryItem(name: "hot", value: hotType),
                      URLQueryItem(name: "page", value: "\(page)"),
                      URLQueryItem(name: "size", value: "\(size)"),
                      URLQueryItem(name: "titleAndMajor", value: "false")]
    
    networkingShared.fetchData(type: "GET",
                               apiVesrion: "v2",
                               urlPath: "/study-posts",
                               queryItems: queryItems,
                               tokenNeed: false,
                               createPostData: nil) { [weak self] (result: Result<PostDataContent, NetworkError>) in
      switch result {
      case .success(let postData):
        print(postData)
        self?.newPostDatas = postData
        completion()

      case .failure(let error):
        print("에러:", error)
      }
    }
  }

}
