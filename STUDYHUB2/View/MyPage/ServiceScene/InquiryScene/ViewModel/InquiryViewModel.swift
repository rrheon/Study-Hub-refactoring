//
//  InquiryViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 10/4/24.
//

import Foundation

import RxSwift
import RxRelay

final class InquiryViewModel: CommonViewModel {
  let commonNetwork = CommonNetworking.shared
  
  let titleValue = BehaviorRelay<String?>(value: nil)
  let contentValue = BehaviorRelay<String?>(value: nil)
  let emailValue = BehaviorRelay<String?>(value: nil)
  
  var isInquiryButtonEnable: Observable<Bool> {
    return Observable.combineLatest(titleValue, contentValue, emailValue)
      .map { title, content, email in
        return !(title?.isEmpty ?? true) && !(content?.isEmpty ?? true) && !(email?.isEmpty ?? true)
      }
  }

  let isSuccessToInquiry = PublishRelay<Bool>()
  
  func inquiryToServer(){
    guard let content = contentValue.value,
          let title = titleValue.value,
          let email = emailValue.value else { return }
    
    commonNetwork.moyaNetworking(networkingChoice: .inquiryQuestion(
      content: content,
      title: title,
      toEmail: email)) { result in
        switch result {
        case .success(let response):
          self.isSuccessToInquiry.accept(true)
        case .failure(let response):
          print(response.response)
          self.isSuccessToInquiry.accept(false)
        }
      }
  }
  
}
