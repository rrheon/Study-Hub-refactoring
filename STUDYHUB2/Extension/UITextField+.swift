//
//  UITextField+.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/30.
//

import UIKit
// MARK: - 문자 길이에 따라 크기 증가
extension UITextView: UITextViewDelegate {
  // MARK: textview 높이 자동조절
  public func textViewDidChange(_ textView: UITextView) {
    let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
    let estimatedSize = textView.sizeThatFits(size)
    textView.constraints.forEach { (constraint) in
      if constraint.firstAttribute == .height {
        constraint.constant = estimatedSize.height
      }
    }
    
  }
  
}

