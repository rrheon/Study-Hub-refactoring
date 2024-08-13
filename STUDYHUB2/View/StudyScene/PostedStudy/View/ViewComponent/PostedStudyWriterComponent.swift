//
//  PostedStudyWriterComponent.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

final class PostedStudyWriterComponent: UIView,
                                        CreateLabel, CreateStackView, CreateDividerLine{
  private lazy var writerLabel = createLabel(
    title: "작성자",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var profileImageStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ProfileAvatar")
    imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    return imageView
  }()
  
  private lazy var writerMajorLabel = createLabel(
    title: "세무회계학과",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var nickNameLabel = createLabel(
    title: "비어있음",
    textColor: .black,
    fontType: "Pretendard-Medium",
    fontSize: 16
  )
  
  private lazy var writerInfoStackView = createStackView(axis: .vertical, spacing: 5)
  
  private lazy var writerInfoWithImageStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var totalWriterInfoStackView = createStackView(axis: .vertical, spacing: 20)
  private lazy var spaceView1 = UIView()
  
  private lazy var grayDividerLine3 = createDividerLine(height: 8.0)
  
  init(){
    super.init(frame: .null)
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    let spaceViewTopUsermajorLabel = UIView()
    let spaceViewUnderNicknameLabel = UIView()
    
    [
      spaceViewTopUsermajorLabel,
      writerMajorLabel,
      nickNameLabel,
      spaceViewUnderNicknameLabel
    ].forEach {
      writerInfoStackView.addArrangedSubview($0)
    }
    
    [
      profileImageView,
      writerInfoStackView,
      spaceView1
    ].forEach {
      writerInfoWithImageStackView.addArrangedSubview($0)
    }
  }
  
  func makeUI(){
    writerInfoWithImageStackView.distribution = .fillProportionally
    
    totalWriterInfoStackView.backgroundColor = .white
    totalWriterInfoStackView.layoutMargins = UIEdgeInsets(
      top: 20,
      left: 20,
      bottom: 20,
      right: 10
    )
    totalWriterInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    spaceView1.snp.makeConstraints { make in
      make.width.equalTo(180)
    }
    
    let spaceView8 = UIView()
    [
      writerLabel,
      writerInfoWithImageStackView,
      spaceView8
    ].forEach {
      totalWriterInfoStackView.addArrangedSubview($0)
    }
  }
}
