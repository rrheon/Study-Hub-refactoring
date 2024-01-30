import UIKit

import SnapKit
import Kingfisher

protocol CommentCellDelegate: AnyObject {
  func menuButtonTapped(in cell: CommentCell, commentId: Int)
}

final class CommentCell: UITableViewCell {
  weak var delegate: CommentCellDelegate?
  
  let userDataManager = UserInfoManager.shared
  
  static let cellId = "CellId"
  
  var model: CommentConetent? { didSet { bind() } }
  var commentId: Int?
  var userNickname: String?
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "ProfileAvatar_change")
    return imageView
  }()
  
  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg90
    label.text = "비어있음"
    label.font = UIFont(name: "Pretendard", size: 16)
    return label
  }()
  
  private lazy var postCommentDate: UILabel = {
    let label = UILabel()
    label.text = "2023.9.8"
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard", size: 10)
    return label
  }()
  
  private lazy var menuButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "MenuButton"), for: .normal)
    button.addAction(UIAction { _ in
      self.menuButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var commentLabel: UILabel = {
    let label = UILabel()
    label.text = "댓글댓글"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard", size: 14)
    return label
  }()
  

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    
    addSubviews()
    configure()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getUserData(completion: @escaping () -> Void){
    userDataManager.getUserInfo { result in
      self.userNickname = result?.nickname
      completion()
    }
  }
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
  
  private func bind() {
    getUserData {
      DispatchQueue.main.async {
        self.commentId = self.model?.commentID

        self.nickNameLabel.text = self.model?.commentedUserData.nickname
    
        if self.userNickname != self.nickNameLabel.text {
          self.menuButton.isHidden = true
        }
        
        self.commentLabel.text = self.model?.content
        
        guard let createeData = self.model?.createdDate else { return }
        self.postCommentDate.text = "\(createeData[0]). \(createeData[1]). \(createeData[2])"

        
        if let imageURL = URL(string: self.model?.commentedUserData.imageURL ?? "") {
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
            }
          }
      }
    }
 
    }
  }
  
  func menuButtonTapped(){
    self.delegate?.menuButtonTapped(in: self, commentId: commentId ?? 0)
  }
}
