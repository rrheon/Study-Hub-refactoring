//
//  InfoManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/14.
//

import UIKit

import Moya

final class PostManager {
  static let shared = PostManager()
  
  let tokenManager = TokenManager.shared
  let commonNetworking = CommonNetworking.shared
  
  private init() {}

  // 게시글 생성, 반환값 나중에 스웨거보고 확인하기
  func createPost(createPostDatas: CreateStudyRequest,
                  completion: @escaping (String) -> Void) {
    commonNetworking.moyaNetworking(networkingChoice: .createMyPost(createPostDatas),
                                    needCheckToken: true) { result in
      switch result {
      case .success(let response):
        print(response.response)
        let strData = String(data: response.data, encoding: .utf8)
        completion(strData ?? "")
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  func modifyPost(data: UpdateStudyRequest,
                  completion: @escaping () -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.modifyMyPost(_data: data)) { result in
      print(data)
      switch result {
      case .success(let postResponse):
        print(postResponse.response)
//        let strData = String(data: postResponse.data, encoding: .utf8)
//        print("Response body: \(strData ?? "")")
        completion()
      case .failure(let error):
        print("Error: \(error)")
      }
    }
//    commonNetworking.moyaNetworking(networkingChoice: .modifyMyPost(_data: data),
//                                    needCheckToken: true) { result in
//      switch result {
//      case .success(let postResponse):
//        print(postResponse.response)
//        let strData = String(data: postResponse.data, encoding: .utf8)
//        print("Response body: \(strData ?? "")")
//        completion()
//      case .failure(let error):
//        print("Error: \(error)")
//      }
//    }
  }
}
