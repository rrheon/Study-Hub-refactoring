
import UIKit

import SnapKit
import RxRelay
import RxCocoa

final class UserInfomationComponent: UIView {
  let viewModel: MyInfomationViewModel
  
  private lazy var nickNamekLabel = createLabel(
    title: "닉네임",
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var userNickNamekLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var nickNameEditButton = createArrowButton()

  private lazy var majorLabel = createLabel(
    title: "학과",
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var userMajorLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var editMajorButton = createArrowButton()
  
  private lazy var passwordLabel = createLabel(
    title: "비밀번호",
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var editPassworButton = createArrowButton()
  
  private lazy var genderLabel = createLabel(
    title: "성별",
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var userGenderLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var emailLabel = createLabel(
    title: "이메일",
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var userEmailLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  init(_ viewModel: MyInfomationViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    setUpLayout()
    makeUI()
    setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func createArrowButton() -> UIButton{
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .bg60
    return button
  }
  
  // MARK: - setUpLayout
  
  
  func setUpLayout(){
    [
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
      userEmailLabel
    ].forEach {
      self.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    nickNamekLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview()
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
  }
  
  func setupBinding(){
    viewModel.userData
      .asDriver()
      .drive(onNext: { [weak self] in
        guard let userData = $0 else { return }
        self?.setupUserInfo(userData)
      })
      .disposed(by: viewModel.disposeBag)
    
    
    let buttonList: [(UIButton, EditInfomationList)] = [
      (nickNameEditButton, .nickname),
      (editMajorButton, .major),
      (editPassworButton, .password)
    ]
    
    buttonList.forEach { button, action in
      button.rx.tap
        .subscribe(onNext: {[weak self] in
          self?.viewModel.editButtonTapped.accept(action)
        })
        .disposed(by: viewModel.disposeBag)
    }
  }
  
  func setupUserInfo(_ data: UserDetailData){
    userNickNamekLabel.text = data.nickname
    userEmailLabel.text = data.email
  
    guard let major = data.major, let gender = data.gender else { return }
    userMajorLabel.text = convertMajor(major, toEnglish: false)
    userGenderLabel.text = convertGender(gender: gender)
  }
}

extension UserInfomationComponent: CreateLabel{}
extension UserInfomationComponent: Convert {}
