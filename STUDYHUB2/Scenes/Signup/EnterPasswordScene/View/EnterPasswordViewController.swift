
import UIKit

import SnapKit
import RxSwift
import RxCocoa

/// StudyHub - front - SignupScreen - 03
/// - 비밀번호 입력 화면
final class EnterPasswordViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  var viewModel: EnterPasswordViewModel
  
  // MARK: - 화면구성
  
  /// main 타이틀 View
  private lazy var mainTitleView = AuthTitleView(
    pageNumber: "3/5",
    pageTitle: "비밀번호를 설정해주세요",
    pageContent: "10자리 이상, 특수문자 포함(!,@,#,$,%,^,&,*,?,~,_)이 필수에요"
  )
  
  /// 비밀번호 TextField의 값
  private lazy var passwordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "비밀번호",
    textFieldPlaceholder: "비밀번호를 입력해주세요",
    alertLabelTitle: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
  )
  

  /// 비밀번호 입력 TextField
  private lazy var passwordTextField = EnterPasswordTextField(
    setValue: passwordTextFieldValue
  )
  
  /// 비밀번호 확인 TextField의 값
  private lazy var confirmPasswordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: nil,
    textFieldPlaceholder: "비밀번호를 한 번 더 입력해주세요",
    alertLabelTitle: "비밀번호가 일치하지 않아요"
  )
  
  /// 비밀번호 확인 TextField
  private lazy var confirmPasswordTextField = EnterPasswordTextField(
    setValue: confirmPasswordTextFieldValue,
    failContent: "비밀번호가 일치하지 않아요",
    successContent: "비밀번호가 확인되었어요"
  )
  
  /// 다음버튼
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  init(with viewModel: EnterPasswordViewModel){
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
    
    registerTapGesture()
  } // viewDidLoad
  
  // MARK: - setupLayout
  
  
  /// Layout 설정
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
  
  /// UI설정
  func makeUI(){
    /// main 타이틀 View
    mainTitleView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    /// 비밀번호 TextField
    passwordTextField.setPasswordSecure()
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(120)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    /// 비밀번호 확인 TextField
    confirmPasswordTextField.setPasswordSecure()
    confirmPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(45)
      $0.leading.trailing.equalTo(passwordTextField)
      $0.height.equalTo(50)
    }
    
    /// 다음버튼
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(passwordTextField)
    }
  }
  
  // MARK: - 네비게이션 바
  
  /// 네비게이션 바 세팅
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(SignupStep.popIsRequired)
  }
  
  
  /// Actions 설정
  func setupActions(){
    nextButton.rx.tap
      .withUnretained(self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { vc, _ in
        vc.viewModel.steps.accept(SignupStep.enterNicknameScreenIsRequired)
        
        // 비밀번호 정보 전달
        EnterMajorViewModel.shared.password = vc.confirmPasswordTextField.getTextFieldValue()
      })
      .disposed(by: disposeBag)
  }
  

  /// 바인딩 설정
  func setupBindings() {
    bindPasswordTextField(passwordTextField, to: viewModel.firstPassword)
 
  /// 비밀번호 확인 TextField
    confirmPasswordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.confirmPassword)
      .disposed(by: disposeBag)
 
    /// 비밀번호 TextField와 비밀번호 확인 TextField의 값 일치 여부
    viewModel.passwordsMatch
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: {  vc, isMatched in
        vc.nextButton.unableButton(isMatched)
        if vc.confirmPasswordTextField.getTextFieldValue() != "" {
          let color: UIColor = isMatched ? .g_10 : .r50
          let text = isMatched ? "비밀번호가 확인되었어요" : "비밀번호가 일치하지 않아요"
          vc.confirmPasswordTextField.alertLabelSetting(
            hidden: false,
            title: text,
            textColor: color,
            underLineColor: color)
        }})
      .disposed(by: disposeBag)
  }
  
  /// 비밀번호 입력 TextField, 비밀번호 TextField 바인딩
  func bindPasswordTextField(_ textField: AuthTextField,
                             to viewModelProperty: BehaviorRelay<String>) {
    textField.textField.rx.text.orEmpty
      .bind(to: viewModelProperty)
      .disposed(by: disposeBag)
    
    textField.textField.rx.controlEvent([.editingChanged, .editingDidEnd])
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.validatePasswordTextField(textField)
      })
      .disposed(by: disposeBag)
  }
  
  /// 비밀번호  유효성 판단
  func validatePasswordTextField(_ textField: AuthTextField) {
    guard let password = textField.getTextFieldValue() else { return }
    
    let isValidPassword = Utils.isValidPassword(password)
    let isTextFieldEditing = textField.textField.isEditing
    
    let color: UIColor = isValidPassword ? .g_10 : .r50
    let text = isValidPassword ? "사용 가능한 비밀번호예요" : "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
    
    textField.alertLabelSetting(hidden: false, title: text, textColor: color, underLineColor: color)
    
    if !isTextFieldEditing && isValidPassword {
      textField.alertLabelSetting(hidden: true, title: "", textColor: .g100, underLineColor: .g100)
    }
  }
}

extension EnterPasswordViewController: KeyboardProtocol {}
