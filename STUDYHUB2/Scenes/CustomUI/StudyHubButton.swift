//
//  StudyHubButton.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/25/24.
//

import UIKit


/// StudyHub 메인 CustomButton - 주황색 버튼
final class StudyHubButton: UIButton {
  
  init(title: String, fontSize: CGFloat = 16, radious: CGFloat = 6) {
    super.init(frame: .zero)
    setup(title: title, fontSize: fontSize, radious: radious)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(title: String, fontSize: CGFloat, radious: CGFloat) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.backgroundColor = .o50
    self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: fontSize)
    self.layer.cornerRadius = radious
  }
  
  
  /// 버튼 활성화/비활성화
  /// - Parameters:
  ///   - check: 활성화 여부 - true 버튼 활성화 , false 버튼비활성화
  ///   - backgroundColor: 배경색
  ///   - titleColor: 제목 색상
  func unableButton(_ check: Bool, backgroundColor: UIColor = .o60, titleColor: UIColor = .g70){
    self.isEnabled = check
    self.backgroundColor = check ? .o50 : backgroundColor
    
    let titleColor = check ? UIColor.white : titleColor
    self.setTitleColor(titleColor, for: .normal)
  }
}


/// StudyHub UI 관련 class
class StudyHubUI {
  /// 구분 선 생성
  /// - Parameter height: 높이
  /// - Returns: UIView
  class func createDividerLine(bgColor: UIColor = UIColor(hexCode: "#F3F5F6") ,height: CGFloat) -> UIView {
    let dividerLine = UIView()
    dividerLine.backgroundColor = bgColor
    dividerLine.heightAnchor.constraint(equalToConstant: height).isActive = true
    return dividerLine
  }

  /// textField 생성
  /// - Parameter title: 제목
  /// - Returns: textField
  class func createTextField(title: String) -> UITextField {
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
  
  /// 스택뷰 생성
  /// - Parameters:
  ///   - axis:방향
  ///   - spacing: 여백
  /// - Returns: 스택뷰
  class func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = axis
    stackView.spacing = spacing
    return stackView
  }
  
  /// 버튼 생성
  /// - Parameters:
  ///   - title: 버튼제목
  ///   - titleColor: 제목색상
  ///   - borderColor: 테두리색상
  class func createButton(
    title: String,
    titleColor: String = "#A1AAB0",
    borderColor: String = "#D8DCDE"
  ) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor(hexCode: titleColor), for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexCode: borderColor).cgColor
    button.layer.cornerRadius = 5
    button.backgroundColor = .white
    return button
  }
  
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
