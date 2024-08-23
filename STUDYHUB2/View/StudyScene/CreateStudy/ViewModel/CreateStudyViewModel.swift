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
  
  init(_ data: PostDetailData?) {
    super.init()
    
    setPostedData(data)
  }
  
  func setPostedData(_ data: PostDetailData?) {
    self.postedData.accept(data)
  }
}
