
import UIKit

import SnapKit

final class PasswordViewController: NaviHelper {
 
  var email: String?
  
  // MARK: - 화면구성
  private lazy var pageNumberLabel: UILabel = {
    let label = UILabel()
    label.text = "3/5"
    label.textColor = .g60
    label.font = UIFont(name: "Pretendard-SemiBold",
                                size: 18)
    return label
  }()
  
  private lazy var passwordTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호를 설정해주세요"
    label.textColor = .white
    label.font = UIFont(name: "Pretendard-Bold", size: 20)
    return label
  }()

  private lazy var underTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "10자리 이상, 특수문자 포함(!,@,#,$,%,^,&,*,?,~,_)이 필수에요"
    label.textColor = .g40
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  private lazy var passwordLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호"
    label.textColor = .g50
    label.font = UIFont(name: "Pretendard-Medium", size: 16)
    return label
  }()
  
  private lazy var passwordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "비밀번호를 입력하세요"
    textField.attributedPlaceholder = NSAttributedString(
      string: "비밀번호를 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80])
    textField.textColor = .white
    textField.backgroundColor = .black
    textField.borderStyle = .roundedRect
    textField.isSecureTextEntry = true
    textField.becomeFirstResponder()
    return textField
  }()

  private lazy var hideFirstPasswordButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "CloseEyeImage_gray"), for: .normal)
    button.addAction(UIAction{ _ in
      self.hidePasswordButtonTapped(self.hideFirstPasswordButton)
    }, for: .touchUpInside)
    return button
  }()

  private lazy var passwordTextFielddividerLine: UIView = {
    let uiView = UIView()
    uiView.backgroundColor = .g100
    return uiView
  }()
  
  private lazy var firstTextFieldStatusLabel = createLabel(
    title: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)",
    textColor: .r50,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var confirmPasswordTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "비밀번호를 한 번 더 입력해주세요"
    textField.attributedPlaceholder = NSAttributedString(
      string: "비밀번호를 한 번 더 입력해주세요",
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.g80])
    textField.textColor = .white
    textField.backgroundColor = .black
    textField.borderStyle = .roundedRect
    textField.becomeFirstResponder()
    textField.isSecureTextEntry = true
    return textField
  }()
  
  private lazy var hideSecondPasswordButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "CloseEyeImage_gray"), for: .normal)
    button.addAction(UIAction{ _ in
      self.hidePasswordButtonTapped(self.hideSecondPasswordButton)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var secondTextfieldStatusLabel = createLabel(
    title: "비밀번호가 일치하지 않아요",
    textColor: .r50,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private let confirmPasswordTextFielddividerLine: UIView = {
    let uiview = UIView()
    uiview.backgroundColor = .g100
    return uiview
  }()

  private lazy var nextButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("다음", for: .normal)
    button.setTitleColor(UIColor(hexCode: "#6F6F6F"), for: .normal)
    button.backgroundColor = UIColor(hexCode: "#6F2B1C")
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      self.goToNicknameVC()
    }, for: .touchUpInside)
    return button
  }()
  
  // MARK: - viewDidLoad
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
      passwordTitleLabel,
      underTitleLabel,
      passwordLabel,
      passwordTextField,
      firstTextFieldStatusLabel,
      hideFirstPasswordButton,
      passwordTextFielddividerLine,
      confirmPasswordTextField,
      hideSecondPasswordButton,
      confirmPasswordTextFielddividerLine,
      secondTextfieldStatusLabel,
      nextButton
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
  
    passwordTitleLabel.snp.makeConstraints {
      $0.top.equalTo(pageNumberLabel.snp.bottom).offset(10)
      $0.leading.equalTo(pageNumberLabel.snp.leading)
    }
    
    underTitleLabel.snp.makeConstraints {
      $0.top.equalTo(passwordTitleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(passwordTitleLabel.snp.leading)
    }
    
    passwordLabel.snp.makeConstraints {
      $0.top.equalTo(underTitleLabel.snp.bottom).offset(30)
      $0.leading.equalTo(pageNumberLabel.snp.leading)
    }
    
    passwordTextField.delegate = self
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
      $0.leading.equalTo(passwordLabel.snp.leading).offset(-5)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    hideFirstPasswordButton.snp.makeConstraints {
      $0.centerY.equalTo(passwordTextField)
      $0.trailing.equalToSuperview().offset(-30)
    }
    
    passwordTextFielddividerLine.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(passwordTextField.snp.bottom).offset(5)
      $0.height.equalTo(1)
    }
    
    firstTextFieldStatusLabel.isHidden = true
    firstTextFieldStatusLabel.snp.makeConstraints {
      $0.leading.equalTo(passwordTextFielddividerLine)
      $0.top.equalTo(passwordTextFielddividerLine.snp.bottom).offset(5)
    }
    
    confirmPasswordTextField.delegate = self
    confirmPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(passwordTextFielddividerLine.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(passwordTextField)
      $0.height.equalTo(50)
    }
    
    hideSecondPasswordButton.snp.makeConstraints {
      $0.centerY.equalTo(confirmPasswordTextField)
      $0.trailing.equalToSuperview().offset(-30)
    }
    
    confirmPasswordTextFielddividerLine.snp.makeConstraints {
      $0.leading.trailing.equalTo(passwordTextFielddividerLine)
      $0.top.equalTo(confirmPasswordTextField.snp.bottom).offset(5)
      $0.height.equalTo(1)
    }
    
    secondTextfieldStatusLabel.isHidden = true
    secondTextfieldStatusLabel.snp.makeConstraints {
      $0.leading.equalTo(passwordTextFielddividerLine)
      $0.top.equalTo(confirmPasswordTextFielddividerLine.snp.bottom).offset(5)
    }
    
    nextButton.isEnabled = false
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(confirmPasswordTextFielddividerLine)
    }
    
    passwordTextField.addTarget(self,
                                       action: #selector(textFieldDidChange(_:)),
                                       for: .editingChanged)
    confirmPasswordTextField.addTarget(self,
                                   action: #selector(textFieldDidChange(_:)),
                                   for: .editingChanged)
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
    
  // MARK: - 비밀번호 표시 on off
  func hidePasswordButtonTapped(_ sender: UIButton) {
    let isPasswordVisible = sender.isSelected
    
    if sender == hideFirstPasswordButton {
      passwordTextField.isSecureTextEntry = !isPasswordVisible
      sender.isSelected = !isPasswordVisible
      
      let image = isPasswordVisible ? "eye_open" : "CloseEyeImage_gray"
      hideFirstPasswordButton.setImage(UIImage(named: image), for: .normal)
    } else if sender == hideSecondPasswordButton {
      confirmPasswordTextField.isSecureTextEntry = !isPasswordVisible
      sender.isSelected = !isPasswordVisible
      
      let image = isPasswordVisible ? "eye_open" : "CloseEyeImage_gray"
      hideSecondPasswordButton.setImage(UIImage(named: image), for: .normal)
    }
  }

  
  // MARK: - 비밀번호 특수문자 등 유효성 확인
  func checkValidPassword(firstPassword: String, secondPassword: String) {
    let specialCharacterRegEx = ".*[!&^%$#@()/]+.*"
    let textTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
    let result = textTest.evaluate(with: passwordTextField.text)

    if passwordTextField.text?.count ?? 0 < 10 || !result {
      firstTextFieldStatusLabel.isHidden = false
      passwordTextFielddividerLine.backgroundColor = .r50
      
      firstTextFieldStatusLabel.text = "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
      firstTextFieldStatusLabel.textColor = .r50
      checkNextButton(check: false)
    } else {
      passwordTextFielddividerLine.backgroundColor = .g_10

      firstTextFieldStatusLabel.text = "사용 가능한 비밀번호예요"
      firstTextFieldStatusLabel.textColor = .g_10
    }
    
    // 다시 입력한 비밀번호가 일치한지 유효성 확인
    if firstPassword != secondPassword {
      secondTextfieldStatusLabel.isHidden = false
      
      confirmPasswordTextFielddividerLine.backgroundColor = .r50
      
      secondTextfieldStatusLabel.text = "비밀번호가 일치하지 않아요"
      secondTextfieldStatusLabel.textColor = .r50
      checkNextButton(check: false)

    } else {
      confirmPasswordTextFielddividerLine.backgroundColor = .g_10
      
      secondTextfieldStatusLabel.text = "비밀번호가 확인되었어요"
      secondTextfieldStatusLabel.textColor = .g_10
    }
  }
  
  // MARK: - 버튼 활성화/비활성화
  func checkNextButton(check: Bool){
    if check {
      nextButton.isEnabled = true
      nextButton.backgroundColor = .o50
      nextButton.setTitleColor(.white, for: .normal)
    } else {
      nextButton.isEnabled = false
      nextButton.backgroundColor = .o60
      nextButton.setTitleColor(.g90, for: .normal)
    }
  }
  
  // MARK: - 두 비밀번호 확인 후 변경
  func checkTextFields() {
    guard let textField1Text = passwordTextField.text, !textField1Text.isEmpty,
          let textField2Text = confirmPasswordTextField.text, !textField2Text.isEmpty else {
      return
    }
    
   let checkFirst = firstTextFieldStatusLabel.textColor == .g_10
   let checkSecond = secondTextfieldStatusLabel.textColor == .g_10

    if checkFirst && checkSecond {
      checkNextButton(check: true)
    }
  }
  
  // MARK: - 닉네임 설정화면으로 이동
  func goToNicknameVC(){
    guard let password = passwordTextField.text else { return }
    
    let nicknameVC = NicknameViewController()
    nicknameVC.email = email
    nicknameVC.password = password
    
    navigationController?.pushViewController(nicknameVC, animated: true)
  }
}

extension PasswordViewController {
  override func textFieldDidEndEditing(_ textField: UITextField) {
    print("1")
  }
  
  override func textFieldDidBeginEditing(_ textField: UITextField) {
    print("1")
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    if textField.placeholder != "10자리 이상, 특수문자 포함 필수" && textField.text?.isEmpty == false {
      let firstPassword = passwordTextField.text ?? ""
      let secondPassword = confirmPasswordTextField.text ?? ""
      
      // checkValidPassword 함수를 호출합니다
      checkValidPassword(firstPassword: firstPassword, secondPassword: secondPassword)
    } else {
      passwordTextField.layer.borderColor = UIColor.bg50.cgColor
    }
    
    checkTextFields()
  }
}

