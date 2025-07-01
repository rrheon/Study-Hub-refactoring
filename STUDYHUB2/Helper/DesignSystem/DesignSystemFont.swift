//
//  DesignSystemFont.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/20/25.
//

import Foundation


/// 폰트 시스템 - Pretendard
enum FontSystem {
  case black
  case bold
  case extraBold
  case extraLight
  case light
  case medium
  case regualr
  case semiBold
  case thin
  
  var value: String {
    switch self {
    case .black:              return "Pretendard-Black"
    case .bold:               return "Pretendard-Bold"
    case .extraBold:          return "Pretendard-ExtraBold"
    case .extraLight:         return "Pretendard-ExtraLight"
    case .light:              return "Pretendard-Light"
    case .medium:             return "Pretendard-Medium"
    case .regualr:            return "Pretendard-Regular"
    case .semiBold:           return "Pretendard-SemiBold"
    case .thin:               return "Pretendard-Thin"
    }
  }
}
