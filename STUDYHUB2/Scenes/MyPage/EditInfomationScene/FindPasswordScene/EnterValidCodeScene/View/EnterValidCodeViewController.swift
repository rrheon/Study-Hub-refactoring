
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class EnterValidCodeViewController: CommonNavi {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: EnterValidCodeViewModel
  
  private lazy var titleLabel = createLabel(
    title: "가입했던 이메일 주소를 입력해주세요",
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 16
  )
  
  private lazy var validCodeTextField = createTextField(title: "인증코드")
  
  private lazy var emailLabel = createLabel(
    textColor: .bg90,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var resendCodeButton = StudyHubButton(title: "  재전송  ")
  
  init(_ email: String) {
    self.viewModel = EnterValidCodeViewModel(email)
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
  
  func setUpLayout(){
    [
      titleLabel,
      emailLabel,
      validCodeTextField,
      resendCodeButton
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
    
    emailLabel.text = "전송된 이메일 \(viewModel.email)"
    emailLabel.changeColor(wantToChange: "\(viewModel.email)", color: .black)
    
    emailLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
    }
    
    validCodeTextField.autocorrectionType = .no
    validCodeTextField.autocapitalizationType = .none
    validCodeTextField.snp.makeConstraints {
      $0.top.equalTo(emailLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    resendCodeButton.snp.makeConstraints {
      $0.centerY.equalTo(validCodeTextField)
      $0.trailing.equalTo(validCodeTextField).offset(-10)
      $0.height.equalTo(30)
      $0.width.equalTo(53)
    }
  }
  
  func setupNavigationbar() {
    settingNavigationTitle(title: "비밀번호 찾기")
    leftButtonSetting()
    rightButtonSetting(imgName: "UnableNextButton", activate: false)
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    viewModel.checkValidCode()
  }
  
  func setupBinding(){
    validCodeTextField.rx.text.orEmpty
      .bind(to: viewModel.validCode)
      .disposed(by: disposeBag)
  }
  
  func setupActions(){
    viewModel.validCode
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [ weak self] email in
        let rightButton = email.isEmpty ? "UnableNextButton" : "ableNextButton"
        self?.rightButtonSetting(imgName: rightButton, activate: !email.isEmpty)
      })
      .disposed(by: disposeBag)
    
    viewModel.isCodeSended
      .subscribe(onNext: { [weak self] sended in
        if sended {
          self?.showToast(message: "인증코드가 재전송됐어요.")
        }
      })
      .disposed(by: disposeBag)
    
    resendCodeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.viewModel.resendEmailValidCode()
      })
      .disposed(by: disposeBag)
    
    viewModel.isValidCode
      .subscribe(onNext: { [weak self] valid in
        guard let self = self else { return }
        let email = viewModel.email
        switch valid {
        case true:
          moveToOtherVCWithSameNavi(
            vc: EditPasswordViewController(email, loginStatus: false),
            hideTabbar: true
          )
        case false:
          self.showToast(
            message: "인증코드가 일치하지 않아요. 다시 입력하거나 새 인증코드를 받아주세요.",
            alertCheck: false
          )
        }
      })
      .disposed(by: disposeBag)
  }
}

extension EnterValidCodeViewController: CreateUIprotocol {}
