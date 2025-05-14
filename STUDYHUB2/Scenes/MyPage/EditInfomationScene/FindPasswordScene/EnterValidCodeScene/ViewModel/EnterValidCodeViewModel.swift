//
//  EnterValidCodeViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/25/24.
//

import Foundation

import RxSwift
import RxFlow
import RxRelay

/// 이메일 유효성 체크 ViewModel
final class EnterValidCodeViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  let disposeBag: DisposeBag = DisposeBag()

  var email: String? = nil
  
  let validCode = BehaviorRelay<String>(value: "")
  let isCodeSended = PublishRelay<Bool>()
  let isValidCode = PublishRelay<Bool>()
  
  init(_ email: String) {
    self.email = email
  }

  
  /// 이메일 인증 코드 보내기
  func sendEmailValidCode(){
    guard let _email = email else { return }
    UserAuthManager.shared.sendEmailCodeWithRx(email: _email)
      .subscribe(onNext: { isSent in
        self.isValidCode.accept(isSent)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag )
//    UserAuthManager.shared.sendEmailCode(email: _email) { result in
//      self.isValidCode.accept(result)
//    }
  }
  
  /// 코드 다시 보내기
  func resendEmailValidCode(){
    sendEmailValidCode()
    self.isCodeSended.accept(true)
  }
  
  // MARK: - 전송받은 코드 유효성 확인
  
  
  /// 코드의 유효성 확인
  /// - Parameter code: 입력한 코드
  func checkValidCode(code: String){
    guard let _email = email else { return }
    UserAuthManager.shared.checkValidCode(code: code , email: _email) { result in
      self.isValidCode.accept(result == "true")
    }
  }
}
