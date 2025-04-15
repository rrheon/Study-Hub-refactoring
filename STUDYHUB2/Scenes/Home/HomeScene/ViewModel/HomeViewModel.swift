//
//  HomeViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/8/24.
//

import Foundation

import RxFlow
import RxRelay
import RxSwift

/// HomeViewModel
final class HomeViewModel: Stepper {
  static let shared = HomeViewModel()
  
  var steps: PublishRelay<Step> = PublishRelay()
  var disposeBag: DisposeBag = DisposeBag()
  
  
  /// 새로 모집중인 스터디
  var newPostDatas = BehaviorRelay<[PostData]>(value: [])
  
  /// 마감이 임박한 스터디
  var deadlinePostDatas = BehaviorRelay<[PostData]>(value: [])
  
  //  var checkLoginStatus = BehaviorRelay<Bool>(value: false)
  //  var singlePostData = PublishRelay<PostDetailData>()
  var isNeedFetchDatas = PublishRelay<Bool>()
  
  
  init() {
    LoginStatusManager.shared.fetchAccessToken()
    
    Task {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      
      fetchHomePostDatas()
    }
  }
  
  
  /// Home화면 데이터 가져오기
  /// 새로운 스터디, 마감이 임박한 스터디
  func fetchHomePostDatas(){
    let newPostObservable = StudyPostManager.shared.searchAllPostWithRx(page: 0, size: 5)
    let deadLinePostObservable = StudyPostManager.shared.searchAllPostWithRx(hot: "true", page: 0, size: 4)
    
    Observable.zip(newPostObservable, deadLinePostObservable)
      .subscribe(onNext: { [weak self] newPostData, deadLinePostData in
        self?.newPostDatas.accept(newPostData.postDataByInquiries.content)
        self?.deadlinePostDatas.accept(deadLinePostData.postDataByInquiries.content)
      }, onError: { err in        
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
        
      }).disposed(by: disposeBag)
  }
}

