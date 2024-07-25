//
//  AuthTitleView.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/25/24.
//

import UIKit

import SnapKit
import Then

final class AuthTitleView: UIView {
  private let pageNumber: String
  private let pageTitle: String
  private let pageContent: String
  
  private lazy var pageNumberLabel = UILabel().then {
    $0.text = pageNumber
    $0.textColor = .g60
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 18)
  }
  
  private lazy var titleLabel = UILabel().then {
    $0.text = pageTitle
    $0.textColor = .white
    $0.font = UIFont(name: "Pretendard-Bold", size: 20)
  }
  
  private lazy var underTitleLabel = UILabel().then {
    $0.text = pageContent
    $0.textColor = .g40
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  init(pageNumber: String, pageTitle: String, pageContent: String) {
    self.pageNumber = pageNumber
    self.pageTitle = pageTitle
    self.pageContent = pageContent
    
    super.init(frame: .zero)
    
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout(){
    [
      pageNumberLabel,
      titleLabel,
      underTitleLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  private func makeUI(){
    pageNumberLabel.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(pageNumberLabel.snp.bottom).offset(10)
      $0.leading.equalTo(pageNumberLabel)
    }
    
    underTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(pageNumberLabel)
    }
  }
}
