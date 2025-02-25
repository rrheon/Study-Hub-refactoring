//
//  SearchViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//

import Foundation

import RxRelay
import RxFlow

/// 검색 ViewModel
final class SearchViewModel: Stepper {
  static let shared = SearchViewModel()
  
  var steps: PublishRelay<Step> = PublishRelay()

  /// 검색어 리스트
  var recommendList: PublishRelay<[String]> = PublishRelay<[String]>()
  
  /// 검색된 스터디 리스트
  var postDatas: PublishRelay<[PostData?]> = PublishRelay<[PostData?]>()

  init() {
    
  }
  
  // MARK: - 추천어 검색하기
  func searchRecommend(keyword: String) async {
    do {
      let result = try await StudyPostManager.shared.searchRecommend(with: keyword)
      self.recommendList.accept(result.recommendList)
    }catch {
      print(#fileID, #function, #line," - \(error)")
    }
  }
  
  /// 검색어와 관련된 스터디 불러오기
  /// - Parameter selectedKeyword: 키워드
  func fectchPostData(with selectedKeyword: String){
    Task {
      do {
        let data = try await StudyPostManager.shared.searchAllPost(title: selectedKeyword)
        postDatas.accept(data.postDataByInquiries.content)
      }
    }
//    postDataManager.getPostData(
//      hot: data.hot,
//      text: data.text,
//      page: data.page,
//      size: data.size,
//      titleAndMajor: data.titleAndMajor,
//      loginStatus: isUserLogin){
//        self.postDatas.accept($0.postDataByInquiries.content)
//        self.numberOfCells =  $0.totalCount
//      }
  }
}

