//
//  EditTextProtocol.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/3/24.
//

import UIKit

protocol EditableViewProtocol {
  func didBeginEditing(view: UIView)
  func didEndEditing(view: UIView, placeholderText: String?, placeholderColor: UIColor?)
}

extension EditableViewProtocol {
  func didBeginEditing(view: UIView) {
    view.layer.borderColor = UIColor.black.cgColor
    view.layer.borderWidth = 1.0
    
    if let textView = view as? UITextView, textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }
  
  func didEndEditing(
    view: UIView,
    placeholderText: String? = nil,
    placeholderColor: UIColor? = UIColor.lightGray
  ) {
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.borderWidth = 1.0
    
    if let textView = view as? UITextView, textView.text.isEmpty {
      textView.text = placeholderText
      textView.textColor = placeholderColor
    }
  }
}

