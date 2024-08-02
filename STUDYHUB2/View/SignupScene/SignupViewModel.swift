//
//  SignupViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/27/24.
//

import Foundation

protocol SignupDataProtocol {
  var email: String? { get set }
  var password: String? { get set }
  var gender: String? { get set }
  var nickname: String? { get set }
}

struct SignupDats: SignupDataProtocol {
  var email: String?
  var password: String?
  var gender: String?
  var nickname: String?

  init(email: String? = nil, password: String? = nil, gender: String? = nil, nickname: String? = nil) {
    self.email = email
    self.password = password
    self.gender = gender
    self.nickname = nickname
  }
}

class SignupViewModel: CommonViewModel, SignupDataProtocol {
  var email: String?
  var password: String?
  var gender: String?
  var nickname: String?
  
  init(_ values: SignupDataProtocol) {
    self.email = values.email
    self.password = values.password
    self.gender = values.gender
    self.nickname = values.nickname
  }
}
