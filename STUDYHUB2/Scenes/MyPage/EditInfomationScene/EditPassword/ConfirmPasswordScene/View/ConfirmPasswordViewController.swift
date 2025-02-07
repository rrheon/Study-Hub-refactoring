import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ConfirmPasswordViewController: CommonNavi {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: ConfirmPasswordViewModel
  
  let value = EditPasswordTextFieldValue(
    labelTitle: "현재 비밀번호를 입력해주세요",
    textFieldTitle: "현재 비밀번호",
    alertContentToSuccess: "",
    alertContentToFail: ""
  )
  
  private lazy var passwordView = EditPasswordTextField(value)
  
  private lazy var forgotPasswordButton: UIButton = {
    let forgotPasswordButton = UIButton(type: .system)
    forgotPasswordButton.setTitle("비밀번호가 기억나지 않으시나요?", for: .normal)
    forgotPasswordButton.setTitleColor(.g70, for: .normal)
    forgotPasswordButton.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    forgotPasswordButton.setUnderlineInLoginVC()
    return forgotPasswordButton
  }()
  
  
  init(_ userEmail: String) {
    self.viewModel = ConfirmPasswordViewModel(userEmail: userEmail)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
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
      passwordView,
      forgotPasswordButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    passwordView.textField.delegate = self
    passwordView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(109)
    }
    
    forgotPasswordButton.snp.makeConstraints {
      $0.top.equalTo(passwordView.snp.bottom)
      $0.centerX.equalTo(passwordView)
    }
  }

  func setupNavigationbar(){
    settingNavigationTitle(title: "비밀번호 변경")
    leftButtonSetting()
    rightButtonSetting(imgName: "UnableNextButton", activate: false)
  }
  
  func setupBinding(){
    passwordView.textField.rx.text.orEmpty
      .bind(to: viewModel.currentPassword)
      .disposed(by: disposeBag)
  }
  
  func setupActions(){
    viewModel.currentPassword
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] in
        let buttonImage = !$0.isEmpty ? "ableNextButton" : "UnableNextButton"
        let buttonActivate = !$0.isEmpty ? true : false
        self?.rightButtonSetting(imgName: buttonImage, activate: buttonActivate)
      })
      .disposed(by: disposeBag)
    
    forgotPasswordButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.moveToOtherVCWithSameNavi(vc: ConfirmEmailViewController(true), hideTabbar: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.isValidPassword
      .subscribe(onNext: { [weak self] valid in
        switch valid {
        case true:
          self?.moveToOtherVCWithSameNavi(vc: EditPasswordViewController(
            self?.viewModel.userEmail ?? ""
          ), hideTabbar: true)
        case false:
          self?.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
        }
      })
      .disposed(by: disposeBag)
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    viewModel.nextButtonTapped(viewModel.currentPassword.value)
  }
  
}

