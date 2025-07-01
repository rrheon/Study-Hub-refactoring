//
//  FetchTokenUseCase.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/23/25.
//

import Foundation

import RxSwift


/// JWT 토큰 가져오기 UseCase
protocol FetchTokenUseCase {
  func execute(type: TokenType) -> String
}

final class FetchTokenUseCaseImpl: FetchTokenUseCase {
  private let repository: TokenRepository
  
  init(repository: TokenRepository) {
    self.repository = repository
  }
  
  func execute(type: TokenType) -> String {
    repository.fetch(type: type)
  }
}
