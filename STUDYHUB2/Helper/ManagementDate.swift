//
//  ManagementDate.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/5/24.
//

import Foundation

protocol ManagementDate {
  var dateFormatter: DateFormatter { get }
  var today: Date { get }
}

extension ManagementDate {
  var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월"
    return formatter
  }
  
  var today: Date {
    return Date()
  }
}
