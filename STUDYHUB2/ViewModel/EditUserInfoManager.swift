//
//  EditUserInfoManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/12/28.
//

import Foundation

final class EditUserInfoManager {
  static let shared = EditUserInfoManager()
  let networkingManager = Networking.networkinhShared
  let tokenManager = TokenManager.shared
  let commonNetworking = CommonNetworking.shared
  
  private init() {}
  
  // MARK: - 닉네임 중복확인
  func checkNicknameDuplication(nickName: String, completion: @escaping (String) -> Void) {
    let urlPath = "/users/duplication-nickname"
    let queryItems = [URLQueryItem(name: "nickname", value: nickName)]

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

  // MARK: - 유저 닉네임 변경
  
  func editUserNickname(_ nickname: String, completion: @escaping (Int?) -> Void) {
    commonNetworking.moyaNetworking(
      networkingChoice: .editUserNickName(_nickname: nickname),
      needCheckToken: true
    ) { result in
      switch result {
      case let .success(response):
        let result = response.response?.statusCode
        completion(result)
        
      case let .failure(error):
        print(error.localizedDescription)
      }
    }
  }

  // MARK: - 이메일 중복 확인
  func checkEmailDuplication(email: String, completion: @escaping (Bool) -> Void){
    commonNetworking.moyaNetworking(
      networkingChoice: .checkEmailDuplication(_email: email)
    ) { result in
      switch result {
      case.success(let response):
        switch response.statusCode {
        case 200:
          //가입이 안된경우
          completion(false)
        case 400:
          completion(false)
        default:
          // 가입이 된경우
          completion(true)
        }
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 이메일 중복체크 후 인증코드 확인
  func checkValidCode(code: String,
                      email: String,
                      completion: @escaping (String) -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .verifyEmail(_code: code,
                                                                   _email: email)) { result in
      switch result {
      case .success(let response):
        let res = String(data: response.data, encoding: .utf8) ?? "No data"
        if let i = res.firstIndex(of: ":"), let j = res.firstIndex(of: "}") {
          let startIndex = res.index(after: i)
          let endIndex = res.index(before: j)
          let codeCheck = res[startIndex...endIndex]
          print(codeCheck)
          switch codeCheck{
          case "true":
            completion("true")
            
          case "false":
            completion("false")
          default:
            return
          }
        }
  
      case .failure(let response):
        print(response.response)
      }
    }
  }

  // MARK: - 인증코드 전송
  func sendEmailCode(email: String, completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .sendEmailCode(_email: email)) { result in
      switch result {
      case .success(let response):
        completion()
    
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 비밀번호 변경
  func changePassword(password: String,
                      email: String,
                      completion: @escaping () -> Void){
    commonNetworking.moyaNetworking(networkingChoice: .editUserPassword(_checkPassword: true,
                                                                        email: email,
                                                                        _password: password)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        
        completion()
      case .failure(let respose):
        print(respose.response)
      }
    }
    
  }
}
  
