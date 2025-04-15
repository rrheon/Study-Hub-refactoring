import UIKit

import SnapKit

/// 팝업종류
enum PopupCase {

  /// 에러가 발생한 경우
  case checkError
  
  /// 로그인이 필요한 경우
  case requiredLogin
  
  /// 로그아웃이 필요한 경우
  case logoutIsRequired
  
  /// 프로필 이미지 변경을 위해 허용이 필요한 경우
  case allowProfileImageChange
  
  /// 탈퇴 완료한 경우
  case accountDeletionCompleted
  
  /// 내가 작성한 글을 모두 삭제하는 경우
  case deleteAllMyPosts
  
  /// 스터디 모집을 마감하는 경우
  case closeStudyRecruitment
  
  /// 내가 작성한 특정 글을 삭제하는 경우
  case deleteStudyPost
  
  /// 신청한 참여자를 수락하는 경우
  case acceptParticipant
  
  /// 참여한 모든 스터디를 삭제하는 경우
  case deleteAllParticipatedStudies
  
  /// 특정 참여한 스터디를 삭제하는 경우
  case deleteSingleParticipatedStudy
  
  /// 북마크를 모두 삭제하는 경우
  case deleteAllBookmarks
  
  /// 게시글 수정 취소의 경우
  case cancelModifyPost
  
  /// 댓글을 삭제하는 경우
  case deleteComment
  
  /// case 별 UI 설정
  var popupData: (title: String?,
                  desc: String?,
                  leftButtonTitle: String?,
                  rightButtonTitle: String?,
                  checkEndButton: Bool) {
      switch self {
      case .requiredLogin:
          return ("로그인이 필요해요", "계속하시려면 로그인을 해주세요!", "취소", "로그인", false)
      case .allowProfileImageChange:
          return ("사진을 변경하려면 허용이 필요해요", "취소", "삭제", "설정", false)
      case .accountDeletionCompleted:
          return ("탈퇴가 완료됐어요", "지금까지 스터디허브를 이용해 주셔서 감사합니다.", nil, nil, true)
      case .deleteAllMyPosts:
          return ("글을 모두 삭제할까요?", "삭제한 글과 참여자는 다시 볼 수 없어요", "취소", "삭제", false)
      case .closeStudyRecruitment:
          return ("이 글의 모집을 마감할까요?", "마감하면 다시 모집할 수 없어요", "취소", "마감", false)
      case .deleteStudyPost:
          return ("이 글을 삭제할까요?", "삭제한 글과 참여자는 다시 볼 수 없어요", "취소", "삭제", false)
      case .acceptParticipant:
          return ("이 신청자를 수락할까요?", "수락 후, 취소가 어려워요", "아니요", "수락", false)
      case .deleteAllParticipatedStudies:
          return ("스터디를 모두 삭제할까요?", "삭제하면 채팅방을 다시 찾을 수 없어요", "취소", "삭제", false)
      case .deleteSingleParticipatedStudy:
          return ("이 스터디를 삭제할까요?", "삭제하면 채팅방을 다시 찾을 수 없어요", "취소", "삭제", false)
      case .deleteAllBookmarks:
          return (nil, "북마크를 모두 삭제할까요?", "취소", "삭제", false)
      case .cancelModifyPost:
        return ("수정을 취소할까요?","취소할 시 내용이 저장되지 않아요","아니요","네" , false )
      case .deleteComment:
        return ("댓글을 삭제할까요?", "", "취소", "삭제", false)
      case .logoutIsRequired:
        return ("로그아웃 하시겠어요?", "", "아니요", "네", false)
      case .checkError:
        return ("잠시 후 다시 시도해주세요.", "", nil, nil, true)
      }
  }
}


/// 팝업 VC
final class PopupViewController: UIViewController {
  
  /// 팝업 view
  let popupView: PopupView
  

  /// popupVC init
  /// - Parameter popupCase: 팝업 종류
  init(popupCase: PopupCase){
    
    /// 팝업뷰 생성
    self.popupView = PopupView(popupCase: popupCase)
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)
    
    self.setupConstraints()
    
    // popupView의 기본 actions
    self.popupView.defaultBtnAction = {
      self.dismiss(animated: true)
    }
  }// viewDidLoad
  
  /// UI 설정
  private func setupConstraints() {
    
    self.view.addSubview(self.popupView)
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
