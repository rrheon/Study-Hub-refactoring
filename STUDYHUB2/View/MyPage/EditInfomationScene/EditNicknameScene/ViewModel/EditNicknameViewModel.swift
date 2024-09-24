
import Foundation

import RxRelay

final class EditNicknameViewModel: EditUserInfoViewModel {
  let editUserInfoManager = EditUserInfoManager.shared
  
  var newNickname = BehaviorRelay<String?>(value: nil)
  var isCheckNicknameDuplication = PublishRelay<String>()
  
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
  }
  
  func checkNicknameDuplication(_ nickname: String){
    editUserInfoManager.checkNicknameDuplication(nickName: nickname) { result in
      self.isCheckNicknameDuplication.accept(result)
    }
  }
  
  func storeNicknameToServer(_ nickname: String){
    editUserInfoManager.editUserNickname(nickname) {
      // 예외처리 필요
      print($0)
      self.updateUserData(nickname: nickname)
    }
  }
  
  // MARK: - 유효성 검사
  
  
  func checkValidNickname(nickname: String) -> Bool {
    let pattern = "^[a-zA-Z0-9가-힣]*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: nickname.utf16.count)
    
    return regex?.firstMatch(in: nickname, options: [], range: range) != nil ? true : false
  }
}
