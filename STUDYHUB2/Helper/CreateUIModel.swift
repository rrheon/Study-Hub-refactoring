//
//  CreateUIModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

protocol CreateLabel {
  func createLabel(
    title: String,
    textColor: UIColor,
    fontType: String,
    fontSize: CGFloat
  ) -> UILabel
}

protocol CreateStackView {
  func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView
}

protocol CreateDividerLine {
  func createDividerLine(height: CGFloat) -> UIView
}

protocol CreateTextField {
  func createTextField(title: String) -> UITextField
}

extension CreateLabel {
  func createLabel(
    title: String,
    textColor: UIColor,
    fontType: String,
    fontSize: CGFloat
  ) -> UILabel {
    let label = UILabel()
    label.text = title
    label.textColor = textColor
    label.font = UIFont(name: fontType, size: fontSize)
    return label
  }
}

extension CreateStackView {
  func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.spacing = spacing
    return stackView
  }
}

extension CreateDividerLine {
  func createDividerLine(height: CGFloat) -> UIView {
    let dividerLine = UIView()
    dividerLine.backgroundColor = UIColor(hexCode: "#F3F5F6")
    dividerLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    return dividerLine
  }
}

extension CreateTextField {
  func createTextField(title: String) -> UITextField {
    let textField = UITextField()
    let placeholderTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.bg70,
      .font: UIFont(name: "Pretendard-Medium", size: 14)
    ]
    
    textField.attributedPlaceholder = NSAttributedString(
      string: title,
      attributes: placeholderTextAttributes
    )
    
    textField.backgroundColor = .white
    textField.textColor = .black
    textField.font = UIFont(name: "Pretendard-Medium", size: 14)
    textField.borderStyle = .roundedRect
    textField.layer.cornerRadius = 5
    textField.layer.borderColor = UIColor.bg50.cgColor
    textField.layer.borderWidth = 0.5
//    textField.delegate = self as! any UITextFieldDelegate
    return textField
  }
}

protocol CreateUIprotocol: CreateLabel, CreateStackView, CreateTextField, CreateDividerLine {}
