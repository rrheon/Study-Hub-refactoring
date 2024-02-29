
import UIKit

import SnapKit

final class SignUpViewController: NaviHelper {
  
  let editUserManager = EditUserInfoManager.shared
  
  var resend: Bool = false
  // MARK: - 화면구성
  private lazy var pageNumberLabel = createLabel(title: "2/5",
                                                 textColor: .g60,
                                                 fontType: "Pretendard-Bold",
                                                 fontSize: 18)
  
  private lazy var emailPromptLabel = createLabel(title: "이메일을 입력해주세요",
                                                  textColor: .white,
                                                  fontType: "Pretendard-Bold",
                                                  fontSize: 20)
  
  private lazy var emailLabel = createLabel(title: "이메일",
                                            textColor: .g50,
                                            fontType: "Pretendard-Medium",
                                            fontSize: 14)
  
  private lazy var emailTextField: UITextField = {
    let emailTF = UITextField()
    emailTF.attributedPlaceholder = NSAttributedString(
      string: "@inu.ac.kr",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80]
    )
    emailTF.textColor = .white
    emailTF.backgroundColor = .black
    emailTF.borderStyle = .roundedRect
    emailTF.translatesAutoresizingMaskIntoConstraints = false
    emailTF.addTarget(self,
                      action: #selector(emailTextFieldDidChange),
                      for: .editingChanged)

    emailTF.becomeFirstResponder()
    emailTF.autocorrectionType = .no
    emailTF.autocapitalizationType = .none
    
    return emailTF
  }()
  
  private lazy var validButton: UIButton = {
    let validBtn = UIButton()
    validBtn.setTitle("인증", for: .normal)
    validBtn.setTitleColor(.g90, for: .normal)
    validBtn.backgroundColor = .o60
    validBtn.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    validBtn.layer.cornerRadius = 5
    validBtn.addAction(UIAction { _ in
      self.checkEmailDuplication()
    }, for: .touchUpInside)
    return validBtn
  }()
  
  private lazy var emailTextFielddividerLine: UIView = {
    let emailTFLine = UIView()
    emailTFLine.backgroundColor = .g100
    return emailTFLine
  }()
  
  private lazy var emailStatusLabel = createLabel(title: "잘못된 주소예요. 다시 입력해주세요.",
                                                  textColor: .r50,
                                                  fontType: "Pretendard-Medium",
                                                  fontSize: 12)
  
  private lazy var verificationLabel : UILabel = {
    let label = UILabel()
    label.text = "인증코드"
    label.textColor = .g50
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.isHidden = true
    return label
  }()
  
  private lazy var codeTextField: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(
      string: "인증코드를 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80]
    )
    textField.textColor = .white
    textField.backgroundColor = .black
    textField.borderStyle = .roundedRect
    textField.isHidden = true
    textField.addTarget(self,
                        action: #selector(codeTextFieldDidChange),
                        for: .editingChanged)
    textField.addTarget(self,
                        action: #selector(codeTextFieldDidend),
                        for: .editingDidEnd)
    return textField
  }()
  
  private lazy var verificationCodedividerLine: UIView = {
    let line = UIView()
    line.backgroundColor = .g100
    line.isHidden = true
    return line
  }()
  
  private lazy var nextButton: UIButton = {
    let nextButton = UIButton(type: .system)
    nextButton.setTitle("다음", for: .normal)
    nextButton.setTitleColor(UIColor(hexCode: "#6F6F6F"), for: .normal)
    nextButton.backgroundColor = UIColor(hexCode: "#6F2B1C")
    nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    nextButton.layer.cornerRadius = 10
    nextButton.addAction(UIAction { _ in
      self.nextButtonTapped()
    }, for: .touchUpInside)
    return nextButton
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      pageNumberLabel,
      emailPromptLabel,
      emailLabel,
      emailTextFielddividerLine,
      emailTextField,
      validButton,
      nextButton,
      emailStatusLabel,
      verificationLabel,
      verificationCodedividerLine,
      codeTextField
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    pageNumberLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    emailPromptLabel.snp.makeConstraints {
      $0.top.equalTo(pageNumberLabel.snp.bottom).offset(10)
      $0.leading.equalTo(pageNumberLabel.snp.leading)
    }
    
    emailLabel.snp.makeConstraints {
      $0.top.equalTo(emailPromptLabel.snp.bottom).offset(40)
      $0.leading.equalTo(emailPromptLabel.snp.leading)
    }
    
    emailTextField.delegate = self
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(emailLabel.snp.bottom).offset(20)
      $0.leading.equalTo(emailLabel)
      $0.trailing.equalTo(view).offset(-70)
      $0.height.equalTo(30)
    }
    
    validButton.snp.makeConstraints {
      $0.trailing.equalTo(emailTextFielddividerLine.snp.trailing).offset(-10)
      $0.centerY.equalTo(emailTextField)
      $0.width.equalTo(50)
      $0.height.equalTo(30)
    }
    
    emailTextFielddividerLine.snp.makeConstraints {
      $0.leading.equalTo(emailTextField.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(emailTextField.snp.bottom).offset(10)
      $0.height.equalTo(1)
    }
    
    nextButton.isEnabled = false
    nextButton.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(emailTextFielddividerLine)
    }
    
    emailStatusLabel.isHidden = true
    emailStatusLabel.snp.makeConstraints {
      $0.top.equalTo(emailTextFielddividerLine.snp.bottom).offset(5)
      $0.leading.equalTo(emailTextFielddividerLine.snp.leading)
    }
    
    verificationLabel.isHidden = true
    verificationLabel.snp.makeConstraints { make in
      make.top.equalTo(emailTextFielddividerLine.snp.bottom).offset(50)
      make.leading.equalTo(emailStatusLabel.snp.leading)
    }
    
    codeTextField.isHidden = true
    codeTextField.delegate = self
    codeTextField.snp.makeConstraints { make in
      make.top.equalTo(verificationLabel.snp.bottom).offset(20)
      make.leading.equalTo(emailStatusLabel.snp.leading)
      make.height.equalTo(30)
    }
    
    verificationCodedividerLine.isHidden = true
    verificationCodedividerLine.snp.makeConstraints { make in
      make.leading.trailing.equalTo(emailTextFielddividerLine)
      make.top.equalTo(codeTextField.snp.bottom).offset(5)
      make.height.equalTo(1)
    }
  }
  
  // MARK: - 네비게이션 바
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    
    self.navigationItem.title = "회원가입"
    self.navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
  }
  
  // MARK: - 이메일 유효성 검증
  @objc func emailTextFieldDidChange(){
    guard let email = emailTextField.text else { return }
    if !isValidEmail(email){
      emailStatusLabel.isHidden = false
      emailTextFielddividerLine.backgroundColor = .r50
      
      validButton.setTitleColor(.g90, for: .normal)
      validButton.backgroundColor = .o60
    } else {
      emailStatusLabel.isHidden = true
      emailTextFielddividerLine.backgroundColor = .g100
      
      validButton.setTitleColor(.white, for: .normal)
      validButton.backgroundColor = .o50
    }
  }
  
  // MARK: - 코드를 입력할 때
  @objc func codeTextFieldDidChange(){
    verificationCodedividerLine.backgroundColor = .g60
    
    guard let code = codeTextField.text,
          let email = emailTextField.text else { return }
    nextButton.isEnabled = true
    nextButton.backgroundColor = .o50
    nextButton.setTitleColor(.white, for: .normal)
  }
  
 // MARK: - 코드입력이 끝났을 때
  @objc func codeTextFieldDidend(){
    verificationCodedividerLine.backgroundColor = .g100
  }
  
  // MARK: - 이메일 중복 확인
  @objc func checkEmailDuplication(){
    guard let email = emailTextField.text else { return }
  
    if isValidEmail(email) {
      editUserManager.checkEmailDuplication(email: email) { result in
        if result {
          DispatchQueue.main.async {
            self.emailStatusLabel.isHidden = false
            self.emailStatusLabel.text = "이미 가입된 이메일 주소예요"
            self.emailTextFielddividerLine.backgroundColor = .r50
          }
        } else {
          DispatchQueue.main.async {
            self.emailStatusLabel.isHidden = true
            self.emailTextFielddividerLine.backgroundColor = .g100
            
            self.sendEmailCode()
          }
        }
      }
    }
  }
  
  // MARK: - 인증코드 전송
  func sendEmailCode(){
    guard let email = emailTextField.text else { return }
    editUserManager.sendEmailCode(email: email) {
      self.settingUIAfterSendCode()

      if self.resend {
        self.showToast(message: "인증코드가 재전송됐어요.", alertCheck: true)
      }
    }
  }
  
  // MARK: - 인증코드 전송 후 UI설정
  func settingUIAfterSendCode(){
    DispatchQueue.main.async {
      self.emailStatusLabel.isHidden = false
      self.emailStatusLabel.text = "인증코드를 메일로 보내드렸어요"
      self.emailStatusLabel.textColor = .g80
      
      self.validButton.setTitle("재전송", for: .normal)
      
      self.verificationLabel.isHidden = false
      self.codeTextField.isHidden = false
      self.verificationCodedividerLine.isHidden = false
      
      self.resend = true
    }
  }
  
  // MARK: - 인증코드 검증
  func nextButtonTapped(){
    guard let code = codeTextField.text,
          let email = emailTextField.text else { return }
    editUserManager.checkValidCode(code: code,
                                   email: email) { result in
      
      if result == "true" {
        self.goToPasswordVC(email)
      } else {
        self.showToast(message: "인증코드가 일치하지 않아요.",
                       alertCheck: false,
                       large: false)
      }
    }
  }
  
  // MARK: - 비밀번호 설정화면으로 이동
  func goToPasswordVC(_ email: String){
    let passwordVC = PasswordViewController()
    passwordVC.email = email
    navigationController?.pushViewController(passwordVC, animated: true)
  }
}
