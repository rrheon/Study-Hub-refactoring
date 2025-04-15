//
//  EditPasswordViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/20/24.
//

import Foundation

import RxSwift
import RxRelay
import RxFlow

/// 비밀번호 확인 ViewModel
final class ConfirmPasswordViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()

  var disposeBag: DisposeBag = DisposeBag()
  
  let userEmail: String
  let currentPassword = BehaviorRelay<String>(value: "")
  let isValidPassword = PublishRelay<Bool>()
  
  init(userEmail: String) {
    self.userEmail = userEmail
  }
  
  
  /// 다음버튼 탭 (비밀번호 유효성 체크))
  /// - 유효한 경우 - 비밀번호 변경 화면으로 이동
  /// - Parameter password: 비밀번호
  func nextButtonTapped(_ password: String){
    UserAuthManager.shared.verifyPasswordWithRx(password: password)
      .subscribe(onNext: { isValid in
        self.isValidPassword.accept(isValid)
      })
      .disposed(by: disposeBag)
//    UserAuthManager.shared.verifyPassword(password: password) { result in
//      self.isValidPassword.accept(result)
//    }

  }
}
