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
  var seletedMajor = PublishRelay<String>()
  
  var isAllGenderButton = BehaviorRelay<Bool>(value: false)
  var isMaleOnlyButton = BehaviorRelay<Bool>(value: false)
  var isFemaleOnlyButton = BehaviorRelay<Bool>(value: false)
  
  var isMixButton = BehaviorRelay<Bool>(value: false)
  var isContactButton = BehaviorRelay<Bool>(value: false)
  var isUntactButton = BehaviorRelay<Bool>(value: false)
  
  var isFineButton = PublishRelay<Bool>()
  
  var isStartDateButton = BehaviorRelay<Bool>(value: false)
  var isEndDateButton = BehaviorRelay<Bool>(value: false)
  var startDate = BehaviorRelay<String>(value: "선택하기")
  var endDate = BehaviorRelay<String>(value: "선택하기")
  
  var seletedDate: String? = nil
  var selectedDay: Int = 0
  var currentPage: Date? = nil

  init(_ data: PostDetailData?) {
    super.init()
    
    setPostedData(data)
  }
  
  func setPostedData(_ data: PostDetailData?) {
    self.postedData.accept(data)
    
  }
}

extension CreateStudyViewModel: ManagementDate {}
