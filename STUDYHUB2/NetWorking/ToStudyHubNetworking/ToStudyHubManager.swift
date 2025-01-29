//
//  ToStudyHubManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//

import Foundation

import Moya

/// 이메일 관련 네트워킹
class ToStudyHubManager: StudyHubCommonNetworking {
  static let shared = ToStudyHubManager()
  
  let provider = MoyaProvider<ToStudyHubNetworking>()
  
  /// 서버에 문의하기
  /// - Parameter content: 문의할 내용
  func inquiryToServer(with content: InquiryQuestionDTO){
    provider.request(.inquiryQuestion(content: content)) { result in
      switch result {
      case .success(let response):
        return
      case .failure(let response):
        print(response.response)
      }
    }
  }
}
