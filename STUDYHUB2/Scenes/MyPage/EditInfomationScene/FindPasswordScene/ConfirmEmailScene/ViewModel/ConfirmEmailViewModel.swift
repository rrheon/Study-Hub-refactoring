

import Foundation

import RxFlow
import RxRelay
import RxSwift

/// Email 유효성 확인 ViewModel
final class ConfirmEmailViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  static let shared = ConfirmEmailViewModel()
  
  let disposeBag: DisposeBag = DisposeBag()

  var checkedEmail: Bool = false
  
  let email = BehaviorRelay<String>(value: "")
  let isExistEmail = PublishRelay<Bool>()

  init() {

  }
  
  
  /// 이메일 유효성 체크
  func checkEmailValid(){
    let email = email.value
    
    UserAuthManager.shared.checkEmailDuplicationWithRx(email: email)
      .flatMapLatest { [weak self] isValid -> Observable<Bool> in
        if isValid {
          // 유효하다면 코드입력 화면으로 이동 및 이메일 확인 코드 전송
          self?.steps.accept(FindPasswordStep.enterEmailCodeScreenIsRequired(email: email))
          return UserAuthManager.shared.sendEmailCodeWithChangePasswordWithRx(email: email)
        } else {
          // 인증 요청하지 않도록 종료
          ToastPopupManager.shared.showToast(message: "가입되지 않은 이메일이에요. 다시 입력해주세요.",
                                             alertCheck: false)
          return .empty()
        }
      }
      .subscribe()
      .disposed(by: disposeBag)



//    UserAuthManager.shared.checkEmailDuplication(email: email) { result in
//      self.isExistEmail.accept(result)
//      
//      UserAuthManager.shared.sendEmailCodeWithChangePassword(email: email) {
//        print($0)
//      }
//    }
  }
}
