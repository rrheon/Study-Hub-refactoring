//
//  InfoManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/14.
//

import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
  case networkingError
  case dataError
  case parseError
}

struct UserDetailData: Codable {
  var bookmarkCount: Int?
  var email, gender, imageURL, major: String?
  var nickname: String?
  var participateCount, postCount: Int?
  
  enum CodingKeys: String, CodingKey {
    case bookmarkCount, email, gender
    case imageURL = "imageUrl"
    case major, nickname, participateCount, postCount
  }
}

//MARK: - 사용자의 정보 가져오는 클래스
final class UserInfoManager {
  
  static let shared = UserInfoManager()
  let networkingManager = Networking.networkinhShared
  private init() {}
  
  private var userData: UserDetailData?
  
  func getUserInfo() -> UserDetailData? {
    guard let data = userData else { return nil}
    return data
  }

  func fetchUserInfo(completion: @escaping () -> Void){
    networkingManager.fetchData(type: "GET",
                                apiVesrion: "v1",
                                urlPath: "/users",
                                queryItems: nil,
                                tokenNeed: true,
                                createPostData: nil) { (result: Result<UserDetailData,
                                                        NetworkError>) in
      switch result {
      case .success(let userData):
        // 사용자 정보를 사용하여 원하는 작업을 수행합니다.
        print("Email: \(userData.email)")
        print("Gender: \(userData.gender)")
        print(userData.imageURL)
        
        if userData.email != nil {
          self.userData = userData
        }
        
        completion()
        
      case .failure(let error):
        // 네트워크 오류 또는 데이터 파싱 오류를 처리합니다.
        print("Error: \(error)")
      }
    }
  }
}
