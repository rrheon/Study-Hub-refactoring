//
//  TermsOfServiceViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/24.
//

import UIKit
import SafariServices

import SnapKit
import RxSwift
import RxCocoa
import Then

final class AgreementViewController: CommonNavi {
  let viewModel = AgreementViewModel()
  
  // MARK: - UI
  private lazy var mainTitleView = AuthTitleView(pageNumber: "1/5",
                                                 pageTitle: "이용약관에 동의해주세요",
                                                 pageContent: "서비스 이용을 위해서 약관 동의가 필요해요")
  
  // 전체동의
  private lazy var agreeAllButton = UIButton().then {
    $0.setTitle("전체동의", for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendara-Medium", size: 16)
    $0.backgroundColor = .g100
    $0.layer.cornerRadius = 6
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
  }
  
  private lazy var agreeAllCheckButton = UIButton().then {
    $0.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
  }
  
  // 개별동의 첫 번째
  private lazy var agreeFirstCheckButton = UIButton().then {
    $0.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
  }
  
  private lazy var firstServiceButton = UIButton().then {
    $0.setTitle("[필수] 서비스 이용약관 동의", for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendara-Medium", size: 14)
  }
  
  private lazy var goToFirstServicePageButton = UIButton().then {
    $0.setImage(UIImage(named: "RightArrow"), for: .normal)
  }
  
  // 개별동의 두 번째
  private lazy var agreeSecondCheckButton = UIButton().then {
    $0.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
  }
  
  private lazy var secondServiceButton = UIButton().then {
    $0.setTitle("[필수] 개인정보 수집 및 이용 동의", for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendara-Medium", size: 14)
  }
  
  private lazy var goToSecondServicePageButton = UIButton().then {
    $0.setImage(UIImage(named: "RightArrow"), for: .normal)
  }
  
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  // MARK: - viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationSetting()
    
    setupLayout()
    makeUI()
    
    setupBindings()
    setupActions()
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
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - navigation
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }
  
  override func leftButtonTapped(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  private func setupBindings() {
    viewModel.agreeAllCheckButtonState
      .subscribe(onNext: { [weak self] isSelected in
        self?.setButtonUI(self!.agreeAllCheckButton, status: isSelected)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.agreeFirstCheckButtonState
      .subscribe(onNext: { [weak self] isSelected in
        self?.setButtonUI(self!.agreeFirstCheckButton, status: isSelected)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.agreeSecondCheckButtonState
      .subscribe(onNext: { [weak self] isSelected in
        self?.setButtonUI(self!.agreeSecondCheckButton, status: isSelected)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.nextButtonStatus
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] status in
        self?.setButtonUI(self!.agreeAllCheckButton, status: status)
        self?.nextButton.unableButton(status)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  private func setupActions() {
    agreeAllCheckButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.toggleAllAgreement()
      }
      .disposed(by: viewModel.disposeBag)
    
    agreeFirstCheckButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.toggleAgreement(for: self!.viewModel.agreeFirstCheckButtonState)
      }
      .disposed(by: viewModel.disposeBag)
    
    agreeSecondCheckButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.toggleAgreement(for: self!.viewModel.agreeSecondCheckButtonState)
      }
      .disposed(by: viewModel.disposeBag)
    
    goToFirstServicePageButton.rx.tap
      .bind { [weak self] in
        self?.moveToPage(button: self!.goToFirstServicePageButton)
      }
      .disposed(by: viewModel.disposeBag)
    
    goToSecondServicePageButton.rx.tap
      .bind { [weak self] in
        self?.moveToPage(button: self!.goToSecondServicePageButton)
      }.disposed(by: viewModel.disposeBag)
    
    nextButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .bind { [weak self] in
        let signUpVC = CheckEmailViewController()
        self?.navigationController?.pushViewController(signUpVC, animated: true)
      }
      .disposed(by: viewModel.disposeBag)
  }
  
  func setButtonUI(_ button: UIButton, status: Bool ){
    let image = UIImage(named: status ? "ButtonChecked" : "ButtonEmpty")
    button.setImage(image, for: .normal)
  }
  
  func moveToPage(button: UIButton) {
    let url = button == goToFirstServicePageButton ? viewModel.serviceURL : viewModel.personalURL
    
    if let url = URL(string: url) {
      let urlView = SFSafariViewController(url: url)
      present(urlView, animated: true)
    }
  }
}
