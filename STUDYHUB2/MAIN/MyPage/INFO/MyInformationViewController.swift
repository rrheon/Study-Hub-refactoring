import UIKit
import AVFoundation
import Photos

import SnapKit
import Moya
import Kingfisher

final class MyInformViewController: NaviHelper {
  let tokenManager = TokenManager.shared
  
  var major: String? {
    didSet {
      userMajorLabel.text = major
    }
  }
  var nickname: String? {
    didSet {
      userNickNamekLabel.text = nickname
    }
  }
  var email: String?
  var gender: String?
  var profileImage: String? {
    didSet {
      if let imageURL = URL(string: profileImage ?? "") {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 56, height: 56))
        self.profileImageView.kf.setImage(with: imageURL, options: [.processor(processor)])
        self.profileImageView.layer.cornerRadius = 35
        self.profileImageView.clipsToBounds = true
      }
    }
  }
  
  let editUserInfo = EditUserInfoManager.shared
  var previousVC: MyPageViewController?
  
  // 프로필 이미지
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "ProfileAvatar_change")
    
    return imageView
  }()
  
  //이미지 삭제, 변경
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("삭제", for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    button.setTitleColor(.bg70, for: .normal)
    button.addAction(UIAction { _ in
      self.deleteProfileButtonTapped()
    } , for: .touchUpInside)
    return button
  }()
  
  private lazy var editButton: UIButton = {
    let button = UIButton()
    button.setTitle("변경", for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    button.setTitleColor(.o50, for: .normal)
    button.addAction(UIAction { _ in
      self.editProfileButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  //닉네임
  private lazy var nickNamekLabel = createLabel(title: "닉네임",
                                                textColor: .black,
                                                fontType: "Pretendard",
                                                fontSize: 16)
  
  private lazy var userNickNamekLabel = createLabel(title: nickname ?? "없음",
                                                    textColor: .bg80,
                                                    fontType: "Pretendard",
                                                    fontSize: 16)
  
  private lazy var nickNameEditButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .bg60
    button.addAction(UIAction { _ in
      self.nickNameEditButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  //학과
  private lazy var majorLabel = createLabel(title: "학과",
                                            textColor: .black,
                                            fontType: "Pretendard",
                                            fontSize: 16)
  
  private lazy var userMajorLabel = createLabel(title: major ?? "없음",
                                                textColor: .bg80,
                                                fontType: "Pretendard",
                                                fontSize: 16)
  
  private lazy var editMajorButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .bg60
    button.addAction(UIAction { _ in
      self.majorEditButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  //비밀번호
  private lazy var passwordLabel = createLabel(title: "비밀번호",
                                               textColor: .black,
                                               fontType: "Pretendard",
                                               fontSize: 16)
  
  
  private lazy var editPassworButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .bg60
    button.addAction(UIAction { _ in
      self.passwordEditButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  //성별
  private lazy var genderLabel = createLabel(title: "성별",
                                             textColor: .black,
                                             fontType: "Pretendard",
                                             fontSize: 16)
  
  private lazy var userGenderLabel = createLabel(title: gender ?? "없음",
                                                 textColor: .bg80,
                                                 fontType: "Pretendard",
                                                 fontSize: 16)
  
  //이메일
  private lazy var emailLabel = createLabel(title: "이메일",
                                            textColor: .black,
                                            fontType: "Pretendard",
                                            fontSize: 16)
  
  private lazy var userEmailLabel = createLabel(title: email ?? "없음",
                                                textColor: .bg80,
                                                fontType: "Pretendard",
                                                fontSize: 16)
  
  private let dividerLine: UIView = {
    let DividerLine = UIView()
    DividerLine.backgroundColor = UIColor(hexCode: "#F3F5F6")
    DividerLine.heightAnchor.constraint(equalToConstant: 10).isActive = true
    return DividerLine
  }()
  
  
  private lazy var logoutButton = createMypageButton(title: "로그아웃")
  private lazy var quitButton = createMypageButton(title: "탈퇴하기")
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent {
      previousVC?.changedUserNickname = nickname
      previousVC?.changedUserMajor = major
      previousVC?.fetchUserData()
    }
  }
  
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationBar()
    
    setUpLayout()
    makeUI()
    
    
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      profileImageView,
      deleteButton,
      editButton,
      nickNamekLabel,
      userNickNamekLabel,
      nickNameEditButton,
      majorLabel,
      userMajorLabel,
      editMajorButton,
      passwordLabel,
      editPassworButton,
      genderLabel,
      userGenderLabel,
      emailLabel,
      userEmailLabel,
      dividerLine,
      logoutButton,
      quitButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    // 프로필
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.width.height.equalTo(80)
      $0.centerX.equalToSuperview()
    }
    
    deleteButton.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.leading)
      $0.top.equalTo(profileImageView.snp.bottom).offset(10)
    }
    
    editButton.snp.makeConstraints {
      $0.trailing.equalTo(profileImageView.snp.trailing)
      $0.top.equalTo(profileImageView.snp.bottom).offset(10)
    }
    
    // 닉네임
    nickNamekLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(deleteButton.snp.bottom).offset(20)
    }
    
    nickNameEditButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(nickNamekLabel)
    }
    
    userNickNamekLabel.snp.makeConstraints {
      $0.trailing.equalTo(nickNameEditButton.snp.leading).offset(-10)
      $0.centerY.equalTo(nickNamekLabel)
    }
    
    // 학과
    majorLabel.snp.makeConstraints {
      $0.leading.equalTo(nickNamekLabel)
      $0.top.equalTo(nickNamekLabel.snp.bottom).offset(30)
    }
    
    editMajorButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(majorLabel)
    }
    
    userMajorLabel.snp.makeConstraints {
      $0.trailing.equalTo(editMajorButton.snp.leading).offset(-10)
      $0.centerY.equalTo(majorLabel)
    }
    
    // 비밀번호
    passwordLabel.snp.makeConstraints {
      $0.leading.equalTo(nickNamekLabel)
      $0.top.equalTo(majorLabel.snp.bottom).offset(30)
    }
    
    editPassworButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(passwordLabel)
    }
    
    // 성별
    genderLabel.snp.makeConstraints {
      $0.leading.equalTo(nickNamekLabel)
      $0.top.equalTo(passwordLabel.snp.bottom).offset(30)
    }
    
    userGenderLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(genderLabel)
    }
    
    // 이메일
    emailLabel.snp.makeConstraints {
      $0.leading.equalTo(nickNamekLabel)
      $0.top.equalTo(genderLabel.snp.bottom).offset(30)
    }
    
    userEmailLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(emailLabel)
    }
    
    // 구분선
    dividerLine.snp.makeConstraints {
      $0.top.equalTo(emailLabel.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview()
    }
    
    logoutButton.addAction(UIAction { _ in
      self.logoutButtonTapped()
    }, for: .touchUpInside)
    
    logoutButton.snp.makeConstraints {
      $0.leading.equalTo(nickNamekLabel)
      $0.top.equalTo(dividerLine.snp.bottom).offset(30)
    }
    
    quitButton.addAction(UIAction { _ in
      self.quitButtonTapped()
    }, for: .touchUpInside)
    quitButton.snp.makeConstraints {
      $0.leading.equalTo(nickNamekLabel)
      $0.top.equalTo(logoutButton.snp.bottom).offset(30)
    }
  }
  
  // MARK: - 네비게이션바 재설정
  func redesignNavigationBar(){
    navigationItem.rightBarButtonItem = .none

    settingNavigationTitle(title: "내 정보",
                           font: "Pretendard-Bold",
                           size: 18)
  }
  
  // MARK: - 프로필 사진 관련 함수
  // 삭제
  func deleteProfileButtonTapped(){
    profileImageView.image = UIImage(named: "ProfileAvatar_change")
    
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.deleteImage) {
      switch $0 {
      case.success(let response):
        self.showToast(message: "사진이 삭제됐어요.", alertCheck: true)
      case.failure(let response):
        print(response.response)
      }
    }
  }
  
  // 변경
  func editProfileButtonTapped(){
    let bottomSheetVC = BottomSheet(postID: 0,
                                    firstButtonTitle: "사진 촬영하기" ,
                                    secondButtonTitle: "앨범에서 선택하기")
    bottomSheetVC.delegate = self
    
    if #available(iOS 15.0, *) {
      if let sheet = bottomSheetVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return 228.0
          })]
        } else {
          // Fallback on earlier versions
        }
        sheet.largestUndimmedDetentIdentifier = nil
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheet.preferredCornerRadius = 20
      }
    } else {
      // Fallback on earlier versions
    }
    present(bottomSheetVC, animated: true, completion: nil)
  }
  
  // 닉네임 변경
  func nickNameEditButtonTapped(){
    let editNickNameVC = EditnicknameViewController()
    editNickNameVC.previousVC = self
    editNickNameVC.changeNickname = nickname
    editNickNameVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(editNickNameVC, animated: true)
  }
  
  // 학과 변경
  func majorEditButtonTapped(){
    let editMajorVC = EditMajorViewController()
    editMajorVC.previousVC = self
    editMajorVC.beforeMajor = major
    editMajorVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(editMajorVC, animated: true)
  }
  
  // MARK: - 비밀번호 변경 버튼
  func passwordEditButtonTapped(){
    let editPasswordVC = FindPasswordViewController()
    editPasswordVC.previousVC = self
    editPasswordVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(editPasswordVC, animated: true)
  }
  
  // MARK: - 로그아웃 버튼
  func logoutButtonTapped(){
    let popupVC = PopupViewController(title: "로그아웃 하시겠어요?",
                                      desc: "",
                                      leftButtonTitle: "아니요",
                                      rightButtonTilte: "네")
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = { [weak self] in
      self?.tokenManager.deleteTokens()
      
      self?.dismiss(animated: true) {
        self?.bookmarkList.removeAll()
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .overFullScreen
        self?.present(loginVC, animated: true, completion: nil)
      }
    }
  }
  
  // MARK: - 탈퇴하기
  func quitButtonTapped(){
    let quitVC = DeleteIDViewContoller()
    quitVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(quitVC, animated: true)
  }
}

// MARK: - bottomSheet Delegate
extension MyInformViewController: BottomSheetDelegate {
  // 프로필 이미지 변경
  func changeProfileImage(type: UIImagePickerController.SourceType){
    self.dismiss(animated: true)
    
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    picker.allowsEditing = true
    self.present(picker, animated: true)
  }
  
  func firstButtonTapped(postID: Int?) {
//    changeProfileImage(type: .camera)
    requestCameraAccess()

  }
  
  // 앨범에서 선택하기
  func secondButtonTapped(postID: Int?) {
//    changeProfileImage(type: .photoLibrary)
    requestPhotoLibraryAccess()

  }
  
  func requestCameraAccess() {
    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
      if granted {
        DispatchQueue.main.async {
          self?.changeProfileImage(type: .camera)
        }
      } else {
        DispatchQueue.main.async {
          self?.showAccessDeniedAlert()
        }
      }
    }
  }
  
  func requestPhotoLibraryAccess() {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        DispatchQueue.main.async {
          self?.changeProfileImage(type: .photoLibrary)
        }
      case .denied, .restricted:
        DispatchQueue.main.async {
          self?.showAccessDeniedAlert()
        }
      case .notDetermined:
        self?.requestPhotoLibraryAccess()
      default:
        break
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
    
    popupVC.popupView.leftButtonAction = {
      self.dismiss(animated: true, completion: nil)
    }
    
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
extension MyInformViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
      DispatchQueue.main.async {
        self.profileImageView.image = image
        self.profileImageView.layer.cornerRadius = 20
        self.profileImageView.clipsToBounds = true
      }
      
      let provider = MoyaProvider<networkingAPI>()
      provider.request(.storeImage(image)) { result in
        switch result {
        case .success(let response):
          
          // Clear image cache
          KingfisherManager.shared.cache.clearMemoryCache()
          KingfisherManager.shared.cache.clearDiskCache {
            
          }
          
        case let .failure(error):
          print(error.localizedDescription)
        }
      }
      
      self.dismiss(animated: true)
    }
  }
}
