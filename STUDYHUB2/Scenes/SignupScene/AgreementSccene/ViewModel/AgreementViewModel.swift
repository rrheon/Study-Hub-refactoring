
import Foundation

import RxSwift
import RxCocoa


/// 이용약관동의 ViewModel
class AgreementViewModel {
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
  /// - Parameter button: 동의버튼
  func toggleAgreement(for button: BehaviorRelay<Bool>) {
    let newState = !button.value
    button.accept(newState)
  }
  
  
  /// 이용약관 및 개인정보처리방침 URL 불러오기
  private func loadURLs() {
    let urlData = DataLoaderFromPlist()
    if let serviceURLString = urlData.loadURLs()?["service"],
       let personalURLString = urlData.loadURLs()?["personal"] {
      serviceURL = serviceURLString
      personalURL = personalURLString
    }
  }
}
