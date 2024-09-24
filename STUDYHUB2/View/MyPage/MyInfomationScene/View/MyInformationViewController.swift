import AVFoundation
import UIKit
import Photos

import SnapKit
import RxRelay

final class MyInformViewController: CommonNavi {
  let viewModel: MyInfomationViewModel
  
  private var profileComponent: ProfileComponent
  private var userInfoComponent: UserInfomationComponent
  private var exitComponent: ExitComponent
  
  init(_ userData: BehaviorRelay<UserDetailData?>, profile:  BehaviorRelay<UIImage?>) {
    self.viewModel = MyInfomationViewModel(userData, userProfile: profile)
    
    self.profileComponent = ProfileComponent(viewModel)
    self.userInfoComponent = UserInfomationComponent(viewModel)
    self.exitComponent = ExitComponent(viewModel)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setUpLayout()
    makeUI()
    
    setupActions()
    self.view.bringSubviewToFront(profileComponent)
  }
  
  // MARK: - setUpLayout
  
  
  func setUpLayout(){
    [
      profileComponent,
      userInfoComponent,
      exitComponent
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    profileComponent.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(168)
      $0.width.equalTo(375)
    }

    userInfoComponent.snp.makeConstraints {
      $0.top.equalTo(profileComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(5)
      $0.height.equalTo(250)
    }

    exitComponent.snp.makeConstraints {
      $0.top.equalTo(userInfoComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(128)
    }
  }
  
  // MARK: - 네비게이션바
  
  
  func setupNavigationbar(){
    leftButtonSetting()
    settingNavigationTitle(title: "내 정보")
  }
  
  // MARK: - setupActions
  
  
  func setupActions(){
    viewModel.isUserProfileAction
      .subscribe(onNext: {[weak self] in
        self?.profileActions($0)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.editButtonTapped
      .subscribe(onNext: { [weak self] in
        self?.editActions($0)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func profileActions(_ action: ProfileActions){
    switch action {
    case .successToDelete:
      self.showToast(message: "사진이 삭제됐어요.", alertCheck: true)
    case .failToDelete:
      self.showToast(message: "사진 삭제에 실패했어요. 다시 시도해주세요.", alertCheck: false)
    case .successToEdit:
      self.showToast(message: "사진이 변경됐어요.", alertCheck: true)
    case .failToEdit:
      self.showToast(message: "사진 변경에 실패했어요. 다시 시도해주세요.", alertCheck: false)
    case .failToLoad:
      return
    }
  }
  
  func editActions(_ action: EditInfomationList){
    let userData = viewModel.userData
    
    switch action {
    case .nickname:
      moveToOtherVCWithSameNavi(vc: EditnicknameViewController(userData), hideTabbar: true)
      return
    case .major:
      moveToOtherVCWithSameNavi(vc: EditMajorViewController(userData), hideTabbar: true)
    case .password:
      moveToOtherVCWithSameNavi(vc: EditPasswordViewController(), hideTabbar: true)
    case .logout:
      logoutButtonTapped()
    case .deleteAccount:
      moveToOtherVCWithSameNavi(vc: DeleteIDViewContoller(), hideTabbar: true)
    case .editProfile:
      editProfileButtonTapped()
    case .deleteProfile:
      viewModel.deleteProfile()
    }
  }
  
  func editProfileButtonTapped(){
    let bottomSheetVC = BottomSheet(
      postID: 0,
      firstButtonTitle: "사진 촬영하기" ,
      secondButtonTitle: "앨범에서 선택하기",
      checkPost: false
    )
    bottomSheetVC.delegate = self
    showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    present(bottomSheetVC, animated: true, completion: nil)
  }


  // MARK: - 로그아웃 버튼
  
  
  func logoutButtonTapped(){
    let popupVC = PopupViewController(
      title: "로그아웃 하시겠어요?",
      desc: "",
      leftButtonTitle: "아니요",
      rightButtonTilte: "네"
    )
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = { [weak self] in
      self?.viewModel.deleteToken()
      self?.dismiss(animated: true) {
        self?.logout()
      }
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
  
  func firstButtonTapped(postID: Int, checkPost: Bool) {
    requestCameraAccess()
  }
  
  func secondButtonTapped(postID: Int, checkPost: Bool) {
    requestPhotoLibraryAccess()
  }
  
  func requestCameraAccess() {
    DispatchQueue.main.async {
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        granted ? self?.changeProfileImage(
          type: .camera,
          checkPost: false
        ) : self?.showAccessDeniedAlert()
      }
    }
  }
  
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
  
  func showAccessDeniedAlert() {
    let popupVC = PopupViewController(
      title: "사진을 변경하려면 허용이 필요해요",
      desc: "",
      leftButtonTitle: "취소",
      rightButtonTilte: "설정"
    )

    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true) {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
      }
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
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
      self.dismiss(animated: true)
    }
  }
}

extension MyInformViewController: ShowBottomSheet{}
extension MyInformViewController: Logout{}
