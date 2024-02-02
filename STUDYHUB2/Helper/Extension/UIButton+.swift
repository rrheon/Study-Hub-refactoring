//
//  UIButton+.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/24.
//

import UIKit

import SnapKit

extension UIButton {
  private struct AssociatedKeys {
    static var titleLabelKey = "titleLabelKey"
  }
  
  private var underlineView: UIView? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.titleLabelKey) as? UIView
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.titleLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  // 밑줄을 생성하는 함수
  func setUnderline() {
    guard let title = title(for: .normal) else { return }
    
    // 기존 제목을 숨기고, 새로운 밑줄 뷰를 추가합니다
    setTitle(nil, for: .normal)
    
    underlineView?.removeFromSuperview()
    
    underlineView = UIView()
    underlineView?.backgroundColor = UIColor.black
    
    let titleLabel = UILabel()
    titleLabel.text = title
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
    
    addSubview(underlineView!)
    underlineView?.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalTo(titleLabel.snp.trailing)
      $0.height.equalTo(3)
      $0.bottom.equalToSuperview().offset(3)
    }
  }
  
  // 밑줄을 제거하는 함수
  func removeUnderline() {
    underlineView?.isHidden = true
  }
  
  func resetUnderline(){
    underlineView?.isHidden = false
  }
  
  
  func setUnderlineInLoginVC() {
    guard let title = title(for: .normal) else { return }
    let attributedString = NSMutableAttributedString(string: title)
    attributedString.addAttribute(.underlineStyle,
                                  value: NSUnderlineStyle.single.rawValue,
                                  range: NSRange(location: 0, length: title.count)
    )
    setAttributedTitle(attributedString, for: .normal)
  }
}
