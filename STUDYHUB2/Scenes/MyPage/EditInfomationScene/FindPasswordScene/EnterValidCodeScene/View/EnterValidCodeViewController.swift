
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 이메일 검증 코드 입력 VC
final class EnterValidCodeViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: EnterValidCodeViewModel
  
  /// 이메일 검증 제목 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = "가입했던 이메일 주소를 입력해주세요"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 16)
  }
  
  /// 유효한 코드 입력 TextField
  private lazy var validCodeTextField = StudyHubUI.createTextField(title: "인증코드")
  
  /// 입력한 이메일 라벨
  private lazy var emailLabel = UILabel().then {
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }

  /// 인증코드 재정송 버튼
  private lazy var resendCodeButton = StudyHubButton(title: "  재전송  ")
  
  init(with viewModel: EnterValidCodeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
  } // viewDidLoad
  
  
  /// layout 설정
  func setUpLayout(){
    [ titleLabel, emailLabel, validCodeTextField, resendCodeButton ]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  
  /// UI 설정
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
  
  /// 네비게이션 바 설정
  func setupNavigationbar() {
    settingNavigationTitle(title: "비밀번호 찾기")
    leftButtonSetting()
    rightButtonSetting(imgName: "UnableNextButton", activate: false)
  }
  
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    guard let code = validCodeTextField.text else { return }
    viewModel.checkValidCode(code: code)
  }
 
  
  /// 바인딩 설정
  func setupBinding(){
    validCodeTextField.rx.text.orEmpty
      .bind(to: viewModel.validCode)
      .disposed(by: disposeBag)
  }
  
  
  /// Actions 설정
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
          ToastPopupManager.shared.showToast(message: "인증코드가 재전송됐어요.")
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
          guard let email = viewModel.email else { return }
          viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: false, animate: false))
          viewModel.steps.accept(AppStep.editPasswordScreenIsRequired(email: email))
        case false:
          ToastPopupManager.shared.showToast(
            message: "인증코드가 일치하지 않아요. 다시 입력하거나 새 인증코드를 받아주세요.",
            alertCheck: false)
        }
      })
      .disposed(by: disposeBag)
  }
}
