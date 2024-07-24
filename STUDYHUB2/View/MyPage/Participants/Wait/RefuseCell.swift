//
//  RefuseCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/24.
//

import UIKit

import SnapKit
  
final class RefuseCell: UITableViewCell {
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }

  static let cellId = "CellId"
  
  var buttonAction: (() -> Void) = {}
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  lazy var reasonLabel: UILabel = {
    let label = UILabel()
    label.text = "정보통신학과"
    return label
  }()
  
   lazy var checkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    button.addAction(UIAction { _ in

    }, for: .touchUpInside)
    return button
  }()
  
  func setupLayout() {
    [
      checkButton,
      reasonLabel
    ].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  func makeUI() {
    checkButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
    }
    
    reasonLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(checkButton.snp.trailing).offset(10)
    }
  }
  
  func setReasonLabel(reason: String){
    reasonLabel.text = reason
    
  }
}
