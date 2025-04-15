//
//  EditPasswordViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/24/24.
//

import Foundation

import RxSwift
import RxFlow
import RxRelay

/// 비밀번호 수정 ViewModel
final class EditPasswordViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  /// 사용자의 이메일
  let userEmail: String
  
  /// 입력한 첫 번째 비밀번호
  let firstPassword = BehaviorRelay<String>(value: "")
  
  /// 입력한 두 번째 비밀번호
  let secondPassword = BehaviorRelay<String>(value: "")
  
  /// 비밀번호 변경 성공 여부
  let isSuccessChangePassword = PublishRelay<Bool>()
 
  init(userEmail: String) {
    self.userEmail = userEmail
  }
  
  /// 입력한 비밀번호 동일성 체크
  /// - Returns: 입력한 비밀번호가 동일한치
  func checkSamePassword() -> Bool{
    let firstPassword = firstPassword.value
    let secondPassword = secondPassword.value
    return firstPassword == secondPassword
  }
  
  
  /// 변경할 비밀번호 서버에 저장
  func storePasswordToServer(){
    let enteredPassword = secondPassword.value
    
    UserProfileManager.shared.changePasswordWithRx(password: enteredPassword, email: userEmail)
      .subscribe(onNext: { isSuccess in
        self.isSuccessChangePassword.accept(isSuccess)
      })
      .disposed(by: disposeBag)
    
//    UserProfileManager.shared.changePassword(password: enteredPassword, email: userEmail) { result in
//      self.isSuccessChangePassword.accept(result)
//    }
  }

}

