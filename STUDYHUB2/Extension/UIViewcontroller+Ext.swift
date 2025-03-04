//
//  UIViewcontrollerExtention.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import UIKit

import SnapKit

extension UIViewController: UITextFieldDelegate, UITextViewDelegate {

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 1.0
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.clear.cgColor
    textField.layer.borderWidth = 0.0
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
    textView.layer.borderColor = UIColor.black.cgColor
    textView.layer.borderWidth = 1.0
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
      textView.textColor = UIColor.lightGray
    }
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 1.0 
  }
}
