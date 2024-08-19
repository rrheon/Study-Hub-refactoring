//
//  ManagementBookmark.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/18/24.
//

import Foundation

protocol BookMarkDelegate: CommonNetworkingProtocol {
  func bookmarkTapped(postId: Int)
}

extension BookMarkDelegate {
  func bookmarkTapped(postId: Int){
    commonNetworking.moyaNetworking(
      networkingChoice: .changeBookMarkStatus(postId), needCheckToken: true
    ) {
      let statusCode = $0.map { $0.statusCode }
      // 코드 받아서 예외처리
      print(statusCode)
    }
  }
}
