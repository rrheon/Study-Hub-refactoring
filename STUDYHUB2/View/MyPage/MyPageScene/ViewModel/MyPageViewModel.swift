
import Foundation

import RxRelay

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

final class MyPageViewModel: CommonViewModel {
  let userInfoManager = UserInfoManager.shared
  let tokenManager = TokenManager.shared
  
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  var checkLoginStatus = BehaviorRelay<Bool>(value: false)
  var managementProfileButton = PublishRelay<Bool>()
  var userProfile =  BehaviorRelay<UIImage?>(value: UIImage(named: "ProfileAvatar_change")!)

  var isNeedFetch = PublishRelay<Bool>()
  var uesrActivityTapped = PublishRelay<UserActivity>()
  var serviceTapped = PublishRelay<Service>()
  
  var serviceURL: String = ""
  var personalURL: String = ""
  
  init(_ checkLoginStatus: Bool) {
    self.checkLoginStatus.accept(checkLoginStatus)
    super.init()
    fetchUserData()
    loadURLs()
  }
  
  func fetchUserData() {
    userInfoManager.getUserInfo { result in
      self.userData.accept(result)
    }
  }
  
  func deleteToken(){
    tokenManager.deleteTokens()
  }
  
  func seletUserActivity(_ seletedActivity: UserActivity){
    uesrActivityTapped.accept(seletedActivity)
  }
  
  func seletService(_ seletedService: Service) {
    serviceTapped.accept(seletedService)
  }
  
  private func loadURLs() {
    let urlData = DataLoaderFromPlist()
    if let serviceURLString = urlData.loadURLs()?["service"],
       let personalURLString = urlData.loadURLs()?["personal"] {
      serviceURL = serviceURLString
      personalURL = personalURLString
    }
  }
}

extension MyPageViewModel: ManagementImage {}
