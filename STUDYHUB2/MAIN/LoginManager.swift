//
//  File.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import UIKit

import Moya

class LoginManager {
  static let shared = LoginManager()
  
  let tokenManager = TokenManager.shared
  
  func refreshAccessToken(completion: @escaping (Bool) -> Void) {
    guard let refreshToken = tokenManager.loadRefreshToken() else {
      completion(false)
      return
    }
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.refreshAccessToken(refreshToken)) { result in
      switch result {
      case .success(let response):
        do {
          if response.statusCode == 200 {
            let refreshResult = try JSONDecoder().decode(AccessTokenResponse.self,
                                                         from: response.data)
            self.tokenManager.deleteTokens()
            
            let saveResult = self.tokenManager.saveTokens(accessToken: refreshResult.accessToken,
                                                          refreshToken: refreshResult.refreshToken)
            completion(true)
          }
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let error):
        completion(false)
      }
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


