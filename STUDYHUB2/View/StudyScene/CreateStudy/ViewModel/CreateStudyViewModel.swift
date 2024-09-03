//
//  CreateStudyViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/21/24.
//

import Foundation

import RxRelay

final class CreateStudyViewModel: CommonViewModel {
  var postedData = BehaviorRelay<PostDetailData?>(value: nil)
  var isMoveToSeletMajor = PublishRelay<Bool>()
  
  var isAllGenderButton = BehaviorRelay<Bool>(value: false)
  var isMaleOnlyButton = BehaviorRelay<Bool>(value: false)
  var isFemaleOnlyButton = BehaviorRelay<Bool>(value: false)
  
  var isMixButton = BehaviorRelay<Bool>(value: false)
  var isContactButton = BehaviorRelay<Bool>(value: false)
  var isUntactButton = BehaviorRelay<Bool>(value: false)
  
  var seletedMajor = PublishRelay<String>()
  
  init(_ data: PostDetailData?) {
    super.init()
    
    setPostedData(data)
  }
  
  func setPostedData(_ data: PostDetailData?) {
    self.postedData.accept(data)
  }
}
