//
//  AuthDIContainer.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/24/25.
//

import Foundation

final class AuthDIContainer {
  
  /// LoginViewModel 받기
  class func makeLoginViewModel() -> LoginViewModel {
    return LoginViewModel(loginUseCase: makeLoginUseCase(),
                          saveTokenUseCase: makeSaveTokenUseCase(),
                          deleteTokenUseCase: makeDeleteTokenUseCase())
  }
  
  private static func makeLoginUseCase() -> LoginUseCase {
    return LoginUseCaseImpl(repository: makeLoginRepository())
  }
  
  private static func makeLoginRepository() -> LoginRepository {
    return LoginRepositoryImpl(apiService: makeUserAuthManager())
  }
  
  private static func makeUserAuthManager() -> UserAuthManager {
    return UserAuthManager()
  }
  
  // MARK: token

  
  /// 토큰 저장 UseCase
  private static func makeSaveTokenUseCase() -> SaveTokenUseCase {
    return SaveTokenUseCaseImpl(repository: makeTokenRepository())
  }
  
  /// 토큰 삭제 UseCase
  private static func makeDeleteTokenUseCase() -> DeleteTokenUseCase {
    return DeleteTokenUseCaseImpl(repository: makeTokenRepository())
  }
  
  private static func makeTokenRepository() -> TokenRepository {
    return TokenRepositoryImpl(apiService: makeTokenManager())
  }
  
  private static func makeTokenManager() -> TokenManager {
    return TokenManager()
  }
  

}
