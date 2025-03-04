
import UIKit

import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import Then

/// 유저 정보 관련 View
final class UserInfomationComponentView: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: MyInfomationViewModel
  
  /// 닉네임 제목 라벨
  private lazy var nickNamekLabel = UILabel().then {
    $0.text = "닉네임"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 16)
  }
  
  /// 사용자의 닉네임 라벨
  private lazy var userNickNamekLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 16)
  }

  /// 닉네임 수정버튼
  private lazy var nickNameEditButton = createArrowButton()

  /// 학과 제목라벨
  private lazy var majorLabel = UILabel().then {
    $0.text = "학과"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 16)
  }
  
  /// 사용자의 학과 라벨
  private lazy var userMajorLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 16)
  }

  /// 학과 수정 버튼
  private lazy var editMajorButton = createArrowButton()
  
  /// 비밀번호 제목 라벨
  private lazy var passwordLabel = UILabel().then {
    $0.text = "비밀번호"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 16)
  }

  /// 비밀번호 수정 버튼
  private lazy var editPassworButton = createArrowButton()
  
  /// 성별 제목 라벨
  private lazy var genderLabel = UILabel().then {
    $0.text = "성별"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 16)
  }
  
  /// 유저의 성별 라벨
  private lazy var userGenderLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 16)
  }

  /// 이메일 제목라벨
  private lazy var emailLabel = UILabel().then {
    $0.text = "이메일"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 16)
  }
  
  /// 사용자의 이메일 라벨
  private lazy var userEmailLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 16)
  }
  
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
  
  /// 화살표 버튼  생성
  func createArrowButton() -> UIButton{
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .bg60
    return button
  }
  
  // MARK: - setUpLayout
  
  /// layout 설정
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
  
  
  /// UI 설정
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
  
  /// 바인딩 설정
  func setupBinding(){
    /// 사용자의 정보
    viewModel.userData
      .asDriver()
      .drive(onNext: { [weak self] in
        guard let userData = $0 else { return }
        self?.setupUserInfo(userData)
      })
      .disposed(by: disposeBag)
    
    // 닉네임 수정버튼 탭
    nickNameEditButton
      .rx
      .tap
      .subscribe(onNext: { _ in
        self.viewModel.steps.accept(AppStep.editNicknameScreenIsRequired(
          userData: self.viewModel.userData))
      })
      .disposed(by: disposeBag)
    
    // 학과 수정버튼 탭
    editMajorButton
      .rx
      .tap
      .subscribe(onNext: { _ in
        self.viewModel.steps.accept(AppStep.editMajorScreenIsRequired(userData: self.viewModel.userData))
      })
      .disposed(by: disposeBag)
    
    // 비밀번호 수정 버튼 탭
    editPassworButton.rx
      .tap
      .subscribe(onNext: { _ in
        guard let email = self.viewModel.userData.value?.email else { return }
        self.viewModel.steps.accept(AppStep.confirmPasswordScreenIsRequired(email: email))
      })
      .disposed(by: disposeBag)

  }
  
  /// UI 데이터 설정
  func setupUserInfo(_ data: UserDetailData){
    userNickNamekLabel.text = data.nickname
    userEmailLabel.text = data.email
  
    guard let major = data.major, let gender = data.gender else { return }
    userMajorLabel.text = Utils.convertMajor(major, toEnglish: false)
    userGenderLabel.text = Utils.convertGender(gender: gender)
  }
}
