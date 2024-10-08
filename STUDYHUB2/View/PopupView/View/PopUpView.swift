//
//  MyPopUpView.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/19.
//

import UIKit

import SnapKit

final class PopupView: UIView {
  var leftButtonAction: (() -> Void)?
  var rightButtonAction: (() -> Void)?
  var endButtonAction: (() -> Void)?
  var checkEndButton: Bool = false
  
  private let popupView: UIView = {
    let view = UIView()

    view.layer.cornerRadius = 7
    view.clipsToBounds = true
    view.backgroundColor = .white
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let descLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = .bg80
    
    return label
  }()
  
  private let leftButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.bg80, for: .normal)
    button.backgroundColor = .bg40
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
    button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    button.layer.cornerRadius = 8
    return button
  }()
  
  private let rightButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .o50
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
    button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    button.layer.cornerRadius = 8
    return button
  }()
  
  private lazy var endButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .o50
    button.setTitleColor(.white, for: .normal)
    button.setTitle("종료", for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
    button.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
    button.layer.cornerRadius = 8
    return button
  }()
  
  private lazy var buttonStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  init(title: String,
       desc: String,
       leftButtonTitle: String = "취소",
       rightButtonTitle: String = "삭제",
       checkEndButton: Bool = false) {
    
    self.titleLabel.text = title
    self.descLabel.text = desc
    self.checkEndButton = checkEndButton
    self.leftButton.setTitle(leftButtonTitle, for: .normal)
    self.rightButton.setTitle(rightButtonTitle, for: .normal)
    
    super.init(frame: .zero)
    
    self.backgroundColor = .clear
  
    setupLayout()
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout(){
    self.addSubview(self.popupView)
    
    if checkEndButton {
      self.checkEndButton = true
      self.buttonStack.addArrangedSubview(self.endButton)
    } else {
      self.buttonStack.addArrangedSubview(self.leftButton)
      self.buttonStack.addArrangedSubview(self.rightButton)
    }
    
    self.popupView.addSubview(self.titleLabel)
    self.popupView.addSubview(self.descLabel)
    self.popupView.addSubview(self.buttonStack)
  }

  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(popupView.snp.top).offset(35)
      make.left.right.equalToSuperview().inset(24)
    }
    
    self.descLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.left.right.equalToSuperview().inset(24)
    }
    
    if !checkEndButton {
      leftButton.snp.makeConstraints { make in
        make.height.equalTo(47)
        make.width.equalTo(rightButton)
      }
      
      rightButton.snp.makeConstraints { make in
        make.height.equalTo(47)
      }
    }
    
    buttonStack.snp.makeConstraints { make in
      make.top.equalTo(descLabel.snp.bottom).offset(30)
      make.left.equalTo(popupView).offset(10)
      make.right.equalTo(popupView).offset(-10)
      make.bottom.equalTo(popupView).offset(-15)
      
      if checkEndButton {
        make.height.equalTo(47)
      }
    }
  }

  @objc private func leftButtonTapped() {
    leftButtonAction?()
  }
  
  @objc private func rightButtonTapped() {
    rightButtonAction?()
  }
  
  @objc private func endButtonTapped() {
    endButtonAction?()
  }
}
