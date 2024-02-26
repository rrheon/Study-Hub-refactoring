//
//  ErrorDTO.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/24.
//

import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
  case networkingError
  case dataError
  case parseError
}

struct StudySearchError: Codable {
  let status, message: String
}
