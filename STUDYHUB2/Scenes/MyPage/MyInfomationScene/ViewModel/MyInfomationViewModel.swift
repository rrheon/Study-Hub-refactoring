
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

final class MyInfomationViewModel {
  private let tokenManager = TokenManager.shared

  
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  var userProfile = BehaviorRelay<UIImage?>(value: UIImage(named: "ProfileAvatar_change")!)
  var isUserProfileAction = PublishRelay<ProfileActions>()
  var editButtonTapped = PublishRelay<EditInfomationList>()
  
  init(_ userData: BehaviorRelay<UserDetailData?>, userProfile: BehaviorRelay<UIImage?>) {
    self.userData = userData
    self.userProfile = userProfile
  }
  
  // userdata에 업데이트 필요
  
  func deleteProfile(){
//    commonNetworking.moyaNetworking(networkingChoice: .deleteImage) { result in
//      switch result {
//      case.success(_):
//        KingfisherManager.shared.cache.clearMemoryCache()
//        KingfisherManager.shared.cache.clearDiskCache {}
//        self.isUserProfileAction.accept(ProfileActions.successToDelete)
//        self.userProfile.accept(UIImage(named: "ProfileAvatar_change")!)
//      case.failure(_):
//        self.isUserProfileAction.accept(ProfileActions.failToDelete)
//      }
//    }
  }
  
  func storeProfileToserver(image: UIImage){
//    commonNetworking.moyaNetworking(networkingChoice: .storeImage(image)) { result in
//      switch result {
//      case .success(_):
//        KingfisherManager.shared.cache.clearMemoryCache()
//        KingfisherManager.shared.cache.clearDiskCache {}
//        self.userProfile.accept(image)
//
//      case let .failure(error):
//        print(error.localizedDescription)
//      }
//    }
  }
  
//  func fetchUserProfile(){
//    guard let profile = userData.value?.imageURL,
//          let imageUrl = URL(string: profile) else { return }
//    getUserProfileImage(imageURL: imageUrl) { result in
//      switch result {
//      case .success(let image):
//        self.userProfile.accept(image)
//      case .failure(_):
//        self.isUserProfileAction.accept(.failToLoad)
//      }
//    }
//  }
  
  func deleteToken(){
    tokenManager.deleteTokens()
  }
}

extension MyInfomationViewModel: ManagementImage {}
