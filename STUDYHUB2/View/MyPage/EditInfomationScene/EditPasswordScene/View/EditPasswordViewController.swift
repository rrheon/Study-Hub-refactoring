import UIKit

import SnapKit
import Moya

final class EditPasswordViewController: NaviHelper {
  
  private lazy var titleLabel = createLabel(title: "현재 비밀번호를 입력해주세요",
                                            textColor: .black,
                                            fontType: "Pretendard-Bold",
                                            fontSize: 16)
  
  private lazy var currentPasswordTextField = createTextField(title: "현재 비밀번호")
  
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
      self.hidePasswordButtonTapped(self.hideFirstPasswordButton)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var forgetPasswordButton: UIButton = {
    let button = UIButton()
    
    let title = "비밀번호가 기억나지 않으세요?"
    let titleAttributes: [NSAttributedString.Key : Any] = [
      .underlineStyle: NSUnderlineStyle.single.rawValue,
      .font: UIFont(name: "Pretendard", size: 12),
      .foregroundColor: UIColor.bg80
    ]
    
    let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
    
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addAction(UIAction { _ in
      self.forgetPasswordButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var newPasswordLabel = createLabel(title: "새로운 비밀번호를 한 번 더 입력해주세요",
                                                  textColor: .black,
                                                  fontType: "Pretendard-Bold",
                                                  fontSize: 16)
  private lazy var newPasswordTextField = createTextField(title: "새 비밀번호를 한 번 더 입력")
  
  private lazy var checkValidPasswordLabel = createLabel(title: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)",
                                                         textColor: .r50,
                                                         fontType: "Pretendard",
                                                         fontSize: 12)
  
  private lazy var checkEqualPasswordLabel = createLabel(title: "비밀번호가 일치하지 않아요",
                                                         textColor: .r50,
                                                         fontType: "Pretendard",
                                                         fontSize: 12)
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      titleLabel,
      currentPasswordTextField,
      hideFirstPasswordButton,
      forgetPasswordButton
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
    
    currentPasswordTextField.isSecureTextEntry = true
    currentPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    hideFirstPasswordButton.snp.makeConstraints {
      $0.centerY.equalTo(currentPasswordTextField)
      $0.trailing.equalTo(currentPasswordTextField.snp.trailing).offset(-10)
    }
  
    forgetPasswordButton.snp.makeConstraints {
      $0.top.equalTo(currentPasswordTextField.snp.bottom).offset(10)
      $0.centerX.equalTo(currentPasswordTextField)
    }
  }
  
  func hidePasswordButtonTapped(_ sender: UIButton){
    let isPasswordVisible = sender.isSelected
    
    // 모든 텍스트 필드에 대해서 isSecureTextEntry 속성을 변경하여 비밀번호 보이기/가리기 설정
    currentPasswordTextField.isSecureTextEntry = !isPasswordVisible
    newPasswordTextField.isSecureTextEntry = !isPasswordVisible
    
    // 버튼의 상태 업데이트
    sender.isSelected = !isPasswordVisible
  }
  
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItem = .none
    
    settingNavigationTitle(title: "비밀번호 변경",
                           font: "Pretendard-Bold",
                           size: 18)
    
    let completeImg = UIImage(named: "UnableNextButton")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: #selector(nextButtonTapped(_:)))
    navigationItem.rightBarButtonItem = completeButton
  }
  
  // MARK: - 이전 비밀번호가 맞는지 체크
  @objc func nextButtonTapped(_ sender: Any){
    guard let password = currentPasswordTextField.text else { return }
    print(password)
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.verifyPassword(_password: password)) { result in
      switch result {
      case .success(let response):
        // 성공시 - 확인 버튼 활성화, 실패 시 - 토스트 팝업 띄우기케이스를 나눠야할듯 200
        print(response.response)
        switch response.statusCode{
        case 200:
          self.afterCheckValid()
        default:
          self.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
        }
      case .failure(let response):
        print(response.response)
        self.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
      }
    }
  }
  
  // MARK: - 비밀번호 검증 완료 시 호출
  func afterCheckValid(){
    let completeImg = UIImage(named: "ableNextButton")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: #selector(updateVC))
    navigationItem.rightBarButtonItem = completeButton
  }
  
  // MARK: - 비밀번호 검증 후 다음버튼 누를 때 호출
  @objc func updateVC(){
    let completeImg = UIImage(named: "DeCompletedImg")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: .none)
    navigationItem.rightBarButtonItem = completeButton
    
    forgetPasswordButton.isHidden = true
    
    titleLabel.text = "새로운 비밀번호를 입력하세요"
    
    currentPasswordTextField.placeholder = "10자리 이상, 특수문자 포함 필수"
    currentPasswordTextField.text = ""
    
    [
      checkValidPasswordLabel,
      newPasswordLabel,
      newPasswordTextField,
      hideSecondPasswordButton,
      checkEqualPasswordLabel
    ].forEach {
      view.addSubview($0)
    }
    
    checkValidPasswordLabel.snp.makeConstraints {
      $0.top.equalTo(currentPasswordTextField.snp.bottom)
      $0.leading.equalTo(currentPasswordTextField.snp.leading)
    }
    
    newPasswordLabel.snp.makeConstraints {
      $0.leading.equalTo(currentPasswordTextField.snp.leading)
      $0.top.equalTo(currentPasswordTextField.snp.bottom).offset(30)
    }
    
    newPasswordTextField.snp.makeConstraints {
      $0.leading.equalTo(currentPasswordTextField.snp.leading)
      $0.top.equalTo(newPasswordLabel.snp.bottom).offset(10)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    hideSecondPasswordButton.snp.makeConstraints {
      $0.centerY.equalTo(newPasswordTextField)
      $0.trailing.equalTo(newPasswordTextField.snp.trailing).offset(-10)
    }
    
    checkEqualPasswordLabel.snp.makeConstraints {
      $0.top.equalTo(newPasswordTextField.snp.bottom)
      $0.leading.equalTo(newPasswordTextField.snp.leading)
    }
    
    checkValidPasswordLabel.isHidden = true
    checkEqualPasswordLabel.isHidden = true
    
    // 텍스트 필드의 입력 상태가 변경될 때마다 checkTextFields() 함수 호출
    currentPasswordTextField.addTarget(self,
                                       action: #selector(textFieldDidChange(_:)),
                                       for: .editingChanged)
    newPasswordTextField.addTarget(self,
                                   action: #selector(textFieldDidChange(_:)),
                                   for: .editingChanged)
  }
  
  // 비밀번호 유효성 검증, 10자리이상, 특수문자포함 필수
  func checkValidPassword(firstPassword: String, secondPassword: String) {
    let specialCharacterRegEx = ".*[!&^%$#@()/]+.*"
    let textTest = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
    let result = textTest.evaluate(with: currentPasswordTextField.text)

    if currentPasswordTextField.text?.count ?? 0 < 10 || !result {
      checkValidPasswordLabel.isHidden = false
      currentPasswordTextField.layer.borderColor = UIColor.r50.cgColor
      
      checkValidPasswordLabel.text = "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
      checkValidPasswordLabel.textColor = .r50
    } else {
      currentPasswordTextField.layer.borderColor = UIColor.g_10.cgColor
      
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
  
  // MARK: - 비밀번호가 두칸 다 입력되어 있을 때 함수가 필요 - 둘 다 입력되어 있으면 버튼은 활성화, 색이 녹색일 때 완료가능
  func checkTextFields() {
    guard let textField1Text = currentPasswordTextField.text, !textField1Text.isEmpty,
          let textField2Text = newPasswordTextField.text, !textField2Text.isEmpty else {
      return
    }
    
    guard currentPasswordTextField.layer.borderColor == UIColor.g_10.cgColor,
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
  
  // MARK: - 비밀번호 변경함수
  @objc func completeButtonTapped(){
    print("완료버튼")
    guard let password = currentPasswordTextField.text else { return }

    let provider = MoyaProvider<networkingAPI>()
    provider.request(.editUserPassword(_checkPassword: true,
                                       email: "",
                                       _password: password)) {
      switch $0 {
      case .success(let response):
        print(response.response)
        
        DispatchQueue.main.async {
          self.navigationController?.popViewController(animated: true)
          
          self.showToast(message: "비밀번호가 변경됐어요", alertCheck: true)
        }
        
      case .failure(let respose):
        print(respose.response)
      }
    }
  }
  
  // MARK: - 비밀번호 모를 때 함수
  func forgetPasswordButtonTapped(){
    let findPasswordVC = FindPasswordViewController()
    findPasswordVC.previousVC = self
    navigationController?.pushViewController(findPasswordVC, animated: true)
  }
}

// MARK: - 비밀번호 유효성 검사
extension EditPasswordViewController {
  override func textFieldDidEndEditing(_ textField: UITextField) {
    print("1")
  }
  
  override func textFieldDidBeginEditing(_ textField: UITextField) {
    print("1")
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    if textField.placeholder != "현재 비밀번호" && textField.text?.isEmpty == false {
      print( textField.text?.isEmpty)

      let firstPassword = currentPasswordTextField.text ?? ""
      let secondPassword = newPasswordTextField.text ?? ""
      
      checkValidPassword(firstPassword: firstPassword, secondPassword: secondPassword)
    } else {
      currentPasswordTextField.layer.borderColor = UIColor.bg50.cgColor
    }
    checkTextFields()
  }
}
