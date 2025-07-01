
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxFlow

/// StudyHub - front - LoginScreen

final class LoginViewController: UIViewController, Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  let disposeBag: DisposeBag = DisposeBag()

  let viewModel: LoginViewModel
  
  private let customView: LoginView = LoginView()
  
  private lazy var emailTF = customView.emailTextField
  private lazy var passwordTF = customView.passwordTextField
  
  init(with viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: .none, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    setupBinding()
    setupActions()
  } // viewDidLoad
  
  override func loadView() {
    self.view = customView
  }

  // MARK: - setupBinding
    
  /// 바인딩
  private func setupBinding(){
    
    let input = LoginViewModel.Input(
      emailText: emailTF.textField.rx.text.orEmpty.asObservable(),
      passwordText: passwordTF.textField.rx.text.orEmpty.asObservable(),
      loginBtnTapped: customView.loginButton.rx.tap.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    // 이메일 유효성
    output.isEmailValid
      .skip(1)
      .withUnretained(self)
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .subscribe(onNext: { (vc, valid) in
        vc.textFieldAction(textField: vc.emailTF, valid: valid)
      })
      .disposed(by: disposeBag)
    
    // 비밀번호 유효성
    output.isPasswordValid
      .skip(1)
      .withUnretained(self)
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .subscribe(onNext: { (vc, valid) in
        vc.textFieldAction(textField: vc.passwordTF, valid: valid)
      })
      .disposed(by: disposeBag)
    
    // 로그인 결과
    output.isLoginResult
      .withUnretained(self)
      .subscribe(onNext: { (vc, result) in
  
        switch result {
        case .empty:
          ToastPopupManager.shared.showToast(message: ToastPopupMessage.loginWithEmptyValues,
                                             imageCheck: false)
          break
        
        case .fail:
          vc.emailTF.alertLabelSetting(hidden: false, title: LabelTitle.emailAlert)
          vc.passwordTF.alertLabelSetting(hidden: false, title: LabelTitle.passwordAlert)
          break
          
        case .success:
          [vc.emailTF, vc.passwordTF]
            .forEach {
            $0.alertLabelSetting(hidden: true, underLineColor: .g100)
          }
          
          self.steps.accept(AppStep.mainTabIsRequired)
          break
        }
      
    })
      .disposed(by: disposeBag)
  }
  
  /// 버튼 Action 설정
  func setupActions(){
    
    // 탐색버튼 터치
    customView.exploreButton
      .rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        self.steps.accept(AppStep.mainTabIsRequired)
      })
      .disposed(by: disposeBag)

    
    // 회원가입 버튼 터치
    customView.signUpButton
      .rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        self.steps.accept(AppStep.auth(.signupIsRequired))
      })
      .disposed(by: disposeBag)
    
    // 비밀번호찾기 버튼 터치
    customView.forgotPasswordButton
      .rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        self.steps.accept(AppStep.auth(.confirmEmailScreenIsRequired))
      })
      .disposed(by: disposeBag)
  }

  
  /// TextField 입력 시 테두리 설정 및 유효성에 따른 UI 변경
  /// - Parameters:
  ///   - textField: 이메일 / 비밀번호 AuthTextField
  ///   - valid: 유효성
  private func textFieldAction(textField: AuthTextField, valid: Bool){
    let isEditing = textField.textField.isEditing
    let underLineColor: UIColor = isEditing ? .g60 : .g100
    
    textField.alertLabelSetting(hidden: false, title: "", underLineColor: underLineColor)
    
    if !valid {
      let alertInfo = textField == customView.emailTextField ? LabelTitle.emailAlert : LabelTitle.passwordAlert
      textField.alertLabelSetting(hidden: valid, title: alertInfo)
    }
  }
}
