
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class EnterPasswordViewController: CommonNavi {
  
  var viewModel: EnterPasswordViewModel
  
  // MARK: - 화면구성
  
  private lazy var mainTitleView = AuthTitleView(
    pageNumber: "3/5",
    pageTitle: "비밀번호를 설정해주세요",
    pageContent: "10자리 이상, 특수문자 포함(!,@,#,$,%,^,&,*,?,~,_)이 필수에요")
  
  private lazy var passwordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "비밀번호",
    textFieldPlaceholder: "비밀번호를 입력해주세요",
    alertLabelTitle: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)")
  
  private lazy var passwordTextField = EnterPasswordTextField(
    setValue: passwordTextFieldValue)
  
  private lazy var confirmPasswordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: nil,
    textFieldPlaceholder: "비밀번호를 한 번 더 입력해주세요",
    alertLabelTitle: "비밀번호가 일치하지 않아요")
  
  private lazy var confirmPasswordTextField = EnterPasswordTextField(
    setValue: confirmPasswordTextFieldValue,
    failContent: "비밀번호가 일치하지 않아요",
    successContent: "비밀번호가 확인되었어요")
  
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  init(_ values: SignupDataProtocol) {
    self.viewModel = EnterPasswordViewModel(values)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationSetting()
    
    setUpLayout()
    makeUI()
    
    setupBindings()
    setupActions()
  }
  
  // MARK: - setupLayout
  
  func setUpLayout(){
    [
      mainTitleView,
      passwordTextField,
      confirmPasswordTextField,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  func makeUI(){
    mainTitleView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    passwordTextField.setPasswordSecure()
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(120)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    confirmPasswordTextField.setPasswordSecure()
    confirmPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(45)
      $0.leading.trailing.equalTo(passwordTextField)
      $0.height.equalTo(50)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(passwordTextField)
    }
  }
  
  // MARK: - 네비게이션 바
  
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }
  
  func setupActions(){
    nextButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let signupDatas = SignupDats(email: viewModel.email,
                                     password: passwordTextField.getTextFieldValue())
        
        let nicknameVC = EnterNicknameViewController(signupDatas)
        navigationController?.pushViewController(nicknameVC, animated: true)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupBindings() {
    bindPasswordTextField(passwordTextField, to: viewModel.firstPassword)
 
    confirmPasswordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.confirmPassword)
      .disposed(by: viewModel.disposeBag)
 
    viewModel.passwordsMatch
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: { [weak self] in
        self?.nextButton.unableButton($0)
        if self?.confirmPasswordTextField.getTextFieldValue() != "" {
          let color: UIColor = $0 ? .g_10 : .r50
          let text = $0 ? "비밀번호가 확인되었어요" : "비밀번호가 일치하지 않아요"
          self?.confirmPasswordTextField.alertLabelSetting(
            hidden: false,
            title: text,
            textColor: color,
            underLineColor: color)
        }})
      .disposed(by: viewModel.disposeBag)
  }
  
  func bindPasswordTextField(_ textField: AuthTextField,
                             to viewModelProperty: BehaviorRelay<String>) {
    textField.textField.rx.text.orEmpty
      .bind(to: viewModelProperty)
      .disposed(by: viewModel.disposeBag)
    
    textField.textField.rx.controlEvent([.editingChanged, .editingDidEnd])
      .subscribe(onNext: { [weak self] in
        self?.validatePasswordTextField(textField)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func validatePasswordTextField(_ textField: AuthTextField) {
    guard let password = textField.getTextFieldValue() else { return }
    
    let isValidPassword = textField.isValidPassword(password)
    let isTextFieldEditing = textField.textField.isEditing
    
    let color: UIColor = isValidPassword ? .g_10 : .r50
    let text = isValidPassword ? "사용 가능한 비밀번호예요" : "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
    
    textField.alertLabelSetting(hidden: false, title: text, textColor: color, underLineColor: color)
    
    if !isTextFieldEditing && isValidPassword {
      textField.alertLabelSetting(hidden: true, title: "", textColor: .g100, underLineColor: .g100)
    }
  }
}
