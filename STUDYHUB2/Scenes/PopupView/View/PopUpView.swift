//
//  MyPopUpView.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/19.
//

import UIKit

import SnapKit
import Then


/// 팝업뷰 Delegate
protocol PopupViewDelegate {
  func leftBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase)
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase)
  func endBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase)
}

/// 팝업뷰 Delegate의 기본값
extension PopupViewDelegate {
  /// 왼쪽 버튼 -> 기본값  =. 닫기
  func leftBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase){
    defaultBtnAction()
  }
  
  /// 오른쪽 버튼
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase){
    defaultBtnAction()
  }
  
  /// 종료버튼
  func endBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase){
    defaultBtnAction()
  }
}

/// 팝업 view
final class PopupView: UIView {
  
  /// popupView 버튼의 기본 action
  var defaultBtnAction: (() -> ())? = nil
  
  /// 팝업의 종류
  var popupCase: PopupCase? = nil
  
  var delegate: PopupViewDelegate?
  
  /// 종료버튼 체크
  var checkEndButton: Bool = false

  /// 팝업 view
  private let popupView: UIView = UIView().then {
    $0.layer.cornerRadius = 7
    $0.clipsToBounds = true
    $0.backgroundColor = .white
  }
  
  /// 팝업 제목 라벨
  private let titleLabel: UILabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  /// 팝업 설명라벨
  private let descLabel: UILabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.textColor = .bg80
  }
  
  /// 팝업의 왼쪽 버튼
  private let leftButton: UIButton = UIButton().then {
    $0.setTitleColor(.bg80, for: .normal)
    $0.backgroundColor = .bg40
    $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
    $0.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    $0.layer.cornerRadius = 8
  }
  
  /// 팝업의 오른쪽 버튼
  private let rightButton: UIButton = UIButton().then {
    $0.backgroundColor = .o50
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
    $0.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    $0.layer.cornerRadius = 8
  }
  
  /// 종료 버튼
  private lazy var endButton: UIButton = UIButton().then {
    $0.backgroundColor = .o50
    $0.setTitleColor(.white, for: .normal)
    $0.setTitle("종료", for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
    $0.addTarget(self, action: #selector(endButtonTapped), for: .touchUpInside)
    $0.layer.cornerRadius = 8
  }
  
  /// 버튼의 스택뷰
  private lazy var buttonStack: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
    $0.distribution = .fillEqually
  }
  
  init(popupCase: PopupCase) {
    self.popupCase = popupCase
    
    self.titleLabel.text = popupCase.popupData.title
    self.descLabel.text = popupCase.popupData.desc
    self.checkEndButton = popupCase.popupData.checkEndButton
    
    self.leftButton.setTitle(popupCase.popupData.leftButtonTitle, for: .normal)
    self.rightButton.setTitle(popupCase.popupData.rightButtonTitle, for: .normal)
      
    super.init(frame: .zero)
    
    self.backgroundColor = .clear
  
    setupLayout()
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 설정
  private func setupLayout(){
    self.addSubview(self.popupView)
    
    /// 종료버튼 true인 경우
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

  /// UI설정
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
    delegate?.leftBtnTapped(defaultBtnAction: {
      defaultBtnAction?()
    }, popupCase: popupCase ?? .requireLogin)
  }
  
  @objc private func rightButtonTapped() {
    delegate?.rightBtnTapped(defaultBtnAction: {
      defaultBtnAction?()
    }, popupCase: popupCase ?? .requireLogin)
  }
  
  @objc private func endButtonTapped() {
    delegate?.endBtnTapped(defaultBtnAction: {
      defaultBtnAction?()
    }, popupCase: popupCase ?? .requireLogin)
  }
}
