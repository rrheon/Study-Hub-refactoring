//
//  StudyHubButton.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/25/24.
//

import UIKit

protocol StudyHubButtonProtocol: AnyObject {
  func buttonTapped()
}

final class StudyHubButton: UIButton {
  private weak var buttonActionDelegate: StudyHubButtonProtocol?
  
  init(title: String, actionDelegate: StudyHubButtonProtocol) {
    self.buttonActionDelegate = actionDelegate
    super.init(frame: .zero)
    setup(title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup(_ title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.backgroundColor = .o50
    self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    self.layer.cornerRadius = 6
    self.addAction(UIAction { [weak self] _ in
      self?.buttonActionDelegate?.buttonTapped()
    }, for: .touchUpInside)
  }
  
  func unableButton(_ check: Bool){
    self.backgroundColor = check ? .o60 : .o50
    
    let titleColor = check ? UIColor.g70 : UIColor.white
    self.setTitleColor(titleColor, for: .normal)
  }
}
