//
//  EnterNicknameViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/30/24.
//

import Foundation

import RxSwift
import RxCocoa

final class EnterNicknameViewModel: SignupViewModel {
  
  let edit = EditUserInfoManager.shared
  
  let checkValidNickname = BehaviorRelay(value: false)
  let checkDuplicationNickname = BehaviorRelay<String>(value: "")
  
  let femaleButtonStatus = BehaviorRelay(value: false)
  let maleButtonStatus = BehaviorRelay(value: false)

  var isActivateNextButton: Observable<Bool> {
    return Observable.combineLatest(checkDuplicationNickname,
                                    femaleButtonStatus,
                                    maleButtonStatus).map { $0 == "Error" && $1 || $2 }
  }
 
  func checkDuplicationNickname(_ nicknmae: String){
    edit.checkNicknameDuplication(nickName: nickname ?? "") {
      self.checkDuplicationNickname.accept($0)
    }
  }
  
  func genderButtonTapped(for button: BehaviorRelay<Bool>){
    let newState = !button.value
    button.accept(newState)
    
    if button === femaleButtonStatus {
      maleButtonStatus.accept(!newState)
    } else if button === maleButtonStatus {
      femaleButtonStatus.accept(!newState)
    }
  }
  
  // MARK: - 유효성 검사
  
  func checkValidNickname(nickname: String) {
    let pattern = "^[a-zA-Z0-9가-힣]*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: nickname.utf16.count)
    
    let pass = regex?.firstMatch(in: nickname, options: [], range: range) != nil ? true : false
    checkValidNickname.accept(pass)
  }
}
