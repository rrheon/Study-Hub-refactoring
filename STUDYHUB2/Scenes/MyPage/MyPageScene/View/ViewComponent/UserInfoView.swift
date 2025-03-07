
import UIKit

import SnapKit
import RxCocoa
import RxSwift
import Then

/// 유저의 정보 View
final class UserInfoView: UIView {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: MyPageViewModel
  
  /// 프로필 이미지View
  private lazy var profileImageView: UIImageView = UIImageView().then {
    $0.layer.cornerRadius = 15
    $0.image = UIImage(named: "ProfileAvatar_change")
  }
  
  /// 회원의 학과라벨
  private lazy var majorLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 14)
  }
 
  /// 회원의 닉네임 라벨
  private lazy var nickNameLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 18)
  }
  
  /// 비 로그인 시  라벨
  private lazy var loginFailLabel = UILabel().then {
    $0.text = "나의 스터디 팀원을 만나보세요"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 14)
  }

  /// 비 로그인 시 라벨
  private lazy var loginFailTitleLabel = UILabel().then {
    $0.text = "로그인 / 회원가입"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 18)
  }
  
  /// 로그인 시 - 프로필 편집으로 이동
  /// 비 로그인 시 - 로그인 화면으로 이동
  private lazy var managementProfileButton: UIButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    $0.tintColor = .black
  }
  
  private lazy var buttonStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
  
  init(_ viewModel: MyPageViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    makeCommonUI()
    self.setupBinding()
    self.setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - makeUI
  
  /// 공통UI 설정
  func makeCommonUI(){
    self.addSubview(managementProfileButton)
    managementProfileButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.width.equalTo(32)
    }
  }
  
  /// 로그인 시 UI
  func loginUI(){
    self.addSubview(profileImageView)
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
      $0.height.width.equalTo(56)
    }
    
    self.addSubview(majorLabel)
    majorLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView).offset(5)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    self.addSubview(nickNameLabel)
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(majorLabel.snp.bottom).offset(5)
      $0.leading.equalTo(majorLabel)
    }
  }
  
  /// 비로그인 시 UI
  func logoutLayout(){
    self.addSubview(loginFailLabel)
    loginFailLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.leading.equalToSuperview().offset(10)
    }
    
    self.addSubview(loginFailTitleLabel)
    loginFailTitleLabel.snp.makeConstraints {
      $0.top.equalTo(loginFailLabel.snp.bottom).offset(13)
      $0.leading.equalTo(loginFailLabel)
    }
  }
  
  
  /// 바인딩 설정
  func setupBinding(){
    /// 사용자의 정보데이터
    viewModel.userData
      .skip(1) // 초기값(nil) 방출 무시
      .distinctUntilChanged { $0?.nickname == $1?.nickname } // 같은 닉네임이면 UI 업데이트 안 함
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, nil))
      .drive(onNext: { (view, userData) in
        if let _ = userData?.nickname,
           let userData = userData {
          view.loginUI()
          view.setupUIData(userData)
        } else {
          view.logoutLayout()
        }
      })
      .disposed(by: disposeBag)
  
    /// 사용자의 프로필
    viewModel.userProfile
      .asDriver(onErrorJustReturn: UIImage(named: "ProfileAvatar_change")!)
      .drive(onNext: { [weak self] image in
        self?.profileImageView.image = image
        self?.profileImageView.layer.cornerRadius = 25
        self?.profileImageView.clipsToBounds = true
      })
      .disposed(by: disposeBag)
  }
  
  /// actions 설정
  func setupActions(){
    
    /// 로그인화면 / 프로필 편집화면으로 이동
    managementProfileButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (view, _) in
        

        if view.viewModel.isLoginStatus {
          /// 로그인 시 - 프로필 편집으로 이동
          NotificationCenter.default.post(name: .navToEditUserProfileScreen,
                                          object: nil,
                                          userInfo: ["userData" : view.viewModel.userData,
                                                     "userProfile": view.viewModel.userProfile])
        }else {
          /// 비 로그인 시 - 로그인 화면으로 이동
          TokenManager.shared.deleteTokens()
          NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// UI 데이터 설정
  func setupUIData(_ data: UserDetailData){
    // 닉네임
    self.nickNameLabel.text = data.nickname
    
    // 학과
    self.majorLabel.text = Utils.convertMajor(data.major ?? "", toEnglish: false)
    
    // 이미지
    if let imageURL = URL(string: data.imageURL ?? "") {
      viewModel.getUserProfileImage(imageURL: imageURL) { result in
        switch result {
        case .success(let image):
          self.viewModel.userProfile.accept(image)
        case .failure(_):
          self.viewModel.userProfile.accept(UIImage(named: "ProfileAvatar_change")!)
        }
      }
    }
  }
}

