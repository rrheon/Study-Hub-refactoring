import UIKit

import SnapKit
 
enum PopupCase {
  
  // 로그인이 필요한 경우
  case requireLogin
  
  // 프로필 이미지 변경을 위해 허용이 필요한 경우
  case allowProfileImageChange
  
  // 탈퇴 완료한 경우
  case accountDeletionCompleted
  
  // 내가 작성한 글을 모두 삭제하는 경우
  case deleteAllMyPosts
  
  // 스터디 모집을 마감하는 경우
  case closeStudyRecruitment
  
  // 내가 작성한 특정 글을 삭제하는 경우
  case deleteStudyPost
  
  // 신청한 참여자를 수락하는 경우
  case acceptParticipant
  
  // 참여한 모든 스터디를 삭제하는 경우
  case deleteAllParticipatedStudies
  
  // 특정 참여한 스터디를 삭제하는 경우
  case deleteSingleParticipatedStudy
  
  // 북마크를 모두 삭제하는 경우
  case deleteAllBookmarks
  
  // case 별 UI 설정
  var popupData: (title: String?,
                  desc: String?,
                  leftButtonTitle: String?,
                  rightButtonTitle: String?,
                  checkEndButton: Bool) {
      switch self {
      case .requireLogin:
          return ("로그인이 필요해요", "계속하시려면 로그인을 해주세요!", nil, "로그인", false)
      case .allowProfileImageChange:
          return ("사진을 변경하려면 허용이 필요해요", nil, nil, "설정", false)
      case .accountDeletionCompleted:
          return ("탈퇴가 완료됐어요", "지금까지 스터디허브를 이용해 주셔서 감사합니다.", nil, nil, true)
      case .deleteAllMyPosts:
          return ("글을 모두 삭제할까요?", "삭제한 글과 참여자는 다시 볼 수 없어요", nil, nil, false)
      case .closeStudyRecruitment:
          return ("이 글의 모집을 마감할까요?", "마감하면 다시 모집할 수 없어요", nil, "마감", false)
      case .deleteStudyPost:
          return ("이 글을 삭제할까요?", "삭제한 글과 참여자는 다시 볼 수 없어요", nil, nil, false)
      case .acceptParticipant:
          return ("이 신청자를 수락할까요?", "수락 후, 취소가 어려워요", "아니요", "수락", false)
      case .deleteAllParticipatedStudies:
          return ("스터디를 모두 삭제할까요?", "삭제하면 채팅방을 다시 찾을 수 없어요", nil, nil, false)
      case .deleteSingleParticipatedStudy:
          return ("이 스터디를 삭제할까요?", "삭제하면 채팅방을 다시 찾을 수 없어요", nil, nil, false)
      case .deleteAllBookmarks:
          return (nil, "북마크를 모두 삭제할까요?", nil, nil, false)
      }
  }
}




/// 팝업 VC
final class PopupViewController: UIViewController {
  
  /// 팝업 view
  let popupView: PopupView
  
  /// 종료버튼 활성화 여부
  let isActivateEndButton: Bool

  /// popupVC init
  /// - Parameter popupCase: 팝업 종류
  init(popupCase: PopupCase){
    
    /// 종료버튼 활성화 여부
    self.isActivateEndButton = popupCase.popupData.checkEndButton
    
    /// 팝업뷰 생성
    self.popupView = PopupView(title: popupCase.popupData.title ?? "",
                               desc: popupCase.popupData.desc ?? "",
                               leftButtonTitle: popupCase.popupData.leftButtonTitle ?? "",
                               rightButtonTitle:  popupCase.popupData.rightButtonTitle ?? "",
                               checkEndButton:  popupCase.popupData.checkEndButton)
    
    super.init(nibName: nil, bundle: nil)
    
    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)
    
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// UI 설정
  private func setupConstraints() {
    
    self.view.addSubview(self.popupView)
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
