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
  var newPostDatas = BehaviorRelay<[PostData]>(value: [])
  
  /// 마감이 임박한 스터디
  var deadlinePostDatas = BehaviorRelay<[PostData]>(value: [])
  
  var checkLoginStatus = BehaviorRelay<Bool>(value: false)
  var singlePostData = PublishRelay<PostDetailData>()
  var isNeedFetchDatas = PublishRelay<Bool>()
  
  
  init() {
    StudyPostManager.shared.fetchAccessToken()
    
    Task {
      do {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        async let newPostData: () = self.fetchNewPostDatas()
        async let deadLinePostData: () = self.fetchDeadLinePostDatas()
        
        await newPostData
        await deadLinePostData
      }
    }
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
}

