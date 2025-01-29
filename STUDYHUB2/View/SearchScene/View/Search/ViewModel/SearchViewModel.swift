//
//  SearchViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/23/24.
//

import Foundation

import Moya
import RxRelay

struct SearchViewData: CommonViewData{
  var isUserLogin: Bool
  var isNeedFechData: PublishRelay<Bool>?
  var keyword: String?
  
  init(isUserLogin: Bool, isNeedFechData: PublishRelay<Bool>? = nil, keyword: String? = nil) {
    self.isUserLogin = isUserLogin
    self.isNeedFechData = isNeedFechData
    self.keyword = keyword
  }
}

struct RequestPostData {
  var hot: String
  var text: String
  var page: Int
  var size: Int
  var titleAndMajor: String
}

final class SearchViewModel: CommonViewModel {
  let detailPostDataManager = PostDetailInfoManager.shared
  let postDataManager = PostDataManager.shared
  
  var isUserLogin: Bool
  var numberOfCells: Int = 0
  var isInfiniteScroll = true
  var searchKeyword: String?

  var isNeedFetchToHomeVC: PublishRelay<Bool>?
  var isNeedFetchToSearchVC = PublishRelay<Bool>()
  
  var recommendList = PublishRelay<[String]>()
  var postDatas = PublishRelay<[Content?]>()

  init(_ data: SearchViewData) {
    self.isNeedFetchToHomeVC = data.isNeedFechData
    self.isUserLogin = data.isUserLogin
  }
  
  // MARK: - 추천어 검색하기
  func searchRecommend(keyword: String){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.recommendSearch(keyword)) {
      switch $0 {
      case .success(let response):
        do {
          let data = try JSONDecoder().decode(RecommendList.self, from: response.data)
          self.recommendList.accept(data.recommendList)
          
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let response):
        print(response.response)
      }
    }
//    StudyPostManager.studyPostShared.searchRecommend(with: keyword)
  }
  
  func getPostData(data: RequestPostData){
    postDataManager.getPostData(
      hot: data.hot,
      text: data.text,
      page: data.page,
      size: data.size,
      titleAndMajor: data.titleAndMajor,
      loginStatus: isUserLogin){
        self.postDatas.accept($0.postDataByInquiries.content)
        self.numberOfCells =  $0.totalCount
      }
  }
}

extension SearchViewModel: PostDataFetching {}
