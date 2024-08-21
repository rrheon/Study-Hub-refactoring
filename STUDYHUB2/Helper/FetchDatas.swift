

import Foundation
import RxRelay

protocol PostDataFetching {
  var postDataManager: PostDataManager { get }
  var detailPostDataManager: PostDetailInfoManager { get }
  
  func fetchNewPostDatas(_ loginStatus: Bool, completion: @escaping ([Content]) -> Void)
  func fetchDeadLinePostDatas(_ loginStatus: Bool, completion: @escaping ([Content]) -> Void)
  func fetchSinglePostDatas(_ postID: Int, completion: @escaping (PostDetailData) -> Void)
}

extension PostDataFetching {
  var postDataManager: PostDataManager { 
    return PostDataManager.shared
  }
  
  var detailPostDataManager: PostDetailInfoManager {
    PostDetailInfoManager.shared
  }
  
  func fetchNewPostDatas(_ loginStatus: Bool, completion: @escaping ([Content]) -> Void) {
    postDataManager.getNewPostData(loginStatus) { datas in
      completion(datas.postDataByInquiries.content)
    }
  }
  
  func fetchDeadLinePostDatas(_ loginStatus: Bool, completion: @escaping ([Content]) -> Void) {
    postDataManager.getDeadLinePostData(loginStatus) { datas in
      completion(datas.postDataByInquiries.content)
    }
  }
  
  func fetchSinglePostDatas(_ postID: Int, completion: @escaping (PostDetailData) -> Void) {
    detailPostDataManager.searchSinglePostData(postId: postID, loginStatus: false) {
      completion($0)
    }
  }
}
