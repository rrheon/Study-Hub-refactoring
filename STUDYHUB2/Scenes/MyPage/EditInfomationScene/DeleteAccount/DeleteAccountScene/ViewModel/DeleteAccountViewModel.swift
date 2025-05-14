//
//  DeleteAccountViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/20/24.
//

import Foundation

import RxSwift
import RxFlow
import RxRelay


/// 탈퇴하기 ViewModel
final class DeleteAccountViewModel: Stepper{
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  let disposeBag: DisposeBag = DisposeBag()

  let password = BehaviorRelay<String>(value: "")
  let isValidPassword = PublishRelay<Bool>()
  let isSuccessToDeleteAccount = PublishRelay<Bool>()
  
  
  /// 비밀번호 유효성 체크
  func checkValidPassword(){
    let password = password.value
    UserAuthManager.shared.verifyPasswordWithRx(password: password)
      .subscribe(onNext: { [weak self] isValid in
        if isValid {
          self?.deleteAccount()
        }else {
          ToastPopupManager.shared.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.",
                                             alertCheck: false)
        }
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    UserAuthManager.shared.verifyPassword(password: password) { result in
//      self.isValidPassword.accept(result)
//    }
  }
  
  /// 계정 삭제하기
  func deleteAccount(){
    UserProfileManager.shared.deleteAccountWithRx()
      .subscribe(onNext: { [weak self] isSuccess in
        if isSuccess {
          self?.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .accountDeletionCompleted)))
        }else {
          ToastPopupManager.shared.showToast(message:  "계정 탈퇴에 실패했어요.", alertCheck: false)
        }
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    UserProfileManager.shared.deleteAccount { result in
//      self.isSuccessToDeleteAccount.accept(result)
//    }
  }

}
