//
//  PostedStudyDetailInfoConponent.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

import SnapKit

final class PostedStudyDetailInfoConponent: UIView, CreateUIprotocol, Convert{
  let postedValues: PostDetailData
  
  private lazy var periodTitleLabel = createLabel(
    title: "기간",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var periodLabel = createLabel(
    title: "기간",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var fineTitleLabel = createLabel(
    title: "벌금",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var fineAmountLabel = createLabel(
    title: "결석비  " + "\(postedValues.penalty)원",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var meetTitleLabel = createLabel(
    title: "대면여부",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var meetLabel = createLabel(
    title: convertStudyWay(wayToStudy: postedValues.studyWay),
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var majorTitleLabel = createLabel(
    title: "관련학과",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = convertMajor(postedValues.major, toEnglish: false)
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.backgroundColor = .bg30
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var majorStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var detailInfoStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var spaceView6 = UIView()
  private lazy var spaceView7 = UIView()
  private lazy var spaceView8 = UIView()
  
  private lazy var periodStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var fineInfoStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var meetStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var periodImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "CalenderImage")
    imageView.contentMode = .left
    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return imageView
  }()
  
  private lazy var meetImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MixMeetImage")
    imageView.contentMode = .left
    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return imageView
  }()
  
  private lazy var smallFineImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MoneyImage")
    imageView.contentMode = .left
    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return imageView
  }()
  
  private lazy var grayDividerLine2 = createDividerLine(height: 8.0)
  
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
    [
      periodImageView,
      periodLabel,
      spaceView6
    ].forEach {
      periodStackView.addArrangedSubview($0)
    }
    
    [
      smallFineImageView,
      fineAmountLabel,
      spaceView7
    ].forEach {
      fineInfoStackView.addArrangedSubview($0)
    }
    
    [
      meetImageView,
      meetLabel,
      spaceView8
    ].forEach {
      meetStackView.addArrangedSubview($0)
    }
    
    majorLabel.backgroundColor = .bg30
    
    let spaceView10 = UIView()
    
    [
      majorLabel,
      spaceView10
    ].forEach {
      majorStackView.addArrangedSubview($0)
    }
    
    [
      periodTitleLabel,
      periodStackView,
      fineTitleLabel,
      fineInfoStackView,
      meetTitleLabel,
      meetStackView,
      majorTitleLabel,
      majorStackView
    ].forEach {
      detailInfoStackView.addArrangedSubview($0)
    }
    
    self.addSubview(detailInfoStackView)
  }
  
  func makeUI(){
    [
      periodStackView,
      fineInfoStackView,
      meetStackView,
      majorStackView
    ].forEach {
      $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
      $0.isLayoutMarginsRelativeArrangement = true
    }
       
    detailInfoStackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    let startDate = postedValues.studyStartDate
    let convertedStartDate = "\(startDate[0]). \(startDate[1]). \(startDate[2])"
    let endDate = postedValues.studyEndDate
    let convertedEndDate = "\(endDate[0]). \(endDate[1]). \(endDate[2])"
    
    periodLabel.text = convertedStartDate + " ~ " + convertedEndDate
  }
}
