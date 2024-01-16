
import Foundation

import Moya

// MARK: - MyPostData
struct MyPostData: Codable {
  let posts: Posts
  let totalCount: Int
}

// MARK: - Posts
struct Posts: Codable {
  let myPostcontent: [MyPostcontent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: Pageable
  let size: Int
  let sort: Sort
  
  enum CodingKeys: String, CodingKey {
    case myPostcontent = "content"
    case empty, first, last, number, numberOfElements, pageable, size, sort
  }
}

// MARK: - MyPostcontent
struct MyPostcontent: Codable {
  let close: Bool
  let content, major: String
  let postID, remainingSeat: Int
  let title: String
  
  enum CodingKeys: String, CodingKey {
    case close, content, major
    case postID = "postId"
    case remainingSeat, title
  }
}

// MARK: - Pageable
struct Pageable: Codable {
  let offset, pageNumber, pageSize: Int
  let paged: Bool
  let sort: Sort
  let unpaged: Bool
}

// MARK: - Sort
struct Sort: Codable {
  let empty, sorted, unsorted: Bool
}


//MARK: - Networking (서버와 통신하는) 클래스 모델
final class MyPostInfoManager {
  // 내가 쓴 게시글 정보
  private var myPostDatas: [MyPostcontent]?
  private var myPostData: MyPostData?
  
  func getMyTotalPostData() -> MyPostData? {
    return myPostData
  }
  
  func getMyPostData() -> [MyPostcontent]? {
    return myPostDatas
  }
  
  let tokenManager = TokenManager.shared
  static let shared = MyPostInfoManager()
  private init() {}
  
  typealias NetworkCompletion = (Result<MyPostData, NetworkError>) -> Void
  
  // MARK: - 내가 쓴 게시글 정보 가져오기
  func fetchMyPostInfo(page: Int,
                       size: Int,
                       completion: @escaping (Bool) -> Void) {
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.getMyPostList(_page: page,
                                    _size: size)) {
      switch $0 {
      case.success(let response):
        do {
          let postContent = try JSONDecoder().decode(MyPostData.self, from: response.data)
          
          self.myPostData = postContent
          self.myPostDatas = postContent.posts.myPostcontent
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        completion(true)
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 내가 쓴 게시글 삭제
//  typealias DeleteNetworkCompletion = (Result<Void, NetworkError>) -> Void
//  
////  func fetchDeletePostInfo(postID: Int, completion: @escaping DeleteNetworkCompletion) {
////    var urlComponents = URLComponents()
////    urlComponents.scheme = "https"
////    urlComponents.host = "study-hub.site"
////    urlComponents.port = 443
////    urlComponents.path = "/api/study-posts/\(postID)"
////    
////    guard var token = tokenManager.loadAccessToken() else { return }
////    
////    guard let urlString = urlComponents.url?.absoluteString else {
////      print("Invalid URL")
////      completion(.failure(.networkingError))
////      return
////    }
////    deleteMyPost(with: urlString, token: token, completion: completion)
////  }
  
  func deleteMyPost(postId: Int,
                    completion: @escaping (Result<Void, Error>) -> Void) {
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.deleteMyPost(_postId: postId)) {
      switch $0 {
      case .success(let response):
        print(response.response)
        completion(.success(()))
      case .failure(let response):
        print(response.response)
        completion(.failure(response))
      }
    }
    //    guard let url = URL(string: urlString) else {
//      print("Invalid URL")
//      completion(.failure(.networkingError))
//      return
//    }
//    var request = URLRequest(url: url)
//    request.httpMethod = "DELETE"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
//    request.setValue("\(token)", forHTTPHeaderField: "Authorization")
//
//    URLSession.shared.dataTask(with: request) { data, response, error in
//      if let error = error {
//        print("Networking Error:", error)
//        completion(.failure(.networkingError))
//        return
//      }
//
//      guard let safeData = data else {
//        print("No Data")
//        completion(.failure(.dataError))
//        return
//      }
//
//      guard let httpResponse = response as? HTTPURLResponse else {
//        print("Invalid Response")
//        completion(.failure(.networkingError))
//        return
//      }
//
//      print("Response Status Code:", httpResponse.statusCode)
//
//      do {
//        let deleteAccepted = String(data: safeData, encoding: .utf8)
//        completion(.success(()))
//      } catch {
//        print("JSON Parsing Error:", error)
//        completion(.failure(.parseError))
//      }
//    }.resume()
  }
}



