//
//  File.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/20/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

/// 로그인 화면의 View
final class LoginView: UIView {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  /// LoginVC 메인 이미지
  private let mainImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(named: ViewImages.loginScreenImage)
    $0.contentMode = .scaleAspectFit
  }
  
  
  /// 이메일 TextField에 들어갈 value
  private lazy var emailTextFieldValue = SetAuthTextFieldValue(
    labelTitle: LabelTitle.email,
    textFieldPlaceholder: TextFieldPlaceholder.email,
    alertLabelTitle: LabelTitle.emailAlert
  )
  
  
  /// 이메일 TextField
  lazy var emailTextField = AuthTextField(setValue: emailTextFieldValue)
  
  
  /// 비밀번호 TextField에 들어갈 값
  private lazy var passwordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: LabelTitle.password,
    textFieldPlaceholder: TextFieldPlaceholder.password,
    alertLabelTitle: LabelTitle.passwordAlert
  )
  
  
  /// 비밀번호 TextField
  lazy var passwordTextField = AuthTextField(setValue: passwordTextFieldValue)
  
  
  /// 로그인 버튼
  lazy var loginButton = StudyHubButton(title: BtnTitle.login)
  
  
  /// 비밀번호 찾기 버튼
  lazy var forgotPasswordButton: UIButton = UIButton().then {
    $0.setTitle(BtnTitle.forgotPassword, for: .normal)
    $0.setTitleColor(.g70, for: .normal)
    $0.titleLabel?.font = UIFont(name: FontSystem.regualr.value, size: 14)
    $0.setUnderlineInLoginVC()
  }
  
  
  /// 둘러보기 버튼
  lazy var exploreButton: UIButton = UIButton().then {
    $0.setTitle(BtnTitle.explore, for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: FontSystem.semiBold.value, size: 16)
  }
  
  
  /// 회원가입 버튼
  lazy var signUpButton: UIButton = UIButton().then {
    $0.setTitle(BtnTitle.signup, for: .normal)
    $0.setTitleColor(.o50, for: .normal)
    $0.titleLabel?.font = UIFont(name: FontSystem.semiBold.value, size: 16)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - makeUI
  
  
  /// UI 설정
  func makeUI(){
    self.addSubview(mainImageView)
    mainImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(-20)
      $0.leading.equalToSuperview().offset(-10)
      $0.width.equalTo(400)
      $0.height.equalTo(250)
    }
    
    self.addSubview(emailTextField)
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom)
      $0.leading.equalTo(mainImageView).offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    self.addSubview(passwordTextField)
    passwordTextField.setPasswordSecure()
    passwordTextField.snp.makeConstraints {
      $0.leading.equalTo(emailTextField)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(emailTextField.snp.bottom).offset(40)
      $0.height.equalTo(50)
    }
    
    self.addSubview(loginButton)
    loginButton.snp.makeConstraints {
      $0.leading.trailing.equalTo(passwordTextField)
      $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
      $0.height.equalTo(55)
    }
    
    self.addSubview(forgotPasswordButton)
    forgotPasswordButton.snp.makeConstraints {
      $0.centerX.equalTo(loginButton)
      $0.top.equalTo(loginButton.snp.bottom).offset(20)
    }
    
    self.addSubview(exploreButton)
    exploreButton.snp.makeConstraints {
      $0.leading.equalTo(forgotPasswordButton.snp.leading).offset(20)
      $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
    }
    
    self.addSubview(signUpButton)
    signUpButton.snp.makeConstraints {
      $0.leading.equalTo(exploreButton.snp.trailing).offset(30)
      $0.centerY.equalTo(exploreButton)
    }
  }
}
