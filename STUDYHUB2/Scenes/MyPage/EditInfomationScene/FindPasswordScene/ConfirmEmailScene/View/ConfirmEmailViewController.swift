
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 이메일 확인 VC
final class ConfirmEmailViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: ConfirmEmailViewModel
  
  /// 이메일 확인 제목 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = "가입했던 이메일 주소를 입력해주세요"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 16)
  }
  
 /// 이메일 입력 TextField
  private lazy var emailTextField = StudyHubUI.createTextField(title: "@inu.ac.kr")
  
  init(with viewModel: ConfirmEmailViewModel) {
    self.viewModel = ConfirmEmailViewModel()
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
  
  // MARK: - setUpLayout
  
  
  /// layout 설정
  func setUpLayout(){
    [ titleLabel, emailTextField ]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  ///UI 설정
  func makeUI(){
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    view.addSubview(emailTextField)
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
  
  /// 네비게이션 설정
  func setupNavigationbar() {
    settingNavigationTitle(title: "비밀번호 찾기")
    leftButtonSetting()
    rightButtonSetting(imgName: "UnableNextButton", activate: false)
    navigationController?.navigationBar.backgroundColor = .black
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(animate: true))
  }
  
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.checkEmailValid()
  }

  /// 바인딩 설정
  func setupBinding(){
    emailTextField.rx.text.orEmpty
      .filter({ !$0.isEmpty })
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    viewModel.email
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [ weak self] email in
        let rightButton = email.isEmpty ? "UnableNextButton" : "ableNextButton"
        self?.rightButtonSetting(imgName: rightButton, activate: !email.isEmpty)
      })
      .disposed(by: disposeBag)
    
    viewModel.isExistEmail
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] result in
        if result {
          guard let email = self?.viewModel.email.value else { return }

          self?.viewModel.steps.accept(AppStep.popCurrentScreen(animate: false))
          self?.viewModel.steps.accept(AppStep.enterEmailCodeScreenIsRequired(email: email))
        } else {
          ToastPopupManager.shared.showToast(message: "가입되지 않은 이메일이에요. 다시 입력해주세요.",
                                             alertCheck: false)
        }
      })
      .disposed(by: disposeBag)

  }
}

