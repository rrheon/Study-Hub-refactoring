//
//  StudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/27/24.
//

import Foundation

import RxRelay
import RxSwift
import RxFlow

/// 전체 스터디 ViewModel
final class StudyViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  static let shared = StudyViewModel()
  
  /// 전체 게시글 데이터
  var postDatas = BehaviorRelay<[Content]>(value: [])
  
  /// 전체 게시글 갯수
  var postCount: Observable<Int> {
    return postDatas.map { $0.count }
  }
  
  /// 스터디 무한스크롤 여부
  var isInfiniteScroll = true
  
  init() {
//    let isLoginStatus: Bool = TokenManager.shared.loadAccessToken()?.first != nil
//    checkLoginStatus.accept(isLoginStatus)
//    fetchPostData(hotType: "false")
    print(#fileID, #function, #line," - 111111111111111")

  }
  
  func fetchPostData(hotType: String, page: Int = 0, size: Int = 5, dataUpdate: Bool = false){
//    postDataManager.getRecentPostDatas(
//      hotType: hotType,
//      page: page,
//      size: size
//    ) { [weak self] response in
//      guard let self = self else { return }
//      
//      if searchType == hotType && !dataUpdate{
//        let updatedPosts = self.postDatas.value + response.postDataByInquiries.content
//        self.postDatas.accept(updatedPosts)
//      } else{
//        self.postDatas.accept(response.postDataByInquiries.content)
//      }
//
//      self.searchType = hotType
//      isLastData = response.postDataByInquiries.last
//      isInfiniteScroll = true
//      postCounts = postDatas.value.count
//    }
  }
  

}
