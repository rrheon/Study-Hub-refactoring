import UIKit

import SnapKit
import Then

struct SetAuthTextFieldValue {
  var labelTitle: String?
  var textFieldPlaceholder: String
  var alertLabelTitle: String?
  var type: Bool
}

class AuthTextField: UIView {
  private var setValues: SetAuthTextFieldValue

  private lazy var label = UILabel().then{
    $0.text = setValues.labelTitle
    $0.textColor = .g50
    $0.font = UIFont(name: "Pretendard-Medium", size: 16)
  }
  
  lazy var textField = UITextField().then {
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    $0.textColor = .white
    $0.backgroundColor = .black
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    $0.addTarget(self, action: #selector(textFieldEnd), for: .editingDidEnd)
  }
  
  private let underlineView = UIView().then {
    $0.backgroundColor = .g100
  }
  
  private lazy var alertLabel = UILabel().then {
    $0.text = setValues.alertLabelTitle
    $0.textColor = .r50
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
    $0.isHidden = true
  }
  
  init(setValue: SetAuthTextFieldValue) {
    self.setValues = setValue
    super.init(frame: .zero)
    setupLayout()
    makeUI()
    setPlaceholder(setValues.textFieldPlaceholder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupLayout(){
    [
      label,
      textField,
      underlineView,
      alertLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  private func makeUI() {
    label.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(label.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    underlineView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(textField.snp.bottom).offset(10)
      $0.height.equalTo(1)
    }
    
    alertLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(underlineView.snp.bottom).offset(5)
    }
  }
  
  func checkTextField(context: String?, type: Bool, typing: Bool, chageColor: UIColor){
    if let context = context, !context.isEmpty {
       let checkValid = type ? isValidEmail(context) : isValidPassword(password: context)
      
      underlineView.backgroundColor = checkValid ? .g100 : chageColor
      alertLabel.isHidden = typing ? true : checkValid
    }
  }

  @objc func textFieldDidChange() {
    checkTextField(context: textField.text, type: setValues.type,
                   typing: true, chageColor: .g60)
  }
  
  @objc func textFieldEnd() {
    let color = setValues.labelTitle == "인증코드" ? UIColor.g100 : .r50
    checkTextField(context: textField.text, type: setValues.type,
                   typing: false, chageColor: color)
  }
  
  func isValidEmail(_ email: String) -> Bool {
      let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: email)
  }
  
  func isValidPassword(password: String) -> Bool {
    let passwordRegex = "(?=.*[a-zA-Z0-9])(?=.*[^a-zA-Z0-9]).{10,}"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
  }
  
  func setPlaceholder(_ placeholder: String) {
    textField.attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80])
  }
  
  func getTextFieldValue() -> String? {
    return textField.text
  }
  
  func setPasswordSecure(){
    textField.isSecureTextEntry = true
    textField.textContentType = .oneTimeCode

    if #available(iOS 15.0, *) {
      textField.setPasswordToggleVisibilityButton()
    } else {
      // Fallback on earlier versions
    }
  }
  
  func failToLogin(){
    underlineView.backgroundColor = .r50
    alertLabel.isHidden = false
  }
  
  func alertLabelSetting(hidden: Bool,
                         title: String = "",
                         textColor: UIColor = .r50,
                         underLineColor: UIColor = .r50){
    alertLabel.isHidden = hidden
    alertLabel.text = title
    alertLabel.textColor = textColor
    
    underlineView.backgroundColor = underLineColor
  }
}
