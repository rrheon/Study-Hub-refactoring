

import Foundation

import RxRelay

final class ConfirmEmailViewModel {
  
  let loginStatus: Bool
  var checkedEmail: Bool = false
  
  let email = BehaviorRelay<String>(value: "")
  let isExistEmail = PublishRelay<Bool>()

  init(loginStatus: Bool) {
    self.loginStatus = loginStatus
  }
  
  func checkEmailValid(){
    let email = email.value
    
    UserAuthManager.shared.checkEmailDuplication(email: email) { result in
      self.isExistEmail.accept(result)
    }
//    editUserInfoManager.checkEmailDuplication(email: email) { result in
//      self.isExistEmail.accept(result)
//    }
  }
}
