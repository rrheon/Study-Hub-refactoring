//
//  MyPostViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/26/24.
//

import Foundation

import RxRelay

final class MyPostViewModel: EditUserInfoViewModel {
  private let myPostDataManager = MyPostInfoManager.shared
  private let detailPostDataManager = PostDetailInfoManager.shared
  
  let myPostData = BehaviorRelay<[MyPostcontent]>(value: [])
  let postDetailData = PublishRelay<PostDetailData>()
  
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
    getMyPostData(size: 5)
  }
  
  // MARK: - 내가쓴 포스트 데이터 가져오기
  
  
  func getMyPostData(size: Int) {
    self.myPostDataManager.fetchMyPostInfo(page: 0, size: size) { [weak self] result in
      guard let data = result else { return }
      self?.myPostData.accept(data)
    }
  }
  
  func getPostDetailData(_ postID: Int){
    self.detailPostDataManager.searchSinglePostData(
      postId: postID,
      loginStatus: true
    ) { result in
      self.postDetailData.accept(result)
      //        postedVC.postedData = cellData
      
      //      guard let postDatas = cellData else { return }
      //      let postedData = PostedStudyData(isUserLogin: true, postDetailData: postDatas)
      //      let postedVC = PostedStudyViewController(postedData)
      //
      //      self.navigationController?.pushViewController(postedVC, animated: true)
    }
  }
  
  // 데이터리로드 ->해당 post 마감하면 해당 postid찾아서 데이터만 바꿔주면 될듯
  func closeMyPost(_ postID: Int){
    self.commonNetworking.moyaNetworking(networkingChoice: .closePost(postID)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        if response.statusCode == 200 {
          self.getMyPostData(size: 5)
          //          self.dismiss(animated: true)
        }
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  func deleteMySinglePost(_ postID: Int){
    guard let postCount = userData.value?.postCount else { return }
    let newPostCount = postCount - 1
    deleteMyPost(postID) { result in
      if result {
        super.updateUserData(postCount: newPostCount)
      }
    }
  }
  
  func deleteMyAllPost(){
    commonNetworking.moyaNetworking(networkingChoice: .deleteMyAllPost) { result in
      print(result)
      super.updateUserData(postCount: 0)
    }
  }
}

extension MyPostViewModel: DeletePost {}
