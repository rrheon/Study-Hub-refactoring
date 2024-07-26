import Foundation

import RxSwift
import RxCocoa

class AgreementViewModel: CommonViewModel {
  var serviceURL: String = ""
  var personalURL: String = ""
  
  let agreeAllCheckButtonState = BehaviorRelay<Bool>(value: false)
  let agreeFirstCheckButtonState = BehaviorRelay<Bool>(value: false)
  let agreeSecondCheckButtonState = BehaviorRelay<Bool>(value: false)
  
  override init(){
    super.init()
    self.loadURLs()
  }
  
  var checkStatus: Observable<Bool> {
    return Observable.combineLatest(agreeFirstCheckButtonState,
                                    agreeSecondCheckButtonState).map { $0 && $1 }
  }
  
  func toggleAllAgreement() {
    let newState = !agreeAllCheckButtonState.value
    agreeAllCheckButtonState.accept(newState)
    agreeFirstCheckButtonState.accept(newState)
    agreeSecondCheckButtonState.accept(newState)
  }
  
  func toggleAgreement(for button: BehaviorRelay<Bool>) {
    let newState = !button.value
    button.accept(newState)
  }
  
  private func loadURLs() {
    let urlData = URLLoader()
    if let serviceURLString = urlData.loadURLs()?["service"],
       let personalURLString = urlData.loadURLs()?["personal"] {
      serviceURL = serviceURLString
      personalURL = personalURLString
    }
  }
}
