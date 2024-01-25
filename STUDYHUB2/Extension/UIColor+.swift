//
//  UIColorExtension.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/06.
//

import UIKit

extension UIColor {
  static let postedMajor = UIColor(red: 1.00, green: 0.71, blue: 0.64, alpha: 1.00)
  static let postedMajorBackGorund = UIColor(red: 0.44, green: 0.17, blue: 0.11, alpha: 1.00)
  static let deepGray = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.00)

  static let backgroundBlack = UIColor(red: 0.06, green: 0.06, blue: 0.06, alpha: 1.00)

  static let bg20 = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1.00)
  static let bg30 = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1.00)
  static let bg40 = UIColor(red: 0.91, green: 0.92, blue: 0.93, alpha: 1.00)
  static let bg50 = UIColor(red: 0.85, green: 0.86, blue: 0.87, alpha: 1.00)
  static let bg60 = UIColor(red: 0.76, green: 0.78, blue: 0.80, alpha: 1.00)
  static let bg70 = UIColor(red: 0.63, green: 0.67, blue: 0.69, alpha: 1.00)
  static let bg80 = UIColor(red: 0.41, green: 0.45, blue: 0.49, alpha: 1.00)
  static let bg90 = UIColor(red: 0.29, green: 0.33, blue: 0.36, alpha: 1.00)

  static let r50 = UIColor(red: 1.00, green: 0.11, blue: 0.21, alpha: 1.00)

  static let g100 = UIColor(red: 0.21, green: 0.21, blue: 0.21, alpha: 1.00)
  static let g10 = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00)
  static let g40 = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1.00)
  static let g50 = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.00)
  static let g60 = UIColor(red: 0.56, green: 0.56, blue: 0.56, alpha: 1.00)
  static let g70 = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
  static let g80 = UIColor(red: 0.39, green: 0.39, blue: 0.39, alpha: 1.00)
  static let g90 = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)


  static let g_10 = UIColor(red: 0.16, green: 0.82, blue: 0.18, alpha: 1.00)

  static let changeInfo = UIColor(red: 1.00, green: 0.33, blue: 0.19, alpha: 1.00)

  static let o10 = UIColor(red: 1.00, green: 0.95, blue: 0.93, alpha: 1.00)
  static let o20 = UIColor(red: 1.00, green: 0.84, blue: 0.80, alpha: 1.00)
  static let o30 = UIColor(red: 1.00, green: 0.71, blue: 0.64, alpha: 1.00)
  static let o40 = UIColor(red: 1.00, green: 0.52, blue: 0.40, alpha: 1.00)
  static let o50 = UIColor(red: 1.00, green: 0.33, blue: 0.19, alpha: 1.00)
  static let o60 = UIColor(red: 0.44, green: 0.17, blue: 0.11, alpha: 1.00)

  static let cellShadow = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
  
  convenience init(hexCode: String, alpha: CGFloat = 1.0) {
    var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if hexFormatted.hasPrefix("#") {
      hexFormatted = String(hexFormatted.dropFirst())
    }
    
    assert(hexFormatted.count == 6, "Invalid hex code used.")
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
    

  }
  

}
