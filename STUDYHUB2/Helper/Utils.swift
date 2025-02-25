//
//  ConvertStudyWay.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/14/24.
//

import Foundation


/// 변환 Utils
class Utils {
  
  /// 스터디 방식 변환 한국어 <-> 영어
  /// - Parameter wayToStudy: 스터디 방식
  /// - Returns: 변환된 스터디방식
  class func convertStudyWay(wayToStudy: String) -> String {
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
  
  
  /// 성별 변환 한국어 <-> 영어
  /// - Parameter gender: 변환할 성별
  /// - Returns: 변환된 성별
  class func convertGender(gender: String) -> String {
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
  
  
  /// 성별 이미지 변환 성별 to 이미지
  /// - Parameter gender: 변환할 이미지
  /// - Returns: 반환할 이미지 문자열
  class func convertGenderImage(_ gender: String) -> String{
    switch gender {
    case "MALE":     return "MenGenderImage"
    case "FEMALE":   return "GenderImage"
    default:         return "GenderMixImg"
    }
  }
  
  /// 스터디 생성 시 성별 타입 반환
  /// - Parameter gender: 성별
  /// - Returns: 반환값
  class func convertGenderType(_ gender: String) -> String{
    let convertGender = Utils.convertGender(gender: gender)
    switch convertGender {
    case "남자":  return "남자만"
    case "여자":  return "여자만"
    default:     return "무관"
    }
  }
  
  /// 학과변환
  /// - Parameters:
  ///   - major: 변환할 학과
  ///   - english: 영문 여부
  /// - Returns: 변환된 학과
  class func convertMajor(_ major: String, toEnglish english: Bool) -> String? {
    guard let majors = DataLoaderFromPlist.loadMajorsWithCodes() else { return nil }
    let filteredMajors = majors.filter { (key, value) -> Bool in
      english ? key.contains(major) : value.contains(major)
    }
    
    return english ? filteredMajors.values.first : filteredMajors.keys.first
  }
  
  
  /// plist에서 일치하는 학과 가져오기
  /// - Parameter enteredMajor: 입력된 학과
  /// - Returns: 일치하는 학과
  class func loadMajors(_ enteredMajor: String) -> [String] {
    guard let majors = DataLoaderFromPlist.loadMajorsWithCodes() else { return [] }
    
    let filteredMajors = majors.keys.filter { $0.contains(enteredMajor) }
    
    return filteredMajors
  }

}

protocol ConvertStudyWay {
  func convertStudyWay(wayToStudy: String) -> String
}

protocol ConvertGender {
  func convertGender(gender: String) -> String
  func convertGenderImage(_ gender: String) -> String
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
  
  func convertGenderImage(_ gender: String) -> String{
    switch gender {
    case "MALE":
      return "MenGenderImage"
    case "FEMALE":
      return "GenderImage"
    default:
      return "GenderMixImg"
    }
  }
}

extension ConvertMajor{
  func convertMajor(_ major: String, toEnglish english: Bool) -> String? {
    guard let majors = DataLoaderFromPlist.loadMajorsWithCodes() else { return nil }
    let filteredMajors = majors.filter { (key, value) -> Bool in
      english ? key.contains(major) : value.contains(major)
    }
    
    return english ? filteredMajors.values.first : filteredMajors.keys.first
  }
}

protocol Convert: ConvertMajor, ConvertGender, ConvertStudyWay {}
