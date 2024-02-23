//
//  BookmarkManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/01.
//

import UIKit

final class BookmarkManager {
  let commonNetworking = CommonNetworking.shared
  
  static let shared = BookmarkManager()
  
  // MARK: - 북마크 버튼 눌렀을 때
  func bookmarkTapped(_ postId: Int,
                      completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .changeBookMarkStatus(postId) ,
                                    needCheckToken: true) { result in
      switch result {
      case .success(let response):
          completion()
        
        
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 북마크 리스트 가져오기
  func getBookmarkList(_ page: Int,
                       _ size: Int,
                       completion: @escaping (BookmarkDatas) -> Void) {
    commonNetworking.moyaNetworking(networkingChoice: .searchBookMarkList(page: 0, size: size),
                                    needCheckToken: true) { result in
      switch result {
      case .success(let response):
        do {
          let searchResult = try JSONDecoder().decode(BookmarkDatas.self,
                                                      from: response.data)
          completion(searchResult)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  func searchSingleBookmark(postId: Int,
                            userId: Int,
                            completion: @escaping (CheckSingleBookmark) -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .searchSingleBookMark(postId,
                                                                            userId)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        do {
          let searchResult = try JSONDecoder().decode(CheckSingleBookmark.self,
                                                      from: response.data)
          completion(searchResult)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  func deleteAllBookmark(completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .deleteAllBookMark) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
        
      case .failure(let response):
        print(response.response)
      }
    }
  }
}


