//
//  UserAuthManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import Foundation

import RxSwift
import RxMoya
import Moya


/// 유저 인증관련 네트워킹
class UserAuthManager: StudyHubCommonNetworking {
  static let shared = UserAuthManager()
  
  let provider = MoyaProvider<UserAuthNetworking>()
  
  /// 로그인하기
  /// - Parameters:
  ///   - email: 유저 email
  ///   - password: 유저 password
  func loginToStudyHub(email: String, password: String, completion: @escaping (AccessTokenResponse) -> Void){
    provider.request(.loginToStudyHub(email: email, password: password)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: AccessTokenResponse.self) { decodedData in
        completion(decodedData)
      }
    }
  }
  
  /// 로그인하기
  /// - Parameters:
  ///   - email: 유저 email
  ///   - password: 유저 password
  func loginToStudyHubWithRx(email: String, password: String) -> Observable<AccessTokenResponse> {
    return provider.rx
      .request(.loginToStudyHub(email: email, password: password))
      .asObservable()
      .flatMap { response -> Observable<AccessTokenResponse> in
        self.commonDecodeNetworkResponse(with: response, decode: AccessTokenResponse.self)
      }
  }
  
  /// 계정 생성하기
  /// - Parameter accountData: 계정관련 데이터
  /// - Parameter completion: 성공여부 콜백함수
  func createNewAccount(accountData: CreateAccount, completion: @escaping (Bool) -> Void){
    provider.request(.createNewAccount(accountData: accountData)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion(true)
      case .failure(let response):
        print(response.response)
        completion(false)
      }
    }
  }
  
  /// 계정 생성하기
  /// - Parameter accountData: 계정관련 데이터
  func createNewAccountWithRx(accountData: CreateAccount) -> Observable<Bool>{
    return provider.rx
      .request(.createNewAccount(accountData: accountData))
      .asObservable()
      .map { response in
        return (200...299).contains(response.statusCode)
      }
      .catchAndReturn(false)
  }
  
  
  /// 비밀번호 검증
  /// - Parameter password: 비밀번호
  func verifyPassword(password: String, completion: @escaping (Bool) -> Void){
    provider.request(.verifyPassword(password: password)) { result in
      switch result {
      case .success(let response):
        switch response.statusCode{
        case 200:
          completion(true)
        default:
          completion(false)
        }
      case .failure(let response):
        completion(false)
      }
    }
  }
  
  /// 비밀번호 검증
  /// - Parameter password: 비밀번호
  func verifyPasswordWithRx(password: String) -> Observable<Bool> {
    return provider.rx
      .request(.verifyPassword(password: password))
      .asObservable()
      .map { response in
        return (200...299).contains(response.statusCode)
      }
      .catchAndReturn(false)
  }
  
  
  /// AccessToken 갱신하기
  /// - Parameter refreshToken: refreshToken
  func refreshAccessToken(refreshToken: String, completion: @escaping (AccessTokenResponse?) -> Void) {
    provider.request(.refreshAccessToken(refreshToken: refreshToken)) { result in
      switch result {
      case .success(let response):
        print(#fileID, #function, #line, " - \(response.statusCode)")
        
        if (200...299).contains(response.statusCode) {
          do {
            let decodedData = try JSONDecoder().decode(AccessTokenResponse.self, from: response.data)
  
            completion(decodedData) //  성공 시 갱신된 Token 반환
          } catch {
            completion(nil)
          }
        } else {
          completion(nil)
        }
        
      case .failure(let error):
        completion(nil)
      }
    }
  }
  
  /// AccessToken 갱신하기
  /// - Parameter refreshToken: refreshToken
  func refreshAccessTokenWithRx(refreshToken: String) -> Observable<AccessTokenResponse> {
    
    return provider.rx
      .request(.refreshAccessToken(refreshToken: refreshToken))
      .asObservable()
      .flatMap { resposne -> Observable<AccessTokenResponse> in
        self.commonDecodeNetworkResponse(with: resposne, decode: AccessTokenResponse.self)
      }
  }

 
  // MARK: - 이메일 중복 확인
  
  /// 이메일 중복 확인하기
  /// - Parameters:
  ///   - email: 확인할 이메일
  ///   - completion: 콜백함수
  func checkEmailDuplication(email: String, completion: @escaping (Bool) -> Void){
    provider.request(.checkEmailDuplication(email: email)) { result in
      print(result)
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
  
  /// 이메일 중복 확인하기
  /// - Parameters:
  ///   - email: 확인할 이메일
  ///   - completion: 콜백함수
  func checkEmailDuplicationWithRx(email: String) -> Observable<Bool>{
    return provider.rx
      .request(.checkEmailDuplication(email: email))
      .asObservable()
      .map { response in
        return !(200...400).contains(response.statusCode)
      }
      .catchAndReturn(false)
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
        // 응답 데이터를 UTF-8 문자열로 변환. 만약 변환 실패 시 "No data"를 반환
        let res = String(data: response.data, encoding: .utf8) ?? "No data"

        // ":"와 "}" 문자 사이의 값을 찾기 위해, 문자열에서 해당 인덱스를 찾는다.
        if let i = res.firstIndex(of: ":"), let j = res.firstIndex(of: "}") {
          // ":" 이후 시작 인덱스를 구한다.
          let startIndex = res.index(after: i)
          // "}" 바로 전 인덱스를 구한다.
          let endIndex = res.index(before: j)
          
          // startIndex부터 endIndex까지의 부분 문자열을 codeCheck로 추출
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
  
//  func checkValidCodeWithRx(code: String, email: String) -> Observable<String>{
//    
//#warning("이메일 중복체크 후 인증코드 확인 - 서버응답 및 데이터 처리 확인 필요")
//    
////    provider.request(.verifyEmailAndCode(code: code, email: email)) { result in
////      switch result {
////      case .success(let response):
////        let res = String(data: response.data, encoding: .utf8) ?? "No data"
////        if let i = res.firstIndex(of: ":"), let j = res.firstIndex(of: "}") {
////          let startIndex = res.index(after: i)
////          let endIndex = res.index(before: j)
////          let codeCheck = res[startIndex...endIndex]
////          print(codeCheck)
////          switch codeCheck{
////          case "true":
////            completion("true")
////            
////          case "false":
////            completion("false")
////          default:
////            return
////          }
////        }
////        
////      case .failure(let response):
////        print(response.response)
////      }
////    }
//    
//  }
  
  // MARK: - 인증코드 전송
  
  /// 이메일로 인증코드 전송
  /// - Parameters:
  ///   - email: 인증코드를 전송할 이메일주소
  ///   - completion: 콜백함수
  func sendEmailCode(email: String, completion: @escaping (Bool) -> Void){
    provider.request(.sendEmailCode(email: email)) { result in
      switch result {
      case .success(let response):
        completion(true)
      case .failure(let response):
        print(response.response)
        completion(false)
      }
    }
  }
  
  func sendEmailCodeWithRx(email: String) -> Observable<Bool> {
    return provider.rx
      .request(.sendEmailCode(email: email))
      .asObservable()
      .map { response in
        return (200...299).contains(response.statusCode)
      }
      .catchAndReturn(false)
  }

  
  func sendEmailCodeWithChangePassword(email: String, completion: @escaping (Bool) -> Void) {
    provider.request(.sendEmailForVerifyPassword(email: email)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion(true)
      case .failure(let response):
        print(response.response)
        completion(false)
      }
    }
  }
  
  func sendEmailCodeWithChangePasswordWithRx(email: String) -> Observable<Bool> {
    return provider.rx
      .request(.sendEmailForVerifyPassword(email: email))
      .asObservable()
      .map { response in
        return (200...299).contains(response.statusCode)
      }
      .catchAndReturn(false)
  }
}
