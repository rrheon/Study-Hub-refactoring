//
//  ToStudyHubNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//


import Foundation

import Moya

/// 이메일관련 네트워킹
enum ToStudyHubNetworking{
  case getNotice(page: Int, size: Int)                    // 공지사항
  case inquiryQuestion(content: InquiryQuestionDTO)       // 문의하기
}

extension ToStudyHubNetworking: TargetType, CommonBaseURL {
  
  /// API 별 요청 path
  var path: String {
    switch self {
    case .inquiryQuestion(_):               return "/v1/email/question"
      //공지사항 이용약관조회랑 묶기
    case .getNotice(page: let page, size: let size):
      return ""
    }
  }
  
  
  /// API 별 메소드
  var method: Moya.Method {
    return .post
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .inquiryQuestion(let content):
      return .requestJSONEncodable(content)
    case .getNotice(page: let page, size: let size):
      return .requestPlain
    }
  
  }
  
  
  /// API 별 헤더
  var headers: [String : String]? {
    return ["Content-type": "application/json"]

    
  }
  
  
  
}
