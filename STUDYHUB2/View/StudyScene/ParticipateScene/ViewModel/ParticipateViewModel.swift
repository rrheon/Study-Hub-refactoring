
import Foundation

import RxRelay

final class ParticipateViewModel: CommonViewModel {
  let participateManager = ParticipateManager.shared
  
  var postData: BehaviorRelay<PostDetailData?>
  var userIntroduce = PublishRelay<String>()
  var isSuccessParticipate = PublishRelay<Bool>()
  
  init(_ postData: BehaviorRelay<PostDetailData?>) {
    self.postData = postData
  }
  
  func participateButtonTapped(_ introduce: String) {
    guard let studyID = postData.value?.studyID else { return }
    participateManager.participateStudy(
      introduce: introduce,
      studyId: studyID
    ) { [weak self] success in
      guard let self = self,
            var currentPostData = self.postData.value else { return }
      
      if success {
        currentPostData.apply = true
        self.postData.accept(currentPostData)
      }
      
      self.isSuccessParticipate.accept(success)
    }
  }
}
