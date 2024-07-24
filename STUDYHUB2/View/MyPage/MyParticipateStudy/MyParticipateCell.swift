//
//  MyParticipateCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/30.
//

import UIKit

import SnapKit

protocol MyParticipateCellDelegate: AnyObject {
  func deleteButtonTapped(in cell: MyParticipateCell, postID: Int)
  func moveToChatUrl(chatURL: NSURL)
}

final class MyParticipateCell: UICollectionViewCell {
  
  weak var delegate: MyParticipateCellDelegate?
  
  var model: ParticipateContent?? {
    didSet {
      bind()
    }
  }
  
  var chatURL: String = ""
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  lazy var majorLabel: UILabel = {
    let label = UILabel()
    label.text = " 세무회계학과 "
    label.textColor = .o50
    label.layer.cornerRadius = 5
    label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    return label
  }()
  
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "DeleteButtonImage"), for: .normal)
    button.addAction(UIAction { _ in
      self.deleteButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "단기 스터디원 구해요!"
    label.textColor = .black
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return label
  }()
  
  lazy var infoLabel: UILabel = {
    let label = UILabel()
    label.text = "내용내용내용"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()

  private lazy var seperateLine = UIView()

  private lazy var moveToChat: UIButton = {
    let button = UIButton()
    button.setTitle("채팅방으로 이동하기", for: .normal)
    button.setTitleColor(UIColor.bg80, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    button.titleLabel?.textAlignment = .center
    button.addAction(UIAction { _ in
      self.moveToChatButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViewShadow(backView: self)
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
      deleteButton,
      titleLabel,
      infoLabel,
      seperateLine,
      moveToChat
    ].forEach {
      addSubview($0)
    }
  }
  
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
    
    self.layer.borderWidth = 0.1
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.cornerRadius = 10
  }
  
  func deleteButtonTapped(){
    guard var postId = model?.map({ $0.studyID }) else { return}
    self.delegate?.deleteButtonTapped(in: self, postID: postId)
    print("1")
  }
  
  func moveToChatButtonTapped(){
    print("@")
    guard let chatURL = NSURL(string: chatURL) else { return }
    self.delegate?.moveToChatUrl(chatURL: chatURL)
  }
  
  func bind(){
    guard let model = model else { return }
    model.map {
      majorLabel.text = $0.major
      titleLabel.text = $0.title
      infoLabel.text = $0.content
      chatURL = $0.chatURL
    }
  }
}

