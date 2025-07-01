//
//  TermsOfServiceViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxFlow


/// StudyHub - front - SignupScreen - 01
/// - 약관 동의 화면
final class AgreementViewController: UIViewController, Stepper {
  let disposeBag: DisposeBag = DisposeBag()
  var viewModel: AgreementViewModel
  var steps: PublishRelay<Step> = PublishRelay<Step>()

  
  // MARK: - UI
  
  private let customView: AgreementView = AgreementView()
  
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
    
    setupBindings()
    setupActions()
  } // viewDidLoad
    

  override func loadView() {
    self.view = customView
  }
  
  // MARK: - navigation
  
  /// 네비게이션 바 설정
  func navigationSetting() {
    settingNavigationTitle(title: NavigationTitle.signup)
    leftButtonSetting()
    settingNavigationbar()
  }
  
  /// 네비게이션 바 왼쪽 버튼 액션
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    steps.accept(SignupStep.dismissIsRequired)
  }
  
  
  /// 바인딩
  private func setupBindings() {
    let input = AgreementViewModel.Input(
      agreeAllCheckBtnTapped: customView.agreeAllCheckButton.rx.tap.asObservable(),
      agreeServiceCheckBtnTapped: customView.agreeFirstCheckButton.rx.tap.asObservable(),
      agreeInfoCheckBtnTapped: customView.agreeSecondCheckButton.rx.tap.asObservable(),
      moveToServicePageTapped: customView.goToFirstServicePageButton.rx.tap.asObservable(),
      moveToInfoPageTapped: customView.goToSecondServicePageButton.rx.tap.asObservable(),
      moveToNextPageTapped: customView.nextButton.rx.tap.asObservable()
    )
    
    let output = viewModel.transform(input: input)
    
    // 전체 동의
    output.agreeAllBtnStatus
      .bind(to: customView.agreeAllCheckButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    // 서비스 이용약관
    output.agreeServiceBtnStatus
      .bind(to: customView.agreeFirstCheckButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    // 개인정보 동의
    output.agreeInfoBtnStatus
      .bind(to: customView.agreeSecondCheckButton.rx.isSelected)
      .disposed(by: disposeBag)
  
    // 개인정보약관 페이지
    output.personalInfoPageUrl
      .subscribe(onNext: { url in
        self.steps.accept(SignupStep.safariIsRequired(url: url))
      })
      .disposed(by: disposeBag)
    
    // 서비스 이용약관 페이지
    output.servicePageUrl
      .subscribe(onNext: { url in
        self.steps.accept(SignupStep.safariIsRequired(url: url))
      })
      .disposed(by: disposeBag)
    
    // 다음버튼 활성화 여부
    output.isNextBtnActivate
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { vc, isActive in
        vc.customView.nextButton.unableButton(isActive)
      }
      .disposed(by: disposeBag)

  }
  
  /// Actions 설정
  private func setupActions() {
    
    // 다음버튼
    customView.nextButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .bind { vc, _ in
        vc.steps.accept(SignupStep.enterEmailScreenIsRequired)
      }
      .disposed(by: disposeBag)
  }

}
