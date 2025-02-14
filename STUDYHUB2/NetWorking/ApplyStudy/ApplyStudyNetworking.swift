//
//  ApplyStudyNetworking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/28/25.
//

import Foundation

import Moya


/// 스터디 신청 관련 네트워킹
enum ApplyStudyNetworking {
  case participateStudy(introduce: String, studyId: Int)        // 스터디 참여하기
  case getMyParticipateList(page: Int, size: Int)               // 참여한 스터디의 리스트 가져오기
  case getMyReqeustList(page: Int, size: Int)                   // 신청한 스터디 목록 가져오기
  case deleteMyRequest(studyId:Int)                             // 나의 신청 삭제하기
  case searchParticipateInfo(data: StudyApplyUserInfos)        // 참여 목록 가져오기
  case acceptParticipate(acceptPersonData: AcceptStudy)        // 참여 수락하기
  case rejectParticipate(rejectPersonData: RejectStudy)        // 참여 거절하기
  case getRejectReason(_ studyId: Int)                         // 스터디 거절사유 가져오기
}

extension ApplyStudyNetworking: TargetType, CommonBaseURL {
  
  /// API 별 요청 path
  var path: String {
    switch self{
      
    case .participateStudy(_, _):         return "/v1/study"
    case .getMyParticipateList(_, _):     return "/v1/participated-study"
    case .searchParticipateInfo(_):       return "/v2/study"
    case .acceptParticipate(_):           return "/v1/study-accept"
    case .rejectParticipate(_):           return "/v1/study-reject"
    case .getMyReqeustList(_,  _):        return "/v1/study-request"
    case .deleteMyRequest(let studyId):   return "/v1/study/\(studyId)"
    case .getRejectReason(_):             return "/v1/reject"
    }
  }
  
  
  /// API 별 method
  var method: Moya.Method {
    switch self{
    case .participateStudy(_, _):
      return .post
      
    case .acceptParticipate(_),
        .rejectParticipate(_):
      return .put
      
    case .deleteMyRequest(_):
        return .delete
      
    default:
      return .get
    }
  }
  
  
  /// API 별 요청
  var task: Moya.Task {
    switch self {
    case .participateStudy(let introduce, let studyId):
      let params: [String: Any] = ["introduce": introduce, "studyId": studyId]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .searchParticipateInfo(let data):
      let params: [String: Any] = [
        "inspection": data.inspection,
        "page": data.page,
        "size": data.size,
        "studyId": data.studyId
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .acceptParticipate(let acceptData):
      return .requestJSONEncodable(acceptData)
      
    case .getRejectReason(let studyId):
      let params: [String: Any] = ["studyId": studyId]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .rejectParticipate(let rejectData):
      return .requestJSONEncodable(rejectData)
      
    case .getMyReqeustList(let page, let size):
      let params: [String: Any] = ["page": page, "size": size]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    default:
      return .requestPlain
    }
  }
  
  /// API 별 헤더설정
  var headers: [String : String]? {
    switch self {
    case .getMyParticipateList(_, _),
        .participateStudy(_, _),
        .acceptParticipate(_),
        .rejectParticipate(_),
        .getRejectReason(_),
        .getMyReqeustList(_, _):
      return ["Content-type": "application/json",
              "Authorization": ""]
      
    case .deleteMyRequest(_):
      return [ "Authorization": ""]

    default:
      return ["Content-type": "application/json"]
    }

  }
  
  
}
