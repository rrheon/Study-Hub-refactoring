import UIKit

import SnapKit
import Then


/// 보안관련 TextField의 값
struct SetAuthTextFieldValue {
  var labelTitle: String?
  var textFieldPlaceholder: String
  var alertLabelTitle: String?
}


/// 보안관련 TextField
/// 밑줄 + Alert이 포함되어 있는 TextField
class AuthTextField: UIView {
  private var setValues: SetAuthTextFieldValue
  
  private lazy var label = UILabel().then{
    $0.text = setValues.labelTitle
    $0.textColor = .g50
    $0.font = UIFont(name: FontSystem.medium.value, size: 16)
  }
  
  lazy var textField = UITextField().then {
    $0.font = UIFont(name: FontSystem.medium.value, size: 14)
    $0.textColor = .white
    $0.backgroundColor = .black
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
  }
  
  private let underlineView = UIView().then {
    $0.backgroundColor = .g100
  }
  
  lazy var alertLabel = UILabel().then {
    $0.text = setValues.alertLabelTitle
    $0.textColor = .r50
    $0.font = UIFont(name: FontSystem.medium.value, size: 12)
    $0.isHidden = true
  }
  
  init(setValue: SetAuthTextFieldValue) {
    self.setValues = setValue
    super.init(frame: .zero)
    
    makeUI()
    setPlaceholder(setValues.textFieldPlaceholder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  private func makeUI() {
    addSubview(label)
    label.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
    }
    
    addSubview(textField)
    textField.snp.makeConstraints {
      $0.top.equalTo(label.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    addSubview(underlineView)
    underlineView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(textField.snp.bottom).offset(10)
      $0.height.equalTo(1)
    }
    
    addSubview(alertLabel)
    alertLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(underlineView.snp.bottom).offset(5)
    }
  }
  
  
  /// PlaceHolder 설정
  /// - Parameter placeholder: 설정할 내용
  private func setPlaceholder(_ placeholder: String) {
    textField.attributedPlaceholder = NSAttributedString(
      string: placeholder,
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80])
  }
  
  
  /// TextField의 값 받기
  /// - Returns: TextField의 값
  func getTextFieldValue() -> String? {
    return textField.text
  }
  
  
  /// TextField 보안 설정
  func setPasswordSecure(isSecure: Bool = true){
    textField.isSecureTextEntry = isSecure
    textField.textContentType = .oneTimeCode
  
    textField.setPasswordToggleVisibilityButton()
  }
  
  
  /// 경고라벨 설정
  /// - Parameters:
  ///   - hidden: 라벨 숨김 여부
  ///   - title: 라벨의 제목
  ///   - textColor: 라벨의 색상
  ///   - underLineColor: 밑줄 색상
  func alertLabelSetting(
    hidden: Bool,
    title: String = "",
    textColor: UIColor = .r50,
    underLineColor: UIColor = .r50
  ){
    alertLabel.isHidden = hidden
    alertLabel.text = title
    alertLabel.textColor = textColor
    
    underlineView.backgroundColor = underLineColor
  }
}
