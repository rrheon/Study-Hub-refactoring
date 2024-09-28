//
//  StudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/27/24.
//

import Foundation

import RxRelay
import RxSwift

final class StudyViewModel: CommonViewModel {
  let postDataManager = PostDataManager.shared
  let detailPostDataManager = PostDetailInfoManager.shared
  
  var postDatas = BehaviorRelay<[Content]>(value: [])
  lazy var postCount = Observable<Int>.create { observer in
    observer.onNext(self.postDatas.value.count)
    observer.onCompleted()
    return Disposables.create()
  }
  
  var checkLoginStatus = BehaviorRelay<Bool>(value: false)
  var isNeedFetch = PublishRelay<Bool>()
  var postData = BehaviorRelay<PostDetailData?>(value: nil)
  
  private var internalCounter: Int = 0
  
  var counter: Int {
    get {
      internalCounter += 1
      return internalCounter
    }
    set {
      internalCounter = newValue
    }
  }
  
  var searchType: String = "false"
  var isInfiniteScroll = true
  var isLastData = false
  lazy var postCounts: Int? = 0
  
  init(loginStatus: Bool) {
    super.init()
    checkLoginStatus.accept(loginStatus)
    self.fetchPostData(hotType: "false")
  }

  // 인기 전체 탭 누를 때 마다 이미 있는 데이터라도 새로운 데이터 계속 추가됨
  func fetchPostData(hotType: String, page: Int = 0, size: Int = 5, dataUpdate: Bool = false){
    postDataManager.getRecentPostDatas(
      hotType: hotType,
      page: page,
      size: size
    ) { [weak self] response in
      guard let self = self else { return }
      
      if searchType == hotType && !dataUpdate{
        let updatedPosts = self.postDatas.value + response.postDataByInquiries.content
        self.postDatas.accept(updatedPosts)
      } else{
        self.postDatas.accept(response.postDataByInquiries.content)
      }

      self.searchType = hotType
      isLastData = response.postDataByInquiries.last
      isInfiniteScroll = true
      postCounts = postDatas.value.count
    }
  }
  
  func resetCounter(){
    internalCounter = 0
  }
}
