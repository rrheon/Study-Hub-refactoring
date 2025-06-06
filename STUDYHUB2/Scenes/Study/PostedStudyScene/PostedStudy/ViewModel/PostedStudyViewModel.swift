
import Foundation

import RxRelay
import RxSwift
import RxFlow

/// 참여하기 버튼을 탭했을 때 action들
enum ParticipateAction {
  /// 로그인이 안되어 있는 경우 -> 로그인 화면으로 이동
  case goToLoginVC
  
  /// 성별에 제한이 있는 경우
  case limitedGender
  
  /// 마감된 경우
  case closed
  
  /// 참여하기 vc로 이동
  case goToParticipateVC
}


/// 스터디 상세 ViewModel
class PostedStudyViewModel: Stepper  {
  var steps: PublishRelay<Step> = PublishRelay()
  
  
//  var postedStudyData: PostedStudyViewData
  
  var disposeBag: DisposeBag = DisposeBag()
  
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

  /// 북마크 여부
  var isBookmarked = BehaviorRelay<Bool>(value: false)

  var loginUserData: BehaviorRelay<UserDetailData?> = BehaviorRelay<UserDetailData?>(value: nil)

  var participatedAction: PublishRelay<ParticipateAction>? = nil
  
  init(with postID: Int) {
    self.postID = postID
    
//    Task {
//      await TokenManager.shared.refreshAccessTokenIfNeeded()
//    }

    UserProfileManager.shared.fetchUserInfoToServerWithRx()
      .subscribe(onNext: { userData in
        self.loginUserData.accept(userData)
        
        self.fetchStudyDeatilData(with: postID)
      },onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      }).disposed(by: disposeBag)
    
//    // 유저 정보를 못가져옴
//    UserProfileManager.shared.fetchUserInfoToServer { userData in
//      self.loginUserData.accept(userData)
//      
////      self.fetchCommentDatas(with: postID)
//      self.fetchStudyDeatilData(with: postID)
//    }
    
    checkParticipateBtnTapped()
  }
  
  
  /// 스터디 데이터 가져오기
  func fetchStudyDeatilData(with postID: Int){
    StudyPostManager.shared.searchSinglePostDataWithRx(postId: postID)
      .subscribe(onNext: { [weak self] postedData in
        self?.postDatas.accept(postedData)
        self?.isBookmarked.accept(postedData.bookmarked)
      }, onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    
//    Task {
//      let postedData: PostDetailData = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
//      postDatas.accept(postedData)
//      isBookmarked.accept(postedData.bookmarked)
//    }
  }
  
  /// 댓글 미리보기 가져오기(스터디 디테일에서 보여주는 댓글들)
  func fetchCommentDatas(with postID: Int){
    CommentManager.shared.getCommentPreviewWithRx(postId: postID)
      .subscribe(onNext: { [weak self] comments in
        self?.commentDatas.accept(comments)
      },onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      }).disposed(by: disposeBag)
//    Task {
//      let comments: [CommentConetent] = try await CommentManager.shared.getCommentPreview(postId: postID)
//      commentDatas.accept(comments)
//    }
  }
  
  
  /// 새로운 댓글 작성하기
  /// - Parameter content: 댓글 내용
  func createNewComment(with content: String){
    CommentManager.shared.createCommentWithRx(content: content, postID: postID)
      .subscribe(onNext: { [weak self] statusCode in
        guard let self = self else { return }
        if (200...299).contains(statusCode){
          self.fetchCommentDatas(with: self.postID)
          
          ToastPopupManager.shared.showToast(message: "댓글이 작성됐어요.")
        }
      }, onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      }).disposed(by: disposeBag)
//    CommentManager.shared.createComment(content: content, postID: postID) { result in
//      if result {
//        self.fetchCommentDatas(with: self.postID)
//        
//        ToastPopupManager.shared.showToast(message: "댓글이 작성됐어요.")
//      }
//    }
  }
  
  
  /// 댓글 삭제하기
  /// - Parameters:
  ///   - commentID: 댓글  ID
  func deleteComment(with commentID: Int){
    // 현재 화면 내리기
    self.steps.accept(AppStep.navigation(.dismissCurrentScreen))
    
    CommentManager.shared.deleteCommentWithRx(commentID: commentID)
      .subscribe(onNext: { [weak self] statusCode in
        guard let self = self else { return }
        if (200...299).contains(statusCode){
          var datas = self.commentDatas.value
          datas?.removeAll(where: { $0.commentID == commentID})
          
          self.commentDatas.accept(datas)
          
          ToastPopupManager.shared.showToast(message: "댓글이 삭제됐어요.")
        }
      }, onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    
//    CommentManager.shared.deleteComment(commentID: commentID) { result in
//      print("댓글 삭제 여부 - \(result)")
//      
//      // 댓글 삭제 후 데이터 수정
//      if result {
//        var datas = self.commentDatas.value
//        datas?.removeAll(where: { $0.commentID == commentID})
//        
//        self.commentDatas.accept(datas)
//        
//        ToastPopupManager.shared.showToast(message: "댓글이 삭제됐어요.")
//      }
//    }
  }
  
  /// 댓글 수정하기
  /// - Parameters:
  ///   - commentID: 댓글ID
  ///   - content: 수정할 댓글 내용
  func modifyComment(content: String) {
    guard let commentID = self.commentID else { return }
    
    CommentManager.shared.modifyCommentWithRx(content: content, commentID: commentID)
      .subscribe(onNext: { [weak self] statusCode in
        guard let self = self else { return }
        if (200...299).contains(statusCode){
          self.fetchCommentDatas(with: self.postID)
          ToastPopupManager.shared.showToast(message: "댓글 수정이 완료됐어요.")
        }
      }, onError: { err in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
    
//    CommentManager.shared.modifyComment(content: content, commentID: commentID) { result in
//      
//      if result {
//        self.fetchCommentDatas(with: self.postID)
//        ToastPopupManager.shared.showToast(message: "댓글 수정이 완료됐어요.")
//      }
//    }
  }
  
  
  /// 내 포스트 삭제하기
  func deleteMyPost(with postID: Int){
    StudyPostManager.shared.deletePostWithRx(with: postID)
      .subscribe(onNext: { [weak self] isDeleted in
        guard let self = self else { return }
          /// 현재 화면 pop
          self.steps.accept(AppStep.navigation(.popCurrentScreen(animate: false)))

          ToastPopupManager.shared.showToast(message: "삭제가 완료됐어요.")
        
      }, onError: { err in
        ToastPopupManager.shared.showToast(message: "삭제에 실패했어요. 잠시후 다시 시도해주세요.")
      })
      .disposed(by: disposeBag)
    
//    StudyPostManager.shared.deletePost(with: postID) { result in
//      if result {
//        /// 현재 화면 pop
//        self.steps.accept(AppStep.navigation(.popCurrentScreen(animate: false)))
//
//        ToastPopupManager.shared.showToast(message: "삭제가 완료됐어요.")
//      }else{
//        ToastPopupManager.shared.showToast(message: "삭제에 실패했어요. 잠시후 다시 시도해주세요.")
//      }
//    }
  }
  
  
  /// 북마크 버튼 탭
  func bookmarkBtnTapped() {
    guard let postID = postDatas.value?.postId else { return }
    
    BookmarkManager.shared.bookmarkTappedWithRx(with: postID)
      .subscribe(onNext: { [weak self] isBookmarked in
        guard let self = self else { return }
        
        var bookmark = self.isBookmarked.value
        bookmark.toggle()
        self.isBookmarked.accept(bookmark)
        
      }, onError: { err in
        ToastPopupManager.shared.showToast(message: "북마크 저장에 실패했어요. 잠시후 다시 시도해주세요.")
      })
      .disposed(by: disposeBag)
    
//    BookmarkManager.shared.bookmarkTapped(with: postID) { statusCode in
//      switch statusCode{
//      case 200:
//        var bookmark = self.isBookmarked.value
//        bookmark.toggle()
//        self.isBookmarked.accept(bookmark)
//      default: return
//      }
//    }
  }
  
  /// 스터디 참여하기 버튼 탭
  func participateBtnTapped(completion: @escaping (ParticipateAction) -> Void) {
    /*
     마감된 스터디 -> self.viewModel.showToastMessage.accept("이미 마감된 스터디예요")
     로그인이 안되어 있는 경우 -> 로그인 팝업 -> 로그인화면
     성별제한 ->  self.viewModel.showToastMessage.accept("이 스터디는 성별 제한이 있는 스터디예요")
     참여 -> 참여화면으로 이동

     */
  
    
    UserProfileManager.shared.fetchUserInfoToServer { userData in
      let postedData = self.postDatas.value
      
      /// 사용자가 로그인이 안된 경우
      if userData.nickname == nil {
        completion(.goToLoginVC)
        return
      }
      
      /// 성별 필터링
      if postedData?.filteredGender != userData.gender && postedData?.filteredGender != "NULL" {
        completion(.limitedGender)
        return
      }
      
      /// 마감 여부 확인
      if postedData?.close == true {
        completion(.closed)
        return
      }
      
      /// 참여하기 VC로 이동
      completion(.goToParticipateVC)
    }
  }
  
  func participatedBtnTapped() {
    UserProfileManager.shared.fetchUserInfoToServerWithRx()
      .map { [weak self] userData -> ParticipateAction in
        guard let self = self else { return .goToLoginVC }
        let postedData = self.postDatas.value

        /// 로그인 여부
        guard let _ = userData.nickname else { return .goToLoginVC }
        
        /// 성별 제한
        if postedData?.filteredGender != userData.gender &&
            postedData?.filteredGender != "NULL" {
          return .limitedGender
        }
        
        /// 마감 여부
        if postedData?.close == true { return .closed }
        
        /// 참여 가능
        return .goToParticipateVC
      }
      .subscribe(onNext: { action in
        self.participatedAction?.accept(action)
      }).disposed(by: disposeBag)
  }
  
  func checkParticipateBtnTapped(){
    participatedAction?
      .subscribe(onNext: { action in
        switch action {
        case .closed:
          ToastPopupManager.shared.showToast(message: "이미 마감된 스터디예요")
        case .goToLoginVC:
          NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
        case .goToParticipateVC:
//          let studyID = self.postDatas.value?.studyId
          //              self.viewModel.moveToParticipateVC.accept(studyID)
          self.steps.accept(AppStep.study(.applyStudyScreenIsRequired(data: self.postDatas)))
        case .limitedGender:
          ToastPopupManager.shared.showToast(message: "이 스터디는 성별 제한이 있는 스터디예요")
        }
      })
      .disposed(by: disposeBag)
//            self.viewModel.participateBtnTapped(completion: { action in
//              switch action {
//              case .closed:
//                ToastPopupManager.shared.showToast(message: "이미 마감된 스터디예요")
//              case .goToLoginVC:
//                NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
//              case .goToParticipateVC:
//                let studyID = self.viewModel.postDatas.value?.studyId
//                //              self.viewModel.moveToParticipateVC.accept(studyID)
//                self.viewModel.steps.accept(AppStep.study(.applyStudyScreenIsRequired(data: self.viewModel.postDatas)))
//              case .limitedGender:
//                ToastPopupManager.shared.showToast(message: "이 스터디는 성별 제한이 있는 스터디예요")
//              }
//            })
  }
}
