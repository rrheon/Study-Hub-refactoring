import UIKit

import SnapKit
import Kingfisher

final class CommentCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  var model: RelatedPost? { didSet { bind() } }
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "ProfileAvatar_change")
    return imageView
  }()
  
  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.text = "비어있음"
    label.font = UIFont(name: "Pretendard", size: 12)
    return label
  }()
  
  private lazy var postCommentDate: UILabel = {
    let label = UILabel()
    label.text = "2023.9.8"
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard", size: 14)
    return label
  }()
  
  private lazy var commentLabel: UILabel = {
    let label = UILabel()
    label.text = "댓글댓글"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard", size: 20)
    return label
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addSubviews() {
    [
      profileImageView,
      nickNameLabel,
      postCommentDate,
      commentLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    postCommentDate.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
      $0.leading.equalTo(nickNameLabel)
    }
    
    commentLabel.snp.makeConstraints {
      $0.top.equalTo(postCommentDate.snp.bottom).offset(20)
      $0.leading.equalTo(postCommentDate.snp.leading)
    }
  }
  
  private func bind() {
    
    
  }
}
