
import Foundation

import RxSwift
import RxCocoa
import RxFlow

/// 이용약관동의 ViewModel
class AgreementViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  var serviceURL: String = ""
  var personalURL: String = ""
  
  /// 모두 동의버튼의 상태
  let agreeAllCheckButtonState = BehaviorRelay<Bool>(value: false)
  
  /// 첫 번째 동의 버튼의 상태
  let agreeFirstCheckButtonState = BehaviorRelay<Bool>(value: false)
  
  /// 두 번째 동의 버튼의 상태
  let agreeSecondCheckButtonState = BehaviorRelay<Bool>(value: false)
  
  init(){
    self.loadURLs()
  }
  
  /// 다음버튼 상태
  var nextButtonStatus: Observable<Bool> {
    return Observable.combineLatest(agreeFirstCheckButtonState,
                                    agreeSecondCheckButtonState).map { $0 && $1 }
  }
  
  /// 동의항목 모두 토글하기
  func toggleAllAgreement() {
    let newState = !agreeAllCheckButtonState.value
    agreeAllCheckButtonState.accept(newState)
    agreeFirstCheckButtonState.accept(newState)
    agreeSecondCheckButtonState.accept(newState)
  }
  
  
  /// 개별항목 동의
  /// - Parameter button: 첫번째 동의버튼 인지 - 아니면 두 번째 동의버튼
  func toggleAgreement(for firstBtn: Bool = true) {
    let btnState: BehaviorRelay<Bool> = firstBtn ? agreeFirstCheckButtonState : agreeSecondCheckButtonState
    let newState = !btnState.value
    btnState.accept(newState)
  }
  
  
  /// 이용약관 및 개인정보처리방침 URL 불러오기
  private func loadURLs() {
    if let serviceURLString = DataLoaderFromPlist.loadURLs()?["service"],
       let personalURLString = DataLoaderFromPlist.loadURLs()?["personal"] {
      serviceURL = serviceURLString
      personalURL = personalURLString
    }
  }
}
