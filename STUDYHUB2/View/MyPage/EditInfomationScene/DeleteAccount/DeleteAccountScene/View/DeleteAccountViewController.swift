
import UIKit

import SnapKit
import RxCocoa

// 탈퇴하기 누를 때 action, 팝업
final class DeleteAccountViewController: CommonNavi {
  let viewModel = DeleteAccountViewModel()

  let value = EditPasswordTextFieldValue(
    labelTitle: "비밀번호를 입력해주세요",
    textFieldTitle: "현재 비밀번호",
    alertContentToSuccess: "",
    alertContentToFail: ""
  )
  
  private lazy var passwordTextField = EditPasswordTextField(value)
  
  private lazy var quitButton = StudyHubButton(title: "탈퇴하기")
  
  // MARK: - viewdidload
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
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
  
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "탈퇴하기")
    leftButtonSetting()
  }
  
  func setupBinding(){
    passwordTextField.textField.rx.text.orEmpty
      .filter { !$0.isEmpty }
      .bind(to: viewModel.password)
      .disposed(by: viewModel.disposeBag)
  }
  
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
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isValidPassword
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        self?.deleteAccountButtonTapped($0)
      })
      .disposed(by: viewModel.disposeBag)
    
    quitButton.rx.tap
      .subscribe(onNext: {[weak self] in
        self?.viewModel.checkValidPassword()
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isSuccessToDeleteAccount
      .subscribe(onNext: { [weak self] result in
        self?.resultOfDeleteAccount(result)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func deleteAccountButtonTapped(_ result: Bool){
    switch result {
    case true:
      viewModel.deleteAccount()
    case false:
      self.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
    }
  }
  
  func resultOfDeleteAccount(_ result: Bool){
    switch result {
    case true:
      let popupVC = PopupViewController(
        title: "탈퇴가 완료됐어요",
        desc: "지금까지 스터디허브를 이용해 주셔서 감사합니다.",
        checkEndButton: true
      )
      
      popupVC.popupView.endButtonAction = { [weak self] in
        self?.logout()
      }
      
      popupVC.modalPresentationStyle = .overFullScreen
      self.present(popupVC, animated: false)
    case false:
      self.showToast(message: "계정 탈퇴에 실패했어요.", alertCheck: false)
    }
  }
}

extension DeleteAccountViewController: Logout {}
