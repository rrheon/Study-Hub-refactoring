
import UIKit

import SnapKit
import RxSwift
import RxCocoa

// 탈퇴하기 누를 때 action, 팝업
/// 계정 삭제 VC
final class DeleteAccountViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: DeleteAccountViewModel

  /// 비밀번호 TextField의 Value
  let value = EditPasswordTextFieldValue(
    labelTitle: "비밀번호를 입력해주세요",
    textFieldTitle: "현재 비밀번호",
    alertContentToSuccess: "",
    alertContentToFail: ""
  )
  
  /// 비밀번호 TextField
  private lazy var passwordTextField = EditPasswordTextField(value)
  
  /// 탈퇴하기 버튼
  private lazy var quitButton = StudyHubButton(title: "탈퇴하기")
  
  
  init(viewModel: DeleteAccountViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewdidload
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    makeUI()
    
    setupBinding()
    setupActions()
  } // viewDidLoad
  
  
  /// UI설정
  func makeUI(){
    view.addSubview(passwordTextField)
    passwordTextField.textField.delegate = self
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(109)
    }
    
    view.addSubview(quitButton)
    quitButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - setupNavigationbar
  
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "탈퇴하기")
    leftButtonSetting()
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
  
  /// 바인딩 설정
  func setupBinding(){
    passwordTextField.textField.rx.text.orEmpty
      .filter { !$0.isEmpty }
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
  }
  
  
  /// Actions 설정
  func setupActions(){
    viewModel.password
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] password in
        let backgroundColor: UIColor =  password.isEmpty ? .o30 : .o50
        
        self?.quitButton.unableButton(
          !password.isEmpty,
          backgroundColor: backgroundColor,
          titleColor: .white
        )
      })
      .disposed(by: disposeBag)
    
//    viewModel.isValidPassword
//      .asDriver(onErrorJustReturn: false)
//      .drive(onNext: { [weak self] in
//        self?.deleteAccountButtonTapped($0)
//      })
//      .disposed(by: disposeBag)
//    
    quitButton.rx.tap
      .subscribe(onNext: {[weak self] in
        self?.viewModel.checkValidPassword()
      })
      .disposed(by: disposeBag)
    
//    viewModel.isSuccessToDeleteAccount
//      .subscribe(onNext: { [weak self] result in
//        self?.resultOfDeleteAccount(result)
//      })
//      .disposed(by: disposeBag)
  }
  
  /// 계정 삭제 버튼 탭
//  func deleteAccountButtonTapped(_ result: Bool){
//    switch result {
//    case true:
//      viewModel.deleteAccount()
//    case false:
//      ToastPopupManager.shared.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
//    }
//  }
  
  /// 삭제 완료 시
//  func resultOfDeleteAccount(_ result: Bool){
//    switch result {
//    case true:
//      viewModel.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .accountDeletionCompleted)))
//  
//    case false:
//      ToastPopupManager.shared.showToast(message:  "계정 탈퇴에 실패했어요.", alertCheck: false)
//
//    }
  
}


// MARK: - PopupView Delegate
extension DeleteAccountViewController: PopupViewDelegate {
  // 팝업 닫고 로그인 화면으로 이동
  func endBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
  }
}
