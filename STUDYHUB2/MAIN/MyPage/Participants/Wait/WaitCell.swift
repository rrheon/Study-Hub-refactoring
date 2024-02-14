//
//  WaitCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/29.
//

import UIKit

import SnapKit
import Kingfisher

protocol ParticipantsCellDelegate: AnyObject {
  func refuseButtonTapped(in cell: WaitCell, userId: Int)
  func acceptButtonTapped(in cell: WaitCell, userId: Int)
}

final class WaitCell: UICollectionViewCell {
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  weak var delegate: ParticipantsCellDelegate?
  var model: [ApplyUserContent]? {
    didSet {
      bind()
    }
  }
  
  lazy var userId: Int = 0
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ProfileAvatar_change")
    return imageView
  }()
  
  private lazy var majorLabel: UILabel = {
    let label = UILabel()
    label.text = "경영학부"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "경영이"
    label.textColor = .black
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "2023. 9 . 8 신청 "
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  private lazy var describeTextView: UITextView = {
    let textView = UITextView()
    textView.textColor = .bg80
    textView.backgroundColor = .bg20
    textView.text = "안녕하세요, 저는 경영학부에 재학 중입니다. 지각이나 잠수 없이 열심히 참여하겠습니다. 잘 부탁드립니다 :)"
    textView.font = UIFont(name: "Pretendard-Medium", size: 14)
    textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    return textView
  }()
  
  private lazy var seperateLine = UIView()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    return stackView
  }()
  
  private lazy var refuseButton: UIButton = {
    let button = UIButton()
    button.setTitle("거절", for: .normal)
    button.setTitleColor(UIColor.bg80, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    button.addAction(UIAction { _ in
      self.delegate?.refuseButtonTapped(in: self, userId: self.userId)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var acceptButton: UIButton = {
    let button = UIButton()
    button.setTitle("수락", for: .normal)
    button.setTitleColor(UIColor.g_10, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    button.addAction(UIAction { _ in
      self.delegate?.acceptButtonTapped(in: self, userId: self.userId)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var seperateLineinStackView = UIView()

  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViewShadow(backView: self)
    
    self.backgroundColor = .white
    
    setupLayout()
    makeUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      refuseButton,
      seperateLineinStackView,
      acceptButton
    ].forEach {
      buttonStackView.addArrangedSubview($0)
    }
    
    [
      profileImageView,
      majorLabel,
      nickNameLabel,
      dateLabel,
      describeTextView,
      seperateLine,
      buttonStackView
    ].forEach {
      addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(10)
    }
    
    majorLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(majorLabel.snp.bottom)
      $0.leading.equalTo(majorLabel)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(5)
      $0.leading.equalTo(majorLabel)
    }
    
    describeTextView.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(10)
      $0.leading.equalTo(profileImageView.snp.leading)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    seperateLine.backgroundColor = .bg30
    seperateLine.snp.makeConstraints {
      $0.top.equalTo(describeTextView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    seperateLineinStackView.backgroundColor = .bg30
    seperateLineinStackView.snp.makeConstraints {
      $0.height.equalTo(20)
      $0.width.equalTo(1)
    }
    
    buttonStackView.alignment = .center
    buttonStackView.distribution = .equalCentering
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(seperateLine.snp.bottom)
      $0.leading.equalTo(profileImageView.snp.trailing)
      $0.height.equalTo(46)
      $0.trailing.equalTo(describeTextView.snp.trailing).offset(-50)
      $0.bottom.equalToSuperview()
    }
  }
  
  func bind(){
    guard let model = model else { return }
    model.map {
      userId = $0.id

      majorLabel.text = $0.major.convertMajor($0.major, isEnglish: false)
      nickNameLabel.text = $0.nickname
      describeTextView.text = $0.introduce
      dateLabel.text = "\($0.createdDate[0]). \($0.createdDate[1]). \($0.createdDate[2])"
      
      if let imageURL = URL(string: $0.imageURL ?? "") {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50))
              
        self.profileImageView.kf.setImage(with: imageURL,
                                          options: [.processor(processor)]) { result in
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
}
