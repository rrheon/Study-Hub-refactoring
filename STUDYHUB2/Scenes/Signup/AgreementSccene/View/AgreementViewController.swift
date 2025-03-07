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


/// 회원가입 - 1. 이용약관 동의 VC
final class AgreementViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  var viewModel: AgreementViewModel
  
  // MARK: - UI
  
  /// main 타이틀 View
  private lazy var mainTitleView = AuthTitleView(
    pageNumber: "1/5",
    pageTitle: "이용약관에 동의해주세요",
    pageContent: "서비스 이용을 위해서 약관 동의가 필요해요"
  )
  
  /// 전체동의 버튼
  private lazy var agreeAllButton = UIButton().then {
    $0.setTitle("전체동의", for: .normal)
    $0.setTitleColor(UIColor.white, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendara-Medium", size: 16)
    $0.backgroundColor = .g100
    $0.layer.cornerRadius = 6
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
  }
  
  
  /// 전체동의 버튼
  private lazy var agreeAllCheckButton = UIButton().then {
    $0.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
  }
  
  /// 개별동의 첫 번째
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
  
  /// 다음버튼
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  init(with viewModel: AgreementViewModel) {
    self.viewModel = AgreementViewModel()
    super.init(nibName: .none, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewdidload
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationSetting()
    
    makeUI()
    
    setupBindings()
    setupActions()
  } // viewDidLoad
  
  
  // MARK: - makeUI
  
  
  /// UI설정
  func makeUI(){
    // 인증 Flow customView
    view.addSubview(mainTitleView)
    mainTitleView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    // 전체동의 버튼
    view.addSubview(agreeAllButton)
    agreeAllButton.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(120)
      $0.leading.equalTo(mainTitleView)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(56)
    }
    
    // 전체동의 버튼
    view.addSubview(agreeAllCheckButton)
    agreeAllCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeAllButton.snp.leading).offset(15)
      $0.centerY.equalTo(agreeAllButton)
      $0.height.width.equalTo(24)
    }
    
    // 서비스 이용약관동의 버튼
    view.addSubview(agreeFirstCheckButton)
    agreeFirstCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeAllCheckButton.snp.leading)
      $0.top.equalTo(agreeAllCheckButton.snp.bottom).offset(40)
      $0.height.width.equalTo(24)
    }
    
    // 서비스 이용약관동의 버튼
    view.addSubview(firstServiceButton)
    firstServiceButton.snp.makeConstraints {
      $0.leading.equalTo(agreeFirstCheckButton.snp.trailing).offset(10)
      $0.centerY.equalTo(agreeFirstCheckButton)
    }
    
    // 서비스 이용약관동의 페이지 이동 버튼
    view.addSubview(goToFirstServicePageButton)
    goToFirstServicePageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(firstServiceButton)
    }
    
    // 개인정보 수집 및 이용동의 버튼
    view.addSubview(agreeSecondCheckButton)
    agreeSecondCheckButton.snp.makeConstraints {
      $0.leading.equalTo(agreeFirstCheckButton.snp.leading)
      $0.top.equalTo(agreeFirstCheckButton.snp.bottom).offset(20)
      $0.height.width.equalTo(24)
    }
    
    // 개인정보 수집 및 이용동의 버튼
    view.addSubview(secondServiceButton)
    secondServiceButton.snp.makeConstraints {
      $0.leading.equalTo(agreeSecondCheckButton.snp.trailing).offset(10)
      $0.centerY.equalTo(agreeSecondCheckButton)
    }
    
    // 개인정보 수집 및 이용동의 페이지 버튼
    view.addSubview(goToSecondServicePageButton)
    goToSecondServicePageButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(secondServiceButton)
    }
    
    // 다음화면 이동버튼
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - navigation
  
  /// 네비게이션 바 설정
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
    settingNavigationbar()
  }
  
  /// 네비게이션 바 왼쪽 버튼 액션
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(SignupStep.dismissIsRequired)
  }
  
  
  /// 바인딩
  private func setupBindings() {
    // 모든 동의사항 체크여부
    viewModel.agreeAllCheckButtonState
      .withUnretained(self)
      .subscribe(onNext: { vc, isSelected in
        vc.setButtonUI(vc.agreeAllCheckButton, status: isSelected)
      })
      .disposed(by: disposeBag)
    
    // 첫번째 동의사항 체크여부
    viewModel.agreeFirstCheckButtonState
      .withUnretained(self)
      .subscribe(onNext: { vc, isSelected in
        vc.setButtonUI(vc.agreeFirstCheckButton, status: isSelected)
      })
      .disposed(by: disposeBag)
    
    // 두 번째 동의사항 체크여부
    viewModel.agreeSecondCheckButtonState
      .withUnretained(self)
      .subscribe(onNext: { vc, isSelected in
        vc.setButtonUI(vc.agreeSecondCheckButton, status: isSelected)
      })
      .disposed(by: disposeBag)
    
    // 다음 버튼 활성화 여부
    viewModel.nextButtonStatus
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: { vc, status in
        vc.setButtonUI(vc.agreeAllCheckButton, status: status)
        vc.nextButton.unableButton(status)
      })
      .disposed(by: disposeBag)

  }
  
  /// Actions 설정
  private func setupActions() {
    // 모든 동의사항 버튼
    agreeAllCheckButton.rx.tap
      .withUnretained(self)
      .bind { vc , _  in
        vc.viewModel.toggleAllAgreement()
      }
      .disposed(by: disposeBag)
    
    // 첫 번째 동의 버튼
    agreeFirstCheckButton.rx.tap
      .withUnretained(self)
      .bind { vc, _ in
        vc.viewModel.toggleAgreement()
      }
      .disposed(by: disposeBag)
    
    // 두 번째 동의 버튼
    agreeSecondCheckButton.rx.tap
      .withUnretained(self)
      .bind { vc, _ in
        vc.viewModel.toggleAgreement(for: false)
      }
      .disposed(by: disposeBag)
    
    // 서비스 이용약관 페에지로 이동 버튼
    goToFirstServicePageButton.rx.tap
      .withUnretained(self)
      .bind { vc, _ in
        guard let url: URL = URL(string: vc.viewModel.serviceURL) else { return }
        
        vc.viewModel.steps.accept(SignupStep.safariIsRequired(url: url))
      }
      .disposed(by: disposeBag)
    
    // 개인정보 수집 및 이용동의 이동 버튼
    goToSecondServicePageButton.rx.tap
      .withUnretained(self)
      .bind { vc, _ in
        guard let url: URL = URL(string: vc.viewModel.personalURL) else { return }
        
        vc.viewModel.steps.accept(SignupStep.safariIsRequired(url: url))
        
      }.disposed(by: disposeBag)
    
    // 다음버튼
    nextButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .bind { vc, _ in
        self.viewModel.steps.accept(SignupStep.enterEmailScreenIsRequired)
      }
      .disposed(by: disposeBag)

  }
  
  
  /// 체크버튼 셋팅
  /// - Parameters:
  ///   - button: 동의 버튼 들
  ///   - status: 상태
  func setButtonUI(_ button: UIButton, status: Bool ){
    let image = UIImage(named: status ? "ButtonChecked" : "ButtonEmpty")
    button.setImage(image, for: .normal)
  }
}
