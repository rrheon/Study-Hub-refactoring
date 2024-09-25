
import Foundation

import SnapKit
import RxCocoa

final class EditPasswordViewController: CommonNavi {
  let viewModel: EditPasswordViewModel
  
  let firstTextFieldvalue = EditPasswordTextFieldValue(
    labelTitle: "새로운 비밀번호를 입력해주세요",
    textFieldTitle: "10자리 이상, 특수문자 포함 필수",
    alertContentToSuccess: "사용 가능한 비밀번호예요",
    alertContentToFail: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
  )
  
  private lazy var firstPasswordTextField = EditPasswordTextField(firstTextFieldvalue)
  
  let secondTextFieldvalue = EditPasswordTextFieldValue(
    labelTitle: "새로운 비밀번호를 한 번 더 입력해주세요",
    textFieldTitle: "새 비밀번호 한 번 더 입력",
    alertContentToSuccess: "비밀번호가 일치해요",
    alertContentToFail: "비밀번호가 일치하지 않아요"
  )
  
  private lazy var secondPasswordTextField = EditPasswordTextField(secondTextFieldvalue)
  
  init(_ userEmail: String, loginStatus: Bool = true) {
    self.viewModel = EditPasswordViewModel(userEmail: userEmail, loginStatus: loginStatus)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    makeUI()
    
    setupActions()
    setupBinding()
  }
  
  func makeUI(){
    view.addSubview(firstPasswordTextField)
    firstPasswordTextField.textField.delegate = self
    firstPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(100)
    }
    
    view.addSubview(secondPasswordTextField)
    secondPasswordTextField.textField.delegate = self
    secondPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(firstPasswordTextField.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(firstPasswordTextField)
      $0.height.equalTo(100)
    }
  }
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "비밀번호 변경")
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg", activate: false)
  }
  
  func setupBinding(){
    firstPasswordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.firstPassword)
      .disposed(by: viewModel.disposeBag)
    
    secondPasswordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.secondPassword)
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    viewModel.firstPassword
      .asDriver(onErrorJustReturn: "")
      .filter({ !$0.isEmpty })
      .drive(onNext: { [weak self] password in
        guard let self = self else { return }
        let checkValid = viewModel.isValidPassword(password)
        
        checkValidPassword(textfield: firstPasswordTextField, checkValid: checkValid)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.secondPassword
      .asDriver(onErrorJustReturn: "")
      .filter({ !$0.isEmpty })
      .drive(onNext: { [weak self] password in
        guard let self = self else { return }
        let checkSamePassword = viewModel.checkSamePassword()
        
        checkValidPassword(textfield: secondPasswordTextField, checkValid: checkSamePassword)
        
        let rightButtonImg = checkSamePassword ? "CompleteImage" : "DeCompletedImg"
        rightButtonSetting(imgName: rightButtonImg, activate: checkSamePassword)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isSuccessChangePassword
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] result in
        switch result {
        case true:
          self?.checkLoginStatus()
        case false:
          return
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func checkValidPassword(textfield: EditPasswordTextField, checkValid: Bool){
    switch checkValid {
    case true:
      textfield.alertLabelSetting(
        hidden: false,
        successOrFail: true,
        textColor: .g_10
      )
    case false:
      textfield.alertLabelSetting(
        hidden: false,
        successOrFail: false,
        textColor: .r50
      )
    }
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    viewModel.storePasswordToServer()
  }
  
  func checkLoginStatus(){
    switch viewModel.loginStatus {
    case true:
      self.navigationController?.popViewController(animated: true)
      self.navigationController?.popViewController(animated: false)
      
    case false:
      logout()
    }
    self.showToast(message: "비밀번호가 변경됐어요", alertCheck: true)
  }
}

extension EditPasswordViewController {
  override func textFieldDidBeginEditing(_ textField: UITextField) {}
  override func textFieldDidEndEditing(_ textField: UITextField) {}
}

extension EditPasswordViewController: Logout {}
