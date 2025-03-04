
import UIKit
import SafariServices

import SnapKit
import RxSwift

/// 마이페이지 VC
final class MyPageViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: MyPageViewModel = MyPageViewModel.shared
  
  /// 유저의 정보 View
  private lazy var userInfoView: UserInfoView = UserInfoView(viewModel)
  
  /// 유저의 활동정보 View - 작성한 글, 참여한 스터디, 신청내역
  private lazy var userActivityView: UserActivityView = UserActivityView(viewModel)
  
  /// 서비스 View - 공지사항, 문의하기, 이용방법, 서비스 이용약관, 개인정보 처리방침
  private lazy var serviceView: ServiceView = ServiceView(viewModel)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupNavigationbar()
    makeUI()

    viewModel.fetchUserData()
  } // viewDidLoad
  

  /// UI설정
  func makeUI(){
    view.addSubview(userInfoView)
    userInfoView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(60)
    }
    
    view.addSubview(userActivityView)
    userActivityView.snp.makeConstraints {
      $0.top.equalTo(userInfoView.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(119)
    }
    
    view.addSubview(serviceView)
    serviceView.snp.makeConstraints {
      $0.top.equalTo(userActivityView.snp.bottom).offset(10)
      $0.leading.equalTo(userInfoView.snp.leading).offset(15)
      $0.height.equalTo(250)
    }
  }
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    leftButtonSetting(imgName: "MyPageImg", activate: false)
    rightButtonSetting(imgName: "BookMarkImg")
    settingNavigationbar()
  }
  
    
  /// 네비게이션 바 오른쪽 버튼 탭 - 북마크 화면으로 이동
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    NotificationCenter.default.post(name: .navToBookmarkScreen, object: nil)
  }
}

extension MyPageViewController: PopupViewDelegate {
  func leftBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
  }
  
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    TokenManager.shared.deleteTokens()
    NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
  }
}
