//
//  PostedStudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import Foundation

import RxRelay

final class PostedStudyViewModel: CommonViewModel {
  let detailPostDataManager = PostDetailInfoManager.shared
  let myPostDataManager = MyPostInfoManager.shared
  let createPostManager = PostManager.shared
  let userDataManager = UserInfoManager.shared
  let commentManager = CommentManager.shared
  
  var postDatas = BehaviorRelay<PostDetailData?>(value: nil)
  var commentDatas = PublishRelay<[CommentConetent]>()
  var relatedPostDatas = BehaviorRelay<[RelatedPost]>(value: [])
  var countComment = PublishRelay<Int>()
  
  init(_ postDatas: PostDetailData) {
    super.init()
    
    self.postDatas.accept(postDatas)
    self.relatedPostDatas.accept(postDatas.relatedPost)

    fetchCommentDatas()
  }
  
  func fetchCommentDatas(){
    guard let postID = postDatas.value?.postID else { return }
    detailPostDataManager.getCommentPreview(postId: postID) { [weak self] comments in
      self?.commentDatas.accept(comments)
      
      let commentCount = comments.filter { $0.commentID != nil }.count
      self?.countComment.accept(commentCount)
    }
  }
}
