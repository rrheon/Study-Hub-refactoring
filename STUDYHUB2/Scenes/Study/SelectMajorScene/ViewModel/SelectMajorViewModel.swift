//
//  SeletMajorViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 9/3/24.
//

import Foundation

import RxRelay
import RxFlow

/// 학과 선택 ViewModel
final class SeletMajorViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  /// 입력한 학과
  lazy var enteredMajor: BehaviorRelay<String?> = BehaviorRelay(value: nil)
  
  /// 입력한 학과와 일치하는 학과
  let matchedMajors: PublishRelay<[String]> = PublishRelay<[String]>()

  /// 선택한 학과
  var selectedMajor = ""
  
  /// ViewModel init
  /// - Parameter enteredMajor: 이전에 선택된 학과가 있었던 경우
  init(enteredMajor: BehaviorRelay<String?>) {
    self.enteredMajor = enteredMajor
  }
  
  
  /// Plist에서 학과 검색하기
  /// - Parameter major: 입력한 학과
  func searchMajorFromPlist(_ major: String){
    matchedMajors.accept(Utils.loadMajors(major))
  }
}
