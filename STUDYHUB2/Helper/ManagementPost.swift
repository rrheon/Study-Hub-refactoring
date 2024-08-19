//
//  CreatePost.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/18/24.
//

import UIKit

protocol ManagementPost {
  var postManagementNetworking: PostManager { get }
}

extension ManagementPost {
  var postManagementNetworking: PostManager {
    return PostManager.shared
  }
}

protocol CreatePost: ManagementPost {
  
}

protocol ModifyPost: ManagementPost {
  func showModifyView(vc: UIViewController)
  func modifyMyPost(_ data: UpdateStudyRequest, completion: @escaping (Bool) -> Void)
}

extension ModifyPost {
  func showModifyView(vc: UIViewController){
    let modifyVC = CreateStudyViewController()
    
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
