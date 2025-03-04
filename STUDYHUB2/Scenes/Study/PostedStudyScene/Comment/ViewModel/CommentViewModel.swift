
import Foundation

import RxRelay

/// 댓글 전체 ViewModel - PostedStudyViewModel을 상속받는건 어떤지
final class CommentViewModel: PostedStudyViewModel {
  
  override init(with postID: Int) {
    super.init(with: postID)
    
    self.postID = postID
    getCommentList()
  }
  
  /// 댓글 전체 리스트 가져오기
  /// - Parameters:
  ///   - page: 가져올 page
  ///   - size: 가져올 댓글 갯수
  func getCommentList(page: Int = 0, size: Int = 10){
    /// last 가 false이면 데이터가 더 있음 true이면 없음
    CommentManager.shared.getCommentList(postId: postID, page: page, size: size) { comments in
      self.commentDatas.accept(comments.content)
    }
  }
}
