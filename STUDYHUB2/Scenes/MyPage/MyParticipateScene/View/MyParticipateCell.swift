//
//  MyParticipateCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/30.
//

import UIKit

import SnapKit
import Then

protocol MyParticipateCellDelegate: AnyObject {
  func deleteButtonTapped(in cell: MyParticipateCell, postID: Int)
  func moveToChatUrl(chatURL: NSURL)
}

/// 내가 참여한 스터디 Cell
final class MyParticipateCell: UICollectionViewCell {
  
  weak var delegate: MyParticipateCellDelegate?
  
  /// 참여한 스터디의 데이터
  var model: ParticipateContent? {
    didSet { bind() }
  }
  
  var chatURL: String = ""
  
  /// 학과라벨
  lazy var majorLabel: UILabel = UILabel().then {
    $0.textColor = .o50
    $0.layer.cornerRadius = 5
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
  }
  
  /// 참여 삭제 버튼
  private lazy var deleteButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "DeleteButtonImage"), for: .normal)
    $0.addAction(UIAction { _ in
      self.deleteButtonTapped()
    }, for: .touchUpInside)
  }
  
  /// 스터디 제목 라벨
  lazy var titleLabel: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 설명라벨
  lazy var infoLabel: UILabel = UILabel().then{
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }

  private lazy var seperateLine = UIView()

  /// 채팅방 이동버튼
  private lazy var moveToChat: UIButton = UIButton().then {
    $0.setTitle("채팅방으로 이동하기", for: .normal)
    $0.setTitleColor(UIColor.bg80, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    $0.titleLabel?.textAlignment = .center
    $0.addAction(UIAction { _ in
      self.moveToChatButtonTapped()
    }, for: .touchUpInside)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubviews()
    
    configure()
    
    setViewShadow(backView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  /// layout 설정
  private func addSubviews() {
    [ majorLabel, deleteButton, titleLabel, infoLabel, seperateLine, moveToChat]
      .forEach { addSubview($0) }
  }
  
  
  /// UI 설정
  private func configure() {
    majorLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    deleteButton.snp.makeConstraints {
      $0.centerY.equalTo(majorLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(majorLabel.snp.bottom).offset(10)
      $0.leading.equalTo(majorLabel.snp.leading)
    }
    
    infoLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.leading.equalTo(majorLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
    }
  
    seperateLine.backgroundColor = .bg30
    seperateLine.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.bottom).offset(-50)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    moveToChat.snp.makeConstraints {
      $0.top.equalTo(seperateLine.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(46)
    }
  
    backgroundColor = .white
  }
  
  /// 참여한 스터디 삭제 버튼 탭
  func deleteButtonTapped(){
    guard let postId = model?.postID else { return}
    self.delegate?.deleteButtonTapped(in: self, postID: postId)
  }
  
  /// 채팅방으로 이동 버튼 탭
  func moveToChatButtonTapped(){
    guard let chatURL = NSURL(string: chatURL) else { return }
    self.delegate?.moveToChatUrl(chatURL: chatURL)
  }
  
  /// 데이터 바인딩
  func bind(){
    guard let model = model else { return }
    majorLabel.text = model.major
    titleLabel.text = model.title
    infoLabel.text = model.content
    chatURL = model.chatURL ?? "없음"
  }
}

