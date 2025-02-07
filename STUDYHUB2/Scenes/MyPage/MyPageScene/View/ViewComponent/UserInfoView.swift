
import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class UserInfoView: UIView {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: MyPageViewModel
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "ProfileAvatar_change")
 
    return imageView
  }()
  
  private lazy var majorLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 14
  )
  
  private lazy var nickNameLabel = createLabel(
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 18
  )
  
  // 로그인 안하면 보이는 라벨
  private lazy var loginFailLabel = createLabel(
    title: "나의 스터디 팀원을 만나보세요",
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 14
  )
  
  private lazy var loginFailTitleLabel = createLabel(
    title: "로그인 / 회원가입",
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 18
  )
  
  private lazy var managementProfileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  private lazy var buttonStackView = createStackView(axis: .vertical, spacing: 10)
  
  init(_ viewModel: MyPageViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupBinding()
    self.setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    viewModel.checkLoginStatus.value ? loginLayout() : logoutLayout()
    
    self.addSubview(managementProfileButton)
  }
  
  func loginLayout(){
    [
      profileImageView,
      majorLabel,
      nickNameLabel
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func logoutLayout(){
    [
      loginFailLabel,
      loginFailTitleLabel
    ].forEach {
      self.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    viewModel.checkLoginStatus.value ? loginUI() : logoutUI()

    managementProfileButton.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.width.equalTo(32)
    }
  }
  
  func loginUI(){
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
      $0.height.width.equalTo(56)
    }
    
    majorLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView).offset(5)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(majorLabel.snp.bottom).offset(5)
      $0.leading.equalTo(majorLabel)
    }
  }
  
  func logoutUI(){
    loginFailLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(13)
      $0.leading.equalToSuperview().offset(10)
    }
    
    loginFailTitleLabel.snp.makeConstraints {
      $0.top.equalTo(loginFailLabel.snp.bottom).offset(13)
      $0.leading.equalTo(loginFailLabel)
    }
  }
  
  func setupBinding(){
    viewModel.userData
      .asDriver()
      .drive(onNext: { [weak self] in
        guard let data = $0 else { return }
        self?.setupUIData(data)
      })
      .disposed(by: disposeBag)
    
    viewModel.userProfile
      .asDriver(onErrorJustReturn: UIImage(named: "ProfileAvatar_change")!)
      .drive(onNext: { [weak self] image in
        self?.profileImageView.image = image
        self?.profileImageView.layer.cornerRadius = 25
        self?.profileImageView.clipsToBounds = true
      })
      .disposed(by: disposeBag)
  }
  
  func setupActions(){
    managementProfileButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let loginStauts = viewModel.checkLoginStatus.value
        viewModel.managementProfileButton.accept(loginStauts)
      })
      .disposed(by: disposeBag)
  }
  
  func setupUIData(_ data: UserDetailData){
    self.nickNameLabel.text = data.nickname
    self.majorLabel.text = self.convertMajor(data.major ?? "", toEnglish: false)
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

extension UserInfoView: CreateUIprotocol {}
extension UserInfoView: ConvertMajor {}
