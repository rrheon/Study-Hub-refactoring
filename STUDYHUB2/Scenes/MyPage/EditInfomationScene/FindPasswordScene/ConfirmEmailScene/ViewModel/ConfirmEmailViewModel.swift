

import Foundation

import RxFlow
import RxRelay

/// Email 유효성 확인 ViewModel
final class ConfirmEmailViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  var checkedEmail: Bool = false
  
  let email = BehaviorRelay<String>(value: "")
  let isExistEmail = PublishRelay<Bool>()

  init() {

  }
  
  
  /// 이메일 유효성 체크
  func checkEmailValid(){
    let email = email.value
    
    UserAuthManager.shared.checkEmailDuplication(email: email) { result in
      self.isExistEmail.accept(result)
    }
  }
}
