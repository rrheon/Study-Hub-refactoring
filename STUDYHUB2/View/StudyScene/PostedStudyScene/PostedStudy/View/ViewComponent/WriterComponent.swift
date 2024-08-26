//
//  PostedStudyWriterComponent.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

import SnapKit

final class PostedStudyWriterComponent: UIView, CreateUIprotocol, ConvertMajor{
  
  let postedValues: PostDetailData
  
  private lazy var writerLabel = createLabel(
    title: "작성자",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var profileImageStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ProfileAvatar_change")
    imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    return imageView
  }()
  
  private lazy var writerMajorLabel = createLabel(
    title: convertMajor(postedValues.postedUser.major, toEnglish: false) ?? "비어있음",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var nickNameLabel = createLabel(
    title: postedValues.postedUser.nickname,
    textColor: .black,
    fontType: "Pretendard-Medium",
    fontSize: 16
  )
  
  private lazy var writerInfoStackView = createStackView(axis: .vertical, spacing: 5)
  
  private lazy var writerInfoWithImageStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var totalWriterInfoStackView = createStackView(axis: .vertical, spacing: 20)
  private lazy var spaceView1 = UIView()
  
  private lazy var grayDividerLine3 = createDividerLine(height: 8.0)
  
  init(_ postedValues: PostDetailData) {
    self.postedValues = postedValues
    
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
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
    
    [
      writerLabel,
      writerInfoWithImageStackView
    ].forEach {
      totalWriterInfoStackView.addArrangedSubview($0)
    }
    
    self.addSubview(totalWriterInfoStackView)
  }
  
  func makeUI(){
    writerInfoWithImageStackView.distribution = .fillProportionally
    
    profileImageView.snp.makeConstraints {
      $0.height.width.equalTo(50)
    }
        
    totalWriterInfoStackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
}
