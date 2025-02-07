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

struct UserData: Codable {
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

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class InfoManager {
  
  let tokenManager = TokenManager.shared
  static let shared = InfoManager()
  private init() {}
  
  typealias NetworkCompletion = (Result<UserData, NetworkError>) -> Void
  
  // 네트워킹 요청하는 함수
  func fetchUser(completion: @escaping NetworkCompletion) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "study-hub.site"
    urlComponents.port = 443
    urlComponents.path = "/api/users"

    guard var token = tokenManager.loadAccessToken() else { return }
    
    guard let urlString = urlComponents.url?.absoluteString else {
      print("Invalid URL")
      completion(.failure(.networkingError))
      return
    }
    getMethod(with: urlString, token: token, completion: completion)
  }
  
  private func getMethod(with urlString: String, token: String, completion: @escaping NetworkCompletion) {
    guard let url = URL(string: urlString) else {
      print("Invalid URL")
      completion(.failure(.networkingError))
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("\(token)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Networking Error:", error)
        completion(.failure(.networkingError))
        return
      }
      
      guard let safeData = data else {
        print("No Data")
        completion(.failure(.dataError))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid Response")
        completion(.failure(.networkingError))
        return
      }
      
      print("Response Status Code:", httpResponse.statusCode)
      
      do {
        let decoder = JSONDecoder()
        let userData = try decoder.decode(UserData.self, from: safeData)
        completion(.success(userData))
      } catch {
        print("JSON Parsing Error:", error)
        completion(.failure(.parseError))
      }
    }.resume()
  }
}
