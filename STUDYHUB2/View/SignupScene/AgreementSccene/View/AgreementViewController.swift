//
//  TermsOfServiceViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/24.
//

import UIKit
import SafariServices

import SnapKit

final class AgreementViewController: NaviHelper {
  var checkStatus: Bool = false
 
  let viewModel = AgreementViewModel()
  // MARK: - UI
  private lazy var mainTitleView = AuthTitleView(pageNumber: "1/5",
                                                 pageTitle: "이용약관에 동의해주세요",
                                                 pageContent: "서비스 이용을 위해서 약관 동의가 필요해요")
  
  // 전체동의
  private lazy var agreeAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체동의", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendara-Medium",
                                     size: 16)
    button.backgroundColor = .g100
    button.layer.cornerRadius = 6
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
    button.addAction(UIAction { _ in
      self.agreeAllButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var agreeAllCheckButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    button.addAction(UIAction { _ in
      self.agreeAllButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  // 개별동의 첫 번째
  private lazy var agreeFirstCheckButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    button.addAction(UIAction { _ in
      self.serviceButtonTapped(button: button)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var firstServiceButton: UIButton = {
    let button = UIButton()
    button.setTitle("[필수] 서비스 이용약관 동의", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendara-Medium",
                                     size: 14)
    button.addAction(UIAction { _ in
      self.serviceButtonTapped(button: self.agreeFirstCheckButton)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var goToFirstServicePageButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.addAction(UIAction { _ in
      self.moveToPage(button: self.goToFirstServicePageButton)},
                     for: .touchUpInside)
    return button
  }()
  
  // 개별동의 두 번째
  private lazy var agreeSecondCheckButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    button.addAction(UIAction { _ in
      self.serviceButtonTapped(button: button)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var secondServiceButton: UIButton = {
    let button = UIButton()
    button.setTitle("[필수] 개인정보 수집 및 이용 동의", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendara-Medium",
                                     size: 14)
    button.addAction(UIAction { _ in
      self.serviceButtonTapped(button: self.agreeSecondCheckButton)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var goToSecondServicePageButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.addAction(UIAction { _ in
      self.moveToPage(button: self.goToSecondServicePageButton)},
                     for: .touchUpInside)
    return button
  }()
  
  private lazy var nextButton = StudyHubButton(title: "다음", actionDelegate: self)
  
  // MARK: - viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      mainTitleView,
      agreeAllButton,
      agreeAllCheckButton,
      agreeFirstCheckButton,
      firstServiceButton,
      goToFirstServicePageButton,
      agreeSecondCheckButton,
      secondServiceButton,
      goToSecondServicePageButton,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainTitleView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    agreeAllButton.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(120)
      $0.leading.equalTo(mainTitleView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(56)
    }
    
    agreeAllCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeAllButton.snp.leading).offset(15)
      $0.centerY.equalTo(agreeAllButton)
    }
    
    agreeFirstCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeAllCheckButton.snp.leading)
      $0.top.equalTo(agreeAllCheckButton.snp.bottom).offset(40)
    }
    
    firstServiceButton.snp.makeConstraints {
      $0.leading.equalTo(agreeFirstCheckButton.snp.trailing).offset(10)
      $0.centerY.equalTo(agreeFirstCheckButton)
    }
    
    goToFirstServicePageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(firstServiceButton)
    }
    
    agreeSecondCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeFirstCheckButton.snp.leading)
      $0.top.equalTo(agreeFirstCheckButton.snp.bottom).offset(20)
    }
    
    secondServiceButton.snp.makeConstraints {
      $0.leading.equalTo(agreeSecondCheckButton.snp.trailing).offset(10)
      $0.centerY.equalTo(agreeSecondCheckButton)
    }
    
    goToSecondServicePageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(secondServiceButton)
    }
    
    nextButton.unableButton(true)
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - navigation
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItems = .none
    settingNavigationTitle(title: "회원가입")
  }
  
  override func leftButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  func moveToPage(button: UIButton) {
    let check = button == goToFirstServicePageButton ? viewModel.serviceURL : viewModel.personalURL
    let url = NSURL(string: check.rawValue)
    
    let urlView: SFSafariViewController = SFSafariViewController(url: url as! URL)
    self.present(urlView, animated: true)
  }
  
  // MARK: - 전체동의 버튼
  func agreeAllButtonTapped(){
    let check = agreeAllCheckButton.isSelected ? "ButtonEmpty" : "ButtonChecked"
    [
      agreeAllCheckButton,
      agreeFirstCheckButton,
      agreeSecondCheckButton
    ].forEach {
      $0.setImage(UIImage(named: check), for: .normal)
    }
    
    let nextButtonColor = agreeAllCheckButton.isSelected
    nextButton.unableButton(nextButtonColor)
    
    agreeAllCheckButton.isSelected.toggle()
    checkStatus.toggle()
  }
  
  // MARK: - 버튼 별 터치
  func serviceButtonTapped(button: UIButton) {
    let check = button.isSelected ? "ButtonEmpty" : "ButtonChecked"
    button.setImage(UIImage(named: check), for: .normal)
    button.isSelected.toggle()
    
    checkStatus = agreeFirstCheckButton.isSelected && agreeSecondCheckButton.isSelected
    let allCheckImage = checkStatus ? "ButtonChecked" : "ButtonEmpty"
    agreeAllCheckButton.setImage(UIImage(named: allCheckImage), for: .normal)
    
    if checkStatus {
      nextButton.unableButton(false)
      agreeAllCheckButton.isSelected.toggle()
    } else {
      nextButton.unableButton(true)
    }
  }
}

extension AgreementViewController: StudyHubButtonProtocol{
  // MARK: - 다음버튼, 밑에꺼 하나만 눌러도 넘어감 - 고치자
  func buttonTapped() {
    if checkStatus {
      let signUpVC = SignUpViewController()
      navigationController?.pushViewController(signUpVC, animated: true)
    }
  }
}
