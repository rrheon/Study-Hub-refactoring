
import UIKit

import SnapKit
import RxSwift

// 프로필이 일관적으로 적용이 안됨..
final class MyPageViewController: CommonNavi {
  let viewModel: MyPageViewModel
  
  private var userInfoView: UserInfoView
  private var userActivityView: UserActivityView
  private var serviceView: ServiceView
  
  override init(_ checkLoginStatus: Bool) {
    self.viewModel = MyPageViewModel(checkLoginStatus)
    self.userInfoView = UserInfoView(viewModel)
    self.userActivityView = UserActivityView(viewModel)
    self.serviceView = ServiceView(viewModel)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupNavigationbar()
    setupLayout()
    makeUI()
    
    setupActions()
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    [
      userInfoView,
      userActivityView,
      serviceView
    ].forEach {
      view.addSubview($0)
    }
  }
  
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
  
  func setupNavigationbar(){
    leftButtonSetting(imgName: "MyPageImg", activate: false)
    rightButtonSetting(imgName: "BookMarkImg")
  }
  
  // MARK: - setupActions
  
  
  func setupActions(){
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
      .disposed(by: viewModel.disposeBag)
    
    viewModel.uesrActivityTapped
      .subscribe(onNext: { [weak self] seleted in
        switch seleted {
        case .writtenButton:
          self?.moveToOtherVCWithSameNavi(vc: MyPostViewController(), hideTabbar: true)
        case .participateStudyButton:
          self?.moveToOtherVCWithSameNavi(vc: MyParticipateStudyVC(), hideTabbar: true)
        case .requestListButton:
          self?.moveToOtherVCWithSameNavi(vc: MyRequestListViewController(), hideTabbar: true)
        }
      })
      .disposed(by: viewModel.disposeBag)
    
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
          self?.moveToOtherVCWithSameNavi(vc: ServiceUseInfoViewContrller(), hideTabbar: true)
        case .privacyPolicy:
          self?.moveToOtherVCWithSameNavi(vc: PersonalInfoViewController(), hideTabbar: true)
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func moveToLoginVC() {
    viewModel.deleteToken()
    logout()
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    let data = BookMarkData(
      loginStatus: viewModel.checkLoginStatus.value,
      isNeedFetch: viewModel.isNeedFetch
    )
    moveToBookmarkView(sender, data: data)
  }
}

extension MyPageViewController: MoveToBookmarkView {}
extension MyPageViewController: Logout{}
