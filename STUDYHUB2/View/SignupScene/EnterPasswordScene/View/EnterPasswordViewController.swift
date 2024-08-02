
import UIKit

import SnapKit
import RxSwift

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
    alertLabelTitle: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)",
    type: true)
  
  private lazy var passwordTextField = EnterPasswordTextField(
    setValue: passwordTextFieldValue)

  private lazy var confirmPasswordTextFieldValue = SetAuthTextFieldValue(
    labelTitle: nil,
    textFieldPlaceholder: "비밀번호를 한 번 더 입력해주세요",
    alertLabelTitle: "비밀번호가 일치하지 않아요",
    type: true)
  
  private lazy var confirmPasswordTextField = EnterPasswordTextField(
    setValue: confirmPasswordTextFieldValue,
    failContent: "비밀번호가 일치하지 않아요",
    successContent: "비밀번호가 확인되었어요")

  private lazy var nextButton = StudyHubButton(title: "다음", actionDelegate: self)
  
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
  }
  
  // MARK: - setUpLayout
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
    
  // MARK: - 두 비밀번호 확인 후 변경
  func setupBindings() {
    passwordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.firstPassword)
      .disposed(by: viewModel.disposeBag)
    
    confirmPasswordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.confirmPassword)
      .disposed(by: viewModel.disposeBag)
    
    viewModel.passwordsMatch
      .subscribe(onNext: { [weak self] in
        self?.nextButton.unableButton(!$0)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - 닉네임 설정화면으로 이동 안눌림 버튼이 데이터가 제대로 옮겨지는지 모르겠음
  func goToNicknameVC(){
    let signupDatas = SignupDats(password: passwordTextField.getTextFieldValue())
    let nicknameVC = EnterNicknameViewController(signupDatas)
  
    navigationController?.pushViewController(nicknameVC, animated: true)
  }
}

extension EnterPasswordViewController: StudyHubButtonProtocol {
  func buttonTapped() {
    goToNicknameVC()
  }
}
