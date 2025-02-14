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
  
  //  let detailPostDataManager = PostDetailInfoManager.shared
  //  let bookmarkManager = BookmarkManager.shared
  
  //  var data: BookMarkDataProtocol
  var bookmarkDatas = PublishRelay<[BookmarkContent]>()
  //  var postData = PublishRelay<PostDetailData>()
  var totalCount = PublishRelay<Int>()
  //  var isNeedFetch: PublishRelay<Bool>
  
  var bookmarkList: [BookmarkContent] = []
  var defaultRequestNum = 100
  let loginStatus: Bool
  
  init() {
    
    loginStatus = false
    
 
  }
  
  func fetchBookmarkData() {
    Task {
      do {
//        await TokenManager.shared.refreshAccessTokenIfNeeded()
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
        let datas = try await BookmarkManager.shared.getBookmarkList(page: 0, size: defaultRequestNum)
        self.totalCount.accept(datas.totalCount)
        self.bookmarkDatas.accept(datas.getBookmarkedPostsData.content)
        self.bookmarkList = datas.getBookmarkedPostsData.content
      }
    }
  }
  
  /// 북마크 버튼 탭 - 북마크 삭제
  /// - Parameter postID: 해당 스터디의 postID
  func deleteButtonTapped(postID: Int){
    BookmarkManager.shared.bookmarkTapped(with: postID) {
      print("북마크 탭")
    }
    
    bookmarkList.removeAll { $0.postID == postID }
    bookmarkDatas.accept(bookmarkList)
    totalCount.accept(bookmarkList.count)
  }
  
  
  /// 스터디 단건 조회
  /// - Parameters:
  ///   - postID: 스터디의 postID
  ///   - loginStatus: 로그인상태
  func searchSingePostData(postID: Int, loginStatus: Bool){
    //    StudyPostManager.shared.searchSinglePostData(postId: postID) { postData in
    //      self.postData.accept(postData)
    //    }
  }
}

