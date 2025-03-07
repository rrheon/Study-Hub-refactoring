//
//  UIView+.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/13.
//

import UIKit

extension UIView {
  
  // MARK: -  colloectionview 테두리 그림자설정
  
  func setViewShadow(backView: UIView) {
       backView.layer.masksToBounds = true
       backView.layer.cornerRadius = 20
       
       layer.masksToBounds = false
       layer.shadowOpacity = 0.1
       layer.shadowOffset = CGSize(width: 0, height: 0)
       layer.shadowRadius = 4
       layer.shadowColor = UIColor.cellShadow.cgColor
    

   }
}
