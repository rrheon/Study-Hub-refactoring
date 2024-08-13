//
//  PostedStudyMainComponent.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

final class PostedStudyMainComponent: UIView,
                                      CreateLabel, CreateStackView {
  let postedValues: PostDetailData
  
  private lazy var postedDateLabel = createLabel(
    title: "\(postedValues.createdDate[0]). \(postedValues.createdDate[1]). \(postedValues.createdDate[2])",
    textColor: .g70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var postedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = postedValues.major
    label.textColor = .o30
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    label.backgroundColor = .o60
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var postedMajorStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var postedTitleLabel = createLabel(
    title: postedValues.title,
    textColor: .white,
    fontType: "Pretendard-Bold",
    fontSize: 20
  )
  
  private lazy var postedInfoStackView = createStackView(axis: .vertical, spacing: 10)
  
  private lazy var memeberNumberLabel = createLabel(
    title: "팀원수",
    textColor: .g60,
    fontType: "Pretendard-SemiBold",
    fontSize: 12
  )
  
  private lazy var memberImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MemberNumberImage")
    return imageView
  }()
  
  private lazy var memeberNumberCountLabel = createLabel(
    title: "\(postedValues.studyPerson - postedValues.remainingSeat)" + "/\(postedValues.studyPerson)",
    textColor: .white,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var memberNumberStackView = createStackView(axis: .vertical, spacing: 8)
  
  private lazy var fineLabel = createLabel(
    title: "벌금",
    textColor: .g60,
    fontType: "Pretendard-SemiBold",
    fontSize: 12
  )
  
  private lazy var fineImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MoneyImage")
    return imageView
  }()
  
  private lazy var fineCountLabel = createLabel(
    title: "\(postedValues.penalty)"+"원",
    textColor: .white,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var fineStackView = createStackView(axis: .vertical, spacing: 8)
  private lazy var genderLabel = createLabel(
    title: "성별",
    textColor: .g60,
    fontType: "Pretendard-SemiBold",
    fontSize: 12
  )
  
  private lazy var genderImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "GenderImage")
    return imageView
  }()
  
  private lazy var fixedGenderLabel = createLabel(
    title: "\(postedValues.filteredGender)",
    textColor: .white,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var genderStackView = createStackView(axis: .vertical, spacing: 8)
  
  private lazy var spaceView4 = UIView()
  private lazy var spaceView5 = UIView()
  
  private lazy var redesignCoreInfoStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var coreInfoStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var topInfoStackView = createStackView(axis: .vertical, spacing: 12)
  private lazy var spaceView = UIView()
  
  init(_ postedValues: PostDetailData) {
    self.postedValues = postedValues
    
    super.init()
    
    self.setupLayout()
    self.makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    let spaceView9 = UIView()
    
    [
      postedMajorLabel,
      spaceView9
    ].forEach {
      postedMajorStackView.addArrangedSubview($0)
    }
    
    let spaceViewUnderTitle = UIView()
    
    [
      postedDateLabel,
      postedMajorStackView,
      postedTitleLabel,
      spaceViewUnderTitle
    ].forEach {
      postedInfoStackView.addArrangedSubview($0)
    }
    
    memberNumberStackView.alignment = .center
    
    [
      memeberNumberLabel,
      memberImageView,
      memeberNumberCountLabel
    ].forEach {
      memberNumberStackView.addArrangedSubview($0)
    }
    
    fineStackView.alignment = .center
    
    [
      fineLabel,
      fineImageView,
      fineCountLabel
    ].forEach {
      fineStackView.addArrangedSubview($0)
    }
    
    genderStackView.alignment = .center
    
    [
      genderLabel,
      genderImageView,
      fixedGenderLabel
    ].forEach {
      genderStackView.addArrangedSubview($0)
    }
    
    let spaceView12 = UIView()
    
    [
      memberNumberStackView,
      fineStackView,
      genderStackView,
      spaceView12
    ].forEach {
      coreInfoStackView.addArrangedSubview($0)
    }
    
    [
      spaceView4,
      coreInfoStackView,
      spaceView5
    ].forEach {
      redesignCoreInfoStackView.addArrangedSubview($0)
    }
    
    [
      postedInfoStackView,
      redesignCoreInfoStackView,
      spaceView
    ].forEach {
      topInfoStackView.addArrangedSubview($0)
    }
  }
  
  func makeUI(){
    coreInfoStackView.distribution = .fillProportionally
    coreInfoStackView.backgroundColor = .deepGray
    
    topInfoStackView.backgroundColor = .black
    
    postedMajorLabel.backgroundColor = .postedMajorBackGorund
    
    postedInfoStackView.layoutMargins = UIEdgeInsets(top: 50, left: 10, bottom: 0, right: 0)
    postedInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    coreInfoStackView.spacing = 10
    coreInfoStackView.layer.cornerRadius = 10
    coreInfoStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
    coreInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    redesignCoreInfoStackView.distribution = .fillProportionally
    
    spaceView.snp.makeConstraints { make in
      make.height.equalTo(20)
    }
  }
}
