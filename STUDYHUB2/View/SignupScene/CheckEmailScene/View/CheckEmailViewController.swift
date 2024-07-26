
import UIKit

import SnapKit

final class CheckEmailViewController: CommonNavi {
  
  let editUserManager = EditUserInfoManager.shared
  
  var resend: Bool = false
  private lazy var mainTitleView = AuthTitleView(pageNumber: "2/5",
                                                 pageTitle: "이메일을 입력해주세요",
                                                 pageContent: nil)

  // MARK: - 화면구성
  private lazy var emailTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "이메일",
    textFieldPlaceholder: "@inu.ac.kr",
    alertLabelTitle: "잘못된 주소예요. 다시 입력해주세요",
    type: true)
  
  private lazy var emailTextField = AuthTextField(setValue: emailTextFieldValue)
  
  private lazy var validButton: UIButton = {
    let validBtn = UIButton()
    validBtn.setTitle("인증", for: .normal)
    validBtn.setTitleColor(.g90, for: .normal)
    validBtn.backgroundColor = .o60
    validBtn.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    validBtn.layer.cornerRadius = 5
//    validBtn.addAction(UIAction { _ in
//      self.checkEmailDuplication()
//    }, for: .touchUpInside)
    return validBtn
  }()
  
  private lazy var codeTextFieldValue = SetAuthTextFieldValue(
    labelTitle: "인증코드",
    textFieldPlaceholder: "인증코드를 입력해주세요",
    alertLabelTitle: "",
    type: false)
  
  private lazy var codeTextField = AuthTextField(setValue: codeTextFieldValue)
  
  private lazy var nextButton = StudyHubButton(title: "다음", actionDelegate: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationSetting()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      mainTitleView,
      emailTextField,
      validButton,
      nextButton,
      codeTextField
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainTitleView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(100)
      $0.leading.equalTo(mainTitleView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(40)
    }
    
    validButton.snp.makeConstraints {
      $0.trailing.equalTo(emailTextField.snp.trailing).offset(-10)
      $0.centerY.equalTo(emailTextField).offset(13)
      $0.width.equalTo(50)
      $0.height.equalTo(30)
    }
    
    nextButton.unableButton(true)
    nextButton.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(mainTitleView)
    }
    
//    codeTextField.isHidden = true
    codeTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(60)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(40)
    }
  }
  
  // MARK: - 네비게이션 바
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }
  
  // MARK: - 코드를 입력할 때
  @objc func codeTextFieldDidChange(){
    
    guard let code = codeTextField.getTextFieldValue()?.isEmpty,
          let email = emailTextField.getTextFieldValue()?.isEmpty else { return }

    nextButton.unableButton(false)
  }
  
 // MARK: - 코드입력이 끝났을 때
//  @objc func codeTextFieldDidend(){
//    codeTextField.textFieldEnd(.g100)
//  }
  
  // MARK: - 이메일 중복 확인
//  @objc func checkEmailDuplication(){
//    guard let email = emailTextField.text else { return }
//  
//    if isValidEmail(email) {
//      editUserManager.checkEmailDuplication(email: email) { result in
//        if result {
//          DispatchQueue.main.async {
//            self.emailStatusLabel.isHidden = false
//            self.emailStatusLabel.text = "이미 가입된 이메일 주소예요"
//            self.emailTextFielddividerLine.backgroundColor = .r50
//          }
//        } else {
//          DispatchQueue.main.async {
//            self.emailStatusLabel.isHidden = true
//            self.emailTextFielddividerLine.backgroundColor = .g100
//            
//            self.sendEmailCode()
//          }
//        }
//      }
//    }
//  }
  
  // MARK: - 인증코드 전송
//  func sendEmailCode(){
//    guard let email = emailTextField.text else { return }
//    editUserManager.sendEmailCode(email: email) {
//      self.settingUIAfterSendCode()
//
//      if self.resend {
//        self.showToast(message: "인증코드가 재전송됐어요.", alertCheck: true)
//      }
//    }
//  }
  
  // MARK: - 인증코드 전송 후 UI설정
//  func settingUIAfterSendCode(){
//    DispatchQueue.main.async {
//      self.emailStatusLabel.isHidden = false
//      self.emailStatusLabel.text = "인증코드를 메일로 보내드렸어요"
//      self.emailStatusLabel.textColor = .g80
//      
//      self.validButton.setTitle("재전송", for: .normal)
//      
//      self.verificationLabel.isHidden = false
//      self.codeTextField.isHidden = false
//      self.verificationCodedividerLine.isHidden = false
//      
//      self.resend = true
//    }
//  }
  
//  // MARK: - 인증코드 검증
//  func nextButtonTapped(){
//    guard let code = codeTextField.text,
//          let email = emailTextField.text else { return }
//    editUserManager.checkValidCode(code: code,
//                                   email: email) { result in
//      
//      if result == "true" {
//        self.goToPasswordVC(email)
//      } else {
//        self.showToast(message: "인증코드가 일치하지 않아요.",
//                       alertCheck: false,
//                       large: false)
//      }
//    }
//  }
//  
  // MARK: - 비밀번호 설정화면으로 이동
  func goToPasswordVC(_ email: String){
    let passwordVC = PasswordViewController()
    passwordVC.email = email
    navigationController?.pushViewController(passwordVC, animated: true)
//    moveToOtherVC(vc: PasswordViewController(), naviCheck: true)
  }
}

extension CheckEmailViewController: StudyHubButtonProtocol {
  func buttonTapped() {
    
  }
}
