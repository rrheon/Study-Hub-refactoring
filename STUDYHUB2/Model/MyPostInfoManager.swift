
import Foundation

import Moya

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class MyPostInfoManager {
  static let shared = MyPostInfoManager()
  
  private init() {}
  
  // MARK: - 내가 쓴 게시글 정보 가져오기
  
  
  func fetchMyPostInfo(
    page: Int,
    size: Int,
    completion: @escaping (Posts?) -> Void
  ) {
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.getMyPostList(page: page, size: size)) {
      switch $0 {
      case.success(let response):
        do {
          let postContent = try JSONDecoder().decode(MyPostData.self, from: response.data)
          completion(postContent.posts)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 내가 쓴 게시글 삭제
  
  
  func deleteMyPost(postId: Int, completion: @escaping (Bool) -> Void) {
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.deleteMyPost(postId)) {
      switch $0 {
      case .success(let response):
        completion(true)
      case .failure(let response):
        completion(false)
      }
    }
  }
}



