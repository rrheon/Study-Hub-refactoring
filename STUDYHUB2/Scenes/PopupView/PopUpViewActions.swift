//
//  PopUpViewActions.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/20/24.
//

import Foundation

enum PopupActionType {
  case editPost
  case deletePost
  case editComment
  case deleteComment
}
//
//protocol PopupActionHandler: StudyBottomSheet {
//  var commentManager: CommentManager { get }
//  func handlePopupAction(
//    action: PopupActionType,
//    postID: Int,
//    completion: @escaping (Bool) -> Void
//  )
//}
//
//extension PopupActionHandler {
//  var commentManager: CommentManager {
//    return CommentManager.shared
//  }
//  
//  func handlePopupAction(
//    action: PopupActionType,
//    postID: Int,
//    completion: @escaping (Bool) -> Void
//  ){
//    switch action {
//    case .deletePost:
//      deleteMyPost(postID){
//        completion($0)
//      }
//     
//    case .editPost:
//     completion(true)
//      
//    case .deleteComment:
//      commentManager.deleteComment(commentID: postID) {
//        completion($0)
//      }
//  
//    case .editComment:
//      completion(true)
//    }
//  }
//}
