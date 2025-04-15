//
//  SearchViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//

import Foundation

import RxSwift
import RxRelay
import RxFlow

/// 검색 ViewModel
final class SearchViewModel: Stepper {
  static let shared = SearchViewModel()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  var steps: PublishRelay<Step> = PublishRelay()

  /// 검색어 리스트
  var recommendList: PublishRelay<[String]> = PublishRelay<[String]>()
  
  /// 검색된 스터디 리스트
  var postDatas: BehaviorRelay<[PostData?]> = BehaviorRelay<[PostData?]>(value: [])

  var page: Int = 0

  var isInfiniteScroll: Bool = true
  
  var searchContent: String = ""
  
  // MARK: - 추천어 검색하기
  
  /// 추천어 검색하기
  /// - Parameter keyword: 입력된 검색어
  func searchRecommend(keyword: String) {
    StudyPostManager.shared.searchRecommendWtihRx(with: keyword)
      .subscribe(onNext: { [weak self] keywords in
        self?.recommendList.accept(keywords.recommendList)
      }, onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
    
  }
  
  /// 검색어와 관련된 스터디 불러오기
  /// - Parameter selectedKeyword: 키워드
  func fetchPostData(with selectedKeyword: String) {
    StudyPostManager.shared
      .searchAllPostWithRx(title: selectedKeyword, page: page)
      .subscribe(onNext: { [weak self] data in
        guard let self = self else { return }
        
        var currentData = self.postDatas.value
        
        if self.page == 0 {
          currentData = data.postDataByInquiries.content
        } else {
          let newData = data.postDataByInquiries.content
          currentData.append(contentsOf: newData)
          self.isInfiniteScroll = data.postDataByInquiries.last
        }
        
        self.postDatas.accept(currentData)
        self.page += 1
      },onError: { err in
        print("❌ 에러 발생:",err)
      }).disposed(by: disposeBag)
  }
}

