
import Foundation

import RxSwift
import RxFlow
import RxRelay

/// 스터디 참여 ViewModel
final class ApplyStudyViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  var postData: BehaviorRelay<PostDetailData?>
  
  /// 사용자의 소개
  var userIntroduce = PublishRelay<String>()
  
  var isSuccessParticipate = PublishRelay<Bool>()
  
  init(_ postData: BehaviorRelay<PostDetailData?>) {
    self.postData = postData
  }
  

  /// 참여하기 버튼 탭
  /// - Parameter introduce: 소개내용
  func participateButtonTapped(_ introduce: String) {

    guard let studyID = postData.value?.studyId else { return }
    
    ApplyStudyManager.shared.participateStudyWithRx(introduce: introduce, studyId: studyID)
      .subscribe(onNext: { isSuccess in
        self.isSuccessParticipate.accept(isSuccess)
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
      
//    ApplyStudyManager.shared.participateStudy(introduce: introduce, studyId: studyID) { result in
//      self.isSuccessParticipate.accept(result)
//    }
  }
}
