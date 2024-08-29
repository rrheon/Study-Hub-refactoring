//
//  PostedStudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import Foundation

import RxRelay

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

final class PostedStudyViewModel: CommonViewModel {
  let detailPostDataManager = PostDetailInfoManager.shared
  let commentManager = CommentManager.shared
  let userInfoManager = UserInfoManager.shared
  
  var postedStudyData: PostedStudyViewData
  
  var postDatas = BehaviorRelay<PostDetailData?>(value: nil)
  var commentDatas = PublishRelay<[CommentConetent]>()
  var relatedPostDatas = BehaviorRelay<[RelatedPost]>(value: [])
  
  var countComment = PublishRelay<Int>()
  var countRelatedPost = BehaviorRelay<Int>(value: 0)
  var commentTextFieldValue = BehaviorRelay<String>(value: "")
  let dataFromPopupView = PublishRelay<PopupActionType>()
  var singlePostData = PublishRelay<PostDetailData>()
  
  var postOrCommentID: Int = 0
  var userNickanme: String = ""
  
  var isBookmarked = BehaviorRelay<Bool>(value: false)
  var isMyPost = PublishRelay<Bool>()
  var isNeedFetch: PublishRelay<Bool>?
  var isActivateParticipate = PublishRelay<Bool>()
  var isUserLogined: Bool
  
  init(_ data: PostedStudyViewData) {
    self.postedStudyData = data

    let postedData = postedStudyData.postDetailData
    postDatas.accept(postedData)
    isMyPost.accept(postedData.usersPost)
    relatedPostDatas.accept(postedData.relatedPost)
    isBookmarked.accept(postedData.bookmarked)

    isNeedFetch = data.isNeedFechData
    isUserLogined = data.isUserLogin
    
    super.init()
    
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
  
  func deleteMyPost(completion: @escaping () -> Void){
    guard let postID = postDatas.value?.postID else { return }
    deleteMyPost(postID) {
      self.postedStudyData.isNeedFechData?.accept($0)
      completion()
    }
  }
  
  func bookmarkToggle(){
    let toggledBookmark = isBookmarked.value ? false : true
    isBookmarked.accept(toggledBookmark)
  }
  
  func similarCellTapped(_ postID: Int){
    fetchSinglePostDatas(postID) {
      self.singlePostData.accept($0)
    }
  }
  
  func participateButtonTapped(completion: @escaping (ParticipateAction) -> Void) {
    userInfoManager.getUserInfo { [weak self] userData in
      let postedData = self?.postedStudyData.postDetailData

      if userData?.nickname == nil {
        completion(.goToLoginVC)
        return
      }
      
      if postedData?.filteredGender != userData?.gender && postedData?.filteredGender != "NULL" {
        completion(.limitedGender)
        return
      }
      
      if postedData?.close == true {
        completion(.closed)
        return
      }
      
      completion(.goToParticipateVC)
    }
  }
}

extension PostedStudyViewModel: PostDataFetching {}
extension PostedStudyViewModel: BookMarkDelegate {}
extension PostedStudyViewModel: StudyBottomSheet {}
