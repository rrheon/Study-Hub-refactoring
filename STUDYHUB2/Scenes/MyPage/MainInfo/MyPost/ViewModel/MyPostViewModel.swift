
import Foundation

import RxSwift
import RxFlow
import RxRelay

enum PostCountUpdate {
  case PLUS
  case MINUS
}


/// 내가 작성한 스터디 포스트 ViewModel
final class MyPostViewModel: EditUserInfoViewModel, Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  let disposeBag: DisposeBag = DisposeBag()

  var selectedPostID: Int? = nil

  /// 내가 작성한 게시글 전체 데이터
  let myPostData = BehaviorRelay<[MyPostcontent]>(value: [])
  
  /// 내가 작성한 게시글 개별 데이터
  let postDetailData = BehaviorRelay<PostDetailData?>(value: nil)
  
  let updateMyPostData = BehaviorRelay<PostDetailData?>(value: nil)
  
  var totalCount: Int = 0
  
  /// 스터디 무한스크롤 여부
  /// true = 마지막 , false = 더 있음
  var isInfiniteScroll: Bool = true
  
  /// 북마크 페이지
  var myPostPage: Int = 0
    
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
    getMyPostData()
  }
  
  // MARK: - 내가쓴 포스트 데이터 가져오기
  
  
  /// 내가 작성한 스터디 데이터 가져오기
  /// - Parameters:
  ///   - page: 페이지
  ///   - size: 사이즈
  func getMyPostData(size: Int = 5) {
    StudyPostManager.shared.searchMyPostWithRx(page: myPostPage, size: size)
      .subscribe(onNext: { [weak self] postData in
        var currentDatas = self?.myPostData.value ?? []
        
        if self?.myPostPage == 0 {
          currentDatas = postData.posts.myPostcontent
        }else{
          var newData = postData.posts.myPostcontent
          currentDatas.append(contentsOf: newData)
        }
        self?.myPostData.accept(currentDatas)
        self?.myPostPage += 1
        self?.isInfiniteScroll = postData.posts.last
        self?.totalCount = postData.totalCount
      })
      .disposed(by: disposeBag)
    
//    StudyPostManager.shared.searchMyPost(page: myPostPage, size: size) { data in
//      var currentDatas = self.myPostData.value
//      
//      if self.myPostPage == 0 {
//        currentDatas = data.posts.myPostcontent
//      }else{
//        var newData = data.posts.myPostcontent
//        currentDatas.append(contentsOf: newData)
//      }
//      self.myPostData.accept(currentDatas)
//      self.myPostPage += 1
//      self.isInfiniteScroll = data.posts.last
//      self.totalCount = data.totalCount
//    }
  }

  
  /// 내가 작성한 스터디 수정하기
  /// - Parameter postID: 스터디 postID
  func modifyMyPostBtnTapped(postID: Int){
    StudyPostManager.shared.searchSinglePostDataWithRx(postId: postID)
      .subscribe(onNext: { [weak self] postData in
        self?.steps.accept(AppStep.navigation(.dismissCurrentScreen))
        self?.steps.accept(AppStep.studyManagement(.studyFormScreenIsRequired(data: postData)))
      })
      .disposed(by: disposeBag)
//    Task {
//      let data = try await StudyPostManager.shared.searchSinglePostData(postId: postID)
//      
//      steps.accept(AppStep.navigation(.dismissCurrentScreen))
//      steps.accept(AppStep.studyManagement(.studyFormScreenIsRequired(data: data)))
//    }
  }



  /// 내가 작성한 스터디 마감처리
  /// - Parameter postID: postID
  func closeMyPost(_ postID: Int){
    StudyPostManager.shared.closePostWithRx(with: postID)
      .subscribe(onNext: { [weak self] isClosed in
        self?.updateClosePost(postID: postID)
      })
      .disposed(by: disposeBag)
//    StudyPostManager.shared.closePost(with: postID) { reulst in
//      self.updateClosePost(postID: postID)
//    }
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
    StudyPostManager.shared.deletePostWithRx(with: postID)
      .subscribe(onNext: { [weak self] isDeleted in
        guard let self = self, isDeleted else { return }

        // 사용자 데이터 업데이트
        let newCount = self.updateMyPostCount(mode: .MINUS)
          
        updateUserData(postCount: newCount)
        
        // 게시글 목록 갱신
        var currentPosts = self.myPostData.value
        currentPosts.removeAll { $0.postID == postID }
        self.myPostData.accept(currentPosts)

      }, onError: { error in
        ToastPopupManager.shared.showToast(message: "게시글 삭제에 실패했습니다.", alertCheck: false)
      })
      .disposed(by: disposeBag)

//    StudyPostManager.shared.deletePost(with: postID) { result in
//      super.updateUserData(postCount: self.updateMyPostCount(mode: .MINUS))
//     
//      var currentPosts = self.myPostData.value
//      currentPosts.removeAll { $0.postID == postID }
//      self.myPostData.accept(currentPosts)
//    }
  }
  
  
  /// 내가 작성한 스터디 모두 삭제
  func deleteMyAllPost(){
    StudyPostManager.shared.deleteMyAllPostWithRx()
      .subscribe(onNext: { [weak self] isDeleted in
        self?.updateUserData(postCount: 0)
        self?.myPostData.accept([])
      })
      .disposed(by: disposeBag)
//    StudyPostManager.shared.deleteMyAllPost { result in
//      super.updateUserData(postCount: 0)
//      self.myPostData.accept([])
//    }
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

