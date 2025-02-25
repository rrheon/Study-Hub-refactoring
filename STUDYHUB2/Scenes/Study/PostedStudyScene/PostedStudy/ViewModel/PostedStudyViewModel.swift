
import Foundation

import RxRelay
import RxSwift
import RxFlow

enum ParticipateAction {
  case goToLoginVC
  case limitedGender
  case closed
  case goToParticipateVC
}


/// 스터디 상세 ViewModel
class PostedStudyViewModel: Stepper  {
  var steps: PublishRelay<Step> = PublishRelay()
  
  
//  var postedStudyData: PostedStudyViewData
  
  /// 게시글의 postID
  var postID: Int
  
  /// 게시글의 상세 데이터
  var postDatas: BehaviorRelay<PostDetailData?> = BehaviorRelay<PostDetailData?>(value: nil)
  
  /// 게시글의 댓글 데이터
  var commentDatas: BehaviorRelay<[CommentConetent]?> = BehaviorRelay<[CommentConetent]?>(value: nil)
  
  /// 게시글의 댓글 갯수
  var commentCount: Observable<Int> {
    return commentDatas.map { $0?.count ?? 0 }
  }

  /// 댓글의 ID - 수정용
  var commentID: Int? = nil

  var loginUserData: BehaviorRelay<UserDetailData?> = BehaviorRelay<UserDetailData?>(value: nil)

  init(with postID: Int) {
    self.postID = postID
    
//    Task {
//      await TokenManager.shared.refreshAccessTokenIfNeeded()
//    }

    // 유저 정보를 못가져옴
    UserProfileManager.shared.fetchUserInfoToServer { userData in
      self.loginUserData.accept(userData)
      
      self.fetchCommentDatas(with: postID)
      self.fetchStudyDeatilData(with: postID)
    }
  }
  
  
  /// 스터디 데이터 가져오기
  func fetchStudyDeatilData(with postID: Int){
    Task {
      let postedData: PostDetailData = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
      postDatas.accept(postedData)
    }
  }
  
  func countRelatedPosts(){
//    guard let count = postDatas.value?.relatedPost.filter({ $0.title != nil }).count else { return }
//    countRelatedPost.accept(count)
  }
  
  
  /// 댓글 미리보기 가져오기(스터디 디테일에서 보여주는 댓글들)
  func fetchCommentDatas(with postID: Int){
    Task {
      let comments: [CommentConetent] = try await CommentManager.shared.getCommentPreview(postId: postID)
      commentDatas.accept(comments)
    }
  }
  
  
  /// 새로운 댓글 작성하기
  /// - Parameter content: 댓글 내용
  func createNewComment(with content: String){
    CommentManager.shared.createComment(content: content, postID: postID) { result in
      if result {
        self.fetchCommentDatas(with: self.postID)
      }
    }
  }
  
  
  /// 댓글 삭제하기
  /// - Parameters:
  ///   - commentID: 댓글  ID
  func deleteComment(with commentID: Int){
    // 현재 화면 내리기
    self.steps.accept(AppStep.dismissCurrentScreen)
    
    CommentManager.shared.deleteComment(commentID: commentID) { result in
      print("댓글 삭제 여부 - \(result)")
      
 
      
      // 댓글 삭제 후 데이터 수정
      if result {
        var datas = self.commentDatas.value
        datas?.removeAll(where: { $0.commentID == commentID})
        
        self.commentDatas.accept(datas)
      }
    }
  }
  
  /// 댓글 수정하기
  /// - Parameters:
  ///   - commentID: 댓글ID
  ///   - content: 수정할 댓글 내용
  func modifyComment(content: String) {
    guard let commentID = self.commentID else { return }
    CommentManager.shared.modifyComment(content: content, commentID: commentID) { result in
      
      if result {
        self.fetchCommentDatas(with: self.postID)
      }
    }
  }
  
  

  
  
  /// 내 포스트 삭제하기
  func deleteMyPost(completion: @escaping () -> Void){
//    guard let postID = postDatas.value?.postID else { return }
//    deleteMyPost(postID) {
//      self.postedStudyData.isNeedFechData?.accept($0)
//      completion()
//    }
  }
  
  
  func bookmarkToggle(){
//    let toggledBookmark = isBookmarked.value ? false : true
//    isBookmarked.accept(toggledBookmark)
  }
  
  func similarCellTapped(_ postID: Int){
//    fetchSinglePostDatas(postID) {
//      self.singlePostData.accept($0)
//    }
  }
  
  func participateButtonTapped(completion: @escaping (ParticipateAction) -> Void) {
    /*
     마감된 스터디 -> self.viewModel.showToastMessage.accept("이미 마감된 스터디예요")
     로그인이 안되어 있는 경우 -> 로그인 팝업 -> 로그인화면
     성별제한 ->  self.viewModel.showToastMessage.accept("이 스터디는 성별 제한이 있는 스터디예요")
     참여 -> 참여화면으로 이동

     */

//    userInfoManager.getUserInfo { [weak self] userData in
//      let postedData = self?.postedStudyData.postDetailData
//      if userData?.nickname == nil {
//        completion(.goToLoginVC)
//        return
//      }
//      
//      if postedData?.filteredGender != userData?.gender && postedData?.filteredGender != "NULL" {
//        completion(.limitedGender)
//        return
//      }
//      
//      if postedData?.close == true {
//        completion(.closed)
//        return
//      }
//      
//      completion(.goToParticipateVC)
//    }
  }
}
