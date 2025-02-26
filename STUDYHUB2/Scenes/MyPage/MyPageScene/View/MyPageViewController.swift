
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
    setupLayout()
    makeUI()
    
    setupActions()
  } // viewDidLoad
  
  // MARK: - setupLayout
  
  
  /// Layout 설정
  func setupLayout(){
    [ userInfoView, userActivityView, serviceView]
      .forEach { view.addSubview($0) }
  }
  
  /// UI설정
  func makeUI(){
    userInfoView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(60)
    }
    
    userActivityView.snp.makeConstraints {
      $0.top.equalTo(userInfoView.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(119)
    }
    
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
  
  /// 네비게이션 왼쪽 버튼 탭 - 현재 탭 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(HomeStep.popScreenIsRequired)
  }
    
  /// 네비게이션 바 오른쪽 버튼 탭 - 북마크 화면으로 이동
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    NotificationCenter.default.post(name: .navToBookmarkScreen, object: nil)
  }
  
  // MARK: - setupActions
  
  /// Actions 설정
  func setupActions(){
    /// 로그인 시 -> 프로필 편집, 비로그인 시 -> 모든 화면 내리고 로그인 화면으로
    viewModel.managementProfileButton
      .subscribe(onNext: { [weak self] loginStatus in
        guard let self = self else { return }
        switch loginStatus {
        case true:
          moveToOtherVCWithSameNavi(
            vc: MyInformViewController(viewModel.userData, profile: viewModel.userProfile),
            hideTabbar: true
          )
        case false :
          moveToLoginVC()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.uesrActivityTapped
      .subscribe(onNext: { [weak self] seleted in
//        guard let userData = self?.viewModel.userData,
//              let self = self else { return }
//        let loginStauts = viewModel.checkLoginStatus.value
//        switch loginStauts {
//        case true:
//          switch seleted {
//          case .writtenButton:
//            self.moveToOtherVCWithSameNavi(vc: MyPostViewController(userData), hideTabbar: true)
//          case .participateStudyButton:
//            self.moveToOtherVCWithSameNavi(vc: MyParticipateStudyVC(userData), hideTabbar: true)
//          case .requestListButton:
//            self.moveToOtherVCWithSameNavi(vc: MyRequestListViewController(userData), hideTabbar: true)
//          }
//        case false:
//          checkLoginPopup(checkUser: false)
//        }
      })
      .disposed(by: disposeBag)
    
    viewModel.serviceTapped
      .subscribe(onNext: { [weak self] seleted in
        guard let loginStatus = self?.viewModel.checkLoginStatus.value else { return }
        switch seleted {
        case .notice:
          self?.moveToOtherVCWithSameNavi(vc: NotificationViewController(), hideTabbar: true)
        case .inquiry:
          self?.moveToOtherVCWithSameNavi(vc: InquiryViewController(), hideTabbar: true)
        case .howToUse:
          self?.moveToOtherVCWithSameNavi(vc: HowToUseViewController(loginStatus), hideTabbar: true)
        case .termsOfService:
          self?.moveToPage(url: self?.viewModel.serviceURL ?? "")
        case .privacyPolicy:
          self?.moveToPage(url: self?.viewModel.personalURL ?? "")
        }
      })
      .disposed(by: disposeBag)
  }
  
  func moveToLoginVC() {
    TokenManager.shared.deleteTokens()
    logout()
  }
  
//  override func rightButtonTapped(_ sender: UIBarButtonItem) {
//    let data = BookMarkData(
//      loginStatus: viewModel.checkLoginStatus.value,
//      isNeedFetch: viewModel.isNeedFetch
//    )
//    let vc = BookmarkViewController(data)
//    vc.hidesBottomBarWhenPushed = true
//    self.navigationController?.pushViewController(vc, animated: true)
//  }
//  
  func moveToPage(url: String) {
    if let url = URL(string: url) {
      let urlView = SFSafariViewController(url: url)
      present(urlView, animated: true)
    }
  }
}

extension MyPageViewController: Logout{}
