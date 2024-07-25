//
//  File.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import Foundation

import Moya

class LoginViewModel: CommonNetworking {
  static let loginViewModel = LoginViewModel()
  
  func login(email: String,
             password: String,
             completion: @escaping (Bool) -> Void){
    guard let loginURL = URL(string: "https://study-hub.site:443/api/v1/users/login") else {
      return
    }
    
    let loginData: [String: Any] = [
      "email": email,
      "password": password
    ]
    
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: loginData, options: [])
      
      var request = URLRequest(url: loginURL)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = jsonData
      
      let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
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
      task.resume()
      
    } catch {
      print("JSON Serialization Error: \(error)")
    }
  }
}

