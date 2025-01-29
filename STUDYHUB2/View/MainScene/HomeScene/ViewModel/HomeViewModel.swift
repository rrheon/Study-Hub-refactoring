//
//  HomeViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/8/24.
//

import Foundation

import RxRelay

final class HomeViewModel: CommonViewModel {
  let postDataManager = PostDataManager.shared
  let detailPostDataManager = PostDetailInfoManager.shared
  
  var newPostDatas = BehaviorRelay<[Content]>(value: [])
  var deadlinePostDatas = BehaviorRelay<[Content]>(value: [])
  
  var userInfo = PublishRelay<UserDetailData>()
  var checkLoginStatus = BehaviorRelay<Bool>(value: false)
  var singlePostData = PublishRelay<PostDetailData>()
  var isNeedFetchDatas = PublishRelay<Bool>()

  init(loginStatus: Bool) {
    checkLoginStatus.accept(loginStatus)
    super.init()
    
    fetchNewPostDatas()
    fetchDeadLinePostDatas()
  }
  
  func fetchNewPostDatas(){
//    let loginStatus = checkLoginStatus.value
//    postDataManager.getNewPostData(loginStatus) { datas in
//      self.newPostDatas.accept(datas.postDataByInquiries.content)
//    }
  }
  
  func fetchDeadLinePostDatas(){
//    let loginStatus = checkLoginStatus.value
//    postDataManager.getDeadLinePostData(loginStatus) { datas in
//      self.deadlinePostDatas.accept(datas.postDataByInquiries.content)
//    }
  }
  
  func fectchSinglePostDatas(_ postID: Int){
//    detailPostDataManager.searchSinglePostData(postId: postID, loginStatus: false) {
//      self.singlePostData.accept($0)
//    }
  }
}

