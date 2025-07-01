//
//  SaveTokenUseCase.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/23/25.
//

import Foundation

import RxSwift


/// JWT 토큰 저장 UseCase
protocol SaveTokenUseCase {
  func execute(token: AccessTokenResponse) -> Bool
}

final class SaveTokenUseCaseImpl: SaveTokenUseCase {
  private let repository: TokenRepository
  
  init(repository: TokenRepository) {
    self.repository = repository
  }
  
  func execute(token: AccessTokenResponse) -> Bool {
    repository.save(tokens: token)
  }
  
}
