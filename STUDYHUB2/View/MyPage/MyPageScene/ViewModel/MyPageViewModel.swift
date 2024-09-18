//
//  MyPageViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/17/24.
//

import Foundation

import RxRelay

final class MyPageViewModel: CommonViewModel {
  let userInfoManager = UserInfoManager.shared

  var userData = BehaviorRelay<UserDetailData?>(value: nil)
  var checkLoginStatus = BehaviorRelay<Bool>(value: false)

  var managementProfileButton = PublishRelay<Bool>()
  
  init(_ checkLoginStatus: Bool) {
    self.checkLoginStatus.accept(checkLoginStatus)
    
    super.init()
    
    fetchUserData()
  }
  
  func fetchUserData() {
    userInfoManager.getUserInfo { result in
      self.userData.accept(result)
    }
  }
}

extension MyPageViewModel: ManagementImage {}
