//
//  StudyHubButton.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/25/24.
//

import UIKit

final class StudyHubButton: UIButton {
  
  init(title: String, fontSize: CGFloat = 16, radious: CGFloat = 6) {
    super.init(frame: .zero)
    setup(title: title, fontSize: fontSize, radious: radious)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(title: String, fontSize: CGFloat, radious: CGFloat) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.backgroundColor = .o50
    self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: fontSize)
    self.layer.cornerRadius = radious
  }
  
  func unableButton(_ check: Bool){
    self.isEnabled = check
    self.backgroundColor = check ? .o50 : .o60
    
    let titleColor = check ? UIColor.white : UIColor.g70
    self.setTitleColor(titleColor, for: .normal)
  }
}
