
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

  /// 내가 작성한 게시글 데이터
  let myPostData = BehaviorRelay<[MyPostcontent]>(value: [])
  let postDetailData = BehaviorRelay<PostDetailData?>(value: nil)
  let updateMyPostData = BehaviorRelay<PostDetailData?>(value: nil)
  var isValidScroll: Bool = false
  
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
    getMyPostData(size: 5)
  }
  
  // MARK: - 내가쓴 포스트 데이터 가져오기
  
  
  func getMyPostData(size: Int) {
    StudyPostManager.shared.searchMyPost(page: 0, size: 5) { data in
      self.myPostData.accept( data.posts.myPostcontent)
    }
  }
  
  func getPostDetailData(
    _ postID: Int,
    completion: @escaping (BehaviorRelay<PostDetailData?>) -> Void
  ){
//    self.detailPostDataManager.searchSinglePostData(
//      postId: postID,
//      loginStatus: true
//    ) { result in
//      self.postDetailData.accept(result)
//      completion(self.postDetailData)
//    }
  }
  
  func updateMyPost(postID: Int) {
    var currentData = myPostData.value
    
    if let index = currentData.firstIndex(where: { $0.postID == postID }) {
      currentData[index].close = true
    }
    
    myPostData.accept(currentData)
  }
  
  func closeMyPost(_ postID: Int){
//    self.commonNetworking.moyaNetworking(networkingChoice: .closePost(postID)) { result in
//      switch result {
//      case .success(let response):
//        print(response.response)
//        if response.statusCode == 200 {
//          self.updateMyPost(postID: postID)
//        }
//      case .failure(let response):
//        print(response.response)
//      }
//    }
  }
  
  // MARK: - Delete post
  
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
  
  func removePost(withId postID: Int) {
    var currentPosts = myPostData.value
    currentPosts.removeAll { $0.postID == postID }
    myPostData.accept(currentPosts)
  }
  
  func deleteMySinglePost(_ postID: Int){
//    deleteMyPost(postID) { result in
//      if result {
//        super.updateUserData(postCount: self.updateMyPostCount(mode: .MINUS))
//        self.removePost(withId: postID)
//      }
//    }
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

