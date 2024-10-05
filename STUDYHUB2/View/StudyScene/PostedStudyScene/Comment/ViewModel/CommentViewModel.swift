
import Foundation

import RxRelay

enum CommentActionList {
  case delete
  case create
  case modify
}

final class CommentViewModel: CommonViewModel {
  let commentManager = CommentManager.shared
  let detailPostDataManager = PostDetailInfoManager.shared
  let userDataManager = UserInfoManager.shared
  
  var postID: Int = 0
  var commentID: Int? = nil
  var userData: UserDetailData?
  
  var commentList = BehaviorRelay<[CommentConetent]>(value: [])
  var commentCount = BehaviorRelay<Int>(value: 0)
  var commentContent = BehaviorRelay<String?>(value: nil)
  var commentActionStatus = PublishRelay<CommentActionList>()
  var isNeedFetch: PublishRelay<Bool>?
  
  init(isNeedFetch: PublishRelay<Bool>?, postID: Int) {
    self.isNeedFetch = isNeedFetch
    self.postID = postID
    
    super.init()
    
    getCommentList()
    getUserData()
  }
  
  func getUserData(){
    userDataManager.getUserInfo { result in
      guard let data = result else { return }
      self.userData = data
    }
  }
  
  func getCommentList(){
    detailPostDataManager.getCommentList(postId: postID, page: 0, size: 100) { result in
      self.commentList.accept(result.content)
      self.commentCount.accept(result.numberOfElements)
    }
  }
  
 // MARK: - 댓글 작성하기

  
  func createComment(){
    guard let content = commentContent.value else { return }
    commentManager.createComment(content: content, postID: postID) { result in
      self.updateCommentList(result)
      if result {
        self.commentActionStatus.accept(.create)
      }

    }
  }
  
// MARK: - 댓글 수정하기
  
  
  func modifyComment(_ commentID: Int){
    guard let content = commentContent.value else { return }
    commentManager.modifyComment(content: content, commentID: commentID) { result in
      self.updateCommentList(result)
      if result {
        self.commentActionStatus.accept(.modify)
      }
    }
  }
  
// MARK: - 댓글 삭제하기

  
  func deleteComment(commentId: Int){
    commentManager.deleteComment(commentID: commentId) { result in
      self.updateCommentList(result)
      if result {
        self.commentActionStatus.accept(.delete)
      }
    }
  }
  
  func updateCommentList(_ result: Bool){
    switch result {
    case true:
      getCommentList()
    case false:
      return
    }
  }
}
