//
//  UIViewcontrollerExtention.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import UIKit

import SnapKit

extension UIViewController: UITextFieldDelegate, UITextViewDelegate {
  
  // MARK: - UI 생성 함수
  func createContactButton(title: String, selector: Selector) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
    button.layer.cornerRadius = 5
    button.backgroundColor = .white
    button.addTarget(self, action: selector, for: .touchUpInside)
    return button
  }
  
  func createFineButton(selector: Selector) -> UIButton {
    let button = UIButton()
    button.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    button.setImage(UIImage(named: "ButtonChecked"), for: .selected)
    button.tintColor = UIColor(hexCode: "#FF5530")
    button.addTarget(self, action: selector, for: .touchUpInside)
    return button
  }
  
  // 날짜 선택하는 버튼
  func createDateButton(selector: Selector) -> UIButton {
    // 버튼 초기화
    let button = UIButton()
    
    // 버튼에 이미지 설정
    let image = UIImage(named: "RightArrow")
    button.setImage(image, for: .normal)
    
    // 버튼의 이미지 위치 조절
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 320, bottom: 0, right: 10)
    
    // 버튼의 나머지 속성 설정
    button.setTitle("선택하기", for: .normal)
    button.contentHorizontalAlignment = .left
    button.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    button.backgroundColor = .white
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
    button.layer.cornerRadius = 5
    button.addTarget(self, action: selector, for: .touchUpInside)
    
    return button
  }
  
  // info
  func createTextField(title: String) -> UITextField {
    let textField = UITextField()
    let placeholderTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.bg70,
      .font: UIFont(name: "Pretendard-Medium", size: 14)
    ]
    
    textField.attributedPlaceholder = NSAttributedString(string: title,
                                                         attributes: placeholderTextAttributes)
    
    textField.backgroundColor = .white
    textField.textColor = .black
    textField.font = UIFont(name: "Pretendard-Medium", size: 14)
    textField.borderStyle = .roundedRect
    textField.layer.cornerRadius = 5
    textField.layer.borderColor = UIColor.bg50.cgColor
    textField.layer.borderWidth = 0.5
    textField.delegate = self
    return textField
  }
  
  func createLabel(title: String,
                   textColor: UIColor,
                   fontType: String,
                   fontSize: CGFloat) -> UILabel {
    let label = UILabel()
    label.text = title
    label.textColor = textColor
    label.font = UIFont(name: fontType, size: fontSize)
    return label
  }
  
  func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.spacing = spacing
    
    return stackView
  }
  
  func createDividerLine(height: CGFloat) -> UIView {
    let dividerLine = UIView()
    dividerLine.backgroundColor = UIColor(hexCode: "#F3F5F6")
    dividerLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    return dividerLine
  }
  
  func createMypageButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setTitleColor(.bg90, for: .normal)
    return button
  }
  
  // MARK: - 날짜 변경 함수
  func convertToFormat(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일" // 입력된 날짜의 형식
    guard let date = dateFormatter.date(from: dateString) else { return "" }
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
  }
  
  
  // MARK: -  UITextField가 선택될 때 호출되는 메서드
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.black.cgColor // 테두리 색상을 검은색으로 변경
    textField.layer.borderWidth = 1.0 // 테두리 두께 설정
  }
  
  // MARK: - UITextField가 선택 해제될 때 호출되는 메서드
  public func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.clear.cgColor // 테두리 색상을 초기화 (투명)
    textField.layer.borderWidth = 0.0 // 테두리 두께 초기화
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil // 텍스트를 날려줌
      textView.textColor = UIColor.black
    }
    textView.layer.borderColor = UIColor.black.cgColor // 테두리 색상을 검은색으로 변경
    textView.layer.borderWidth = 1.0 // 테두리 두께 설정
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
      textView.textColor = UIColor.lightGray
    }
    textView.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상을 초기화 (투명)
    textView.layer.borderWidth = 1.0 // 테두리 두께 초기화
  }
  
  // MARK: - toast message, 이미지가 뒤에 나오고 있음 앞으로 빼기, 이미지 없을 때도 있음
  func showToast(message: String,
                 imageCheck: Bool = true,
                 alertCheck: Bool = true,
                 large: Bool = false) {
    let toastContainer = UIView()
    toastContainer.backgroundColor = .g100
    toastContainer.layer.cornerRadius = 10
    
    let toastLabel = UILabel()
    toastLabel.textColor = .g10
    toastLabel.font = UIFont(name: "Pretendard", size: 14)
    toastLabel.text = message
    toastLabel.numberOfLines = 0
    
    let alertImage = alertCheck ? "SuccessImage" : "WarningImg"
    let imageView = UIImageView(image: UIImage(named: alertImage))
    
    if imageCheck {
      toastContainer.addSubview(imageView)
    }
    toastContainer.addSubview(toastLabel)
  
    guard let keyWindow = UIApplication.shared.keyWindow else { return }
    
    keyWindow.addSubview(toastContainer)
    
    toastContainer.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(keyWindow.safeAreaLayoutGuide.snp.bottom).offset(-50)
      make.width.equalTo(335)
      
      let size = large ? 74 : 56
      make.height.equalTo(size)
    }
    
    if imageCheck {
      imageView.snp.makeConstraints { make in
        make.centerY.equalTo(toastContainer)
        make.leading.equalTo(toastContainer).offset(15)
      }
    }
    
    toastLabel.snp.makeConstraints { make in
      make.centerY.equalTo(toastContainer)
      if imageCheck {
        make.leading.equalTo(imageView.snp.trailing).offset(8)
      } else {
        make.leading.equalTo(toastContainer).offset(30)
      }
      make.trailing.equalTo(toastContainer).offset(-16)
    }
    
    UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastContainer.alpha = 0.0
    }, completion: { _ in
      toastContainer.removeFromSuperview()
    })
  }

  // MARK: - 성별 to 한글
  func convertGender(gender: String) -> String {
    if gender == "FEMALE" {
      return "여자"
    } else if gender == "MALE" {
      return "남자"
    } else {
      return "무관"
    }
  }
  
  // MARK: - 대면여부 to 한글
  func convertStudyWay(wayToStudy: String) -> String {
    if wayToStudy == "CONTACT" {
      return "대면"
    } else if wayToStudy == "MIX" {
      return "혼합"
    } else {
      return "비대면"
    }
  }
  
  func convertImageToString(image: UIImage) -> String? {
      guard let imageData = image.jpegData(compressionQuality: 1.0) else {
          return nil
      }
      let base64String = imageData.base64EncodedString()
      return base64String
  }

  func isValidEmail(_ email: String) -> Bool {
      let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let test = NSPredicate(format:"SELF MATCHES %@", regex)
      return test.evaluate(with: email)
  }
  
}
