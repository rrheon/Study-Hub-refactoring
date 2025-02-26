
import UIKit

import RxRelay
import RxFlow

enum UserActivity {
  case writtenButton
  case participateStudyButton
  case requestListButton
}

enum Service {
  case notice
  case inquiry
  case howToUse
  case termsOfService
  case privacyPolicy
}

/// 마이페이지 ViewModel
final class MyPageViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  static let shared = MyPageViewModel()
  
  /// 사용자의 정보 데이터
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  var checkLoginStatus = BehaviorRelay<Bool>(value: false)
  var managementProfileButton = PublishRelay<Bool>()
  var userProfile =  BehaviorRelay<UIImage?>(value: UIImage(named: "ProfileAvatar_change")!)
  
  var isNeedFetch = PublishRelay<Bool>()
  var uesrActivityTapped = PublishRelay<UserActivity>()
  var serviceTapped = PublishRelay<Service>()
  
  var serviceURL: String? {
    return DataLoaderFromPlist.loadURLs()?["service"]
  }
  var personalURL: String? {
    return DataLoaderFromPlist.loadURLs()?["personal"]
  }
  
  init() {
    //    let isLoginStatus: Bool = TokenManager.shared.loadAccessToken()?.first != nil
    //    self.checkLoginStatus.accept(isLoginStatus)
//    fetchUserData()
  }
  
  /// 사용자의 정보 가져오기
  func fetchUserData() {
    UserProfileManager.shared.fetchUserInfoToServer { userData in
      self.userData.accept(userData)
      print(#fileID, #function, #line," - \(userData)")

    }
    //    userInfoManager.getUserInfo { result in
    //      self.userData.accept(result)
    //    }
  }
}

extension MyPageViewModel: ManagementImage {}
