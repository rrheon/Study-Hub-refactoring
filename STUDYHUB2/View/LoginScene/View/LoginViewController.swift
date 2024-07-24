import UIKit

import SnapKit

final class LoginViewController: UIViewController {
  let loginViewModel = LoginViewModel.loginViewModel
  
  // MARK: - 화면구성
  // 메인 이미지
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Image 7")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var emailTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "이메일",
    textFieldPlaceholder: "이메일 주소를 입력해주세요 (@inu.ac.kr)",
    alertLabelTitle: "잘못된 주소예요. 다시 입력해주세요",
    type: "email")
  
  private lazy var emailTextField = AuthTextField(setValue: emailTextFieldValue)
  
  private lazy var passwordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "비밀번호",
    textFieldPlaceholder: "비밀번호를 입력해주세요",
    alertLabelTitle: "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)",
    type: "password")
  
  private lazy var passwordTextField = AuthTextField(setValue: passwordTextFieldValue)
  
  var eyeButton = UIButton(type: .custom)
  
  // 로그인 버튼
  private lazy var loginButton: UIButton = {
    let loginButton = UIButton(type: .system)
    loginButton.setTitle("로그인하기", for: .normal)
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.backgroundColor = .o50
    loginButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18)
    loginButton.layer.cornerRadius = 10
    loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    return loginButton
  }()
  
  // 비밀번호 잊엇을 때
  private lazy var forgotPasswordButton: UIButton = {
    let forgotPasswordButton = UIButton(type: .system)
    forgotPasswordButton.setTitle("비밀번호가 기억나지 않으시나요?", for: .normal)
    forgotPasswordButton.setTitleColor(.g70, for: .normal)
    forgotPasswordButton.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    forgotPasswordButton.setUnderlineInLoginVC()
    forgotPasswordButton.addAction(UIAction { _ in
      self.forgotPasswordButtonTapped()
    }, for: .touchUpInside)
    return forgotPasswordButton
  }()
  
  // 둘러보기
  private lazy var exploreButton: UIButton = {
    let exploreButton = UIButton(type: .system)
    exploreButton.setTitle("둘러보기", for: .normal)
    exploreButton.setTitleColor(.white, for: .normal)
    exploreButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    exploreButton.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
    return exploreButton
  }()
  
  // 회원가입
  private lazy var signUpButton: UIButton = {
    let signUpButton = UIButton(type: .system)
    signUpButton.setTitle("회원가입", for: .normal)
    signUpButton.setTitleColor(.o50, for: .normal)
    signUpButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    return signUpButton
  }()
  
  // MARK: - ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      mainImageView,
      passwordTextField,
      eyeButton,
      loginButton,
      forgotPasswordButton,
      exploreButton,
      signUpButton,
      emailTextField
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

    emailTextField.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    passwordTextField.setPasswordSecure()
     passwordTextField.snp.makeConstraints {
      $0.leading.equalTo(emailTextField)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(emailTextField.snp.bottom).offset(40)
      $0.height.equalTo(50)
    }
    
    eyeButton.snp.makeConstraints {
      $0.trailing.equalTo(passwordTextField.snp.trailing)
    }
    
    loginButton.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.leading.trailing.equalTo(passwordTextField)
      $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
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
  @objc func loginButtonTapped() {
    guard let email = emailTextField.getTextFieldValue() ,!email.isEmpty,
          let password = passwordTextField.getTextFieldValue(), !password.isEmpty else {
      showToast(message: "이메일과 비밀번호를 모두 작성해주세요.", imageCheck: false, alertCheck: true)
      return
    }
   
    emailTextField.hideAlertLabel()
    passwordTextField.hideAlertLabel()
    
    loginViewModel.login(email: email, password: password) { [weak self] result in
      DispatchQueue.main.async {
        self?.handleLoginResult(result)
      }
    }
  }
  
  private func handleLoginResult(_ success: Bool) {
    success ? moveToTabbar() : failToLogin()
  }

  func failToLogin(){
    emailTextField.failToLogin()
    passwordTextField.failToLogin()
  }
  
  // MARK: - 둘러보기 함수
  @objc func exploreButtonTapped() {
    moveToTabbar()
  }

  // MARK: - 회원가입
  @objc func signUpButtonTapped() {
    moveToOtherVC(vc: TermsOfServiceViewController(), naviCheck: true)
  }
  
  // MARK: - 비밀번호 잊었을 때
  func forgotPasswordButtonTapped(){
    moveToOtherVC(vc: FindPasswordViewController(), naviCheck: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    textField.resignFirstResponder()
    return true
  }
}

