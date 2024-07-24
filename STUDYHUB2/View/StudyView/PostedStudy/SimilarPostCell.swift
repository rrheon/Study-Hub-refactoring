//
//  SimilarPostCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/31.
//

import UIKit

import SnapKit
import Kingfisher

final class SimilarPostCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  var model: RelatedPost? { didSet { bind() } }
  var postID: Int?
  
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    label.text = "세무회계학과"
    label.textColor = .o50
    label.backgroundColor = .o10
    label.layer.cornerRadius = 5
    label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    label.textColor = .black
    return label
  }()
  
  var remainMemberNum: Int = 0 {
    didSet {
      remainMemeber.text = "\(remainMemberNum)자리 남았어요"
    }
  }
  private lazy var remainMemeber: UILabel = {
    let label = UILabel()
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "ProfileAvatar_change")
    imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    return imageView
  }()
  
  private lazy var writerMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.textColor = .bg80
    label.backgroundColor = .bg30
    label.layer.cornerRadius = 10
    label.text = "정보통신공학과"
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    label.clipsToBounds = true
    return label
  }()
   
  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg80
    label.text = "비어있음"
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
 
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubviews()
    
    configure()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addSubviews() {
    [
      majorLabel,
      titleLabel,
      remainMemeber,
      profileImageView,
      writerMajorLabel,
      nickNameLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    majorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(15)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(24)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    remainMemeber.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(5)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    profileImageView.snp.makeConstraints { make in
      make.leading.equalTo(majorLabel.snp.leading)
      make.bottom.equalToSuperview().offset(-15)
    }
    
    writerMajorLabel.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.top).offset(-5)
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    nickNameLabel.snp.makeConstraints { make in
      make.top.equalTo(writerMajorLabel.snp.bottom).offset(5)
      make.leading.equalTo(profileImageView.snp.trailing).offset(20)
    }
    
    backgroundColor = .white
    self.layer.borderWidth = 0.5
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.cornerRadius = 10
  }
  
  private func bind() {
    guard let major = model?.major.convertMajor(model?.major ?? "공통",
                                                isEnglish: false) else { return }
    
    guard let writerMajor = model?.userData.major.convertMajor(model?.userData.major ?? "없음",
                                                               isEnglish: false) else { return }
    majorLabel.text = "\(major)"
    titleLabel.text = model?.title
    remainMemberNum = model?.remainingSeat ?? 0
    writerMajorLabel.text = "\(writerMajor)"
    nickNameLabel.text = model?.userData.nickname
    postID = model?.postID
    
    
    if let imageURL = URL(string: model?.userData.imageURL ?? "") {
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: 40, height: 40))
            
      self.profileImageView.kf.setImage(with: imageURL, options: [.processor(processor)]) { result in
        switch result {
        case .success(let value):
          DispatchQueue.main.async {
            self.profileImageView.image = value.image
            self.profileImageView.layer.cornerRadius = 20
            self.profileImageView.clipsToBounds = true
          }
        case .failure(let error):
          print("Image download failed: \(error)")
        }
      }
    }
  }
  
}
