
import UIKit

import SnapKit
import Kingfisher
import Then

/// 댓글 Cell Delegate
protocol CommentCellDelegate: AnyObject {
  
  /// 메뉴 버튼 탭 - 본인이 쓴 댓글 수정 및 삭제
  /// - Parameters:
  ///   - commentID: 댓글의 ID
  func menuButtonTapped(commentID: Int)
}


/// 댓글 Cell
final class CommentCell: UITableViewCell {
  weak var delegate: CommentCellDelegate?
  
  var loginUserName: String? = nil
  var model: CommentConetent? { didSet { bind() } }
  
  /// 작성자의 프로필 이미지뷰
  private lazy var profileImageView: UIImageView = UIImageView().then {
    $0.layer.cornerRadius = 15
    $0.image = UIImage(named: "ProfileAvatar_change")
  }
  
  /// 작성자의 닉네임 라벨
  private lazy var nickNameLabel: UILabel = UILabel().then {
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard", size: 16)
  }
  
  /// 댓글이 작성된 날짜 라벨
  private lazy var postCommentDate: UILabel = UILabel().then {
   $0.textColor = .bg70
   $0.font = UIFont(name: "Pretendard", size: 10)
  }
  
  /// 메뉴 버튼 - 댓글 수정, 삭제
  private lazy var menuButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "MenuButton"), for: .normal)
  }
  
  /// 댓글 내용 라벨
  private lazy var commentLabel: UILabel = UILabel().then {
   $0.textColor = .bg80
   $0.font = UIFont(name: "Pretendard", size: 14)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubviews()
    configure()
    
    menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 세팅
  private func addSubviews() {
    [
      profileImageView,
      nickNameLabel,
      postCommentDate,
      menuButton,
      commentLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  /// UI설정
  private func configure() {
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
      $0.height.width.equalTo(28)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    postCommentDate.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom)
      $0.leading.equalTo(nickNameLabel)
    }
    
    menuButton.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.top)
      $0.bottom.equalTo(postCommentDate.snp.bottom)
      $0.centerY.equalTo(profileImageView)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    commentLabel.snp.makeConstraints {
      $0.top.equalTo(postCommentDate.snp.bottom).offset(10)
      $0.leading.equalTo(postCommentDate.snp.leading)
    }
  }
  
  /// 데이터 바인딩
  private func bind() {
    guard let data = model else { return }
      /// 작성자의 닉네임
      self.nickNameLabel.text = data.commentedUserData.nickname
      
    print(#fileID, #function, #line," - \(loginUserName)")

      
  /// 사용자가 작성한 댓글이라면 수정이 가능한 메뉴 표시
    
    self.menuButton.isHidden = !data.usersComment
      
      
      /// 댓글 내용
      self.commentLabel.text = data.content
      
      /// 작성된 날짜

      self.postCommentDate.text = "\(data.createdDate[0]). \(data.createdDate[1]). \(data.createdDate[2])"
      
      
      /// 이미지
    if let imageURL = URL(string: data.commentedUserData.imageURL ?? "") {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 28, height: 28))
        
        KingfisherManager.shared.cache.removeImage(forKey: imageURL.absoluteString)
        
        self.profileImageView.kf.setImage(with: imageURL, options: [.processor(processor)]) { result in
          switch result {
          case .success(let value):
            DispatchQueue.main.async {
              self.profileImageView.image = value.image
              self.profileImageView.layer.cornerRadius = 12
              self.profileImageView.clipsToBounds = true
            }
          case .failure(let error):
            print("Image download failed: \(error)")
            self.profileImageView.image = UIImage(named: "ProfileAvatar_change")
          }
        }
      }
    
  }
  
  /// 댓글의 메뉴 버튼 탭
  @objc func menuButtonTapped(){
    guard let commentID = model?.commentID else { return }
    self.delegate?.menuButtonTapped(commentID: commentID)
  }
}
