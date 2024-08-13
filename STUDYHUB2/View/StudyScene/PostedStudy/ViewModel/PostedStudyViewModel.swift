//
//  PostedStudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import Foundation

final class PostedStudyViewModel: CommonViewModel {
  let detailPostDataManager = PostDetailInfoManager.shared
  let myPostDataManager = MyPostInfoManager.shared
  let createPostManager = PostManager.shared
  let userDataManager = UserInfoManager.shared
  let commentManager = CommentManager.shared
  
  let postedID: Int
  
  init(postedID: Int) {
    self.postedID = postedID
  }
}
