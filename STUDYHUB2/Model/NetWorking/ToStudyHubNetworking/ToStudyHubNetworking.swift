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
    case .inquiryQuestion(_):    return "/v1/email/question"
    case .getNotice(_, _):       return "/v1/announce"
    }
  }
  
  
  /// API 별 메소드
  var method: Moya.Method {
    switch self {
    case .inquiryQuestion(_):     return .post
    case .getNotice(_, _):        return .get
    }
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .inquiryQuestion(let content):
      return .requestJSONEncodable(content)
    case .getNotice(let page, let size):
      let params: [String: Any] = ["page": page, "size": size]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
  
  }
  
  
  /// API 별 헤더
  var headers: [String : String]? {
    return ["Content-type": "application/json"]

    
  }
  
  
  
}
