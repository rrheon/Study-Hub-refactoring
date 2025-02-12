
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

protocol PostedStudyViewData: CommonViewData {
  var postDetailData: PostDetailData { get }
}

struct PostedStudyData: PostedStudyViewData {
  var isUserLogin: Bool
  var postDetailData: PostDetailData
  var isNeedFechData: PublishRelay<Bool>?
 
  init(isUserLogin: Bool,
       postDetailData: PostDetailData,
       isNeedFechData: PublishRelay<Bool>? = nil
  ) {
    self.isUserLogin = isUserLogin
    self.postDetailData = postDetailData
    self.isNeedFechData = isNeedFechData
  }
}

/// 스터디 상세 ViewModel
final class PostedStudyViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  
//  var postedStudyData: PostedStudyViewData
  
  var postDatas = BehaviorRelay<PostDetailData?>(value: nil)
//  var commentDatas = PublishRelay<[CommentConetent]>()
//  var relatedPostDatas = BehaviorRelay<[RelatedPost]>(value: [])
//  
//  var countComment = PublishRelay<Int>()
//  var countRelatedPost = BehaviorRelay<Int>(value: 0)
//  var commentTextFieldValue = BehaviorRelay<String>(value: "")
//  let dataFromPopupView = PublishRelay<PopupActionType>()
//  var singlePostData = PublishRelay<PostDetailData>()
//  
//  var postOrCommentID: Int = 0
//  var userNickanme: String = ""
//  
//  var isBookmarked = BehaviorRelay<Bool>(value: false)
//  var isMyPost = PublishRelay<Bool>()
//  var isNeedFetch: PublishRelay<Bool>?
//  var isActivateParticipate = PublishRelay<Bool>()
//  var isUserLogined: Bool
//  
//  var showToastMessage = PublishRelay<String>()
//  var showBottomSheet = PublishRelay<Int>()
//  var moveToCommentVC = PublishRelay<CommentViewController>()
//  var moveToLoginVC = PublishRelay<Bool>()
//  var moveToParticipateVC = PublishRelay<Int>()
//  
  init(with postID: Int) {
    
//    let postedData = postedStudyData.postDetailData
//    postDatas.accept(postedData)
//    isMyPost.accept(postedData.usersPost)
//    relatedPostDatas.accept(postedData.relatedPost)
//    isBookmarked.accept(postedData.bookmarked)

//    isNeedFetch = data.isNeedFechData
//    isUserLogined = data.isUserLogin
//    
    
//    getUserInfo()
//    fetchCommentDatas()
//    countRelatedPosts()
//
    fetchStudyDeatilData(with: postID)
    
  }

  
  /// 스터디 데이터 가져오기
  func fetchStudyDeatilData(with postID: Int){
    Task {
      let postedData: PostDetailData = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
      print(postedData)
      postDatas.accept(postedData)
    }
  }
  
  func countRelatedPosts(){
//    guard let count = postDatas.value?.relatedPost.filter({ $0.title != nil }).count else { return }
//    countRelatedPost.accept(count)
  }
  
  
  /// 댓글 가져오기
  func fetchCommentDatas(){
//    guard let postID = postDatas.value?.postID else { return }
//    detailPostDataManager.getCommentPreview(postId: postID) { [weak self] comments in
//      self?.commentDatas.accept(comments)
//      
//      let commentCount = comments.filter { $0.commentID != nil }.count
//      self?.countComment.accept(commentCount)
//    }
  }
  
  
  /// 사용자 정보 가져오기
  func getUserInfo(){
//    userInfoManager.getUserInfo {
//      guard let nickname = $0?.nickname else { return }
//      self.userNickanme = nickname
//    }
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
