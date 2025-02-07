//
//  EnterPasswordViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/29/24.
//

import Foundation

import RxSwift
import RxCocoa

/// 비밀번호 입력 ViewModel
final class EnterPasswordViewModel: SignupViewModel {
  
  
  /// 첫 번째 비밀번호
  let firstPassword = BehaviorRelay<String>(value: "")
  
  /// 확인 검증용 비밀번호
  let confirmPassword = BehaviorRelay<String>(value: "")
  
  /// 두 비밀번호의 일치 여부
  var passwordsMatch: Observable<Bool> {
    return Observable.combineLatest(firstPassword, confirmPassword).map { $0 == $1 && !$0.isEmpty }
  }

  override init(_ values: SignupDataProtocol) {
    super.init(values)
  }
}
