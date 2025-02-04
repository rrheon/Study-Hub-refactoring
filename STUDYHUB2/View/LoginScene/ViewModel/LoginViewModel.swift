//
//  File.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import Foundation

import RxSwift
import RxRelay


/// 로그인 ViewModel
class LoginViewModel {
  let disposeBag: DisposeBag = DisposeBag()

  let tokenManager = TokenManager.shared
  
  let isValidAccount: PublishRelay<Bool> = PublishRelay<Bool>()
  
  
  /// 로그인하기
  /// - Parameters:
  ///   - email: 사용자의 email
  ///   - password: 사용자 password
  func loginToStudyHub(email: String, password: String){
    UserAuthManager.shared.loginToStudyHub(email: email, password: password)
  }
  
  func login(email: String, password: String){
    guard let loginURL: URL = URL(string: "https://studyhub.shop:443/api/v1/users/login") else {
      return
    }
    
    let loginData: [String: Any] = [
      "email": email,
      "password": password
    ]
    
    do {
      let jsonData: Data = try JSONSerialization.data(withJSONObject: loginData, options: [])
      
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
              accessToken: accessTokenResponse.accessToken!,
              refreshToken: accessTokenResponse.refreshToken!) else { return }
            
            self?.isValidAccount.accept(loginResult)
          } catch {
            print("JSON Decoding Error: \(error)")
          }
        } else {
          self?.isValidAccount.accept(false)
        }
      }
      task.resume()
      
    } catch {
      print("JSON Serialization Error: \(error)")
    }
  }
}

