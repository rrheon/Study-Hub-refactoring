//
//  BookMarkCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/09.
//
import UIKit

import SnapKit

protocol BookMarkDelegate: AnyObject {
  func bookmarkTapped(postId: Int, userId: Int)
}

protocol ParticipatePostDelegate: AnyObject {
  func participateButtonTapped(studyId: Int, postId: Int)
}

final class BookMarkCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  weak var delegate: BookMarkDelegate?
  weak var postDelegate: ParticipatePostDelegate?
  
  var model: BookmarkContent? { didSet { bind()} }
  
  private lazy var majorLabel: UILabel = {
    let label = UILabel()
    label.text = "세무회계학과"
    label.textColor = .o50
    label.layer.cornerRadius = 5
    label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    return label
  }()
  
  private lazy var bookMarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkChecked"), for: .normal)
    button.addAction(UIAction { _ in
      self.delegate?.bookmarkTapped(postId: self.model?.postID ?? 0, userId: 0)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "단기 스터디원 구해요!"
    label.textColor = .black
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return label
  }()
  
  private lazy var infoLabel: UILabel = {
    let label = UILabel()
    label.text = "내용내용내용"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  var remainCount: Int = 4
  private lazy var remainLabel: UILabel = {
    let label = UILabel()
    label.text = "잔여 \(remainCount)자리"
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  private lazy var enterButton: UIButton = {
    let button = UIButton()
    button.setTitle("신청하기", for: .normal)
    button.setTitleColor(UIColor.o50, for: .normal)
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.o40.cgColor
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    button.addAction(UIAction { _ in
      self.postDelegate?.participateButtonTapped(studyId: self.model?.studyID ?? 0,
                                                 postId: self.model?.postID ?? 0)
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
      bookMarkButton,
      titleLabel,
      infoLabel,
      remainLabel,
      enterButton
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    majorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
    }
    
    bookMarkButton.snp.makeConstraints { make in
      make.centerY.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    infoLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    remainLabel.snp.makeConstraints { make in
      make.top.equalTo(infoLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    enterButton.snp.makeConstraints { make in
      make.top.equalTo(remainLabel.snp.bottom).offset(30)
      make.leading.equalTo(majorLabel.snp.leading)
      make.trailing.equalTo(bookMarkButton.snp.trailing)
      make.height.equalTo(47)
    }
    
    backgroundColor = .white
    
    self.layer.borderWidth = 0.1
    self.layer.borderColor = UIColor.cellShadow.cgColor
    self.layer.cornerRadius = 10
  }
  
  private func bind() {
    majorLabel.text = model?.major.convertMajor(model?.major ?? "",
                                                isEnglish: false)
    titleLabel.text =  model?.title
    infoLabel.text = model?.content
    remainLabel.text = "잔여 \(model?.remainingSeat ?? 0)자리"
   
    if model?.close == true {
      enterButton.setTitle("마감되었어요", for: .normal)
      enterButton.layer.borderColor = UIColor.bg40.cgColor
      enterButton.titleLabel?.textColor = .bg60
      enterButton.setTitleColor(.bg60, for: .normal)
      enterButton.isEnabled = false
    }
  }
  
}

