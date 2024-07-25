//
//  TermsOfServiceViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/25/24.
//

import RxSwift
import RxCocoa

enum StudyHubURL: String {
  case personal = "https://github.com/rrheon/Study-Hub/blob/main/Study-Hub/Assets.xcassets/InfoImage.imageset/InfoImage.png"
  case service = "https://github.com/rrheon/Study-Hub/blob/main/Study-Hub/Assets.xcassets/serviceImage.imageset/serviceImage.png"
}

final class AgreementViewModel {
  let personalURL: StudyHubURL = .personal
  let serviceURL: StudyHubURL = .service
  let isAllAgreed = BehaviorRelay<Bool>(value: false)
  let checkStatus = BehaviorRelay<Bool>(value: false)
  
  func toggleAgreeAll() {
    let newStatus = !isAllAgreed.value
    isAllAgreed.accept(newStatus)
    checkStatus.accept(newStatus)
  }
}
