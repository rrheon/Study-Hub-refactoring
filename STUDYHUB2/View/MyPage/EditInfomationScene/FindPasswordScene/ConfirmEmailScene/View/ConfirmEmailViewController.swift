
import UIKit

import SnapKit
import RxCocoa

final class ConfirmEmailViewController: CommonNavi {
  let viewModel: ConfirmEmailViewModel
  
  private lazy var titleLabel = createLabel(
    title: "가입했던 이메일 주소를 입력해주세요",
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 16
  )
  
  private lazy var emailTextField = createTextField(title: "@inu.ac.kr")
  
  override init(_ loginStatus: Bool) {
    self.viewModel = ConfirmEmailViewModel(loginStatus: loginStatus)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setUpLayout()
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  // MARK: - setUpLayout
  
  
  func setUpLayout(){
    [
      titleLabel,
      emailTextField
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    emailTextField.autocorrectionType = .no
    emailTextField.autocapitalizationType = .none
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
  }
  
  // MARK: - navigationbar
  
  
  func setupNavigationbar() {
    settingNavigationTitle(title: "비밀번호 찾기")
    leftButtonSetting()
    rightButtonSetting(imgName: "UnableNextButton", activate: false)
  }
  
  override func leftButtonTapped(_ sender: UIBarButtonItem) {
    viewModel.loginStatus ? super.leftButtonTapped(sender) : dismiss(animated: true)
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    viewModel.checkEmailValid()
  }
  
  func setupBinding(){
    emailTextField.rx.text.orEmpty
      .filter({ !$0.isEmpty })
      .bind(to: viewModel.email)
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    viewModel.email
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [ weak self] email in
        let rightButton = email.isEmpty ? "UnableNextButton" : "ableNextButton"
        self?.rightButtonSetting(imgName: rightButton, activate: !email.isEmpty)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isExistEmail
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] result in
        if result {
          guard let email = self?.viewModel.email.value else { return }
          self?.moveToOtherVCWithSameNavi(vc: EnterValidCodeViewController(email), hideTabbar: true)
        } else {
          self?.showToast(message: "가입되지 않은 이메일이에요. 다시 입력해주세요.", alertCheck: false)
        }
      })
      .disposed(by: viewModel.disposeBag)

  }
}

extension ConfirmEmailViewController: CreateUIprotocol {}
