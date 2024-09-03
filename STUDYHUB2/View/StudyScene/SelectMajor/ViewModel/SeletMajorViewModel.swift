//
//  SeletMajorViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/3/24.
//

import Foundation

import RxRelay

final class SeletMajorViewModel: CommonViewModel {
  let enteredMajor: PublishRelay<String>
  let matchedMajors = PublishRelay<[String]>()

  init(enteredMajor: PublishRelay<String>) {
    self.enteredMajor = enteredMajor
  }
  
  func searchMajorFromPlist(_ major: String){
    loadMajors(major)
    enteredMajor.accept(major)
  }
  
  private func loadMajors(_ enteredMajor: String) {
    let majorDatas = DataLoaderFromPlist()
    if let majors = majorDatas.loadMajorsWithCodes() {
      let filteredMajors = majors.filter { (key, value) -> Bool in
        key.contains(enteredMajor)
      }
      matchedMajors.accept(filteredMajors.keys.map({ $0 }))
    }
  }
}
