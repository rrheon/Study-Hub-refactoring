//
//  ViewController.swift
//  STUDYHUB2
//
//  Created by HYERYEONG on 2023/08/05.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
  let tokenManager = TokenManager.shared
  let loginManager = LoginManager.shared
  
  // MARK: - 화면구성
  lazy var emailTextField: UITextField =  {
    let emailTF = UITextField()
    emailTF.attributedPlaceholder = NSAttributedString(string: "이메일 주소를 입력해주세요 (@inu.ac.kr)",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    emailTF.textColor = .white
    emailTF.backgroundColor = .black
    emailTF.borderStyle = .roundedRect
    emailTF.addTarget(self,
                      action: #selector(emailTextFieldDidChange),
                      for: .editingChanged)
    
    emailTF.autocorrectionType = .no
    emailTF.autocapitalizationType = .none
    emailTF.becomeFirstResponder()
    return emailTF
  }()
  
  private let emailTextFielddividerLine: UIView = {
    let lineView = UIView()
    lineView.backgroundColor = .gray
    return lineView
  }()
  
  lazy var passwordTextField: UITextField = {
    let passwordTF = UITextField()
    passwordTF.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    passwordTF.textColor = .white
    passwordTF.backgroundColor = .black
    passwordTF.borderStyle = .roundedRect
    passwordTF.addTarget(self,
                         action: #selector(passwordTextFieldDidChange),
                         for: .editingChanged)
    passwordTF.isSecureTextEntry = true
    return passwordTF
  }()
  
  var eyeButton = UIButton(type: .custom)
  
  private let passwordTextFielddividerLine: UIView = {
    let passwordLine = UIView()
    passwordLine.backgroundColor = .gray
    return passwordLine
  }()
  
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Image 7") // Set the image name
    imageView.contentMode = .scaleAspectFit // Adjust content mode as needed
    return imageView
  }()
  
  private let emailLabel: UILabel = {
    let emailLabel = UILabel()
    emailLabel.text = "이메일"
    emailLabel.textColor = .white
    return emailLabel
  }()
  
  private let passwordLabel: UILabel = {
    // '비밀번호' 텍스트
    let passwordLabel = UILabel()
    passwordLabel.text = "비밀번호"
    passwordLabel.textColor = .white
    return passwordLabel
  }()
  
  lazy var loginButton: UIButton = {
    let loginButton = UIButton(type: .system)
    loginButton.setTitle("로그인하기", for: .normal)
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.backgroundColor = UIColor(hexCode: "FF5935")
    loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    loginButton.layer.cornerRadius = 10
    loginButton.addTarget(self,
                          action: #selector(loginButtonTapped),
                          for: .touchUpInside)
    return loginButton
  }()
  
  private let forgotPasswordButton: UIButton = {
    let forgotPasswordButton = UIButton(type: .system)
    forgotPasswordButton.setTitle("비밀번호가 기억나지 않으시나요?",
                                  for: .normal)
    forgotPasswordButton.setTitleColor(.gray,
                                       for: .normal)
    forgotPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    return forgotPasswordButton
  }()
  
  lazy var exploreButton: UIButton = {
    let exploreButton = UIButton(type: .system)
    exploreButton.setTitle("둘러보기",
                           for: .normal)
    exploreButton.setTitleColor(.white,
                                for: .normal)
    exploreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    exploreButton.addTarget(self,
                            action: #selector(exploreButtonTapped),
                            for: .touchUpInside)
    return exploreButton
  }()
  
  lazy var signUpButton: UIButton = {
    let signUpButton = UIButton(type: .system)
    signUpButton.setTitle("회원가입",
                          for: .normal)
    signUpButton.setTitleColor(UIColor(hexCode: "FF5935"),
                               for: .normal)
    signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
  
  @available(iOS 15.0, *)
  func setPasswordShowButtonImage(){
    eyeButton = UIButton.init(primaryAction: UIAction(handler: { [self] _ in
      passwordTextField.isSecureTextEntry.toggle()
      self.eyeButton.isSelected.toggle()
    }))
    
    var buttonConfiguration = UIButton.Configuration.plain()
    buttonConfiguration.imagePadding = 10
    buttonConfiguration.baseBackgroundColor = .clear
    
    eyeButton.setImage(UIImage(named: "eye_open"), for: .normal)
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
      passwordLabel,
      passwordTextField,
      eyeButton,
      passwordTextFielddividerLine,
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
    mainImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-20)
      make.width.equalTo(400)
      make.height.equalTo(200)
    }
    
    emailLabel.snp.makeConstraints { make in
      make.top.equalTo(mainImageView.snp.bottom).offset(20)
      make.leading.equalTo(view).offset(15)
    }
    
    emailTextField.snp.makeConstraints { make in
      make.leading.equalTo(emailLabel)
      make.trailing.equalTo(view).offset(-20)
      make.top.equalTo(emailLabel.snp.bottom).offset(5)
      make.height.equalTo(30)
    }
    
    emailTextFielddividerLine.snp.makeConstraints { make in
      make.leading.trailing.equalTo(view)
      make.top.equalTo(emailTextField.snp.bottom).offset(5)
      make.height.equalTo(1)
    }
    
    passwordLabel.snp.makeConstraints { make in
      make.leading.equalTo(view).offset(20)
      make.top.equalTo(emailTextFielddividerLine.snp.bottom).offset(40)
    }
    
    passwordTextField.snp.makeConstraints { make in
      make.leading.equalTo(passwordLabel)
      make.trailing.equalTo(view).offset(-20)
      make.top.equalTo(passwordLabel.snp.bottom).offset(5)
      make.height.equalTo(30)
    }
    
    eyeButton.snp.makeConstraints { make in
      make.trailing.equalTo(passwordTextFielddividerLine.snp.trailing)
    }

    passwordTextFielddividerLine.snp.makeConstraints { make in
      make.leading.trailing.equalTo(view)
      make.top.equalTo(passwordTextField.snp.bottom).offset(5)
      make.height.equalTo(1)
    }
    
    loginButton.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(passwordTextFielddividerLine.snp.bottom).offset(40)
      make.height.equalTo(55)
      make.width.equalTo(400)
    }
    
    forgotPasswordButton.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(loginButton.snp.bottom).offset(10)
    }
    
    exploreButton.snp.makeConstraints { make in
      make.leading.equalTo(view).offset(120)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
    }
    
    signUpButton.snp.makeConstraints { make in
      make.leading.equalTo(exploreButton.snp.trailing).offset(50)
      make.centerY.equalTo(exploreButton)
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
      emailTextFielddividerLine.backgroundColor = .red
      
      alertShow(title: "경고",
                message: "이메일을 입력해주세요.")
      return
    }
    
    // 페스워트 없으면 경고
    guard let password = passwordTextField.text,
          !password.isEmpty else {
      passwordTextFielddividerLine.backgroundColor = .red
      
      alertShow(title: "경고",
                message: "비밀번호를 입력해주세요.")
      return
    }
    // 이메일 형식 다르면 경고
    if let email = emailTextField.text {
      let isValidEmail = email.hasSuffix("@inu.ac.kr")
      
      // Check if the entered email follows the '@inu.ac.kr' format
      emailTextFielddividerLine.backgroundColor = isValidEmail ? .green : .red
      
      if !isValidEmail {
        alertShow(title: "경고",
                  message: "잘못된 이메일 주소입니다. 다시 입력해주세요")
        return
      }
      else {
        emailTextFielddividerLine.backgroundColor = .green
      }
    }
    // 비밀번호 10자리 아니면 경고
    if !validatePassword(password: password) {
      alertShow(title: "경고",
                message: "비밀번호는 10자리 이상이거나 특수문자를 포함해야 합니다.")
      
      passwordTextFielddividerLine.backgroundColor = .red
      return
    } else {
      passwordTextFielddividerLine.backgroundColor = .green
    }
    
    
    loginManager.login(email: emailTextField.text ?? "",
                       password: passwordTextField.text ?? "") { result in
      switch result {
      case true:
        DispatchQueue.main.async {
          let tapbarcontroller = TabBarController()
          let navigationController = UINavigationController(rootViewController: tapbarcontroller)
          navigationController.modalPresentationStyle = .fullScreen
          
          self.present(navigationController, animated: true, completion: nil)
        }
      case false:
        self.alertShow(title: "경고", message: "잘못된 주소")
        
      }
    }
  }

  // MARK: - email action 함수
  @objc func emailTextFieldDidChange() {
    if let email = emailTextField.text {
      // Check if the entered email follows the '@inu.ac.kr' format
      let isValidEmail = email.hasSuffix("@inu.ac.kr")
      
      // Change the color of the emailTextFielddividerLine based on the validation result
      emailTextFielddividerLine.backgroundColor = isValidEmail ? .green : .red
    }
    
  }
  
  // MARK: - password action 함수
  @objc func passwordTextFieldDidChange() {
    if let password = passwordTextField.text {
      // Check if the entered password meets the required criteria
      let isValidPassword = validatePassword(password: password)
      
      // Change the color of the passwordTextFielddividerLine based on the validation result
      passwordTextFielddividerLine.backgroundColor = isValidPassword ? .green : .red
    }
  }
  
  // MARK: - 둘러보기 함수
  @objc func exploreButtonTapped() {
    tokenManager.deleteTokens()
    
    print(tokenManager.loadRefreshToken())
    let tapbarcontroller = TabBarController()
    let navigationController = UINavigationController(rootViewController: tapbarcontroller)
    navigationController.modalPresentationStyle = .fullScreen
    
    self.present(navigationController, animated: true, completion: nil)
  }
  
  // Action for the "회원가입" (Signup) button
  @objc func signUpButtonTapped() {
    let signUpViewController = SignUpViewController()
    
      let backButton = UIBarButtonItem(title: "",
                                       style: .plain,
                                       target: self,
                                       action: #selector(backButtonTapped))
      backButton.image = UIImage(systemName: "chevron.left")
      backButton.tintColor = .white
      signUpViewController.navigationItem.leftBarButtonItem = backButton
      
      navigationController?.pushViewController(signUpViewController, animated: true)
  }
  
  @objc func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
}

