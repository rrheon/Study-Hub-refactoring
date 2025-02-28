import UIKit

import SnapKit
import RxSwift
import RxCocoa

/// 비밀번호 확인 VC
final class ConfirmPasswordViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: ConfirmPasswordViewModel
  
  let value = EditPasswordTextFieldValue(
    labelTitle: "현재 비밀번호를 입력해주세요",
    textFieldTitle: "현재 비밀번호",
    alertContentToSuccess: "",
    alertContentToFail: ""
  )
  
  /// 비밀번호 확인 View
  private lazy var passwordView = EditPasswordTextField(value)
  
  /// 비밀번호 찾기 버튼
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
    super.init(nibName: nil, bundle: nil)
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
  } // viewDidLoad
  
  // MARK: - setUpLayout
  
  
  /// layout 설정
  func setUpLayout(){
    [ passwordView, forgotPasswordButton ]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  
  /// UI 설정
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

  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "비밀번호 변경")
    leftButtonSetting()
    rightButtonSetting(imgName: "UnableNextButton", activate: false)
  }
  
  /// 네비게이션 바 오른쪽 버튼 탭
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.nextButtonTapped(viewModel.currentPassword.value)
  }
  
  /// 바인딩 설정
  func setupBinding(){
    passwordView.textField.rx.text.orEmpty
      .bind(to: viewModel.currentPassword)
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
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
          return
//          self?.moveToOtherVCWithSameNavi(vc: EditPasswordViewController(
//            self?.viewModel.userEmail ?? ""
//          ), hideTabbar: true)
        case false:
          self?.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
        }
      })
      .disposed(by: disposeBag)
  }

}

