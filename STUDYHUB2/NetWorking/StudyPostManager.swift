//
//  StudyPostManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/23/25.
//

import Foundation

import Moya


/// 스터디 게시물 네트워킹 Manager
class StudyPostManager {
  static let service = MoyaProvider<StudyPostNetworking>()
  
#warning("에러처리 해야함")
  /*
   1. 에러타입 정의
   2. moya에서 공통으로 에러처리
   3. 사용자에게 에러표시
   4. 재시도 로직 구현
   */
  
  /// 모든 스터디 게시글 조회하기
  /// - Parameters:
  ///   - hot: true - 인기순, false - 인기순 x
  ///   - titleAndMajor: true - 제목만 일치, false 학과만 일치
  ///   - page: 페이지
  ///   - size: 가져올 갯수
  class func searchAllPost(hot: String = "false",
                           titleAndMajor: String = "false",
                           page: Int,
                           size: Int){
    
    let data: SearchAllPostDTO = SearchAllPostDTO(hot: hot,
                                                  titleAndMajor: titleAndMajor,
                                                  page: page,
                                                  size: size)
    
    service.request(.searchAllPost(searchData: data)) { result in
    
      switch result{
      case .success(let response):
        do {
          print(response.statusCode)
          let postDatas = try JSONDecoder().decode(PostDataContent.self, from: response.data)
          print(postDatas)
        } catch(let err) {
          print(err.localizedDescription)
          print(err)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
      
    }
  }
}
