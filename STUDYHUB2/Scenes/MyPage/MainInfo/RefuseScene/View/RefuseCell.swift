//
//  RefuseCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/24.
//

import UIKit

import SnapKit
import Then


/// 거절항목 Cell
final class RefuseCell: UITableViewCell {

  var buttonAction: (() -> Void) = {}
  
  /// 거절 사유 라벨
  lazy var reasonLabel: UILabel = UILabel()
  
  /// 해당 사유 체크 버튼
  lazy var checkButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    $0.addAction(UIAction { _ in

    }, for: .touchUpInside)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 설정
  func setupLayout() {
    [ checkButton, reasonLabel]
      .forEach { self.contentView.addSubview($0) }
  }
  
  /// UI 설정
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
  
  /// 거절사유 라벨에 넣어주기
  func setReasonLabel(reason: String){
    reasonLabel.text = reason
  }
}
