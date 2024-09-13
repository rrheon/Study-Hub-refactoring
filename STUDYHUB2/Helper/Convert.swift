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
    let mappings: [String: String] = [
      "CONTACT": "대면",
      "MIX": "혼합",
      "UNTACT": "비대면",
      "대면": "CONTACT",
      "혼합": "MIX",
      "비대면": "UNTACT"
    ]
    
    return mappings[wayToStudy, default: "MIX"]
  }
}

extension ConvertGender {
  func convertGender(gender: String) -> String {
    let mappings: [String: String] = [
      "FEMALE": "여자",
      "MALE": "남자",
      "NULL": "무관",
      "여자": "FEMALE",
      "남자": "MALE",
      "무관": "NULL"
    ]
    
    return mappings[gender, default: "NULL"]
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
