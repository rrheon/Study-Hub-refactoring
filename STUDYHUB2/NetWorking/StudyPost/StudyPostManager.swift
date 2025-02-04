//
//  StudyPostManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/23/25.
//

import Foundation

import Moya

/// 스터디 게시물 네트워킹 Manager
class StudyPostManager: StudyHubCommonNetworking {
  static let shared = StudyPostManager()
  
  let provider = MoyaProvider<StudyPostNetworking>()
#warning("네트워킹 전 토큰 확인하고 해야하는 것들 체크해야함 -> 애초에 함수에서 토큰을 메게변수로 받으면 안되나?")
  /// 모든 스터디 게시글 조회하기
  /// - Parameters:
  ///   - hot: true - 인기순, false - 인기순 x
  ///   - titleAndMajor: true - 제목만 일치, false 학과만 일치
  ///   - page: 페이지
  ///   - size: 가져올 갯수
  func searchAllPost(hot: String = "false",
                     titleAndMajor: String = "false",
                     page: Int,
                     size: Int){
    
    let data: SearchAllPostDTO = SearchAllPostDTO(hot: hot,
                                                  titleAndMajor: titleAndMajor,
                                                  page: page,
                                                  size: size)
    
    provider.request(.searchAllPost(searchData: data)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: PostDataContent.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  
  /// 게시글 단건 조회하기
  /// - Parameters:
  ///   - postId: 게시글의 PostId
  ///   - completion: API 처리 후 전달
  func searchSinglePostData(postId: Int, completion: @escaping (PostDetailData) -> Void){
    provider.request(.searchSinglePost(postId: postId)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: PostDetailData.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  
  /// 내가 작성한 게시글 조회하기
  /// - Parameters:
  ///   - page: 게시글 페이지
  ///   - size: 게시글 갯수
  func searchMyPost(page: Int, size: Int){
    provider.request(.searchMyPost(page: page, size: size)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: MyPostData.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  
  /// 북마크 리스트 가져오기
  /// - Parameters:
  ///   - page: 북마크 페이지
  ///   - size: 북마크 갯수
  func searchMyBookmarkList(page: Int, size: Int){
    provider.request(.searchBookmarkList(page: page, size: size)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: BookmarkDatas.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  
  /// 스터디 생성
  /// - Parameter data: 스터디 관련 데이터
  func createNewPost(with data: CreateStudyRequest){
    provider.request(.createNewPost(newData: data)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: CreateStudyRequest.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  
  /// 스터디 삭제
  /// - Parameter postId: 삭제할 스터디의 postId
  func deletePost(with postId: Int){
    provider.request(.deletePost(postId: postId)) { result in
      switch result {
      case .success(_): print("삭제 완")
      case .failure(_): print("삭제 실패")
      }
    }
  }
  
  
  /// 스터디 수정
  /// - Parameter data: 수정할 스터디 데이터
  func modifyPost(with data: UpdateStudyRequest){
    provider.request(.modifyPost(modifiedData: data)) { result in
      switch result {
      case .success(_): print("수정 완")
      case .failure(_): print("수정 실패")
      }
    }
  }
  
  
  /// 작성한 스터디 마감하기
  /// - Parameter postId: 마감할 postId
  func closePost(with postId: Int){
    provider.request(.closePost(postId: postId)) { result in
      switch result {
      case .success(_): print("마감 완료")
      case .failure(_): print("마감 실패")
      }
    }
  }
  
  
  /// 검색어 추천
  /// - Parameter keyword: 검색어
  func searchRecommend(with keyword: String){
    provider.request(.recommendSearch(keyword: keyword)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: RecommendList.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  /// 작성한 모든 게시글 삭제
  func deleteMyAllPost(){
    provider.request(.deleteAllPost) { result in
      switch result {
      case .success(_): print("삭제 완료")
      case .failure(_): print("삭제 실패")
      }
    }
  }
}
