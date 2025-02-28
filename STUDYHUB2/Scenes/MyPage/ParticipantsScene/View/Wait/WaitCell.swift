//
//  WaitCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/29.
//

import UIKit

import SnapKit
import Kingfisher
import Then

protocol ParticipantsCellDelegate: AnyObject {
  func refuseButtonTapped(in cell: WaitCell, userId: Int)
  func acceptButtonTapped(in cell: WaitCell, userId: Int)
}

/// 스터디 신청 대기인원 Cell
final class WaitCell: UICollectionViewCell {

  weak var delegate: ParticipantsCellDelegate?
  
  /// 신청한 인원의 데이터
  var model: ApplyUserContent? {
    didSet { bind() }
  }
  
  /// 신청한 인원의 ID
  lazy var userId: Int = 0
  
  /// 신청자의 프로필 이미지뷰
  private lazy var profileImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "ProfileAvatar_change")
  }
  
  /// 신청자의 학과 라벨
  private lazy var majorLabel: UILabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
  /// 신청자의 닉네임 라벨
  private lazy var nickNameLabel: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }
  
  /// 신청한 날짜 라벨
  private lazy var dateLabel: UILabel = UILabel().then {
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }

  /// 신청사유 TextView
  private lazy var describeTextView: UITextView = UITextView().then {
    $0.textColor = .bg80
    $0.backgroundColor = .bg20
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  /// 셀의 구분선
  private lazy var seperateLine = UIView()

  /// 거절 / 수락 버튼 스택뷰
  private lazy var buttonStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  
  /// 신청 거절 버튼
  private lazy var refuseButton: UIButton = UIButton().then {
    $0.setTitle("거절", for: .normal)
    $0.setTitleColor(UIColor.bg80, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    $0.addAction(UIAction { _ in
      self.delegate?.refuseButtonTapped(in: self, userId: self.userId)
    }, for: .touchUpInside)
  }
  
  /// 신청 수락 버튼
  private lazy var acceptButton: UIButton = UIButton().then {
    $0.setTitle("수락", for: .normal)
    $0.setTitleColor(UIColor.g_10, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    $0.addAction(UIAction { _ in
      self.delegate?.acceptButtonTapped(in: self, userId: self.userId)
    }, for: .touchUpInside)
  }
  
  /// 스택뷰 구분선
  private lazy var seperateLineinStackView = UIView()

  // MARK: - init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
    
    setupLayout()
    makeUI()
    setViewShadow(backView: self)

  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - setupLayout
  
  /// layout 설정
  func setupLayout(){
    [ refuseButton, seperateLineinStackView, acceptButton ]
      .forEach { buttonStackView.addArrangedSubview($0) }
    
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
  
  /// UI 설정
  func makeUI(){
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(10)
      $0.width.height.equalTo(50)
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
  
  /// 데이터 설정
  func bind(){
    guard let data = model else { return }
    userId = data.id
    majorLabel.text = Utils.convertMajor(data.major, toEnglish: false)
    nickNameLabel.text = data.nickname
    describeTextView.text = data.introduce
    dateLabel.text = "\(data.createdDate[0]). \(data.createdDate[1]). \(data.createdDate[2])"
    
    if let imageURL = URL(string: data.imageURL) {
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50))
            
      self.profileImageView.kf.setImage(
        with: imageURL,
        options: [.processor(processor)]) { result in
        switch result {
        case .success(let value):
          DispatchQueue.main.async {
            self.profileImageView.image = value.image
            self.profileImageView.layer.cornerRadius = 15
            self.profileImageView.clipsToBounds = true
          }
        case .failure(let error):
          print("Image download failed: \(error)")
          self.profileImageView.image = UIImage(named: "ProfileAvatar_change")
        }
      }
    }
  }
}

