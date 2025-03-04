
import Foundation

import RxRelay
import RxFlow
import Kingfisher


/// 사용자 프로필 관리에 대한 Actions
enum ProfileActions {
  
  /// 프로필 사진 삭제 성공 시
  case successToDelete
  
  /// 사진 삭제에 실패한 경우
  case failToDelete
  
  /// 프로필 사진 변경에 성공 시
  case successToEdit
  
  /// 프로필 사진 변경에 실패 시
  case failToEdit
}

/// 내 정보 관리 ViewModel
final class MyInfomationViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  /// 사용자의 정보
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  
  /// 사용자의 프로필 정보
  var userProfile = BehaviorRelay<UIImage?>(value: UIImage(named: "ProfileAvatar_change")!)
  
  /// 프로필 변경에 대한 actions
  var isUserProfileAction = PublishRelay<ProfileActions>()
  
  init(_ userData: BehaviorRelay<UserDetailData?>, userProfile: BehaviorRelay<UIImage?>) {
    self.userData = userData
    self.userProfile = userProfile
  }
    
  
  /// 현재 프로필 이미지 삭제(기본 이미지로 변경)
  func deleteProfile(){
    UserProfileManager.shared.deleteProfile { result in
      if result {
        // 삭제에 성공한 경우 캐시 지우기
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache {}
        
        // 기본 이미지로 변경
        self.isUserProfileAction.accept(ProfileActions.successToDelete)
        self.userProfile.accept(UIImage(named: "ProfileAvatar_change")!)
      }else {
        // 삭제에 실패한 경우
        self.isUserProfileAction.accept(ProfileActions.failToDelete)
      }
    }
  }
  
  
  /// 프로필 이미지 변경 후 저장
  /// - Parameter image: 저장할 이미지
  func storeProfileToserver(image: UIImage){
    UserProfileManager.shared.storeProfileToserver(image: image) { result in
      if result {
        // 변경에 성공한 경우
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache {}
        self.userProfile.accept(image)
        
        self.isUserProfileAction.accept(ProfileActions.successToEdit)
      }else {
        // 변경에 실패한 경우
        self.isUserProfileAction.accept(ProfileActions.failToEdit)
      }
    }
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

}

extension MyInfomationViewModel: ManagementImage {}
