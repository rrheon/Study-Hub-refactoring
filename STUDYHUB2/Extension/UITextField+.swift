//
//  UITextField+.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/30.
//

import UIKit

@available(iOS 15.0, *)
extension UITextField {
  func setPasswordToggleVisibilityButton() {
    let eyeButton = UIButton(type: .custom)
    var isSecure = true
    
    eyeButton.setImage(UIImage(named: "CloseEyeImage"), for: .normal)
    
    eyeButton.addAction(UIAction(handler: { [weak self] _ in
      guard let self = self else { return }
      self.isSecureTextEntry.toggle()
      isSecure.toggle()
      let eyeImage = isSecure ? "eye_open" : "CloseEyeImage"
      eyeButton.setImage(UIImage(named: eyeImage), for: .normal)
    }), for: .touchUpInside)
    
    var buttonConfiguration = UIButton.Configuration.plain()
    buttonConfiguration.imagePadding = 10
    buttonConfiguration.baseBackgroundColor = .clear
    eyeButton.configuration = buttonConfiguration
    
    self.rightView = eyeButton
    self.rightViewMode = .always
  }
}
