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
  var totalPostDatas = BehaviorRelay<PostDataContent?>(value: nil)

  /// 게시글 데이터
  var postDatas: Observable<[PostData]> {
    return totalPostDatas.map { $0?.postDataByInquiries.content ?? [] }
  }

  /// 전체 게시글 갯수
  var postCount: Observable<Int> {
    return totalPostDatas.map { $0?.totalCount ?? 0 }
  }

  /// 스터디 무한스크롤 여부
  var isInfiniteScroll: Bool {
    return totalPostDatas.value?.postDataByInquiries.last ?? true
  }


  /// 게시글의 페이지
  var postPage: Int = 0

  init() {
    print(#fileID, #function, #line," - 111111111111111")

  }

  /// 모든 스터디 게시글 조회하기
  /// - Parameters:
  ///   - hotType: true - 인기순, false - 인기순 x
  ///   - page: 페이지
  ///   - size: 가져올 갯수
  func fetchPostData(hotType: String, size: Int = 5) async  {
    do {
      let result = try await StudyPostManager.shared.searchAllPost(hot: hotType, page: postPage, size: size)
      
      // 현재 데이터 가져오기
      var currentData = totalPostDatas.value
      
      if postPage == 0 {
        // 첫 페이지면 새 데이터로 덮어쓰기
        currentData = result
      } else {
        var newData = result.postDataByInquiries.content
        
        // 기존 데이터에 새로운 데이터를 추가
        currentData?.postDataByInquiries.content.append(contentsOf: newData)
        // 데이터가 존재 여부 수정
        currentData?.postDataByInquiries.last = result.postDataByInquiries.last
      }

      // 새로운 데이터 설정
      self.totalPostDatas.accept(currentData)
      
      // 페이지 증가
      postPage += 1
    } catch {
      print(#fileID, #function, #line, " - \(error)")
    }
  }
  
  /*
   최신순 / 인기순 탭
   
   최신순 -> 최신순
    페이지 0 들고 기존 데이터 다 없애고 새로운 데이터로
   최신순 -> 인기순
    
   인기순 -> 인기순
   인기순 -> 최신순
   */
  
  /// 최신순 / 인기순 버튼 탭
  /// - Parameter btnType: true - 인기순, false - 인기순 x
  func recentOrPopularBtnTapped(btnType: String = "false") {
    postPage = 0
    
    Task {
      await fetchPostData(hotType: btnType)
    }
  }
}
