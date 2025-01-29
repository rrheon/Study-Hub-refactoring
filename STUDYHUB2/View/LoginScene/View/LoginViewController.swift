
import UIKit

import SnapKit
import RxSwift
import RxCocoa


/// 로그인 VC
final class LoginViewController: UIViewController {
  let viewModel = LoginViewModel()
  
  // MARK: - 화면구성

  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "LoginSceneImage")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var emailTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "이메일",
    textFieldPlaceholder: "이메일 주소를 입력해주세요 (@inu.ac.kr)",
    alertLabelTitle: "잘못된 주소예요. 다시 입력해주세요")
  
  private lazy var emailTextField = AuthTextField(setValue: emailTextFieldValue)
  
  private lazy var passwordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "비밀번호",
    textFieldPlaceholder: "비밀번호를 입력해주세요",
    alertLabelTitle: "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)")
  
  private lazy var passwordTextField = AuthTextField(setValue: passwordTextFieldValue)
  
  private lazy var loginButton = StudyHubButton(title: "로그인하기")
  
  private lazy var forgotPasswordButton: UIButton = {
    let forgotPasswordButton = UIButton(type: .system)
    forgotPasswordButton.setTitle("비밀번호가 기억나지 않으시나요?", for: .normal)
    forgotPasswordButton.setTitleColor(.g70, for: .normal)
    forgotPasswordButton.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    forgotPasswordButton.setUnderlineInLoginVC()
    return forgotPasswordButton
  }()
  
  private lazy var exploreButton: UIButton = {
    let exploreButton = UIButton(type: .system)
    exploreButton.setTitle("둘러보기", for: .normal)
    exploreButton.setTitleColor(.white, for: .normal)
    exploreButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return exploreButton
  }()
  
  private lazy var signUpButton: UIButton = {
    let signUpButton = UIButton(type: .system)
    signUpButton.setTitle("회원가입", for: .normal)
    signUpButton.setTitleColor(.o50, for: .normal)
    signUpButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return signUpButton
  }()
  
  // MARK: - ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    setUpLayout()
    makeUI()
    
    setupBinding()
    setupActions()
    
    //    StudyPostManager.studyPostShared.searchMyPost(page: 0, size: 5)
    print(StudyPostManager.shared.loadAccessToken())
  }
  
  // MARK: - setUpLayout
  
  func setUpLayout(){
    [
      mainImageView,
      passwordTextField,
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
      $0.leading.equalTo(mainImageView).offset(20)
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
    
    loginButton.snp.makeConstraints {
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
  
  // MARK: - setupBinding
  
  func setupBinding(){
    bindTextFieldEvents(textField: emailTextField)
    bindTextFieldEvents(textField: passwordTextField)
    
    viewModel.isValidAccount
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        self.handleLoginResult($0)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    exploreButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.moveToTabbar(false)
      })
      .disposed(by: viewModel.disposeBag)
    
    signUpButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.moveToOtherVC(vc: AgreementViewController(), naviCheck: true)
      })
      .disposed(by: viewModel.disposeBag)
    
    forgotPasswordButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.moveToOtherVC(vc: ConfirmEmailViewController(false), naviCheck: true)
      })
      .disposed(by: viewModel.disposeBag)
    
    loginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.loginButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func bindTextFieldEvents(textField: AuthTextField) {
    textField.textField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let isEditingDidBegin = textField.textField.isEditing
        self.handleTextFieldEvents(textField: textField, isEditingDidBegin: isEditingDidBegin)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func handleTextFieldEvents(textField: AuthTextField, isEditingDidBegin: Bool) {
    let underLineColor: UIColor = isEditingDidBegin ? .g60 : .g100
    textField.alertLabelSetting(hidden: false, title: "", underLineColor: underLineColor)
    
    if !isEditingDidBegin {
      guard let text = textField.getTextFieldValue() else { return }
      
      let isValid: Bool
      let invalidMessage: String
      
      if textField == emailTextField {
        isValid = textField.isValidEmail(text)
        invalidMessage = "잘못된 주소예요. 다시 입력해주세요"
      } else if textField == passwordTextField {
        isValid = textField.isValidPassword(text)
        invalidMessage = "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
      } else {
        return
      }
      
      if !isValid {
        textField.alertLabelSetting(hidden: false, title: invalidMessage)
      }
    }
  }

  func loginButtonTapped() {
    guard let email = emailTextField.getTextFieldValue() ,!email.isEmpty,
          let password = passwordTextField.getTextFieldValue(), !password.isEmpty else {
      showToast(message: "이메일과 비밀번호를 모두 작성해주세요.", imageCheck: false, alertCheck: true)
      return
    }
    
    emailTextField.alertLabelSetting(
      hidden: true,
      title: "",
      textColor: .g100,
      underLineColor: .g100
    )
    
    passwordTextField.alertLabelSetting(
      hidden: true,
      title: "",
      textColor: .g100,
      underLineColor: .g100
    )
  
//    viewModel.login(email: email, password: password)
    viewModel.loginToStudyHub(email: email, password: password)
  }
  
  private func handleLoginResult(_ success: Bool) {
    success ? moveToTabbar(success) : failToLogin()
  }
  
  func failToLogin(){
    emailTextField.alertLabelSetting(hidden: false, title: "잘못된 주소예요. 다시 입력해주세요")
    passwordTextField.alertLabelSetting(
      hidden: false,
      title: "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
    )
  }
}
