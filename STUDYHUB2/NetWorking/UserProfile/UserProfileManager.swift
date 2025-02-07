//
//  UserProfileManager.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 1/29/25.
//

import Foundation

import Moya


/// 사용자 프로필 관련 네트워킹
class UserProfileManager: StudyHubCommonNetworking, ConvertMajor {
  static let shared = UserProfileManager()
  
  let provider = MoyaProvider<UserProfileNetworking>()
  
  
  /// 사용자의 정보 가져오기
  func loadUserInfo(){
    provider.request(.loadUserInfo) { result in
      self.commonDecodeNetworkResponse(with: result, decode: UserDetailData.self) { decodedData in
        print(decodedData)
      }
    }
  }
  
  // MARK: - 유저 닉네임 변경
  
  /// 사용자의 닉네임 변경
  /// - Parameters:
  ///   - nickname: 변경할 닉네임
  ///   - completion: 콜백함수
  func editUserNickname(nickname: String, completion: @escaping (Int?) -> Void) {
    provider.request(.editUserNickName(nickname: nickname)) { result in
      switch result {
      case let .success(response):
        let result = response.response?.statusCode
        completion(result)
        
      case let .failure(error):
        print(error.localizedDescription)
      }
    }
  }
  
  
  /// 사용자의 비밀번호 변경
  /// - Parameters:
  ///   - password: 변경할 비밀번호
  ///   - email: 사용자의 이메일
  ///   - completion: 콜백함수
  func changePassword(password: String, email: String, completion: @escaping () -> Void){
    let data = EditUserPasswordDTO(checkPassword: true, email: email, password: password)
    provider.request(.editUserPassword(data: data)) { result in
      switch result {
      case .success(let response):
        print(response.response)
        completion()
      case .failure(let respose):
        print(respose.response)
      }
    }
 
  }
  
  /// 사용자의 학과 변경
  /// - Parameter major: 변경할 학과
  func changeMajor(major: String){
    guard let major = convertMajor(major, toEnglish: true) else { return }
    
    provider.request(.editUserMajor(major: major)) { result in
      switch result {
      case .success(let response):
        print(response.response)
      case .failure(let respose):
        print(respose.response)
      }
    }
  }
  
  
  /// 사용자의 계정 삭제
  func deleteAccount(){
    provider.request(.deleteUserAccount) { result in
      switch result {
      case .success(let response):
        print(response.response)
      case .failure(let respose):
        print(respose.response)
      }
     }
  }
  
  
  /// 사용자의 프로필 이미지 삭제
  func deleteProfile(){
    provider.request(.deleteUserProfileImage) { result in
      switch result {
      case .success(let response):
        print(response.response)
      case .failure(let respose):
        print(respose.response)
      }
    }
  }
  
  
  /// 사용자의 프로필 이미지 저장
  /// - Parameter image: 저장할 이미지
  func storeProfileToserver(image: UIImage){
    provider.request(.storeUserProfileImage(image: image)) { result in
      switch result {
      case .success(let response):
        print(response.response)
      case .failure(let respose):
        print(respose.response)
      }
    }
  }
  
  /// 닉네임 중복확인
  /// - Parameters:
  ///   - nickname: 확인할 닉네임
  ///   - completion: 콜백함수
  func checkNicknameDuplication(nickname: String, completion: @escaping (String) -> Void){
    provider.request(.checkNicknameDuplication(nickname: nickname)) { result in
      self.commonDecodeNetworkResponse(with: result, decode: DuplicationResponse.self) { result in
        completion(result.status)
        print(result.message)
      }
    }
  }
}
