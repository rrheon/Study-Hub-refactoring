//
//  SimilarPostCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/31.
//

import UIKit

import SnapKit
import Kingfisher
import Then

/// 유사한 게시글 셀
final class SimilarPostCell: UICollectionViewCell {
    
  var model: RelatedPost? { didSet { bind() } }
  var postID: Int?
  
  
  /// 스터디 관련 학과라벨
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    label.textColor = .o50
    label.backgroundColor = .o10
    label.layer.cornerRadius = 5
    label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    label.clipsToBounds = true
    return label
  }()
  
  /// 스터디 제목라벨
  private lazy var titleLabel: UILabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    $0.textColor = .black
  }
  
  var remainMemberNum: Int = 0 {
    didSet {
      remainMemeberLabel.text = "\(remainMemberNum)자리 남았어요"
    }
  }
  
  /// 남은자리 라벨
  private lazy var remainMemeberLabel: UILabel = UILabel().then {
   $0.textColor = .bg80
   $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 작성자의 프로필 이미지
  private lazy var profileImageView: UIImageView = UIImageView().then {
   $0.layer.cornerRadius = 15
   $0.image = UIImage(named: "ProfileAvatar_change")
   $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
  }
  
  /// 작성자의 전공라벨
  private lazy var writerMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.textColor = .bg80
    label.backgroundColor = .bg30
    label.layer.cornerRadius = 10
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    label.clipsToBounds = true
    return label
  }()
   
  /// 사용자의 닉네임 라벨
  private lazy var nickNameLabel: UILabel = UILabel().then {
    $0.textColor = .bg80
    $0.text = "비어있음"
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
 
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubviews()
    
    configure()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  /// layout 설정
  private func addSubviews() {
    [
      majorLabel,
      titleLabel,
      remainMemeberLabel,
      profileImageView,
      writerMajorLabel,
      nickNameLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  /// UI 설정
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
    
    remainMemeberLabel.snp.makeConstraints { make in
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
  
  /// 데이터 바인딩
  private func bind() {
    guard let major = Utils.convertMajor(model?.major ?? "없음", toEnglish: false),
          let writerMajor = Utils.convertMajor(model?.userData.major ?? "없음", toEnglish: false)
          else { return }

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

