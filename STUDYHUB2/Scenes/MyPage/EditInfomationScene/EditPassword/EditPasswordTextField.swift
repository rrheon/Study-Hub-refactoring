
import UIKit

import SnapKit
import Then

/// 비밀번호 수정 TextField의 Value
struct EditPasswordTextFieldValue {
  let labelTitle: String
  let textFieldTitle: String
  let alertContentToSuccess: String
  let alertContentToFail: String
}

/// 비밀번호 수정 TextField
final class EditPasswordTextField: UIView {
  /// 비밀번호 수정 value
  let content: EditPasswordTextFieldValue
  
  /// TextField 위의 타이틀 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = content.labelTitle
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// TextField
  lazy var textField = StudyHubUI.createTextField(title: content.textFieldTitle)
  
  /// 경고라벨
  private lazy var alertLabel = UILabel().then {
    $0.textColor = .r50
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
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
  
  /// layout 설정
  func setupLayout(){
    [ titleLabel, textField, alertLabel]
      .forEach { self.addSubview($0) }
  }
  
  
  /// Ui설정
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
  
  /// TextField 보안설정
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
  
  
  /// 경고라벨 설정
  /// - Parameters:
  ///   - hidden: 경고라벨 숨김여부
  ///   - successOrFail: 성공 / 실패 여부
  ///   - textColor: 라벨 제목 색상
  func alertLabelSetting(hidden: Bool, successOrFail: Bool, textColor: UIColor = .r50){
    alertLabel.isHidden = hidden
    alertLabel.text = successOrFail ? content.alertContentToSuccess : content.alertContentToFail
    alertLabel.textColor = textColor
    
    textField.layer.borderColor = textColor.cgColor
  }
}

