//
//  FindPasswordViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/12/27.
//

import UIKit

import SnapKit
import Moya

final class FindPasswordViewController: NaviHelper {
  let editUserInfoManager = EditUserInfoManager.shared
  
  var previousVC: UIViewController?
  var userEmail: String? {
    didSet {
      emailLabel.text = "전송된 이메일 \(userEmail ?? "없음")"
    }
  }
  private lazy var titleLabel = createLabel(title: "가입했던 이메일 주소를 입력해주세요",
                                            textColor: .black,
                                            fontType: "Pretendard-Bold",
                                            fontSize: 16)
  
  private lazy var emailTextField = createTextField(title: "@inu.ac.kr")
  
  private lazy var emailLabel = createLabel(title: "전송된 이메일 \(userEmail ?? "없음")",
                                            textColor: .bg90,
                                            fontType: "Prentendard",
                                            fontSize: 12)
  
  private lazy var codeTextField = createTextField(title: "인증코드")
  
  private lazy var resendCodeButton: UIButton = {
    let button = UIButton()
    button.setTitle("  재전송  ", for: .normal)
    button.tintColor = .white
    button.backgroundColor = .o50
    button.layer.cornerRadius = 5
    button.addAction(UIAction { _ in
      self.sendCodeButtonTapped(resend: true)
    }, for: .touchUpInside)

    return button
  }()
  
  var checkEmail: Bool = false
  
  // MARK: - 새로운 비밀번호 입력하는 VC
  private lazy var hideFirstPasswordButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "CloseEyeImage"), for: .normal)
    button.addAction(UIAction{ _ in
      self.hidePasswordButtonTapped(self.hideFirstPasswordButton)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var hideSecondPasswordButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "CloseEyeImage"), for: .normal)
    button.addAction(UIAction{ _ in
      self.hidePasswordButtonTapped(self.hideSecondPasswordButton)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var enterNewPasswordTextField = createTextField(title: "10자리 이상,특수문자 포함 필수")
  
  private lazy var newPasswordLabel = createLabel(title: "새로운 비밀번호를 한 번 더 입력해주세요",
                                                  textColor: .black,
                                                  fontType: "Pretendard-Bold",
                                                  fontSize: 16)
  private lazy var newPasswordTextField = createTextField(title: "새 비밀번호를 한 번 더 입력")
  
  private lazy var checkValidPasswordLabel = createLabel(
    title: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)",
    textColor: .r50,
    fontType: "Pretendard",
    fontSize: 12)
  
  private lazy var checkEqualPasswordLabel = createLabel(title: "비밀번호가 일치하지 않아요",
                                                         textColor: .r50,
                                                         fontType: "Pretendard",
                                                         fontSize: 12)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      titleLabel,
      emailTextField,
      resendCodeButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
   
    emailTextField.addTarget(self,
                             action: #selector(textFieldDidChange(_:)),
                             for: .editingChanged)
    emailTextField.autocorrectionType = .no
    emailTextField.autocapitalizationType = .none
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
  }
  
  override func leftButtonTapped(_ sender: UIBarButtonItem) {
    if previousVC != nil {
      navigationController?.popViewController(animated: true)
    } else {
      dismiss(animated: true)
    }
  }
  
  // MARK: - 네비게이션 재설정
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    
    settingNavigationTitle(title: "비밀번호 찾기",
                           font: "Pretendard-Bold",
                           size: 18)
    
    let completeImg = UIImage(named: "UnableNextButton")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: .none)
    navigationItem.rightBarButtonItem = completeButton
  }
    
  // MARK: - 이메일 입력 시
  func checkTextFields(checkEmail: Bool) {
    guard let textField1Text = emailTextField.text, !textField1Text.isEmpty else { return }
   
    let choseFunc = checkEmail ? #selector(checkValidCode) : #selector(checkEmailValid)
    print("이메일 체크:\(checkEmail)")
    let completeImg = UIImage(named: "ableNextButton")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: choseFunc)
    navigationItem.rightBarButtonItem = completeButton
  }
  
  // MARK: - 이메일 가입여부 확인
  @objc func checkEmailValid(){
    guard let email = emailTextField.text else { return }
    print("이메일 가입 여부")
    print(email)
    editUserInfoManager.checkEmailDuplication(email: email) { result in
      print(result)
      if result {
        DispatchQueue.main.async {
          self.userEmail = email
          self.checkEmail = true
          self.nextButtonTapped()
        }
      } else {
        self.showToast(message: "가입되지 않은 이메일이에요. 다시 입력해주세요.",
                       alertCheck: false)
      }
    }
  }
  
  // MARK: - 이메일 가입여부 확인 후
  @objc func nextButtonTapped(){
    let completeImg = UIImage(named: "UnableNextButton")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: #selector(checkValidCode))
    navigationItem.rightBarButtonItem = completeButton
    
    sendCodeButtonTapped(resend: false)
    
    titleLabel.text = "이메일에 전송된 인증코드를 입력해주세요"
    emailTextField.isHidden = true
    
    [
      emailLabel,
      codeTextField,
      resendCodeButton
    ].forEach {
      view.addSubview($0)
    }
    
    emailLabel.changeColor(label: emailLabel, wantToChange: "전송된 이메일", color: .bg70)
    emailLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    codeTextField.snp.makeConstraints {
      $0.top.equalTo(emailLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    resendCodeButton.snp.makeConstraints {
      $0.trailing.equalTo(codeTextField.snp.trailing).offset(-10)
      $0.centerY.equalTo(codeTextField)
      $0.height.equalTo(codeTextField).multipliedBy(0.6)
    }
  }
  
  // MARK: - 전송받은 코드 유효성 확인
  @objc func checkValidCode(){
    print("코드체크전")
    guard let code = codeTextField.text else { return }
    guard let email = userEmail else { return }
    
    editUserInfoManager.checkValidCode(code: code,
                                       email: email) { result in
      if result == "true" {
        self.afterCheckCode()
      } else {
        self.showToast(message: "인증코드가 일치하지 않아요. 다시 입력하거나 새 인증코드를 받아주세요.",
                       alertCheck: false,
                       large: true)
      }
    }
    
  }

  // MARK: - 이메일 검증 코드 전송
  func sendCodeButtonTapped(resend: Bool){
    guard let email = userEmail else { return }
    
    editUserInfoManager.sendEmailCode(email: email) {
      if resend {
        self.showToast(message: "인증코드가 재전송됐어요.", alertCheck: true)
      }
    }
  }
  
  // MARK: - 코드가 일치할 때 VC업데이트, editpassword에서 새로운 비밀번호 입력하는거랑 동일하게 수정
  @objc func afterCheckCode(){
    
    titleLabel.text = "새로운 비밀번호를 입력해주세요"
    
    emailLabel.isHidden = true
    codeTextField.isHidden = true
    resendCodeButton.isHidden = true
    
    [
      enterNewPasswordTextField,
      hideFirstPasswordButton,
      checkValidPasswordLabel,
      newPasswordLabel,
      newPasswordTextField,
      hideSecondPasswordButton,
      checkEqualPasswordLabel
    ].forEach {
      view.addSubview($0)
    }
    
    enterNewPasswordTextField.isSecureTextEntry = true
    enterNewPasswordTextField.layer.borderColor = UIColor.bg50.cgColor
    enterNewPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.trailing.equalToSuperview().offset(-20)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.height.equalTo(50)
    }
    
    hideFirstPasswordButton.snp.makeConstraints {
      $0.centerY.equalTo(enterNewPasswordTextField)
      $0.trailing.equalTo(enterNewPasswordTextField.snp.trailing).offset(-10)
    }
    
    checkValidPasswordLabel.isHidden = true
    checkValidPasswordLabel.snp.makeConstraints {
      $0.top.equalTo(enterNewPasswordTextField.snp.bottom)
      $0.leading.equalTo(enterNewPasswordTextField.snp.leading)
    }
    
    newPasswordLabel.snp.makeConstraints {
      $0.leading.equalTo(enterNewPasswordTextField.snp.leading)
      $0.top.equalTo(enterNewPasswordTextField.snp.bottom).offset(30)
    }
    
    newPasswordTextField.isSecureTextEntry = true
    newPasswordTextField.layer.borderColor = UIColor.bg50.cgColor
    newPasswordTextField.snp.makeConstraints {
      $0.leading.equalTo(enterNewPasswordTextField.snp.leading)
      $0.top.equalTo(newPasswordLabel.snp.bottom).offset(10)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    hideSecondPasswordButton.snp.makeConstraints {
      $0.centerY.equalTo(newPasswordTextField)
      $0.trailing.equalTo(newPasswordTextField.snp.trailing).offset(-10)
    }
    
    checkEqualPasswordLabel.isHidden = true
    checkEqualPasswordLabel.snp.makeConstraints {
      $0.top.equalTo(newPasswordTextField.snp.bottom)
      $0.leading.equalTo(newPasswordTextField.snp.leading)
    }
    
    enterNewPasswordTextField.addTarget(self,
                                       action: #selector(textFieldDidChange(_:)),
                                       for: .editingChanged)
    newPasswordTextField.addTarget(self,
                                   action: #selector(textFieldDidChange(_:)),
                                   for: .editingChanged)
  }
  
  // MARK: - 비밀번호 표시 on off
  func hidePasswordButtonTapped(_ sender: UIButton){
    let isPasswordVisible = sender.isSelected
    
    // 모든 텍스트 필드에 대해서 isSecureTextEntry 속성을 변경하여 비밀번호 보이기/가리기 설정
    enterNewPasswordTextField.isSecureTextEntry = !isPasswordVisible
    newPasswordTextField.isSecureTextEntry = !isPasswordVisible
    
    // 버튼의 상태 업데이트
    sender.isSelected = !isPasswordVisible
  }
  
  // MARK: - 비밀번호 특수문자 등 유효성 확인
  func checkValidPassword(firstPassword: String, secondPassword: String) {
    let specialCharacterRegEx = ".*[!&^%$#@()/]+.*"
    let textTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
    let result = textTest.evaluate(with: enterNewPasswordTextField.text)

    if enterNewPasswordTextField.text?.count ?? 0 < 10 || !result {
      checkValidPasswordLabel.isHidden = false
      enterNewPasswordTextField.layer.borderColor = UIColor.r50.cgColor
      
      checkValidPasswordLabel.text = "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
      checkValidPasswordLabel.textColor = .r50
    } else {
      enterNewPasswordTextField.layer.borderColor = UIColor.g_10.cgColor
      
      checkValidPasswordLabel.text = "사용 가능한 비밀번호예요"
      checkValidPasswordLabel.textColor = .g_10
    }
    
    // 다시 입력한 비밀번호가 일치한지 유효성 확인
    if firstPassword != secondPassword {
      checkEqualPasswordLabel.isHidden = false

      newPasswordTextField.layer.borderColor = UIColor.r50.cgColor
      
      checkEqualPasswordLabel.text = "비밀번호가 일치하지 않아요"
      checkEqualPasswordLabel.textColor = .r50
    } else {
      newPasswordTextField.layer.borderColor = UIColor.g_10.cgColor
      
      checkEqualPasswordLabel.text = "비밀번호가 일치해요"
      checkEqualPasswordLabel.textColor = .g_10
    }
  }
  
  // MARK: - 비밀번호 변경
  @objc func completeButtonTapped(){
    guard let password = enterNewPasswordTextField.text else { return }

    editUserInfoManager.changePassword(password: password, email: userEmail ?? "") {
      DispatchQueue.main.async {
        self.navigationController?.popViewController(animated: true)

        self.showToast(message: "비밀번호가 변경됐어요", alertCheck: true)
      }
    }
  }
  
  // MARK: - 두 비밀번호 확인 후 변경
  func checkTextFields() {
    guard let textField1Text = enterNewPasswordTextField.text, !textField1Text.isEmpty,
          let textField2Text = newPasswordTextField.text, !textField2Text.isEmpty else {
      return
    }
    
    guard enterNewPasswordTextField.layer.borderColor == UIColor.g_10.cgColor,
          newPasswordTextField.layer.borderColor == UIColor.g_10.cgColor else {
      return
    }
    
    let completeImg = UIImage(named: "CompleteImage")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: #selector(completeButtonTapped))
    navigationItem.rightBarButtonItem = completeButton
  }
}

extension FindPasswordViewController {
  override func textFieldDidEndEditing(_ textField: UITextField) {
    print("1")
  }
  
  override func textFieldDidBeginEditing(_ textField: UITextField) {
    print("1")
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    if emailTextField.text?.isEmpty != true {
      checkTextFields(checkEmail: checkEmail)
    }
    
    if codeTextField.text?.isEmpty != true {
      let completeImg = UIImage(named: "ableNextButton")?.withRenderingMode(.alwaysOriginal)
      let completeButton = UIBarButtonItem(image: completeImg,
                                           style: .plain,
                                           target: self,
                                           action: #selector(afterCheckCode))
      navigationItem.rightBarButtonItem = completeButton
    }
    
    if textField.placeholder != "10자리 이상, 특수문자 포함 필수" && textField.text?.isEmpty == false {
      let firstPassword = enterNewPasswordTextField.text ?? ""
      let secondPassword = newPasswordTextField.text ?? ""
      
      // checkValidPassword 함수를 호출합니다
      checkValidPassword(firstPassword: firstPassword, secondPassword: secondPassword)
    } else {
      enterNewPasswordTextField.layer.borderColor = UIColor.bg50.cgColor
    }
    
    checkTextFields()
  }
}
