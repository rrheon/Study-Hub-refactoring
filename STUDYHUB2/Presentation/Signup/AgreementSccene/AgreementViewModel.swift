
import Foundation

import RxSwift
import RxCocoa

/// 이용약관동의 ViewModel
final class AgreementViewModel: ViewModelType {
  var disposeBag: DisposeBag = DisposeBag()
  
  
  /// 첫 번째 동의 버튼의 상태
  let agreeFirstCheckButtonState = BehaviorRelay<Bool>(value: false)
  
  /// 두 번째 동의 버튼의 상태
  let agreeSecondCheckButtonState = BehaviorRelay<Bool>(value: false)
  
  /// 모두 동의버튼의 상태
  lazy var agreeAllCheckButtonState: Observable<Bool> = Observable
    .combineLatest(agreeFirstCheckButtonState, agreeSecondCheckButtonState)
    .map { $0 && $1 }
    .distinctUntilChanged()
  
  
  struct Input {
    let agreeAllCheckBtnTapped: Observable<Void>
    let agreeServiceCheckBtnTapped: Observable<Void>
    let agreeInfoCheckBtnTapped: Observable<Void>
    let moveToServicePageTapped: Observable<Void>
    let moveToInfoPageTapped: Observable<Void>
    let moveToNextPageTapped: Observable<Void>
  }
  
  struct Output {
    let agreeAllBtnStatus: Observable<Bool>
    let agreeServiceBtnStatus: Observable<Bool>
    let agreeInfoBtnStatus: Observable<Bool>
    let personalInfoPageUrl: Observable<URL>
    let servicePageUrl: Observable<URL>
    let isNextBtnActivate: Observable<Bool>
  }

  
  func transform(input: Input) -> Output {
    
    // 서비스동의 버튼의 상태
    input.agreeServiceCheckBtnTapped
      .withUnretained(self)
      .bind { (vm, _) in
        let current = vm.agreeFirstCheckButtonState.value
        vm.agreeFirstCheckButtonState.accept(!current)
      }
      .disposed(by: disposeBag)
     
    // 개인정보 활용 동의 버튼의 상태
    input.agreeInfoCheckBtnTapped
      .withUnretained(self)
      .bind { (vm, _) in
        let current = vm.agreeSecondCheckButtonState.value
        vm.agreeSecondCheckButtonState.accept(!current)
      }
      .disposed(by: disposeBag)
    
    
    // 모두 동의하기 버튼 탭 -> 하나라도 눌려있으면 모두 동의된것으로 바꾸기 , 둘 다 눌려있으면 모두 해제하기
    input.agreeAllCheckBtnTapped
      .withUnretained(self)
      .bind { (vm, _) in
        vm.toggleAllAgreement()
      }.disposed(by: disposeBag)
      
    
    // 개인정보 이용약관 url
    let personalInfoPageUrl = input.moveToInfoPageTapped
      .compactMap { DataLoaderFromPlist.loadURLs()?["personal"] }
      .compactMap { URL(string: $0) }
    
    // 서비스 이용약관 url
    let servicePageUrl = input.moveToServicePageTapped
      .compactMap { DataLoaderFromPlist.loadURLs()?["service"] }
      .compactMap { URL(string: $0) }

    
    // 다음버튼 활성화 상태
    let isNextBtnActivate = Observable
      .combineLatest(agreeFirstCheckButtonState,agreeSecondCheckButtonState)
      .map { $0 && $1}
      .distinctUntilChanged()
    
    return Output(
      agreeAllBtnStatus: agreeAllCheckButtonState,
      agreeServiceBtnStatus: agreeFirstCheckButtonState.asObservable(),
      agreeInfoBtnStatus: agreeSecondCheckButtonState.asObservable(),
      personalInfoPageUrl: personalInfoPageUrl,
      servicePageUrl: servicePageUrl,
      isNextBtnActivate: isNextBtnActivate
    )
  }
  
  /// 동의항목 모두 토글하기
  func toggleAllAgreement() {
    let service = agreeFirstCheckButtonState.value
    let privacy = agreeSecondCheckButtonState.value
    let shouldSelectAll = !(service && privacy)
    
    agreeFirstCheckButtonState.accept(shouldSelectAll)
    agreeSecondCheckButtonState.accept(shouldSelectAll)
  }
}
