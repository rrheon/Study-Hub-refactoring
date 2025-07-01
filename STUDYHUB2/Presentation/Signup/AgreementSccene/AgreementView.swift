//
//  AgreementView.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/25/25.
//

import UIKit

import SnapKit
import Then


/// 약관동의화면의 View
final class AgreementView: UIView {
  // MARK: - UI
  
  /// main 타이틀 View
  private lazy var mainTitleView = AuthTitleView(
    pageNumber: LabelTitle.pageNum1,
    pageTitle: LabelTitle.agreementTitle,
    pageContent: LabelTitle.agreementInfo
  )
  
  /// 전체동의 버튼
  lazy var agreeAllButton = UIButton().then {
    $0.setTitle(BtnTitle.allAgreement, for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: FontSystem.medium.value, size: 16)
    $0.backgroundColor = .g100
    $0.layer.cornerRadius = 6
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -210, bottom: 0, right: 0)
  }
  
  
  /// 전체동의 버튼
  lazy var agreeAllCheckButton = UIButton().then {
    $0.setImage(UIImage(named: ButtonImages.emptyBtnImage), for: .normal)
    $0.setImage(UIImage(named: ButtonImages.checkedBtnImage), for: .selected)
  }
  
  /// 개별동의 첫 번째
  lazy var agreeFirstCheckButton = UIButton().then {
    $0.setImage(UIImage(named: ButtonImages.emptyBtnImage), for: .normal)
    $0.setImage(UIImage(named: ButtonImages.checkedBtnImage), for: .selected)
  }
  
  lazy var firstServiceButton = UIButton().then {
    $0.setTitle(BtnTitle.serviceAgreement, for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: FontSystem.medium.value, size: 14)
  }
  
  lazy var goToFirstServicePageButton = UIButton().then {
    $0.setImage(UIImage(named: ButtonImages.rightArrow), for: .normal)
  }
  
  // 개별동의 두 번째
  lazy var agreeSecondCheckButton = UIButton().then {
    $0.setImage(UIImage(named: ButtonImages.emptyBtnImage), for: .normal)
    $0.setImage(UIImage(named: ButtonImages.checkedBtnImage), for: .selected)
  }
  
  lazy var secondServiceButton = UIButton().then {
    $0.setTitle(BtnTitle.personalInfoAgreement, for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: FontSystem.medium.value, size: 14)
  }
  
  lazy var goToSecondServicePageButton = UIButton().then {
    $0.setImage(UIImage(named: ButtonImages.rightArrow), for: .normal)
  }
  
  /// 다음버튼
  lazy var nextButton = StudyHubButton(title: BtnTitle.next)

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - makeUI
  
  
  /// UI설정
  func makeUI(){
    // 인증 Flow customView
    self.addSubview(mainTitleView)
    mainTitleView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    // 전체동의 버튼
    self.addSubview(agreeAllButton)
    agreeAllButton.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(120)
      $0.leading.equalTo(mainTitleView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(56)
    }
    
    // 전체동의 버튼
    self.addSubview(agreeAllCheckButton)
    agreeAllCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeAllButton.snp.leading).offset(15)
      $0.centerY.equalTo(agreeAllButton)
      $0.height.width.equalTo(24)
    }
    
    // 서비스 이용약관동의 버튼
    self.addSubview(agreeFirstCheckButton)
    agreeFirstCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeAllCheckButton.snp.leading)
      $0.top.equalTo(agreeAllCheckButton.snp.bottom).offset(40)
      $0.height.width.equalTo(24)
    }
    
    // 서비스 이용약관동의 버튼
    self.addSubview(firstServiceButton)
    firstServiceButton.snp.makeConstraints {
      $0.leading.equalTo(agreeFirstCheckButton.snp.trailing).offset(10)
      $0.centerY.equalTo(agreeFirstCheckButton)
    }
    
    // 서비스 이용약관동의 페이지 이동 버튼
    self.addSubview(goToFirstServicePageButton)
    goToFirstServicePageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(firstServiceButton)
    }
    
    // 개인정보 수집 및 이용동의 버튼
    self.addSubview(agreeSecondCheckButton)
    agreeSecondCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeFirstCheckButton.snp.leading)
      $0.top.equalTo(agreeFirstCheckButton.snp.bottom).offset(20)
      $0.height.width.equalTo(24)
    }
    
    // 개인정보 수집 및 이용동의 버튼
    self.addSubview(secondServiceButton)
    secondServiceButton.snp.makeConstraints {
      $0.leading.equalTo(agreeSecondCheckButton.snp.trailing).offset(10)
      $0.centerY.equalTo(agreeSecondCheckButton)
    }
    
    // 개인정보 수집 및 이용동의 페이지 버튼
    self.addSubview(goToSecondServicePageButton)
    goToSecondServicePageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(secondServiceButton)
    }
    
    // 다음화면 이동버튼
    self.addSubview(nextButton)
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
}
