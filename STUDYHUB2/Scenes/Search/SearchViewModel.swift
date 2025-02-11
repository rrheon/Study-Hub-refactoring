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
  var steps: PublishRelay<Step> = PublishRelay()

  /// 검색어 리스트
  var recommendList: PublishRelay<[String]> = PublishRelay<[String]>()
  
  /// 검색된 스터디 리스트
  var postDatas: PublishRelay<[Content?]> = PublishRelay<[Content?]>()

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
  
  func getPostData(){
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

