
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class CheckEmailViewController: CommonNavi {
  let viewModel = CheckEmailViewModel()
  
  private lazy var mainTitleView = AuthTitleView(pageNumber: "2/5",
                                                 pageTitle: "이메일을 입력해주세요",
                                                 pageContent: nil)

  // MARK: - 화면구성
  private lazy var emailTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "이메일",
    textFieldPlaceholder: "@inu.ac.kr",
    alertLabelTitle: "잘못된 주소예요. 다시 입력해주세요")
  
  private lazy var emailTextField = AuthTextField(setValue: emailTextFieldValue)
  
  private lazy var validButton: UIButton = {
    let validBtn = UIButton()
    validBtn.setTitle("인증", for: .normal)
    validBtn.setTitleColor(.g90, for: .normal)
    validBtn.backgroundColor = .o60
    validBtn.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    validBtn.layer.cornerRadius = 5
    return validBtn
  }()
  
  private lazy var codeTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "인증코드",
    textFieldPlaceholder: "인증코드를 입력해주세요",
    alertLabelTitle: "")
  
  private lazy var codeTextField = AuthTextField(setValue: codeTextFieldValue)
  
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationSetting()
    
    setUpLayout()
    makeUI()
    
    setupBindings()
    setupActions()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      mainTitleView,
      emailTextField,
      validButton,
      nextButton,
      codeTextField
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainTitleView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(130)
      $0.leading.equalToSuperview().offset(20)
    }
    
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(100)
      $0.leading.equalTo(mainTitleView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(40)
    }
    
    validButton.snp.makeConstraints {
      $0.trailing.equalTo(emailTextField.snp.trailing).offset(-10)
      $0.centerY.equalTo(emailTextField).offset(13)
      $0.width.equalTo(50)
      $0.height.equalTo(30)
    }
    
    nextButton.unableButton(false)
    nextButton.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(mainTitleView)
    }
    
    codeTextField.isHidden = true
    codeTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(60)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(40)
    }
  }
  
  // MARK: - 네비게이션 바
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }
  
  func handleTextFieldEvents(textField: AuthTextField) {
    guard let text = textField.getTextFieldValue() else { return }
    
    let isValid = textField.isValidEmail(text)
    let invalidMessage = "잘못된 주소예요. 다시 입력해주세요"
    if isValid {
      textField.alertLabelSetting(hidden: true, title: "", textColor: .g60, underLineColor: .g60)
      unableValidButton(true)
    }else {
      textField.alertLabelSetting(hidden: false, title: invalidMessage)
    }
  }
  
  private func setupBindings() {
    emailTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: viewModel.disposeBag)
    
    codeTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.code)
      .disposed(by: viewModel.disposeBag)
    
    emailTextField.textField.rx.controlEvent(.editingChanged)
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        handleTextFieldEvents(textField: emailTextField)
      })
      .disposed(by: viewModel.disposeBag)
    
    codeTextField.textField.rx.controlEvent([.editingChanged, .editingDidEnd])
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let color: UIColor = codeTextField.textField.isEditing ? .g60 : .g100
          codeTextField.alertLabelSetting(
            hidden: true,
            title: "",
            textColor: color,
            underLineColor: color
          )
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isEmailDuplication
      .subscribe(onNext: { [weak self] result in
        guard let self = self else { return }
        if result {
          self.emailTextField.alertLabelSetting(hidden: false, title: "이미 가입된 이메일 주소예요")
        } else {
          self.emailTextField.alertLabelSetting(hidden: true, underLineColor: .g100)
          self.sendEmailCode()
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isValidCode
      .subscribe(onNext: { [weak self] result in
        guard let self = self,
              let email = emailTextField.getTextFieldValue() else { return }
        result == "true" ? self.goToPasswordVC(email) : self.showToast(message: "인증코드가 일치하지 않아요.",
                                                                   alertCheck: false,
                                                                   large: false)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.nextButtonStatus
      .bind(to: nextButton.rx.isEnabled)
      .disposed(by: viewModel.disposeBag)
    
    viewModel.nextButtonStatus
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: { [weak self] in
        self?.nextButton.unableButton($0)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    validButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        self?.checkEmailDuplication()
      })
      .disposed(by: viewModel.disposeBag)
    
    nextButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        guard let code = self?.codeTextField.getTextFieldValue(),
              let email = self?.emailTextField.getTextFieldValue() else { return }
        self?.viewModel.checkValidCode(code: code, email: email)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - 이메일 중복 확인
  @objc func checkEmailDuplication(){
    guard let email = emailTextField.getTextFieldValue() else { return }
    if emailTextField.isValidEmail(email) {
      viewModel.checkEmailDuplication(email)
    }
  }
  
  // MARK: - 인증코드 전송
  func sendEmailCode(){
    guard let email = emailTextField.getTextFieldValue() else { return }
    
    self.emailTextField.alertLabelSetting(hidden: false,
                                          title: "이메일 코드를 메일로 보내드렸어요.",
                                          textColor: .g80,
                                          underLineColor: .g100)
    if self.viewModel.resend {
      self.showToast(message: "인증코드가 재전송됐어요.", alertCheck: true)
    }
    
    self.viewModel.changeStatus()
    
    viewModel.sendEmailCode(email) {
      self.settingUIAfterSendCode()
    }
  }
  
  // MARK: - 인증코드 전송 후 UI설정
  func settingUIAfterSendCode(){
    self.validButton.setTitle("재전송", for: .normal)
    self.codeTextField.isHidden = false
  }
  
  func unableValidButton(_ check: Bool){
    validButton.isEnabled = check
    validButton.backgroundColor = check ? .o50 : .o60
    
    let titleColor = check ? UIColor.white : UIColor.g70
    validButton.setTitleColor(titleColor, for: .normal)
  }
  
  // MARK: - 비밀번호 설정화면으로 이동
  func goToPasswordVC(_ email: String){
    let signupDatas = SignupDats(email: email)
    let passwordVC = EnterPasswordViewController(signupDatas)
    navigationController?.pushViewController(passwordVC, animated: true)
  }
}
