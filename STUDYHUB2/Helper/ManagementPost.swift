//
//  CreatePost.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/18/24.
//

import UIKit

protocol ManagementPost: CommonNetworkingProtocol {
  var postManagementNetworking: PostManager { get }
}

extension ManagementPost {
  var postManagementNetworking: PostManager {
    return PostManager.shared
  }
}

protocol CreatePost: ManagementPost {
  func createPost(_ postData: CreateStudyRequest, completion: @escaping (String) -> Void)
}

extension CreatePost {
  func createPost(_ postData: CreateStudyRequest, completion: @escaping (String) -> Void) {
    commonNetworking.refreshAccessToken {
      if $0 {
        self.postManagementNetworking.createPost(createPostDatas: postData) {
          completion($0)
        }
      }
    }
  }
}

protocol ModifyPost: ManagementPost {
  func showModifyView(vc: UIViewController)
  func modifyMyPost(_ data: UpdateStudyRequest, completion: @escaping (Bool) -> Void)
}

extension ModifyPost {
  func showModifyView(vc: UIViewController){
    let modifyVC = CreateStudyViewController(mode: .PUT)
    
    vc.navigationController?.pushViewController(modifyVC, animated: true)
  }
  
  func modifyMyPost(_ data: UpdateStudyRequest, completion: @escaping (Bool) -> Void){
    postManagementNetworking.modifyPost(data: data) {
      completion($0)
    }
  }
}

protocol DeletePost: ManagementPost {
  func deleteMyPost(_ postID: Int, completion: @escaping (Bool) -> Void)
}

extension DeletePost {
  func deleteMyPost(_ postID: Int, completion: @escaping (Bool) -> Void){
    postManagementNetworking.deleteMyPost(postId: postID) {
      completion($0)
    }
  }
}

