//
//  InfoManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/14.
//

import Foundation

import Moya

final class PostManager {
  static let shared = PostManager()
  
  let tokenManager = TokenManager.shared
  let networkingManager = Networking.networkinhShared
  
  private init() {}

  // 게시글 생성, 반환값 나중에 스웨거보고 확인하기
  func createPost(createPostDatas: CreateStudyRequest,
                  completion: @escaping () -> Void) {
    
    networkingManager.fetchData(type: "POST",
                                apiVesrion: "v1",
                                urlPath: "/study-posts",
                                queryItems: nil,
                                tokenNeed: true,
                                createPostData: createPostDatas) { result in
      switch result {
      case .success(let postResponse):
        print(postResponse) // 이제 id는 Int 타입의 값입니다.
        print("성공")

        completion()
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
  
  func modifyPost(data: UpdateStudyRequest,
                  completion: @escaping () -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.modifyMyPost(_data: data)) { result in
      switch result {
      case .success(let postResponse):
        
        let strData = String(data: postResponse.data, encoding: .utf8)
        print("Response body: \(strData ?? "")")
        completion()
      case .failure(let error):
        print("Error: \(error)")
      }
    }
  }
}
