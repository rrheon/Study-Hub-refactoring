
import UIKit

import SnapKit
import RxSwift
import RxCocoa

/// 회원가입 - 2. 이메일 확인 VC
final class CheckEmailViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: CheckEmailViewModel
  
  /// main 타이틀 View
  private lazy var mainTitleView = AuthTitleView(pageNumber: "2/5",
                                                 pageTitle: "이메일을 입력해주세요",
                                                 pageContent: nil)

  /// emailTexstField의 값
  private lazy var emailTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "이메일",
    textFieldPlaceholder: "@inu.ac.kr",
    alertLabelTitle: "잘못된 주소예요. 다시 입력해주세요")
  
  /// emailTextField
  private lazy var emailTextField = AuthTextField(setValue: emailTextFieldValue)
  
  /// 이메일 인증 버튼
  private lazy var validButton: UIButton = {
    let validBtn = UIButton()
    validBtn.setTitle("인증", for: .normal)
    validBtn.setTitleColor(.g90, for: .normal)
    validBtn.backgroundColor = .o60
    validBtn.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    validBtn.layer.cornerRadius = 5
    return validBtn
  }()

  /// 인증코드 TextFiled 값
  private lazy var codeTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "인증코드",
    textFieldPlaceholder: "인증코드를 입력해주세요",
    alertLabelTitle: ""
  )
  
  ///  인증코드 TextFiled
  private lazy var codeTextField = AuthTextField(setValue: codeTextFieldValue)
  
  /// 다음버튼
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  init(with viewModel: CheckEmailViewModel){
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: .none)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationSetting()
    
    setUpLayout()
    makeUI()
    
    setupBindings()
    setupActions()
  } // viewDidLoad
  
  
  // MARK: - setUpLayout
  
  /// Layout 설정
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
  
  /// UI설정
  func makeUI(){
    // mainTitleView
    mainTitleView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    // 이메일 TextField
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(100)
      $0.leading.equalTo(mainTitleView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(40)
    }
    
    // 인증버튼
    validButton.snp.makeConstraints {
      $0.trailing.equalTo(emailTextField.snp.trailing).offset(-10)
      $0.centerY.equalTo(emailTextField).offset(13)
      $0.width.equalTo(50)
      $0.height.equalTo(30)
    }
    
    // 다음버튼
    nextButton.unableButton(false)
    nextButton.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(mainTitleView)
    }
    
    // 인증코드 입력 TextField
    codeTextField.isHidden = true
    codeTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(60)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(40)
    }
  }
  
  // MARK: - 네비게이션 바
  
  /// 네비게이션 바 세팅
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }
  
  /// 이메일 TextField 이벤트 처리
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
  
  
  /// 바인딩
  private func setupBindings() {
    // 이메일 TextField 바인딩
    emailTextField.textField.rx.text.orEmpty
      .compactMap({ $0 })
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    // 인증코드 TextField
    codeTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.code)
      .disposed(by: disposeBag)
    
    // 이메일 TextField 값 변경 시 이벤트
    emailTextField.textField.rx.controlEvent(.editingChanged)
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.handleTextFieldEvents(textField: vc.emailTextField)
      })
      .disposed(by: disposeBag)

    // 인증코드 TextField 변경 시, 입력 종료 시 이벤트처리
    codeTextField.textField.rx.controlEvent([.editingChanged, .editingDidEnd])
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        let color: UIColor = vc.codeTextField.textField.isEditing ? .g60 : .g100
        vc.codeTextField.alertLabelSetting(
          hidden: true,
          title: "",
          textColor: color,
          underLineColor: color
        )
      })
      .disposed(by: disposeBag)
    
    // 이메일 중복 여부에 따른 처리
    viewModel.isEmailDuplication
      .withUnretained(self)
      .subscribe(onNext: { vc, result in
        if result {
          vc.emailTextField.alertLabelSetting(hidden: false, title: "이미 가입된 이메일 주소예요")
        } else {
          vc.emailTextField.alertLabelSetting(hidden: true, underLineColor: .g100)
          vc.sendEmailCode()
        }
      })
      .disposed(by: disposeBag)
    
    // 인증코드 유효성 체크 처리
    viewModel.isValidCode
      .withUnretained(self)
      .subscribe(onNext: { vc, result in
        guard let email = vc.emailTextField.getTextFieldValue() else { return }
        if result == "true" {
          vc.viewModel.steps.accept(SignupStep.enterPasswordScreenIsRequired)
        } else {
          ToastPopupManager.shared.showToast(message: "인증코드가 일치하지 않아요.",
                                             alertCheck: false,
                                             large: false)
        }
      })
      .disposed(by: disposeBag)
    
    // 다음버튼 상태
    viewModel.nextButtonStatus
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: { vc, status in
        vc.nextButton.isEnabled = status
        vc.nextButton.unableButton(status)
      })
      .disposed(by: disposeBag)

  }
  
  /// Actions 설정
  func setupActions(){
    // 이메일 중복여부 확인
    validButton.rx.tap
      .map { _ in true }
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: { vc, _ in
        guard let email = vc.emailTextField.getTextFieldValue() else { return }
        if vc.emailTextField.isValidEmail(email) {
          vc.viewModel.checkEmailDuplication(email)
        }
      })
      .disposed(by: disposeBag)

    // 다음 버튼 터치 시
    nextButton.rx.tap
      .map { _ in true}
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: { vc, _ in
        guard let code = vc.codeTextField.getTextFieldValue(),
              let email = vc.emailTextField.getTextFieldValue() else { return }
        vc.viewModel.checkValidCode(code: code, email: email)
        
        // 이메일 정보 전달
        EnterMajorViewModel.shared.email = email
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - 인증코드 전송
  
  /// 인증코드 전송
  func sendEmailCode(){
    guard let email = emailTextField.getTextFieldValue() else { return }
    
    self.emailTextField.alertLabelSetting(hidden: false,
                                          title: "이메일 코드를 메일로 보내드렸어요.",
                                          textColor: .g80,
                                          underLineColor: .g100)
    if self.viewModel.resend == true {
      ToastPopupManager.shared.showToast(message: "인증코드가 재전송됐어요.")
    }
    
    self.viewModel.resend = true
    
    viewModel.sendEmailCode(email) {
      self.validButton.setTitle("재전송", for: .normal)
      self.codeTextField.isHidden = false
    }
  }
  
  // MARK: - 인증코드 전송 후 UI설정
  
  
  /// 인증코드 전송 후 UI설정
  /// - Parameter check:이메일 유효성
  func unableValidButton(_ check: Bool){
    validButton.isEnabled = check
    validButton.backgroundColor = check ? .o50 : .o60
    
    let titleColor = check ? UIColor.white : UIColor.g70
    validButton.setTitleColor(titleColor, for: .normal)
  }
  
}
