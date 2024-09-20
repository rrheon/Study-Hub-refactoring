
import Foundation

import RxRelay
import Kingfisher

enum EditInfomationList {
  case nickname
  case deleteProfile
  case editProfile
  case major
  case password
  case logout
  case deleteAccount
}

enum ProfileActions {
  case failToLoad
  case successToDelete
  case failToDelete
  case successToEdit
  case failToEdit
}

final class MyInfomationViewModel: CommonViewModel {
  private let tokenManager = TokenManager.shared
  private let editUserInfo = EditUserInfoManager.shared
  private let commonNetworking = CommonNetworking.shared
  
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  var userProfile = PublishRelay<UIImage>()
  var isUserProfileAction = PublishRelay<ProfileActions>()
  var editButtonTapped = PublishRelay<EditInfomationList>()
  
  init(_ userData: BehaviorRelay<UserDetailData?>) {
    self.userData = userData
    super.init()
  }
  
  // userdata에 업데이트 필요
  func deleteProfile(){
    userProfile.accept(UIImage(named: "ProfileAvatar_change")!)
    commonNetworking.moyaNetworking(networkingChoice: .deleteImage) { result in
      switch result {
      case.success(_):
        self.isUserProfileAction.accept(ProfileActions.successToDelete)
      case.failure(_):
        self.isUserProfileAction.accept(ProfileActions.failToDelete)
      }
    }
  }
  
  func storeProfileToserver(image: UIImage){
    userProfile.accept(image)
    commonNetworking.moyaNetworking(networkingChoice: .storeImage(image)) { result in
      switch result {
      case .success(_):
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache {}
      case let .failure(error):
        print(error.localizedDescription)
      }
    }
  }
  
  func fetchUserProfile(){
    guard let profile = userData.value?.imageURL,
          let imageUrl = URL(string: profile) else { return }
    getUserProfileImage(imageURL: imageUrl) { result in
      switch result {
      case .success(let image):
        self.userProfile.accept(image)
      case .failure(_):
        self.isUserProfileAction.accept(.failToLoad)
      }
    }
  }
  
  func deleteToken(){
    tokenManager.deleteTokens()
  }
  
  func updateUserInfo(){
//    var data = UserDetailData(
//      applyCount: <#T##Int?#>,
//      email: <#T##String?#>,
//      gender: <#T##String?#>,
//      imageURL: <#T##String?#>,
//      major: <#T##String?#>,
//      nickname: <#T##String?#>,
//      participateCount: <#T##Int?#>,
//      postCount: <#T##Int?#>
//    )
  }

}

extension MyInfomationViewModel: ManagementImage {}
