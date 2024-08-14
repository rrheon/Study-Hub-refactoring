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
  
  init(_ postDatas: PostDetailData) {
    super.init()
    self.postDatas.accept(postDatas)
    fetchCommentDatas()
  }
  
  func fetchCommentDatas(){
    guard let postID = postDatas.value?.postID else { return }
    detailPostDataManager.getCommentPreview(postId: postID) {
      self.commentDatas.accept($0)
    }
  }
}
