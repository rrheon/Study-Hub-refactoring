
import UIKit

import SnapKit
import RxSwift
import RxCocoa


/// StudyHub - front - LoginScreen

final class LoginViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()

  let viewModel: LoginViewModel
  
  // MARK: - 화면구성

  /// LoginVC 메인 이미지
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "LoginSceneImage")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  
  /// 이메일 TextField에 들어갈 value
  private lazy var emailTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "이메일",
    textFieldPlaceholder: "이메일 주소를 입력해주세요 (@inu.ac.kr)",
    alertLabelTitle: "잘못된 주소예요. 다시 입력해주세요"
  )
  
  
  /// 이메일 TextField
  private lazy var emailTextField = AuthTextField(setValue: emailTextFieldValue)
  
  
  /// 비밀번호 TextField에 들어갈 값
  private lazy var passwordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "비밀번호",
    textFieldPlaceholder: "비밀번호를 입력해주세요",
    alertLabelTitle: "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
  )
  
  
  /// 비밀번호 TextField
  private lazy var passwordTextField = AuthTextField(setValue: passwordTextFieldValue)
  
  
  /// 로그인 버튼
  private lazy var loginButton = StudyHubButton(title: "로그인하기")
  
  
  /// 비밀번호 찾기 버튼
  private lazy var forgotPasswordButton: UIButton = {
    let forgotPasswordButton = UIButton(type: .system)
    forgotPasswordButton.setTitle("비밀번호가 기억나지 않으시나요?", for: .normal)
    forgotPasswordButton.setTitleColor(.g70, for: .normal)
    forgotPasswordButton.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    forgotPasswordButton.setUnderlineInLoginVC()
    return forgotPasswordButton
  }()
  
  
  /// 둘러보기 버튼
  private lazy var exploreButton: UIButton = {
    let exploreButton = UIButton(type: .system)
    exploreButton.setTitle("둘러보기", for: .normal)
    exploreButton.setTitleColor(.white, for: .normal)
    exploreButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return exploreButton
  }()
  
  
  /// 회원가입 버튼
  private lazy var signUpButton: UIButton = {
    let signUpButton = UIButton(type: .system)
    signUpButton.setTitle("회원가입", for: .normal)
    signUpButton.setTitleColor(.o50, for: .normal)
    signUpButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return signUpButton
  }()
  
          
  init(with viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: .none, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    setUpLayout()
    makeUI()
    
    setupBinding()
    setupActions()
  } // viewDidLoad
  
  
  // MARK: - setUpLayout
  
  
  /// 레이아웃 설정
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
  
  
  /// UI 설정
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
  
  
  /// 바인딩
  func setupBinding(){
    bindTextFieldEvents(textField: emailTextField)
    bindTextFieldEvents(textField: passwordTextField)
    
    // 로그인 버튼 터치 후 유효한 계정 판단
    viewModel.isValidAccount
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false)) // 튜플 형태로 맞춤
      .drive(onNext: { vc, result in
        result ? vc.viewModel.steps.accept(AppStep.mainTabIsRequired) : vc.failToLogin()
      })
      .disposed(by: disposeBag)
    
  }
  
  /// 버튼 Action 설정
  func setupActions(){
    
    // 탐색버튼 터치
    exploreButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.viewModel.steps.accept(AppStep.mainTabIsRequired)
      })
      .disposed(by: disposeBag)

    
    // 회원가입 버튼 터치
    signUpButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.viewModel.steps.accept(AppStep.auth(.signupIsRequired))
      })
      .disposed(by: disposeBag)
    
    // 비밀번호찾기 버튼 터치
    forgotPasswordButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.viewModel.steps.accept(AppStep.auth(.confirmEmailScreenIsRequired))
      })
      .disposed(by: disposeBag)
    
    // 로그인 버튼 터치
    loginButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.loginButtonTapped()
      })
      .disposed(by: disposeBag)
  }
  
  
  /// 이메일, 비밀번호 TextField 바인딩
  /// - Parameter textField: AuthTextField
  func bindTextFieldEvents(textField: AuthTextField) {
    textField.textField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        let isEditingDidBegin = textField.textField.isEditing
        self.handleTextFieldEvents(textField: textField, isEditingDidBegin: isEditingDidBegin)
      })
      .disposed(by: disposeBag)
  }
  
  
  /// TextField 관련 이벤트
  /// - Parameters:
  ///   - textField: AuthTextField
  ///   - isEditingDidBegin: 입력시작 여부
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
        isValid = Utils.isValidPassword(text)
        invalidMessage = "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
      } else {
        return
      }
      
      if !isValid {
        textField.alertLabelSetting(hidden: false, title: invalidMessage)
      }
    }
  }

  
  /// 로그인버튼 터치
  func loginButtonTapped() {
    guard let email = emailTextField.getTextFieldValue() ,!email.isEmpty,
          let password = passwordTextField.getTextFieldValue(), !password.isEmpty else {
      ToastPopupManager.shared.showToast(message: "이메일과 비밀번호를 모두 작성해주세요.", imageCheck: false)
      return
    }
    
    // 이메일 TextField 경고라벨 세팅
    emailTextField.alertLabelSetting(
      hidden: true,
      title: "",
      textColor: .g100,
      underLineColor: .g100
    )
    
    // 비밀번호 TextField 경고라벨 세팅
    passwordTextField.alertLabelSetting(
      hidden: true,
      title: "",
      textColor: .g100,
      underLineColor: .g100
    )
  
    viewModel.loginToStudyHub(email: email, password: password)
  }
  
  /// 로그인 실패 시 경고라벨 활성화
  func failToLogin(){
    let emailAlertTitle: String = "잘못된 주소예요. 다시 입력해주세요"
    emailTextField.alertLabelSetting(hidden: false, title: emailAlertTitle)
    
    let passwordAlertTitle: String = "잘못된 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
    passwordTextField.alertLabelSetting(hidden: false, title: passwordAlertTitle)
  }
}
