//
//  EditUserInfoManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/12/28.
//

import Foundation

struct StoreImage: Codable {
  let image: String
}

struct DuplicationResponse: Codable {
  let status: String
  let message: String
}

struct EditNickName: Codable {
  let nickname: String
}

struct EditMajor: Codable {
  let major: String
}

struct EditPassword: Codable {
  let auth: Bool
  let password: String
}

struct VerifyPassword: Codable {
  let password: String
}

struct VerifyEmail: Codable {
  let authCode: String
  let email: String
}

struct CheckEmailDuplication: Codable {
  let email: String
}

final class EditUserInfoManager {
  static let shared = EditUserInfoManager()
  let networkingManager = Networking.networkinhShared
  let tokenManager = TokenManager.shared
  
  private init() {}
  
  // MARK: - 닉네임 중복확인
  func checkNicknameDuplication(nickName: String, completion: @escaping (String) -> Void) {
    let urlPath = "/users/duplication-nickname"
    let queryItems = [URLQueryItem(name: "nickname", value: nickName)]

    // Networking 인스턴스를 사용하여 요청을 보냅니다.
    networkingManager.fetchData(type: "GET",
                                apiVesrion: "v1",
                                urlPath: urlPath,
                                queryItems: queryItems,
                                tokenNeed: false,
                                createPostData: nil,
                                completion: { (result: Result<DuplicationResponse, NetworkError>) in
      switch result {
      case .success(let response):
        completion(response.status)
      case .failure(let error):
        // 에러 발생 시 처리
        print("Error: \(error)")
        completion("Error")
      }
    })
  }
  

  
  // MARK: - 사용자 프로필 이미지 저장
  func storeUserProfile(imageWithString: String) -> Void{
    let storeImage = StoreImage(image: imageWithString)
//    networkingManager.fetchData(type: "PUT",
//                                urlPath: "/users/image",
//                                queryItems: nil,
//                                tokenNeed: true,
//                                createPostData: storeImage) { (result: Result<Response,
//                                                               NetworkError>) in
//      switch result {
//      case .success(let data):
//        print("프로필 이미지 변경완료")
//        print(data.status)
//        print(data.image)
//      case .failure(let error):
//        print("프로필 이미지 변경 실패: \(error)")
//      }
//
//    }
    let url = URL(string: "https://study-hub.site:443/api/v1/users/image")!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    guard let token = tokenManager.loadAccessToken() else { return }
    request.setValue("\(token)", forHTTPHeaderField: "Authorization")
    
    guard let uploadData = try? JSONEncoder().encode(storeImage) else { return }
    request.httpBody = uploadData
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      // 에러 처리
      if let error = error {
        print("요청 실패: \(error)")
        return
      }
      
      // 데이터 처리
      if let data = data {
        let str = String(data: data, encoding: .utf8)
        print("응답 문자열: \(str ?? "")")
      }
    }
    task.resume()

  }
}
  
