//
//  CreateUIModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

protocol CreateLabel {
  func createLabel(
    title: String?,
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

protocol CreateButtonInCreatePost {
  func createButton(title: String) -> UIButton
}


extension CreateLabel {
  
  /// 라벨 생성
  /// - Parameters:
  ///   - title: 제목
  ///   - textColor: 제목 색상
  ///   - fontType: 폰트
  ///   - fontSize: 폰트사이즈
  /// - Returns: 라벨
  func createLabel(
    title: String? = "",
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
  
  /// 스택뷰 생성
  /// - Parameters:
  ///   - axis:방향
  ///   - spacing: 여백
  /// - Returns: <#description#>
  func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.spacing = spacing
    return stackView
  }
}

extension CreateDividerLine {
  
  /// 구분 선 생성
  /// - Parameter height: 높이
  /// - Returns: UIView
  func createDividerLine(height: CGFloat) -> UIView {
    let dividerLine = UIView()
    dividerLine.backgroundColor = UIColor(hexCode: "#F3F5F6")
    dividerLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    return dividerLine
  }
}

extension CreateTextField {
  
  /// textField 생성
  /// - Parameter title: 제목
  /// - Returns: textField
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
    return textField
  }
}

extension CreateButtonInCreatePost {
  
  /// 버튼 생성
  /// - Parameter title: 버튼 제목
  /// - Returns: 버튼
  func createButton(title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
    button.layer.cornerRadius = 5
    button.backgroundColor = .white
    return button
  }
}


protocol CreateUIprotocol: CreateLabel,
                           CreateStackView,
                           CreateTextField,
                           CreateDividerLine,
                           CreateButtonInCreatePost{}

extension UISearchBar {
  /// 서치바 생성
  /// - Parameter placeholder: placeHolder
  /// - Returns: 서치바
  class func createSearchBar(placeholder: String) -> UISearchBar {
    let bar = UISearchBar()
    
    bar.placeholder = placeholder
    bar.searchTextField.font = UIFont(name: "Pretendard-Medium", size: 20)
    
    if let searchBarTextField = bar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.font = UIFont.systemFont(ofSize: 14)
      searchBarTextField.layer.cornerRadius = 10
      searchBarTextField.layer.masksToBounds = true
      searchBarTextField.backgroundColor = .white
      searchBarTextField.layer.borderColor = UIColor.lightGray.cgColor
      searchBarTextField.layer.borderWidth = 0.5
    }
    
    let searchImg = UIImage(named: "SearchImg")?.withRenderingMode(.alwaysOriginal)
    bar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    bar.showsBookmarkButton = true
    bar.setImage(searchImg, for: .bookmark, state: .normal)
    bar.backgroundImage = UIImage()
    
    return bar
  }
}
