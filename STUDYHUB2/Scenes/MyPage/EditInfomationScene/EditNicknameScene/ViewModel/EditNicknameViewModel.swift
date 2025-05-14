
import Foundation

import RxFlow
import RxSwift
import RxRelay

/// 닉네임 변경 ViewModel
final class EditNicknameViewModel: EditUserInfoViewModel, Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  var disposeBag: DisposeBag = DisposeBag()
  /// 새로운 닉네임
  var newNickname = BehaviorRelay<String?>(value: nil)
  
  /// 닉네임 중복 확인
  var isCheckNicknameDuplication = PublishRelay<Bool>()
  
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
  }
  
  
  /// 닉네임 중복 체크
  /// 200 중복 X, 400 중복
  /// - Parameter nickname: 체크할 닉네임
  func checkNicknameDuplication(_ nickname: String){
    UserProfileManager.shared.checkNicknameDuplicationWithRx(nickname: nickname)
      .subscribe(onNext: { isValid in
        self.isCheckNicknameDuplication.accept(isValid)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    UserProfileManager.shared.checkNicknameDuplication(nickname: nickname, completion: { result in
//      print(#fileID, #function, #line," - \(result)")
//
//      self.isCheckNicknameDuplication.accept(result)
//    })
//    editUserInfoManager.checkNicknameDuplication(nickName: nickname) { result in
//      self.isCheckNicknameDuplication.accept(result)
//    }
  }
  
  
  /// 새로운 닉네임 저장
  /// - Parameter nickname: 저장할 닉네임
  func storeNicknameToServer(_ nickname: String){
    UserProfileManager.shared.editUserNicknameWithRx(nickname: nickname)
      .subscribe(onNext: { _ in
        self.updateUserData(nickname: nickname)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    UserProfileManager.shared.editUserNickname(nickname: nickname) { statusCode in
//#warning("코드 체크해보기")
//      print(statusCode)
//      self.updateUserData(nickname: nickname)
//    }

  }
  
  // MARK: - 유효성 검사
  
  
  func checkValidNickname(nickname: String) -> Bool {
    let pattern = "^[a-zA-Z0-9가-힣]*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: nickname.utf16.count)
    
    return regex?.firstMatch(in: nickname, options: [], range: range) != nil ? true : false
  }
}
