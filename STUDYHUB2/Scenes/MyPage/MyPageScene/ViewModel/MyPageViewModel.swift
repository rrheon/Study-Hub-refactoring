
import UIKit

import RxSwift
import RxRelay
import RxFlow


/// 마이페이지 ViewModel
final class MyPageViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  static let shared = MyPageViewModel()
  
  /// 사용자의 정보 데이터
  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  
  /// 로그인 상태 체크
  var isLoginStatus: Bool {
    return userData.value?.nickname != nil
  }
  
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
    UserProfileManager.shared.fetchUserInfoToServerWithRx()
      .subscribe(onNext: { userData in
        self.userData.accept(userData)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
    
//    UserProfileManager.shared.fetchUserInfoToServer { userData in
//      self.userData.accept(userData)
//      print(#fileID, #function, #line," - \(userData)")
//
//    }
  }
}

extension MyPageViewModel: ManagementImage {}
