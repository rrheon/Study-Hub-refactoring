//
//  BookmarkViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/22/24.
//

import Foundation

import RxRelay

protocol BookMarkDataProtocol {
  var loginStatus: Bool { get }
  var isNeedFetch: PublishRelay<Bool> { get }
}

struct BookMarkData: BookMarkDataProtocol {
  var loginStatus: Bool
  var isNeedFetch: PublishRelay<Bool>
  
  init(loginStatus: Bool, isNeedFetch: PublishRelay<Bool>) {
    self.loginStatus = loginStatus
    self.isNeedFetch = isNeedFetch
  }
}

final class BookmarkViewModel: CommonViewModel {
  let detailPostDataManager = PostDetailInfoManager.shared
  let bookmarkManager = BookmarkManager.shared
  
  var data: BookMarkDataProtocol
  var bookmarkDatas = PublishRelay<[BookmarkContent]>()
  var postData = PublishRelay<PostDetailData>()
  var totalCount = PublishRelay<Int>()
  var isNeedFetch: PublishRelay<Bool>
  
  var bookmarkList: [BookmarkContent] = []
  var defaultRequestNum = 100
  let loginStatus: Bool
  
  init(_ data: BookMarkDataProtocol) {
    self.data = data
    self.loginStatus = data.loginStatus
    self.isNeedFetch = data.isNeedFetch
    super.init()
    
    self.getBookmarkList()
  }
  
  func getBookmarkList(){
    bookmarkManager.getBookmarkList(0, defaultRequestNum) { [weak self] result in
      self?.totalCount.accept( result.totalCount)
      self?.bookmarkDatas.accept(result.getBookmarkedPostsData.content)
      self?.bookmarkList = result.getBookmarkedPostsData.content
    }
  }
  
  func deleteButtonTapped(postID: Int){
    bookmarkTapped(postId: postID)
    
    bookmarkList.removeAll { $0.postID == postID }
    bookmarkDatas.accept(bookmarkList)
    totalCount.accept(bookmarkList.count)
  }
  
  func searchSingePostData(postID: Int, loginStatus: Bool){
    detailPostDataManager.searchSinglePostData(postId: postID, loginStatus: loginStatus) {
      self.postData.accept($0)
    }
  }
}

extension BookmarkViewModel: BookMarkDelegate {}
