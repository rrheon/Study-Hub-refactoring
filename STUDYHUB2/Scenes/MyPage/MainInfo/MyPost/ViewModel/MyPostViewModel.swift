
import Foundation

import RxFlow
import RxRelay

enum PostCountUpdate {
  case PLUS
  case MINUS
}


/// 내가 작성한 스터디 포스트 ViewModel
final class MyPostViewModel: EditUserInfoViewModel, Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  var selectedPostID: Int? = nil

  /// 내가 작성한 게시글 전체 데이터
  let myPostData = BehaviorRelay<[MyPostcontent]>(value: [])
  
  /// 내가 작성한 게시글 개별 데이터
  let postDetailData = BehaviorRelay<PostDetailData?>(value: nil)
  
  let updateMyPostData = BehaviorRelay<PostDetailData?>(value: nil)
  
  var isValidScroll: Bool = false
  
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
    getMyPostData()
  }
  
  // MARK: - 내가쓴 포스트 데이터 가져오기
  
  
  /// 내가 작성한 스터디 데이터 가져오기
  /// - Parameters:
  ///   - page: 페이지
  ///   - size: 사이즈
  func getMyPostData(page: Int = 0, size: Int = 5) {
    StudyPostManager.shared.searchMyPost(page: page, size: size) { data in
      self.myPostData.accept( data.posts.myPostcontent)
    }
  }
  
  
  /// 내가 작성한 스터디 수정하기
  /// - Parameter postID: 스터디 postID
  func modifyMyPostBtnTapped(postID: Int){
    Task {
      let data = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
      
      steps.accept(AppStep.dismissCurrentScreen)
      steps.accept(AppStep.studyFormScreenIsRequired(data: data))
    }
  }



  /// 내가 작성한 스터디 마감처리
  /// - Parameter postID: postID
  func closeMyPost(_ postID: Int){
    StudyPostManager.shared.closePost(with: postID) { reulst in
      self.updateClosePost(postID: postID)
    }
  }
  
  
  /// 마감처리 된 스터디 데이터 업데이트
  /// - Parameter postID: 마감처리 된 스터디의 PostID
  func updateClosePost(postID: Int) {
    var currentData = myPostData.value
    
    if let index = currentData.firstIndex(where: { $0.postID == postID }) {
      currentData[index].close = true
    }
    
    myPostData.accept(currentData)
  }
  
  // MARK: - Delete post
  
  
  /// 내가 작성한 게시글 갯수 업데이트
  /// - Parameter mode:갯수 증가 / 감소
  func updateMyPostCount(mode: PostCountUpdate) -> Int {
    guard var postCount = userData.value?.postCount else { return 0 }
    switch mode {
    case .PLUS:
        postCount += 1
    case .MINUS:
        postCount = max(postCount - 1, 0)
    }
    return postCount
  }
  
  
  
  /// 내가 작성한 스터디 삭제
  /// - Parameter postID: postID
  func deleteMySinglePost(_ postID: Int){
    StudyPostManager.shared.deletePost(with: postID) { result in
      super.updateUserData(postCount: self.updateMyPostCount(mode: .MINUS))
     
      var currentPosts = self.myPostData.value
      currentPosts.removeAll { $0.postID == postID }
      self.myPostData.accept(currentPosts)
    }
  }
  
  
  /// 내가 작성한 스터디 모두 삭제
  func deleteMyAllPost(){
    StudyPostManager.shared.deleteMyAllPost { result in
      super.updateUserData(postCount: 0)
      self.myPostData.accept([])
    }
  }
  
  
  func updateMyPost(postData: PostDetailData, addPost: Bool = false) {
    var currentData = myPostData.value
    
    if let index = currentData.firstIndex(where: { $0.postID == postData.postId }) {
      currentData.remove(at: index)
    }
    
    let newPost = MyPostcontent(
      close: postData.close,
      content: postData.content,
      major: postData.major,
      postID: postData.postId,
      remainingSeat: postData.remainingSeat,
      studyId: postData.studyId,
      title: postData.title
    )
    currentData.append(newPost)
    
    myPostData.accept(currentData)
    
    if addPost {
      super.updateUserData(postCount: self.updateMyPostCount(mode: .PLUS))
    }
  }
  
}

