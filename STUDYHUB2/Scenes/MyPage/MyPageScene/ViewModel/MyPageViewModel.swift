
import UIKit

import RxRelay
import RxFlow


/// 마이페이지 ViewModel
final class MyPageViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  static let shared = MyPageViewModel()
  
  /// 사용자의 정보 데이터
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  
  /// 사용자 프로필
  var userProfile =  BehaviorRelay<UIImage?>(value: UIImage(named: "ProfileAvatar_change")!)

  /// 서비스 이용약관 URL
  var serviceURL: String? {
    return DataLoaderFromPlist.loadURLs()?["service"]
  }
  
  /// 개인정보 처리방침 URL
  var personalURL: String? {
    return DataLoaderFromPlist.loadURLs()?["personal"]
  }
  

  /// 사용자의 정보 가져오기
  func fetchUserData() {
    UserProfileManager.shared.fetchUserInfoToServer { userData in
      self.userData.accept(userData)
      print(#fileID, #function, #line," - \(userData)")

    }
  }
}

extension MyPageViewModel: ManagementImage {}
