//
//  TermsOfServiceViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/24.
//

import UIKit
import SafariServices

import SnapKit

final class TermsOfServiceViewController: NaviHelper {
  var checkStatus: Bool = false
  let personalURL = "https://github.com/study-hub-inu/study-hub-iOS-2/blob/main/STUDYHUB2/Assets.xcassets/InfoImage.imageset/InfoImage.png"
  let serviceURl = "https://github.com/study-hub-inu/study-hub-iOS-2/blob/main/STUDYHUB2/Assets.xcassets/serviceImage.imageset/serviceImage.png"
  
  // MARK: - UI
  private lazy var pageNumberLabel = createLabel(title: "1/5",
                                                 textColor: .g60,
                                                 fontType: "Pretendard-SemiBold",
                                                 fontSize: 18)
  
  private lazy var titleLabel = createLabel(title: "이용약관에 동의해주세요",
                                            textColor: .white,
                                            fontType: "Pretendard-Bold",
                                            fontSize: 20)
  
  private lazy var underTitleLabel = createLabel(title: "서비스 이용을 위해서 약관 동의가 필요해요",
                                                 textColor: .g40,
                                                 fontType: "Pretendard-Medium",
                                                 fontSize: 14)
  
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
  
  // 다음버튼
  private lazy var nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("다음", for: .normal)
    button.setTitleColor(UIColor.g90, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendara-Medium",
                                     size: 14)
    button.layer.cornerRadius = 6
    button.backgroundColor = .o60
    button.addAction(UIAction { _ in
      self.nextButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
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
      pageNumberLabel,
      titleLabel,
      underTitleLabel,
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
    pageNumberLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(pageNumberLabel.snp.bottom).offset(10)
      $0.leading.equalTo(pageNumberLabel.snp.leading)
    }
    
    underTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    agreeAllButton.snp.makeConstraints {
      $0.top.equalTo(underTitleLabel.snp.bottom).offset(20)
      $0.leading.equalTo(underTitleLabel)
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
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - navigation
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItems = .none
    self.navigationItem.title = "회원가입"
    self.navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
  }
  
  override func leftButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  func moveToPage(button: UIButton) {
    let check = button == goToFirstServicePageButton ? serviceURl : personalURL
    let url = NSURL(string: check)
    
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
    
    let nextButtonColor = !agreeAllCheckButton.isSelected ? UIColor.o50 : UIColor.o60
    let nextButtonTextColor = !agreeAllCheckButton.isSelected ? UIColor.white : UIColor.g90
    nextButton.backgroundColor = nextButtonColor
    nextButton.setTitleColor(nextButtonTextColor, for: .normal)
    
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
      nextButton.backgroundColor = .o50
      nextButton.setTitleColor(.white, for: .normal)
      agreeAllCheckButton.isSelected.toggle()
    } else {
      nextButton.backgroundColor = .o60
      nextButton.setTitleColor(.g90, for: .normal)
    }
  }
  
  // MARK: - 다음버튼, 밑에꺼 하나만 눌러도 넘어감 - 고치자
  func nextButtonTapped(){
    if checkStatus {
      let signUpVC = SignUpViewController()
      navigationController?.pushViewController(signUpVC, animated: true)
    }
    
  }
}
