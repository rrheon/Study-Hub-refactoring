//
//  MajorLoader.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/26/24.
//

import Foundation

/// Plist Loader
class DataLoaderFromPlist {
  private class func loadData(_ from: String) -> [String: String]? {
    if let url = Bundle.main.url(forResource: from, withExtension: "plist") {
      do {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let urlData = try decoder.decode([String: String].self, from: data)
        return urlData
      } catch {
        print("Error decoding Plist: \(error)")
      }
    }
    return nil
  }
  
  /// URL 주소 가져오기 - 서비스이용약관, 개인정보 처리방침
  /// - Returns: 주소
  class func loadURLs() -> [String: String]? {
    return loadData("StudyHubURL")
  }
  
  /// 학과 가져오기
  /// - Returns: 학과
  class func loadMajorsWithCodes() -> [String: String]? {
    return loadData("MajorDataSet")
  }
}
