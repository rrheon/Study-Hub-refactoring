//
//  File.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import UIKit

import Moya

struct AccessTokenResponse: Codable {
  let accessToken: String
  let refreshToken: String
}

class LoginManager: UIViewController {
  
  let tokenManager = TokenManager.shared
  static let shared = LoginManager()
  
  func moyaNetworking(networkingChoice: networkingAPI,
                      completion: @escaping (Result<Response, MoyaError>) -> Void) {
    let provider = MoyaProvider<networkingAPI>()
    provider.request(networkingChoice) { result in
      completion(result)
    }
  }
  
  func refreshAccessToken(completion: @escaping (Bool) -> Void) {
    guard let refreshToken = tokenManager.loadRefreshToken() else {
      completion(false)
      return
    }
    moyaNetworking(networkingChoice: .refreshAccessToken(refreshToken)) { result in
      switch result {
      case .success(let response):
        do {
          if response.statusCode == 200 {
            let refreshResult = try JSONDecoder().decode(AccessTokenResponse.self,
                                                         from: response.data)
            self.tokenManager.deleteTokens()
            
            let saveResult = self.tokenManager.saveTokens(accessToken: refreshResult.accessToken,
                                                          refreshToken: refreshResult.refreshToken)
            completion(saveResult)
          }
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  
  func autoLogin() {
    guard let autoLoginURL = URL(string: "https://study-hub.site:443/api/v1/jwt/accessToken") else {
      return
    }
    
    guard let refreshToken = tokenManager.loadRefreshToken() else {
      return
    }
    
    let tokenData: [String: Any] = [
      "refreshToken": refreshToken
    ]
    
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: tokenData, options: [])
      // Create a URLRequest with the login URL
      var request = URLRequest(url: autoLoginURL)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = jsonData
      
      // Create a URLSessionDataTask to perform the request
      let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        // Handle the response
        if let response = response as? HTTPURLResponse {
          switch response.statusCode {
          case 200:
            // Login successful
            if let data = data {
              do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                  if let data = json["data"] as? [String: Any],
                     let accessToken = data["accessToken"] as? String,
                     let refreshToken = data["refreshToken"] as? String {
                    // Store the access token in Keychain
                    print("refresh: " + refreshToken)
                    print("access: " + accessToken)
                  }
                }
              } catch {
                // Handle JSON parsing error
                print("JSON Parsing Error: \(error)")
              }
            }
          case 401:
            // Token expired
            print("토큰이 만료되었습니다.")
          default:
            // Handle other status codes
            print("통신 실패 - 상태 코드: \(response.statusCode)")
          }
        } else if let error = error {
          // Handle network error
          print("네트워크 에러: \(error.localizedDescription)")
        }
      }
      
      // Start the URLSessionDataTask
      task.resume()
      
    } catch {
      // Handle JSON serialization error
      print("JSON Serialization Error: \(error)")
    }
  }
  
  
  func login(email: String,
             password: String,
             completion: @escaping (Bool) -> Void){
    guard let loginURL = URL(string: "https://study-hub.site:443/api/v1/users/login") else {
      return
    }
    
    // Create a dictionary to represent the login data
    let loginData: [String: Any] = [
      "email": email,
      "password": password
    ]
    
    // Convert the loginData dictionary to JSON data
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: loginData, options: [])
      
      // Create a URLRequest with the login URL
      var request = URLRequest(url: loginURL)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = jsonData
      
      // Create a URLSessionDataTask to perform the request
      let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
        // Handle the response
        if let data = data,
           let response = response as? HTTPURLResponse,
           response.statusCode == 200 {
          
          do {
            let decoder = JSONDecoder()
            let accessTokenResponse = try decoder.decode(AccessTokenResponse.self, from: data)
            
            self?.tokenManager.deleteTokens()
            guard let loginResult = self?.tokenManager.saveTokens(
              accessToken: accessTokenResponse.accessToken,
              refreshToken: accessTokenResponse.refreshToken) else { return }
                    
            completion(loginResult)
          } catch {
            print("JSON Decoding Error: \(error)")
          }
        } else {
          completion(false)
        }
      }
      
      // Start the URLSessionDataTask
      task.resume()
      
    } catch {
      // Handle JSON serialization error
      print("JSON Serialization Error: \(error)")
    }
  }
}


