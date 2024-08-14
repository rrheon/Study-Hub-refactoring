//
//  MajorLoader.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/26/24.
//

import Foundation

class DataLoaderFromPlist {
  private func loadData(_ from: String) -> [String: String]? {
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
  
  func loadURLs() -> [String: String]? {
    return loadData("StudyHubURL")
  }
  
  func loadMajorsWithCodes() -> [String: String]? {
    return loadData("MajorDataSet")
  }
}
