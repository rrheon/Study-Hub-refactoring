//
//  StudyPostManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/23/25.
//

import Foundation

import Moya

/// 스터디 게시물 네트워킹 Manager
class StudyPostManager: StudyHubCommonNetworking {
  static let shared = StudyPostManager()
  
  let provider = MoyaProvider<StudyPostNetworking>()
  
  /// 모든 스터디 게시글 조회하기
  /// - Parameters:
  ///   - hot: true - 인기순, false - 인기순 x
  ///   - titleAndMajor: true - 제목만 일치, false 학과만 일치
  ///   - page: 페이지
  ///   - size: 가져올 갯수
  func searchAllPost(hot: String = "false",
                     titleAndMajor: String = "false",
                     title: String = "",
                     page: Int = 0,
                     size: Int = 5) async throws -> PostDataContent {
    
    let data: SearchAllPostDTO = SearchAllPostDTO(hot: hot,
                                                  text: title,
                                                  titleAndMajor: titleAndMajor,
                                                  page: page,
                                                  size: size)
    
    let loginStatus = LoginStatusManager.shared.loginStatus
    let result = await provider.request(.searchAllPost(loginStatus: loginStatus, searchData: data))
    return try await self.commonDecodeNetworkResponse(with: result, decode: PostDataContent.self)
  }
  
  
  /// 게시글 단건 조회하기
  /// - Parameters:
  ///   - postId: 게시글의 PostId
  ///   - completion: API 처리 후 전달
  func searchSinglePostData(postId: Int) async throws -> PostDetailData {
    let loginStatus = LoginStatusManager.shared.loginStatus
    print(#fileID, #function, #line," - \(loginStatus)")

    let result = await provider.request(.searchSinglePost(loginStatus: loginStatus, postId: postId))
    return try await self.commonDecodeNetworkResponse(with: result, decode: PostDetailData.self)
  }
  
  
  /// 내가 작성한 게시글 조회하기
  /// - Parameters:
  ///   - page: 게시글 페이지
  ///   - size: 게시글 갯수
  func searchMyPost(page: Int, size: Int, completion: @escaping (MyPostData) -> Void){
    provider.request(.searchMyPost(page: page, size: size)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: MyPostData.self) { decodedData in
        completion(decodedData)
      }
    }
  }
  
  
  /// 스터디 생성
  /// - Parameter data: 스터디 관련 데이터
  func createNewPost(with data: CreateStudyRequest ,completion: @escaping (Int?) -> Void) {
    provider.request(.createNewPost(newData: data)) { result in
      switch result {
      case .success(let response):
        print(response.description)
        print(response.response)
        
        
        /// 게시 후 postID 반환해야함
        guard let postID = String(data: response.data, encoding: .utf8) else {
          completion(nil)
          return
        }
        print(postID)
        completion(Int(postID))
      case .failure(let err):
        print(err)
        completion(nil)
      }
//      self.commonDecodeNetworkResponse(with: result, decode: StudyDTO.self) { decodedData in
//        print(decodedData)
//      }
    }
  }
  
  
  /// 스터디 삭제
  /// - Parameter postId: 삭제할 스터디의 postId
  func deletePost(with postId: Int, completion: @escaping (Bool) -> Void){
    provider.request(.deletePost(postId: postId)) { result in
      switch result {
      case .success(_): completion(true)
      case .failure(_): completion(false)
      }
    }
  }
  
  
  /// 스터디 수정
  /// - Parameter data: 수정할 스터디 데이터
  func modifyPost(with data: UpdateStudyRequest){
    provider.request(.modifyPost(modifiedData: data)) { result in
      switch result {
      case .success(_): print("수정 완")
      case .failure(_): print("수정 실패")
      }
    }
  }
  
  
  /// 작성한 스터디 마감하기
  /// - Parameter postId: 마감할 postId
  func closePost(with postId: Int, completion: @escaping (Bool) -> Void){
    provider.request(.closePost(postId: postId)) { result in
      switch result {
      case .success(_): completion(true)
      case .failure(_): completion(false)
      }
    }
  }
  
  
  /// 검색어 추천
  /// - Parameter keyword: 검색어
  func searchRecommend(with keyword: String) async throws -> RecommendList {
    let result = await provider.request(.recommendSearch(keyword: keyword))
    return try await self.commonDecodeNetworkResponse(with: result, decode: RecommendList.self)
  }
  
  /// 작성한 모든 게시글 삭제
  func deleteMyAllPost(completion: @escaping (Bool) -> Void){
    provider.request(.deleteAllPost) { result in
      switch result {
      case .success(_):
        print("삭제 완료")
        completion(true)
      case .failure(_):
        print("삭제 실패")
        completion(false)
      }
    }
  }
}
