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
  
  init(loginStatus: Bool) {
    super.init()
    checkLoginStatus.accept(loginStatus)
    self.fetchPostData(hotType: "false")
  }
  
  func fetchPostData(hotType: String, page: Int = 0, size: Int = 5, test: Bool = false){
    postDataManager.getRecentPostDatas(
      hotType: hotType,
      page: page,
      size: size
    ) { [weak self] response in
      guard let self = self else { return }
      
      // 기존의 데이터와 합칠 때 문제 
      if searchType == hotType && !test {
        let updatedPosts = self.postDatas.value + response.postDataByInquiries.content
        self.postDatas.accept(updatedPosts)
      } else{
        self.postDatas.accept(response.postDataByInquiries.content)
      }

      self.searchType = hotType
      isLastData = response.postDataByInquiries.last
      isInfiniteScroll = true
    }
  }
  
  // 삭제하고 데이터 업데이트 어떻게 할건지
  // -> 데이터 뒤져서 해당 포스트 데이터에서 없애기, 셀 터치하면 포스트 아이디 받아서 해당 포스트 아이디 없애주기
  // 북마크 저장 삭제하고 업데이트 어떻게 할건지
  // -> 데이터 뒤져서 해당 포스트의 북마크 확인 후 true false 지정
  func resetCounter(){
    internalCounter = 0
  }
  
//  func removePost(with postID: Int) {
//    let updatedData = postDatas.value.filter { $0.postID != postID }
//    postDatas.accept(updatedData)
//  }
//
//  func toggleBookmark(for postID: Int) {
//    let updatedData = postDatas.value.map { post -> Content in
//      var mutablePost = post
//      if post.postID == postID {
//        mutablePost.bookmarked.toggle()
//      }
//      return mutablePost
//    }
//    postDatas.accept(updatedData)
//  }
}
