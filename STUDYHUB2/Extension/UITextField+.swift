//
//  UITextField+.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/30.
//

import UIKit
// MARK: - 문자 길이에 따라 크기 증가
extension UITextView {
  func adjustUITextViewHeight() {
    self.translatesAutoresizingMaskIntoConstraints = true
    self.sizeToFit()
    self.isScrollEnabled = false
  }

}
