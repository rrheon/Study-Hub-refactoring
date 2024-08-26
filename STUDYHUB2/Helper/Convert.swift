//
//  ConvertStudyWay.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/14/24.
//

import Foundation

protocol ConvertStudyWay {
  func convertStudyWay(wayToStudy: String) -> String
}

protocol ConvertGender {
  func convertGender(gender: String) -> String
}

protocol ConvertMajor{
  func convertMajor(_ major: String, toEnglish english: Bool) -> String?
}

extension ConvertStudyWay {
  func convertStudyWay(wayToStudy: String) -> String {
    switch wayToStudy {
    case "CONTACT":
      return "대면"
    case "MIX":
      return "혼합"
    default:
      return "비대면"
    }
  }
}

extension ConvertGender {
  func convertGender(gender: String) -> String {
    switch gender {
    case "FEMALE":
      return "여자"
    case "MALE":
      return "남자"
    default:
      return "무관"
    }
  }
}

extension ConvertMajor{
  func convertMajor(_ major: String, toEnglish english: Bool) -> String? {
    let majorDatas = DataLoaderFromPlist()
    guard let majors = majorDatas.loadMajorsWithCodes() else { return nil }
    let filteredMajors = majors.filter { (key, value) -> Bool in
      english ? key.contains(major) : value.contains(major)
    }
    
    return english ? filteredMajors.values.first : filteredMajors.keys.first
  }
}

protocol Convert: ConvertMajor, ConvertGender, ConvertStudyWay {}
