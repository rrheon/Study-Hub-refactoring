
import UIKit

import SnapKit
import Then


/// BottomSheet Delegate
protocol BottomSheetDelegate {
  func firstButtonTapped(postOrCommentID: Int, bottomSheetCase: BottomSheetCase)
  func secondButtonTapped(postOrCommentID: Int, bottomSheetCase: BottomSheetCase)
}


/// BottomSheet 종류
enum BottomSheetCase {
  case managementPost           // 게시글 삭제 수정
  case managementComment       // 댓글 삭제 수정
  case editProfile             // 프로필 편집
  
  /// 첫 번째 버튼 타이틀
  var firstBtntitle: String {
    switch self {
    case .editProfile:        return "사진 촬영하기"
    default:                  return "삭제하기"
    }
  }
  
  /// 두 번째 버튼 타이틀
  var secondBtntitle: String {
    switch self {
    case .editProfile:        return "앨범에서 선택하기"
    default:                  return "수정하기"
    }
  }
}


// 종류 - 프로필 수정, 게시글 삭제 수정, 댓글 삭제 수정
/// BottomSheet VC
final class BottomSheet: UIViewController {
  private var postOrCommentID: Int? = nil
  private let type: BottomSheetCase
  
  var delegate: BottomSheetDelegate?
  
  /// bottomSheet VC생성
  /// - Parameters:
  ///   - postID: postID 혹은 CommentID
  ///   - type: BottomSheet 종류
  init(with postOrCommentID: Int? = nil , type: BottomSheetCase = .managementPost) {
    self.postOrCommentID = postOrCommentID
    self.type = type
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /// 첫 번째 버튼
  private lazy var firstButton: UIButton = UIButton().then{
    $0.setTitle(type.firstBtntitle, for: .normal)
    
    let buttonColor = type.firstBtntitle == "삭제하기" ? UIColor.o50 : UIColor.bg80
    $0.setTitleColor(buttonColor, for: .normal)
    $0.addAction(UIAction { _ in
      self.firstButtonTapped()
    }, for: .touchUpInside)
  }
  
  /// 두 번째 버튼
  private lazy var secondeButton: UIButton = UIButton().then {
    $0.setTitle(type.secondBtntitle, for: .normal)
    $0.setTitleColor(.bg80, for: .normal)
    $0.addAction(UIAction { _ in
      self.secondButtonTapped()
    }, for: .touchUpInside)
  }
  
  /// 닫기 버튼
  private lazy var dismissButton: UIButton = UIButton().then {
    $0.setTitle("닫기", for: .normal)
    $0.setTitleColor(.bg80, for: .normal)
    $0.backgroundColor = .bg30
    $0.addTarget(self, action: #selector(dissMissButtonTapped), for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    makeUI()
  } // viewDidLoad
  
 
  /// UI 설정
  func makeUI(){
    view.addSubview(firstButton)
    firstButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview()
      make.height.equalTo(50)
    }
    
    view.addSubview(secondeButton)
    secondeButton.snp.makeConstraints { make in
      make.top.equalTo(firstButton.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.height.equalTo(50)
    }
    
    view.addSubview(dismissButton)
    dismissButton.snp.makeConstraints { make in
      make.top.equalTo(secondeButton.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.height.equalTo(50)
      make.width.equalTo(335)
    }
  }
  
  /// 첫번째 버튼 터치 시
  func firstButtonTapped(){
    guard let id = postOrCommentID else { return }
    delegate?.firstButtonTapped(postOrCommentID: id, bottomSheetCase: type)
  }
  
  /// 두번째 버튼 터치 시
  func secondButtonTapped(){
    guard let id = postOrCommentID else { return }
    delegate?.secondButtonTapped(postOrCommentID: id, bottomSheetCase: type)
  }
  
  /// 닫기 버튼 터치 시
  @objc func dissMissButtonTapped(){
    dismiss(animated: true, completion: nil)
  }
}
