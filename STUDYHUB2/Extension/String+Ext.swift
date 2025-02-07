//
//  String+.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/13.
//

import UIKit

enum DateFormat: String {
  case format1 = "yyyy'년' MM'월' dd'일'"
  case format2 = "yyyy/MM/dd"
  case format3 = "yyyy-M-d"
}

extension String {
  func convertDateString(from format: DateFormat, to outputFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    
    if let date = dateFormatter.date(from: self) {
      dateFormatter.dateFormat = outputFormat
      let outputDate = dateFormatter.string(from: date)
      return outputDate
    } else {
      return "fail"
    }
  }
}
