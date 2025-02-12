//
//  HomeViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/8/24.
//

import Foundation

import RxFlow
import RxRelay

/// HomeViewModel
final class HomeViewModel: Stepper {
  static let shared = HomeViewModel()
  
  var steps: PublishRelay<Step> = PublishRelay()

  /// 새로 모집중인 스터디
  var newPostDatas = BehaviorRelay<[Content]>(value: [])
 
  /// 마감이 임박한 스터디
  var deadlinePostDatas = BehaviorRelay<[Content]>(value: [])
  
  var userInfo = PublishRelay<UserDetailData>()
  var checkLoginStatus = BehaviorRelay<Bool>(value: false)
  var singlePostData = PublishRelay<PostDetailData>()
  var isNeedFetchDatas = PublishRelay<Bool>()

  
  init() {
    let isLoginStatus: Bool = TokenManager.shared.loadAccessToken()?.first != nil
    checkLoginStatus.accept(isLoginStatus)
//    
//    Task {
//      await fetchNewPostDatas()
//    }
//    
  }
  
  
  /// 새로 모집중인 스터디 가져오기
  func fetchNewPostDatas() async {
    do {
      let result = try await StudyPostManager.shared.searchAllPost(page: 0,size: 5)
      self.newPostDatas.accept(result.postDataByInquiries.content)
    } catch {
      print(#fileID, #function, #line," - \(error)")

    }
  }
  
  /// 마감이 임박한 스터디 가져오기
  func fetchDeadLinePostDatas() async{
    do {
      let result = try await StudyPostManager.shared.searchAllPost(hot: "true", page: 0, size: 4)
      self.deadlinePostDatas.accept(result.postDataByInquiries.content)
    } catch {
      print(#fileID, #function, #line," - \(error)")

    }
  }
  
  func fectchSinglePostDatas(_ postID: Int) async {
//    do {
//      let result = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
//    }
//    StudyPostManager.shared.searchSinglePostData(postId: <#T##Int#>) { <#PostDetailData#> in
//      <#code#>
//    }
//    detailPostDataManager.searchSinglePostData(postId: postID, loginStatus: false) {
//      self.singlePostData.accept($0)
//    }
  }
}

