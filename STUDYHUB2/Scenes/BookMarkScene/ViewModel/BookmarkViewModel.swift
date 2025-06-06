//
//  BookmarkViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/22/24.
//

import Foundation

import RxSwift
import RxRelay
import RxFlow

/// 북마크 ViewModel
final class BookmarkViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  /// 서버에서 받아오는 북마크 데이터
  var bookmarkDatas = BehaviorRelay<[BookmarkContent?]>(value: [])
  
  var totalCount = PublishRelay<Int>()
  
  /// 북마크 리스트 업데이트용
  var bookmarkList: [BookmarkContent?] = []
  
  /// 로그인 상태
  var loginStatus = BehaviorRelay<Bool>(value: false)
  
  /// 스터디 무한스크롤 여부
  /// true = 마지막 , false = 더 있음
  var isInfiniteScroll: Bool = true
  
  /// 북마크 페이지
  var bookmarkPage: Int = 0
  
//  func fetchBookmarkData() {
//    Task {
//      do {
//        getBookmarkList()
//      } catch {
//        print("Error refreshing token: \(error)")
//        clearBookmarkList()
//      }
//    }
//  }
  
  private func clearBookmarkList() {
    self.totalCount.accept(0)
    self.bookmarkDatas.accept([])
    self.bookmarkList = []
  }
  
  /// 북마크 리스트 가져오기
  func getBookmarkList(size: Int = 5){
    
    BookmarkManager.shared.getBookmarkListWithRx(page: bookmarkPage, size: size)
      .subscribe(onNext: { [weak self] bookmarkData in
        var currentDatas = self?.bookmarkDatas.value ?? []
        
        if self?.bookmarkPage == 0 {
          // 첫 페이지면 새 데이터로 덮어쓰기
          currentDatas = bookmarkData.getBookmarkedPostsData.content
        }else{
          var newData = bookmarkData.getBookmarkedPostsData.content
          
          currentDatas.append(contentsOf: newData)
        }
        
        self?.totalCount.accept(bookmarkData.getBookmarkedPostsData.numberOfElements)
        self?.bookmarkDatas.accept(currentDatas)
        self?.bookmarkList = currentDatas
        
        // 스크롤 여부
        self?.isInfiniteScroll = bookmarkData.getBookmarkedPostsData.last
        self?.loginStatus.accept(true)
        
        // 페이지 증가
        self?.bookmarkPage += 1
      },onError: { err in
        self.loginStatus.accept(false)
        self.totalCount.accept(0)
      })
      .disposed(by: disposeBag)
//    Task {
//      do {
//        let datas = try await BookmarkManager.shared.getBookmarkList(page: bookmarkPage, size: size)
//        
//        var currentDatas = bookmarkDatas.value
//        
//        if bookmarkPage == 0 {
//          // 첫 페이지면 새 데이터로 덮어쓰기
//          currentDatas = datas.getBookmarkedPostsData.content
//        }else{
//          var newData = datas.getBookmarkedPostsData.content
//          
//          currentDatas.append(contentsOf: newData)
//        }
//        
//        self.totalCount.accept(datas.getBookmarkedPostsData.numberOfElements)
//        self.bookmarkDatas.accept(currentDatas)
//        self.bookmarkList = currentDatas
//        
//        // 스크롤 여부
//        self.isInfiniteScroll = datas.getBookmarkedPostsData.last
//        loginStatus.accept(true)
//        
//        // 페이지 증가
//        bookmarkPage += 1
//      }catch {
//        print(#fileID, #function, #line," - 로그인 안함")
//        loginStatus.accept(false)
//        self.totalCount.accept(0)
//      }
//    }
  }
   
  /// 모든 북마크 삭제
  func deleteAllBtnTapped(){
    BookmarkManager.shared.deleteAllBookmarkWithRx()
      .subscribe(onNext: { [weak self] isDeleted in
        self?.bookmarkList = []
        self?.bookmarkDatas.accept(self?.bookmarkList ?? [])
        self?.totalCount.accept(self?.bookmarkList.count ?? 0)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    BookmarkManager.shared.deleteAllBookmark {
//      self.bookmarkList = []
//      self.bookmarkDatas.accept(self.bookmarkList)
//      self.totalCount.accept(self.bookmarkList.count)
//    }
  }
   
  
  /// 북마크 버튼 탭 - 북마크 삭제
  /// - Parameter postID: 해당 스터디의 postID
  func deleteSingleBtnTapped(postID: Int){
    BookmarkManager.shared.bookmarkTappedWithRx(with: postID)
      .subscribe(onNext: { [weak self] _ in
        self?.bookmarkList.removeAll { $0?.postID == postID }
        self?.bookmarkDatas.accept(self?.bookmarkList ?? [])
        self?.totalCount.accept(self?.bookmarkList.count ?? 0)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    BookmarkManager.shared.bookmarkTapped(with: postID) { result in
//      if result == 500 {
//        print("삭제실패")
//      } else {
//        self.bookmarkList.removeAll { $0?.postID == postID }
//        self.bookmarkDatas.accept(self.bookmarkList)
//        self.totalCount.accept(self.bookmarkList.count)
//      }
//    }
  }
  
  
  /// 스터디 참여버튼 탭
  /// - Parameters:
  ///   - postID: 스터디의 postID
  func applyStudyBtnTppaed(postID: Int){
    StudyPostManager.shared.searchSinglePostDataWithRx(postId: postID)
      .map { ($0.apply, $0) }
      .subscribe(onNext: { [weak self] isApplied, postedData in
        guard let self = self else { return }
        
        if isApplied {
          ToastPopupManager.shared.showToast(message: "이미 신청한 스터디예요.", imageCheck: false)
        } else {
          let dataRelay = BehaviorRelay<PostDetailData?>(value: postedData)
          self.steps.accept(AppStep.study(.applyStudyScreenIsRequired(data: dataRelay)))
        }
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)

//    Task {
//      do {
//        let result = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
//        
//        if result.apply {
//          ToastPopupManager.shared.showToast(message: "이미 신청한 스터디예요.", imageCheck: false)
//        }else {
//          let postedData = BehaviorRelay<PostDetailData?>(value: nil)
//          postedData.accept(result)
//          steps.accept(AppStep.study(.applyStudyScreenIsRequired(data: postedData)))
//        }
//      }
//    }
  }

}

