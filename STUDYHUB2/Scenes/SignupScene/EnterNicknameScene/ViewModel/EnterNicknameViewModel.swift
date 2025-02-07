//
//  EnterNicknameViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/30/24.
//

import Foundation

import RxSwift
import RxCocoa


/// 닉네임 입력 ViewModel
class EnterNicknameViewModel: SignupViewModel {
  
  
  /// 닉네임 유효성 체크
  let checkValidNickname: PublishRelay<Bool> = PublishRelay<Bool>()
  
  /// 닉네임 중복여부 체크
  let checkDuplicationNickname: PublishRelay<String> = PublishRelay<String>()
  
  
  /// 성별버튼 - 여자 상태 체크
  let femaleButtonStatus: BehaviorRelay<Bool> = BehaviorRelay(value: false)
  
  /// 성별버튼 - 남자 상태 체크
  let maleButtonStatus: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  
  /// 선택된 성별
  var selectedGender = String()

  
  /// 다음버튼 활성화 여부
  var isActivateNextButton: Observable<Bool> {
    return Observable.combineLatest(checkDuplicationNickname,
                                    femaleButtonStatus,
                                    maleButtonStatus).map { $0 == "Error" && $1 || $2 }
  }
  
  /// 닉네임 중복여부 확인하기
  /// - Parameter nicknmae: 확인할 닉네임
  func checkDuplicationNickname(_ nicknmae: String){
    UserProfileManager.shared.checkNicknameDuplication(nickname: nicknmae) { result in
      self.checkDuplicationNickname.accept(result)
    }
    
//    edit.checkNicknameDuplication(nickName: nickname ?? "") {
//      self.checkDuplicationNickname.accept($0)
//    }
  }
  
  
  /// 성별버튼 터치
  /// - Parameter button: 성별버튼
  func genderButtonTapped(for button: BehaviorRelay<Bool>){
    let newState = !button.value
    button.accept(newState)
    
    if button === femaleButtonStatus {
      maleButtonStatus.accept(!newState)
      selectedGender = "FEMALE"
    } else if button === maleButtonStatus {
      femaleButtonStatus.accept(!newState)
      selectedGender = "MALE"
    }
  }
  
  // MARK: - 유효성 검사
  
  /// 닉네임 유효성 검사
  /// - Parameter nickname: 검사할 닉네임
  func checkValidNickname(nickname: String) {
    let pattern = "^[a-zA-Z0-9가-힣]*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: nickname.utf16.count)
    
    let pass = regex?.firstMatch(in: nickname, options: [], range: range) != nil ? true : false
    checkValidNickname.accept(pass)
  }
}
