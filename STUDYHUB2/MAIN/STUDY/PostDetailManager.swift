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
  private init() {}
  typealias NetworkCompletion = (Result<PostDetailData, NetworkError>) -> Void
  
  // 네트워킹 요청하는 함수
  private func fetchPostDetailData(postID: Int, completion: @escaping NetworkCompletion) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "study-hub.site"
    urlComponents.port = 443
    urlComponents.path = "/api/v1/study-posts/\(postID)"
    
    guard let urlString = urlComponents.url?.absoluteString else {
      print("Invalid URL")
      completion(.failure(.networkingError))
      return
    }
    getMethod(with: urlString, completion: completion)
  }
  
  private func getMethod(with urlString: String, completion: @escaping NetworkCompletion) {
    guard let url = URL(string: urlString) else {
      print("Invalid URL")
      completion(.failure(.networkingError))
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Networking Error:", error)
        completion(.failure(.networkingError))
        return
      }
      
      guard let safeData = data else {
        print("No Data")
        completion(.failure(.dataError))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid Response")
        completion(.failure(.networkingError))
        return
      }
      
      print("Response Status Code:", httpResponse.statusCode)
      
      do {
        let decoder = JSONDecoder()
        let postDetailData = try decoder.decode(PostDetailData.self, from: safeData)
        completion(.success(postDetailData))
      } catch {
        print("JSON Parsing Error:", error)
        completion(.failure(.parseError))
      }
    }.resume()
  }
  
  private var postDetailData: PostDetailData?
  
  func getPostDetailData() -> PostDetailData? {
    return postDetailData
  }
  
  func getPostDetailData(postID: Int, completion: @escaping () -> Void){
    fetchPostDetailData(postID: postID) { result in
      switch result {
      case .success(let postDetailData):
        self.postDetailData = postDetailData
        completion()
      case .failure(let error):
        print("Network Error:", error)
      }
    }
  }
  
  func searchSinglePostData(postId: Int, completion: @escaping () -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.searchSinglePost(_postId: postId)) {
      switch $0 {
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
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.getCommentList(_postId: postId,
                                     _page: page,
                                     _size: size)) {
      switch $0 {
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
}


