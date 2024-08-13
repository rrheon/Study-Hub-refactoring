//
//  PostedStudyMainComponent.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

final class PostedStudyMainComponent: UIViewController {

  private lazy var postedDateLabel = createLabel(
    title: "2023-10-31",
    textColor: .g70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var postedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = "세무회계학과"
    label.textColor = .o30
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    label.backgroundColor = .o60
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var postedMajorStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var postedTitleLabel = createLabel(
    title: "전산세무 같이 준비해요",
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
    title: "1" + "/30명",
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
    title: "1000"+"원",
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
    title: "여자",
    textColor: .white,
    fontType: "Pretendard-SemiBold",
    fontSize: 16)
  
  private lazy var genderStackView = createStackView(axis: .vertical, spacing: 8)
  
  private lazy var spaceView4 = UIView()
  private lazy var spaceView5 = UIView()
  
  private lazy var redesignCoreInfoStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var coreInfoStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var topInfoStackView = createStackView(axis: .vertical, spacing: 12)
  private lazy var spaceView = UIView()
}
