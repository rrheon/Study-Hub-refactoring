//
//  BookmarkManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//

import Foundation

import RxSwift
import RxMoya
import Moya

/// 북마크 관련 네트워킹
class BookmarkManager: StudyHubCommonNetworking {
  static let shared = BookmarkManager()
  
  let provider = MoyaProvider<BookmarkNetworking>()
  
  // MARK: - 북마크 버튼 눌렀을 때
  
  /// 북마크 버튼 탭 - 북마크 저장 혹은 삭제
  /// - Parameters:
  ///   - postId: 해당 스터디의 postId
  ///   - completion: 콜백함수
  func bookmarkTapped(with postId: Int, completion: @escaping (Int) -> Void){
    provider.request(.changeBookMarkStatus(postId: postId)) { result in
      
      print(result)
      switch result {
      case .success(let response):
        print(response.statusCode)
        completion(response.statusCode)
      case .failure(let response):
        print(response.response)
        completion(response.errorCode)
      }
    }
  }
  
  /// 북마크 버튼 탭 - 북마크 저장 혹은 삭제
  /// - Parameters:
  ///   - postId: 해당 스터디의 postId
  func bookmarkTappedWithRx(with postId: Int) -> Observable<Bool>{
    return provider.rx
      .request(.changeBookMarkStatus(postId: postId))
      .asObservable()
      .map { reponse in
        return (200...299).contains(reponse.statusCode)
      }
      .catchAndReturn(false)
  }
  
  // MARK: - 북마크 리스트 가져오기
  
  /// 북마크리스트 가져오기
  /// - Parameters:
  ///   - page: 북마크 페이지
  ///   - size: 북마크 갯수
  ///   - completion: 콜백함수
  func getBookmarkList(page: Int, size: Int) async throws -> BookmarkDatas {
    let result = await provider.request(.searchBookMarkList(page: page, size: size))
    return try await commonDecodeNetworkResponse(with: result, decode: BookmarkDatas.self)
  }
  
  /// 북마크리스트 가져오기
  /// - Parameters:
  ///   - page: 북마크 페이지
  ///   - size: 북마크 갯수
  ///   - completion: 콜백함수
  func getBookmarkListWithRx(page: Int, size: Int) -> Observable<BookmarkDatas> {
    return provider.rx
      .request(.searchBookMarkList(page: page, size: size))
      .asObservable()
      .flatMap { response -> Observable<BookmarkDatas> in
        self.commonDecodeNetworkResponse(with: response, decode: BookmarkDatas.self)
      }
  }
  
  
  /// 북마크여부 단일 조회
  /// - Parameters:
  ///   - postId: 조회할 스터디의 PostId
  ///   - userId: 사용자의 userId
  ///   - completion: 콜백함수
  func searchSingleBookmark(postId: Int,userId: Int, completion: @escaping (CheckSingleBookmark) -> Void){
    provider.request(.searchSingleBookMarked(postId: postId, userId: userId)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: CheckSingleBookmark.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  /// 북마크여부 단일 조회
  /// - Parameters:
  ///   - postId: 조회할 스터디의 PostId
  ///   - userId: 사용자의 userId
  func searchSingleBookmarkWithRx(postId: Int,userId: Int) -> Observable<Bool> {
    return provider.rx
      .request(.searchSingleBookMarked(postId: postId, userId: userId))
      .asObservable()
      .map { $0.statusCode == 200 }
  }
  
  
  /// 모든 북마크 삭제
  /// - Parameter completion: 콜백함수
  func deleteAllBookmark(completion: @escaping () -> Void){
    provider.request(.deleteAllBookMark) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
        
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  func deleteAllBookmarkWithRx() -> Observable<Bool>{
    return provider.rx
          .request(.deleteAllBookMark)
          .asObservable()
          .map { response in
            return (200...299).contains(response.statusCode)
          }
          .catchAndReturn(false)
  }
}
