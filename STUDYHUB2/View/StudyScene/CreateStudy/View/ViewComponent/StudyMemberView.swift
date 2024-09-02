//
//  StudyMemberView.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/30/24.
//

import UIKit

import SnapKit

final class StudyMemberView: UIView {

  let viewModel: CreateStudyViewModel
  
  private lazy var studymemberLabel = createLabel(
    title: "스터디 팀원",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  private lazy var studymemberDividerLine = createDividerLine(height: 1)
  
  // MARK: - 인원
  private lazy var studymemberTitleLabel = createLabel(
    title: "인원",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var studyMemberDescibeLabel = createLabel(
    title: "본인 제외 최대 50명",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
    
  private lazy var studymemberTextField = createTextField(title: "스터디 인원을 알려주세요")
  
  private lazy var countLabel = createLabel(
    title: "명",
    textColor: .bg80,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var countAlert = createLabel(
    title: "1명부터 가능해요(본인 제외)",
    textColor: .r50,
    fontType: "Pretendard",
    fontSize: 12
  )
  
  // MARK: - 성별
  private lazy var genderLabel = createLabel(
    title: "성별",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var genderDescribeLabel = createLabel(
    title: "참여자의 성별 선택",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var allGenderButton = createButton(title: "무관")
  private lazy var maleOnlyButton = createButton(title: "남자만")
  private lazy var femaleOnlyButton = createButton(title: "여자만")
  private lazy var genderButtonDividerLine = createDividerLine(height: 8)
 
  init(_ viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      studymemberLabel,
      studymemberDividerLine,
      studymemberTitleLabel,
      studyMemberDescibeLabel,
      studymemberTextField,
      countLabel,
      genderLabel,
      genderDescribeLabel,
      allGenderButton,
      maleOnlyButton,
      femaleOnlyButton,
      genderButtonDividerLine
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    studymemberLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    studymemberDividerLine.snp.makeConstraints {
      $0.top.equalTo(studymemberLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
    
    studymemberTitleLabel.snp.makeConstraints {
      $0.top.equalTo(studymemberDividerLine.snp.bottom).offset(33)
      $0.leading.equalTo(studymemberLabel)
    }
    
    studyMemberDescibeLabel.snp.makeConstraints {
      $0.top.equalTo(studymemberTitleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(studymemberLabel)
    }
    
    studymemberTextField.snp.makeConstraints {
      $0.top.equalTo(studyMemberDescibeLabel.snp.bottom).offset(10)
      $0.leading.equalTo(studymemberLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    countLabel.snp.makeConstraints {
      $0.centerY.equalTo(studymemberTextField)
      $0.trailing.equalTo(studymemberTextField.snp.trailing).offset(-10)
    }
    
    genderLabel.snp.makeConstraints {
      $0.top.equalTo(studymemberTextField.snp.bottom).offset(33)
      $0.leading.equalTo(studymemberLabel)
    }
    
    genderDescribeLabel.snp.makeConstraints {
      $0.top.equalTo(genderLabel.snp.bottom).offset(8)
      $0.leading.equalTo(studymemberLabel)
    }
    
    allGenderButton.snp.makeConstraints {
      $0.top.equalTo(genderDescribeLabel.snp.bottom).offset(11)
      $0.height.equalTo(35)
      $0.width.equalTo(65)
      $0.leading.equalTo(studymemberLabel)
    }
    
    maleOnlyButton.snp.makeConstraints {
      $0.top.equalTo(genderDescribeLabel.snp.bottom).offset(11)
      $0.height.equalTo(35)
      $0.width.equalTo(65)
      $0.leading.equalTo(allGenderButton.snp.trailing).offset(10)
    }
    
    femaleOnlyButton.snp.makeConstraints {
      $0.top.equalTo(genderDescribeLabel.snp.bottom).offset(11)
      $0.height.equalTo(35)
      $0.width.equalTo(65)
      $0.leading.equalTo(maleOnlyButton.snp.trailing).offset(10)
    }
    
    genderButtonDividerLine.snp.makeConstraints {
      $0.top.equalTo(allGenderButton.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
}

extension StudyMemberView: CreateUIprotocol {}
