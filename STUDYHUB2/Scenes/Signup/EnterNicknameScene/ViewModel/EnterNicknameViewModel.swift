//
//  EnterNicknameViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/30/24.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow

/// 성별
enum Gender {
  case female
  case male
  case none
  

  /// 서버로 전달을 위한 문자열
  var toServer: String {
    switch self {
    case .female:   return "FEMALE"
    case .male:     return "MALE"
    default:        return "FEMALE"
    }
  }
}


/// 닉네임 입력 ViewModel
class EnterNicknameViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()

  var disposeBag: DisposeBag = DisposeBag()
  
  /// 닉네임 유효성 체크
  let checkValidNickname: PublishRelay<Bool> = PublishRelay<Bool>()
  
  /// 닉네임 중복여부 체크
  let checkDuplicationNickname: PublishRelay<Bool> = PublishRelay<Bool>()
  
  /// 성별 관리
  let genderStatus: BehaviorRelay<Gender> = BehaviorRelay(value: .none)

  
  /// 다음버튼 활성화 여부
  var isActivateNextButton: Observable<Bool> {
    return Observable.combineLatest(checkDuplicationNickname, genderStatus)
      .map { $0 && $1 != .none  }
  }
  
  /// 닉네임 중복여부 확인하기
  /// - Parameter nicknmae: 확인할 닉네임
  func checkDuplicationNickname(_ nickname: String){
    UserProfileManager.shared.checkNicknameDuplicationWithRx(nickname: nickname)
      .subscribe(onNext: { [weak self] isValid in
        self?.checkDuplicationNickname.accept(isValid)
      }, onError: { _ in
        /// 다시 시도 요청 팝업 띄우기
        ToastPopupManager.shared.showToast()
      })
      .disposed(by: disposeBag)
//    UserProfileManager.shared.checkNicknameDuplication(nickname: nickname) { result in
//      self.checkDuplicationNickname.accept(result)
//    }
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
