//
//  UserToken.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/06.
//

import Foundation

struct User: Codable {
  var accessToken: String
  static var currentUser: User?
  
}
