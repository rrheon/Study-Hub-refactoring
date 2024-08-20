//
//  PostedStudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import Foundation

import RxRelay

final class PostedStudyViewModel: CommonViewModel, BookMarkDelegate, StudyBottomSheet {
  let detailPostDataManager = PostDetailInfoManager.shared
  let commentManager = CommentManager.shared
  let userInfoManager = UserInfoManager.shared
  
  var postDatas = BehaviorRelay<PostDetailData?>(value: nil)
  var commentDatas = PublishRelay<[CommentConetent]>()
  var relatedPostDatas = BehaviorRelay<[RelatedPost]>(value: [])
  
  var countComment = PublishRelay<Int>()
  var countRelatedPost = BehaviorRelay<Int>(value: 0)
  var commentTextFieldValue = BehaviorRelay<String>(value: "")
  let dataFromPopupView = PublishRelay<PopupActionType>()
  
  var postOrCommentID: Int = 0
  var userNickanme: String = ""
  
  var isBookmarked = BehaviorRelay<Bool>(value: false)
  var isMyPost = PublishRelay<Bool>()
  
  init(_ postDatas: PostDetailData) {
    super.init()
    
    self.postDatas.accept(postDatas)
    self.isMyPost.accept(postDatas.usersPost)
    self.relatedPostDatas.accept(postDatas.relatedPost)
    self.isBookmarked.accept(postDatas.bookmarked)
    
    getUserInfo()
    fetchCommentDatas()
    countRelatedPosts()
  }
  
  func countRelatedPosts(){
    guard let count = postDatas.value?.relatedPost.filter({ $0.title != nil }).count else { return }
    countRelatedPost.accept(count)
  }
  
  func fetchCommentDatas(){
    guard let postID = postDatas.value?.postID else { return }
    detailPostDataManager.getCommentPreview(postId: postID) { [weak self] comments in
      self?.commentDatas.accept(comments)
      
      let commentCount = comments.filter { $0.commentID != nil }.count
      self?.countComment.accept(commentCount)
    }
  }
  
  func getUserInfo(){
    userInfoManager.getUserInfo {
      guard let nickname = $0?.nickname else { return }
      self.userNickanme = nickname
    }
  }
  
  func bookmarkToggle(){
    let toggledBookmark = isBookmarked.value ? false : true
    isBookmarked.accept(toggledBookmark)
  }
}
