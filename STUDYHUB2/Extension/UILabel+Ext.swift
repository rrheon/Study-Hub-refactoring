//
//  UILabel+.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/07.
//

import UIKit

extension UILabel {
  
  // MARK: - 글자색상 일부분 변경
  
  
  /// 글자색상 일부분 변경
  /// - Parameters:
  ///   - wantToChange: 변경을 원하는 부분
  ///   - color: 변경할 색상
  ///   - font: 변경할 폰트
  ///   - lineSpacing: 여백
  func changeColor(
    wantToChange: String,
    color: UIColor,
    font: UIFont? = nil,
    lineSpacing: CGFloat? = nil
  ) {
    guard let originalText = self.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
    
    let range = (originalText.string as NSString).range(of: wantToChange)
    
    if range.location != NSNotFound {
      originalText.addAttribute(.foregroundColor, value: color, range: range)
      
      if let font = font {
        originalText.addAttribute(.font, value: font, range: range)
      }
      
      if let lineSpacing = lineSpacing {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        originalText.addAttribute(.paragraphStyle, value: style, range: range)
      }
      
      self.attributedText = originalText
    }
  }

  func setLineSpacing(spacing: CGFloat) {
    guard let text = text else { return }
    
    let attributeString = NSMutableAttributedString(string: text)
    let style = NSMutableParagraphStyle()
    style.lineSpacing = spacing
    attributeString.addAttribute(
      .paragraphStyle,
      value: style,
      range: NSRange(location: 0, length: attributeString.length)
    )
    attributedText = attributeString
  }
}


