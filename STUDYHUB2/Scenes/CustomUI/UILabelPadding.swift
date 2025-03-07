//
//  UILabelPadding.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/02.
//

import UIKit

/// 여백있는 라벨
class BasePaddingLabel: UILabel {
  private var padding = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
  
  
  /// 라벨 생성하기
  /// - Parameter padding: 여백 설정
  convenience init(padding: UIEdgeInsets) {
    self.init()
    self.padding = padding
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: padding))
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right
    
    return contentSize
  }
}
