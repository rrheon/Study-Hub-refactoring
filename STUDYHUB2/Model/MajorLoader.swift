//
//  MajorLoader.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/26/24.
//

import Foundation

class MajorLoader {
  func loadMajorsWithCodes() -> [String: String]? {
    if let url = Bundle.main.url(forResource: "MajorDataSet", withExtension: "plist") {
      do {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let majorData = try decoder.decode([String: String].self, from: data)
        return majorData
      } catch {
        print("Error decoding Plist: \(error)")
      }
    }
    return nil
  }
}

class URLLoader {
  func loadURLs() -> [String: String]? {
    if let url = Bundle.main.url(forResource: "StudyHubURL", withExtension: "plist") {
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
}
