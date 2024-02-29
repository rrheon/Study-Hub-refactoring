//
//  ViewController.swift
//  STUDYHUB2
//
//  Created by HYERYEONG on 2023/08/05.
//


/*
 전반적으로 수정 필요..
 
 */

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
  let tokenManager = TokenManager.shared
  let loginManager = LoginManager.shared
  
  // MARK: - 화면구성
  // 메인 이미지
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Image 7")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  // 이메일 입력
  private lazy var emailLabel: UILabel = {
    let emailLabel = UILabel()
    emailLabel.text = "이메일"
    emailLabel.textColor = .g50
    emailLabel.font = UIFont(name: "Pretendard-Medium",
                             size: 16)
    return emailLabel
  }()
  
  private lazy var emailTextField: UITextField =  {
    let emailTF = UITextField()
    emailTF.attributedPlaceholder = NSAttributedString(
      string: "이메일 주소를 입력해주세요 (@inu.ac.kr)",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80])
    emailTF.font = UIFont(name:  "Pretendard-Medium",
                          size: 14)
    emailTF.textColor = .white
    emailTF.backgroundColor = .black
    emailTF.addTarget(self,
                      action: #selector(emailTextFieldDidChange),
                      for: .editingChanged)
    emailTF.addTarget(self,
                      action: #selector(emailTextFieldEnd),
                      for: .editingDidEnd)
    
    emailTF.autocorrectionType = .no
    emailTF.autocapitalizationType = .none
    //    emailTF.becomeFirstResponder()
    return emailTF
  }()
  
  private lazy var emailTextFielddividerLine: UIView = {
    let lineView = UIView()
    lineView.backgroundColor = .g100
    return lineView
  }()
  
  private lazy var emailAlertLabel = createLabel(title: "잘못된 주소예요. 다시 입력해주세요",
                                                 textColor: .r50,
                                                 fontType: "Pretendard-Medium",
                                                 fontSize: 12)
  
  // 비밀번호 입력
  private lazy var passwordLabel: UILabel = {
    let passwordLabel = UILabel()
    passwordLabel.text = "비밀번호"
    passwordLabel.textColor = .g50
    passwordLabel.font = UIFont(name: "Pretendard-Medium",
                                size: 16)
    return passwordLabel
  }()
  
  private lazy var passwordTextField: UITextField = {
    let passwordTF = UITextField()
    passwordTF.attributedPlaceholder = NSAttributedString(
      string: "비밀번호를 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80])
    passwordTF.font = UIFont(name: "Pretendard-Medium",
                             size: 14)
    passwordTF.textColor = .white
    passwordTF.backgroundColor = .black
    passwordTF.addTarget(self,
                         action: #selector(passwordTextFieldDidChange),
                         for: .editingChanged)
    
    passwordTF.addTarget(self,
                         action: #selector(passwordTextFieldEnd),
                         for: .editingDidEnd)
    passwordTF.isSecureTextEntry = true
    return passwordTF
  }()
  
  var eyeButton = UIButton(type: .custom)
  
  private lazy var passwordTextFielddividerLine: UIView = {
    let passwordLine = UIView()
    passwordLine.backgroundColor = .g100
    return passwordLine
  }()
  
  private lazy var passwordAlertLabel = createLabel(
    title: "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)",
    textColor: .r50,
    fontType: "Pretendard-Medium",
    fontSize: 12)
  
  // 로그인 버튼
  private lazy var loginButton: UIButton = {
    let loginButton = UIButton(type: .system)
    loginButton.setTitle("로그인하기", for: .normal)
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.backgroundColor = .o50
    loginButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    loginButton.layer.cornerRadius = 10
    loginButton.addTarget(self,
                          action: #selector(loginButtonTapped),
                          for: .touchUpInside)
    return loginButton
  }()
  
  // 비밀번호 잊엇을 때
  private lazy var forgotPasswordButton: UIButton = {
    let forgotPasswordButton = UIButton(type: .system)
    forgotPasswordButton.setTitle("비밀번호가 기억나지 않으시나요?",
                                  for: .normal)
    forgotPasswordButton.setTitleColor(.g70,
                                       for: .normal)
    forgotPasswordButton.titleLabel?.font = UIFont(name: "Pretendard",
                                                   size: 14)
    forgotPasswordButton.setUnderlineInLoginVC()
    forgotPasswordButton.addAction(UIAction { _ in
      self.forgotPasswordButtonTapped()
    }, for: .touchUpInside)
    return forgotPasswordButton
  }()
  
  // 둘러보기
  private lazy var exploreButton: UIButton = {
    let exploreButton = UIButton(type: .system)
    exploreButton.setTitle("둘러보기",
                           for: .normal)
    exploreButton.setTitleColor(.white,
                                for: .normal)
    exploreButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold",
                                            size: 16)
    exploreButton.addTarget(self,
                            action: #selector(exploreButtonTapped),
                            for: .touchUpInside)
    return exploreButton
  }()
  
  // 회원가입
  private lazy var signUpButton: UIButton = {
    let signUpButton = UIButton(type: .system)
    signUpButton.setTitle("회원가입",
                          for: .normal)
    signUpButton.setTitleColor(.o50,
                               for: .normal)
    signUpButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold",
                                           size: 16)
    signUpButton.addTarget(self,
                           action: #selector(signUpButtonTapped),
                           for: .touchUpInside)
    return signUpButton
  }()
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    setUpLayout()
    makeUI()
    
    if #available(iOS 15.0, *) {
      setPasswordShowButtonImage()
    }
  }
  
  // MARK: - 비밀번호 보이게 설정
  @available(iOS 15.0, *)
  func setPasswordShowButtonImage() {
    var check = true
    eyeButton = UIButton.init(primaryAction: UIAction(handler: { [self] _ in
      passwordTextField.isSecureTextEntry.toggle()
      self.eyeButton.isSelected.toggle()
      check.toggle()
      
      var eyeImage = check ? "CloseEyeImage" : "eye_open"
      eyeButton.setImage(UIImage(named: eyeImage), for: .normal)
    }))
    
    var buttonConfiguration = UIButton.Configuration.plain()
    buttonConfiguration.imagePadding = 10
    buttonConfiguration.baseBackgroundColor = .clear
    
    eyeButton.setImage(UIImage(named: "CloseEyeImage"), for: .normal)
    
    self.eyeButton.configuration = buttonConfiguration
    
    self.passwordTextField.rightView = eyeButton
    self.passwordTextField.rightViewMode = .always
  }
  
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      mainImageView,
      emailLabel,
      emailTextField,
      emailTextFielddividerLine,
      emailAlertLabel,
      passwordLabel,
      passwordTextField,
      eyeButton,
      passwordTextFielddividerLine,
      passwordAlertLabel,
      loginButton,
      forgotPasswordButton,
      exploreButton,
      signUpButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(-20)
      $0.leading.equalToSuperview().offset(-10)
      $0.width.equalTo(400)
      $0.height.equalTo(250)
    }
    
    emailLabel.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom)
      $0.leading.equalToSuperview().offset(10)
    }
    
    emailTextField.delegate = self
    emailTextField.snp.makeConstraints {
      $0.leading.equalTo(emailLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(emailLabel.snp.bottom).offset(10)
      $0.height.equalTo(50)
    }
    
    emailTextFielddividerLine.snp.makeConstraints {
      $0.leading.trailing.equalTo(emailTextField)
      $0.top.equalTo(emailTextField.snp.bottom).offset(5)
      $0.height.equalTo(1)
    }
    
    emailAlertLabel.isHidden = true
    emailAlertLabel.snp.makeConstraints {
      $0.leading.equalTo(emailTextFielddividerLine.snp.leading)
      $0.top.equalTo(emailTextFielddividerLine.snp.bottom).offset(5)
    }
    
    passwordLabel.snp.makeConstraints {
      $0.leading.equalTo(emailLabel.snp.leading)
      $0.top.equalTo(emailTextFielddividerLine.snp.bottom).offset(40)
    }
    
    passwordTextField.delegate = self
    passwordTextField.snp.makeConstraints {
      $0.leading.equalTo(emailTextField)
      $0.top.equalTo(passwordLabel.snp.bottom).offset(5)
      $0.height.equalTo(50)
    }
    
    eyeButton.snp.makeConstraints {
      $0.trailing.equalTo(passwordTextFielddividerLine.snp.trailing)
    }
    
    passwordTextFielddividerLine.snp.makeConstraints {
      $0.leading.trailing.equalTo(passwordTextField)
      $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
      $0.height.equalTo(1)
    }
    
    passwordAlertLabel.isHidden = true
    passwordAlertLabel.snp.makeConstraints {
      $0.leading.equalTo(passwordTextFielddividerLine)
      $0.top.equalTo(passwordTextFielddividerLine.snp.bottom).offset(5)
    }
    
    loginButton.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.leading.trailing.equalTo(passwordTextFielddividerLine)
      $0.top.equalTo(passwordTextFielddividerLine.snp.bottom).offset(40)
      $0.height.equalTo(55)
    }
    
    forgotPasswordButton.snp.makeConstraints {
      $0.centerX.equalTo(loginButton)
      $0.top.equalTo(loginButton.snp.bottom).offset(20)
    }
    
    exploreButton.snp.makeConstraints {
      $0.leading.equalTo(forgotPasswordButton.snp.leading).offset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
    }
    
    signUpButton.snp.makeConstraints {
      $0.leading.equalTo(exploreButton.snp.trailing).offset(30)
      $0.centerY.equalTo(exploreButton)
    }
  }
  
  // MARK: - 함수
  func validatePassword(password: String) -> Bool {
    let passwordRegex = "(?=.*[a-zA-Z0-9])(?=.*[^a-zA-Z0-9]).{10,}"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
  }

  // MARK: - 로그인 버튼 눌리는 함수
  @objc func loginButtonTapped() {
    // 이메일 없으면 경고
    guard let email = emailTextField.text,
          !email.isEmpty else {
      showToast(message: "이메일과 비밀번호를 모두 작성해주세요.",
                imageCheck: false,
                alertCheck: true)
      return
    }
    
    // 페스워트 없으면 경고
    guard let password = passwordTextField.text,
          !password.isEmpty else {
      showToast(message: "이메일과 비밀번호를 모두 작성해주세요.",
                imageCheck: false,
                alertCheck: true)
      return
    }
    
    emailAlertLabel.isHidden = true
    passwordAlertLabel.isHidden = true
    
    loginManager.login(email: emailTextField.text ?? "",
                       password: passwordTextField.text ?? "") { result in
      switch result {
      case true:
        DispatchQueue.main.async {
          let tapbarcontroller = TabBarController()

          tapbarcontroller.modalPresentationStyle = .fullScreen
          
          self.present(tapbarcontroller, animated: true, completion: nil)
        }
      case false:
        DispatchQueue.main.async {
          self.emailTextFielddividerLine.backgroundColor = .r50
          self.passwordTextFielddividerLine.backgroundColor = .r50
          self.emailAlertLabel.isHidden = false
          self.passwordAlertLabel.isHidden = false
        }
      }
    }
  }
  
  // MARK: - email action 함수
  @objc func emailTextFieldDidChange() {
    if let email = emailTextField.text, !email.isEmpty {
      let isValidEmail = isValidEmail(email)
      
      emailTextFielddividerLine.backgroundColor = isValidEmail ? .g100 : .g60
      emailAlertLabel.isHidden = true
    }
  }
  
  @objc func emailTextFieldEnd() {
    if let email = emailTextField.text, !email.isEmpty {
      let isValidEmail = isValidEmail(email)
      
      emailTextFielddividerLine.backgroundColor = isValidEmail ? .g100 : .r50
      emailAlertLabel.isHidden = isValidEmail ? true : false
    }
  }
  
  // MARK: - password action 함수
  @objc func passwordTextFieldDidChange() {
    if let password = passwordTextField.text, !password.isEmpty {
      let isValidPassword = validatePassword(password: password)
      
      passwordTextFielddividerLine.backgroundColor = isValidPassword ? .g100 : .g60
      passwordAlertLabel.isHidden = true
    }
  }
  
  @objc func passwordTextFieldEnd() {
    if let password = passwordTextField.text, !password.isEmpty {
      let isValidPassword = validatePassword(password: password)
      
      passwordTextFielddividerLine.backgroundColor = isValidPassword ? .g100 : .r50
      passwordAlertLabel.isHidden = isValidPassword ? true : false
    }
  }
  
  // MARK: - 둘러보기 함수
  @objc func exploreButtonTapped() {
    tokenManager.deleteTokens()

    let tapbarcontroller = TabBarController()
    tapbarcontroller.modalPresentationStyle = .fullScreen
    
    self.present(tapbarcontroller, animated: true, completion: nil)
  }

  // Action for the "회원가입" (Signup) button
  @objc func signUpButtonTapped() {
    let termsOfServiceVC = TermsOfServiceViewController()
    let navigationVC = UINavigationController(rootViewController: termsOfServiceVC)
    navigationVC.modalPresentationStyle = .fullScreen
    
    self.present(navigationVC, animated: true, completion: nil)
  }
  
  // MARK: - 비밀번호 잊었을 때
  func forgotPasswordButtonTapped(){
    let forgotPasswordVC = FindPasswordViewController()
    let navigationController = UINavigationController(rootViewController: forgotPasswordVC)
    navigationController.modalPresentationStyle = .fullScreen
    
    self.present(navigationController, animated: true, completion: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    textField.resignFirstResponder()
    return true
  }
}

