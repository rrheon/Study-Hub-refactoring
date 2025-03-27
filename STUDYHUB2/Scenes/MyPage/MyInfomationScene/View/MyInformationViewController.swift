
import AVFoundation
import UIKit
import Photos

import SnapKit
import RxSwift
import RxRelay

/// 내 정보 관리 VC
final class MyInformViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: MyInfomationViewModel
  
  /// 유저 프로필 View
  private var profileComponent: ProfileComponentView
  
  /// 유저 정보 관련
  private var userInfoComponent: UserInfomationComponentView
  
  /// 로그아웃 / 탈퇴 View
  private var exitComponent: ExitComponentView
  
  init(with viewModel: MyInfomationViewModel) {
    self.viewModel = viewModel
    
    self.profileComponent = ProfileComponentView(viewModel)
    self.userInfoComponent = UserInfomationComponentView(viewModel)
    self.exitComponent = ExitComponentView(viewModel)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
      
    setupNavigationbar()
    
    makeUI()
    
    setupActions()
    self.view.bringSubviewToFront(profileComponent)
  } // viewDidLoad

  
  // MARK: - makeUI
  
  
  /// UI 설정
  func makeUI(){
    view.addSubview(profileComponent)
    profileComponent.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(168)
      $0.width.equalTo(375)
    }
    
    view.addSubview(userInfoComponent)
    userInfoComponent.snp.makeConstraints {
      $0.top.equalTo(profileComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(5)
      $0.height.equalTo(250)
    }
    
    view.addSubview(exitComponent)
    exitComponent.snp.makeConstraints {
      $0.top.equalTo(userInfoComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(128)
    }
  }
  
  // MARK: - 네비게이션바
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    leftButtonSetting()
    settingNavigationTitle(title: "내 정보")
    settingNavigationbar()
  }
  
  /// 네비게이션 왼쪽 버튼 탭 - 현재 탭 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
    
  // MARK: - setupActions
  
  /// Actions 설정
  func setupActions(){
    viewModel.isUserProfileAction
      .subscribe(onNext: {[weak self] in
        self?.profileActions($0)
      })
      .disposed(by: disposeBag)
    
    }
   
  /// 프로필 액션 별 toast
  func profileActions(_ action: ProfileActions){
    switch action {
    case .successToDelete:
      ToastPopupManager.shared.showToast(message: "사진이 삭제됐어요.")
    case .failToDelete:
      ToastPopupManager.shared.showToast(message: "사진 삭제에 실패했어요. 다시 시도해주세요.", alertCheck: false)
    case .successToEdit:
      ToastPopupManager.shared.showToast(message: "사진이 변경됐어요.")
    case .failToEdit:
      ToastPopupManager.shared.showToast(message: "사진 변경에 실패했어요. 다시 시도해주세요.", alertCheck: false)
    default: return
    }
  }
}

// MARK: - PopupView Delegate


extension MyInformViewController: PopupViewDelegate {
  // 오른쪽 버튼 탭 -> 로그아웃의 경우  = 팝업 닫고 로그인 화면으로 이동, 프로필 변경 허용의 경우 = 허용 팝업
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    
    if popupCase == .logoutIsRequired {
      TokenManager.shared.deleteTokens()
      
      LoginStatusManager.shared.loginStatus = false
      NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
    }else{
      guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
      UIApplication.shared.open(settingsURL)
    }
  }
}

// MARK: - bottomSheet Delegate


extension MyInformViewController: BottomSheetDelegate {
  
  // 프로필 이미지 변경
  func changeProfileImage(type: UIImagePickerController.SourceType, checkPost: Bool){
    self.dismiss(animated: true)
    
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    picker.allowsEditing = true
    self.present(picker, animated: true)
  }
  
  /// bottomSheet 첫 번째 버튼 -> 촬영
  func firstButtonTapped(postOrCommentID postID: Int, bottomSheetCase: BottomSheetCase) {
    requestCameraAccess()
  }
  
  /// bottomSheet 두 번째 버튼 -> 갤러리에서 선택
  func secondButtonTapped(postOrCommentID postID: Int, bottomSheetCase: BottomSheetCase) {
    requestPhotoLibraryAccess()
  }
  
  /// 카메라 요청 허용
  func requestCameraAccess() {
    DispatchQueue.main.async {
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        if granted {
          self?.changeProfileImage(type: .camera, checkPost: false)
        }else {
          self?.showAccessDeniedAlert()
        }
      }
    }
  }
  
  /// 허용에 따른 actions
  func requestPhotoLibraryAccess() {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      DispatchQueue.main.async {
        switch status {
        case .authorized:
          self?.changeProfileImage(type: .photoLibrary, checkPost: false)
        case .denied, .restricted:
          self?.showAccessDeniedAlert()
        case .notDetermined:
          self?.requestPhotoLibraryAccess()
        default:
          break
        }
      }
    }
  }
  
  /// 프로필 사진 변경 허용 팝업
  func showAccessDeniedAlert() {
    viewModel.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .allowProfileImageChange)))
  }
}

// 사진 선택
extension MyInformViewController: UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
      viewModel.storeProfileToserver(image: image)
      
      viewModel.steps.accept(AppStep.navigation(.dismissCurrentScreen))
    }
  }
}
