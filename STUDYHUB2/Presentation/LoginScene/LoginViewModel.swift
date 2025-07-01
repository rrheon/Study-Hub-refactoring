//
//  File.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import Foundation

import RxFlow
import RxCocoa
import RxSwift
import RxRelay


/// 로그인 시도 상태
enum LoginStatus {
  case empty    // 아이디, 비밀번호 항목이 비었거나 유효하지 않을 때
  case success
  case fail
}

/// 로그인 ViewModel
class LoginViewModel: ViewModelType {
  var disposeBag: DisposeBag = DisposeBag()

  private let loginUseCase: LoginUseCase
  private let saveTokenUseCase: SaveTokenUseCase
  private let deleteTokenUseCase: DeleteTokenUseCase
  
  struct Input {
    let emailText: Observable<String>
    let passwordText: Observable<String>
    let loginBtnTapped: Observable<Void>
  }
  
  struct Output {
    let isEmailValid: Observable<Bool>
    let isPasswordValid: Observable<Bool>
    let isLoginResult: Observable<LoginStatus>
  }
  
  init(loginUseCase: LoginUseCase,
       saveTokenUseCase: SaveTokenUseCase,
       deleteTokenUseCase: DeleteTokenUseCase) {
    self.loginUseCase = loginUseCase
    self.saveTokenUseCase = saveTokenUseCase
    self.deleteTokenUseCase = deleteTokenUseCase
  }
  
  func transform(input: Input) -> Output {
    // 이메일 유효성
    let isEmailValid = input.emailText
      .filter { !$0.isEmpty }
      .map { Validators.isValidEmail($0) }

    
    // 비밀번호 유효성
    let isPasswordValid = input.passwordText
      .filter { !$0.isEmpty }
      .map { Validators.isValidPassword($0)}
 
    // 로그인버튼 탭 -> 로그인 시도
    let isLoginResult = input.loginBtnTapped
      .withLatestFrom(Observable.combineLatest(input.emailText, input.passwordText))
      .flatMapLatest { [weak self] email, password -> Observable<LoginStatus> in
        guard let self = self else { return .just(.empty) }
        
        if !Validators.isValidEmail(email) || !Validators.isValidPassword(password) {
          return .just(.empty)
        }
        
        let loginData = LoginEntity(email: email, password: password)
        return self.loginUseCase.execute(loginData: loginData)
          .asObservable()
          .map { token in
            _ = self.deleteTokenUseCase.execute()
            
            // 토큰 저장 성공여부에 따라 로그인 성공여부 방출
            return self.saveTokenUseCase.execute(token: token) ? .success : .fail
          }
      }
    
    return Output(isEmailValid: isEmailValid,
                  isPasswordValid: isPasswordValid,
                  isLoginResult: isLoginResult)
  }
}
