//
//  EnterPasswordViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/29/24.
//

import Foundation

import RxSwift
import RxCocoa

final class EnterPasswordViewModel: SignupViewModel {

  let firstPassword = BehaviorRelay<String>(value: "")
  let confirmPassword = BehaviorRelay<String>(value: "")
  
  var passwordsMatch: Observable<Bool> {
    return Observable.combineLatest(firstPassword, confirmPassword).map { $0 == $1 && !$0.isEmpty }
  }

  override init(_ values: SignupDataProtocol) {
    super.init(values)
  }
}
