
import UIKit

import SnapKit

struct EditPasswordTextFieldValue {
  let labelTitle: String
  let textFieldTitle: String
  let alertContentToSuccess: String
  let alertContentToFail: String
}

final class EditPasswordTextField: UIView {
  let content: EditPasswordTextFieldValue
  
  private lazy var titleLabel = createLabel(
    title: content.labelTitle,
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  lazy var textField = createTextField(title: content.textFieldTitle)
  
  private lazy var alertLabel = createLabel(
    textColor: .r50,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )

  init(_ content: EditPasswordTextFieldValue){
    self.content = content
    super.init(frame: .zero)
    
    setupLayout()
    makeUI()
    setPasswordSecure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      titleLabel,
      textField,
      alertLabel
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    titleLabel.snp.makeConstraints{
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50)
    }
    
    alertLabel.snp.makeConstraints {
      $0.top.equalTo(textField.snp.bottom).offset(5)
      $0.leading.trailing.equalTo(textField)
    }
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
  
  func isValidPassword(_ password: String) -> Bool {
    let passwordRegex = "(?=.*[a-zA-Z0-9])(?=.*[^a-zA-Z0-9]).{10,}"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
  }
  
  func alertLabelSetting(
    hidden: Bool,
    successOrFail: Bool,
    textColor: UIColor = .r50
  ){
    alertLabel.isHidden = hidden
    alertLabel.text = successOrFail ? content.alertContentToSuccess : content.alertContentToFail
    alertLabel.textColor = textColor
    
    textField.layer.borderColor = textColor.cgColor
  }
}

extension EditPasswordTextField: CreateUIprotocol {}
