//
//  BookmarkViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/22/24.
//

import Foundation

import RxRelay
import RxFlow

/// 북마크 ViewModel
final class BookmarkViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  var bookmarkDatas = PublishRelay<[BookmarkContent]>()
  
  var totalCount = PublishRelay<Int>()
  
  
  var bookmarkList: [BookmarkContent] = []
  var loginStatus = BehaviorRelay<Bool>(value: false)
  
  func fetchBookmarkData() {
    Task {
      do {
        getBookmarkList()
      } catch {
        print("Error refreshing token: \(error)")
        clearBookmarkList()
      }
    }
  }
  
  private func clearBookmarkList() {
    self.totalCount.accept(0)
    self.bookmarkDatas.accept([])
    self.bookmarkList = []
  }
  
#warning("무한 스크롤로 변경")
  /// 북마크 리스트 가져오기
  func getBookmarkList(){
    Task {
      do {
        let datas = try await BookmarkManager.shared.getBookmarkList(page: 0, size: 5)
        print(#fileID, #function, #line," - \(datas)")

        self.totalCount.accept(datas.totalCount)
        self.bookmarkDatas.accept(datas.getBookmarkedPostsData.content)
        self.bookmarkList = datas.getBookmarkedPostsData.content
        loginStatus.accept(true)
      }catch {
        print(#fileID, #function, #line," - 로그인 안함")
        loginStatus.accept(false)
        self.totalCount.accept(0)
      }
    }
  }
  
  /// 모든 북마크 삭제
  func deleteAllBtnTapped(){
 
    BookmarkManager.shared.deleteAllBookmark {
      self.bookmarkList = []
      self.bookmarkDatas.accept(self.bookmarkList)
      self.totalCount.accept(self.bookmarkList.count)
    }
  }
  
  
  /// 북마크 버튼 탭 - 북마크 삭제
  /// - Parameter postID: 해당 스터디의 postID
  func deleteSingleBtnTapped(postID: Int){
    BookmarkManager.shared.bookmarkTapped(with: postID) { result in
      self.bookmarkList.removeAll { $0.postID == postID }
      self.bookmarkDatas.accept(self.bookmarkList)
      self.totalCount.accept(self.bookmarkList.count)
    }
  }
  
  
  /// 스터디 참여버튼 탭
  /// - Parameters:
  ///   - postID: 스터디의 postID
  func applyStudyBtnTppaed(postID: Int){
    Task {
      do {
        let result = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
        
        if result.apply {
          ToastPopupManager.shared.showToast(message: "이미 신청한 스터디예요.", imageCheck: false)
        }else {
          let postedData = BehaviorRelay<PostDetailData?>(value: nil)
          postedData.accept(result)
          steps.accept(AppStep.applyStudyScreenIsRequired(data: postedData))
        }
      }
    }
  }

}

