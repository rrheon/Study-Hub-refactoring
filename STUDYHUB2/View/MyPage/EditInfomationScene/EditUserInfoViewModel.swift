
import Foundation

import RxRelay

class EditUserInfoViewModel: CommonViewModel {
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  
  init(userData: BehaviorRelay<UserDetailData?>) {
    self.userData = userData
  }
  
  func updateUserData(
    applyCount: Int? = nil,
    email: String? = nil,
    gender: String? = nil,
    imageURL: String? = nil,
    major: String? = nil,
    nickname: String? = nil,
    participateCount: Int? = nil,
    postCount: Int? = nil
  ) {
    guard var currentData = userData.value else { return }
    
    currentData.applyCount = applyCount ?? currentData.applyCount
    currentData.email = email ?? currentData.email
    currentData.gender = gender ?? currentData.gender
    currentData.imageURL = imageURL ?? currentData.imageURL
    currentData.major = major ?? currentData.major
    currentData.nickname = nickname ?? currentData.nickname
    currentData.participateCount = participateCount ?? currentData.participateCount
    currentData.postCount = postCount ?? currentData.postCount
    
    userData.accept(currentData)
  }
}
