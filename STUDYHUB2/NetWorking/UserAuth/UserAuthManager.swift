//
//  UserAuthManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import Foundation

import Moya


/// 유저 인증관련 네트워킹
class UserAuthManager: StudyHubCommonNetworking {
  static let shared = UserAuthManager()
  
  let provider = MoyaProvider<UserAuthNetworking>()
  
  
  /// 로그인하기
  /// - Parameters:
  ///   - email: 유저 email
  ///   - password: 유저 password
  func loginToStudyHub(email: String, password: String){
    provider.request(.loginToStudyHub(email: email, password: password)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: AccessTokenResponse.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  /// 계정 생성하기
  /// - Parameter accountData: 계정관련 데이터
  func createNewAccount(accountData: CreateAccount){
    provider.request(.createNewAccount(accountData: accountData)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        
      case .failure(let response):
        print(response.response)
        
      }
    }
  }
  
  
  /// 비밀번호 검증
  /// - Parameter password: 비밀번호
  func verifyPassword(password: String){
    provider.request(.verifyPassword(password: password)) { result in
      switch result {
      case .success(let response):
        switch response.statusCode{
        case 200:
          return // 검증성공
        default:
          return // 검증실패
        }
      case .failure(let response):
        return // 검증실패
      }
    }
  }
  
  
  /// AccessToken 갱신하기
  /// - Parameter refreshToken: refreshToken
  func refreshAccessToken(refreshToken: String){
    provider.request(.refreshAccessToken(refreshToken: refreshToken)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: AccessTokenResponse.self) { decodedData in
        print(decodedData)
      }
    }
  }
 
  // MARK: - 이메일 중복 확인
  
  /// 이메일 중복 확인하기
  /// - Parameters:
  ///   - email: 확인할 이메일
  ///   - completion: 콜백함수
  func checkEmailDuplication(email: String, completion: @escaping (Bool) -> Void){
    provider.request(.checkEmailDuplication(email: email)) { result in
      switch result {
      case.success(let response):
        switch response.statusCode {
        case 200:         completion(false)           //사용 가능한 이메일
        case 400:         completion(false)           //사용 가능한 이메일
        default:          completion(true)            //사용 불가능한 이메일
        }
      case .failure(let response):
        print(response.response)
      }
    }
    
  }
  
  // MARK: - 이메일 중복체크 후 인증코드 확인
  
  /// 이메일 중복체크 후 인증코드 확인
  /// - Parameters:
  ///   - code: 입력한 코드
  ///   - email: 입력한 이메일
  ///   - completion:콜백함수
  func checkValidCode(code: String, email: String, completion: @escaping (String) -> Void){
    
#warning("이메일 중복체크 후 인증코드 확인 - 서버응답 및 데이터 처리 확인 필요")
    
    provider.request(.verifyEmailAndCode(code: code, email: email)) { result in
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
  
  /// 이메일로 인증코드 전송
  /// - Parameters:
  ///   - email: 인증코드를 전송할 이메일주소
  ///   - completion: 콜백함수
  func sendEmailCode(email: String, completion: @escaping () -> Void){
    provider.request(.sendEmailCode(email: email)) { result in
      switch result {
      case .success(let response):
        completion()
      case .failure(let response):
        print(response.response)
      }
    }
  }

}
