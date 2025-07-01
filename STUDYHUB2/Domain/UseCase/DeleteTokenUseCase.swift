//
//  DeleteTokenUseCase.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/23/25.
//

import Foundation

import RxSwift


/// JWT 토큰 삭제하기
protocol DeleteTokenUseCase {
  func execute() -> Bool
}

final class DeleteTokenUseCaseImpl: DeleteTokenUseCase {
  private let repository: TokenRepository
  
  init(repository: TokenRepository) {
    self.repository = repository
  }
  
  func execute() -> Bool {
    repository.delete()
  }
}
