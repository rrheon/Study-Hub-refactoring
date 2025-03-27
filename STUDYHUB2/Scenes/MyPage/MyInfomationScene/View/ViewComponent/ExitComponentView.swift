
import UIKit

import SnapKit
import RxSwift
import RxRelay
import RxCocoa

/// 로그아웃 / 탈퇴 View
final class ExitComponentView: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: MyInfomationViewModel
  
  /// 구분선
  private lazy var dividerLine = StudyHubUI.createDividerLine(height: 10)
  
  /// 로그아웃 버튼
  private lazy var logoutButton = createMypageButton(title: "로그아웃")
  
  /// 탈퇴하기 버튼
  private lazy var quitButton = createMypageButton(title: "탈퇴하기")
  
  init(_ viewModel: MyInfomationViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    setUpLayout()
    makeUI()
    setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// 로그아웃 / 탈퇴하기 버튼 생성
  func createMypageButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setTitleColor(.bg90, for: .normal)
    return button
  }
  
  
  // MARK: - setUpLayout
  
  /// Layout 설정
  func setUpLayout(){
    [dividerLine, logoutButton, quitButton]
      .forEach { self.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  /// UI설정
  func makeUI(){
    dividerLine.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
    
    logoutButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(dividerLine.snp.bottom).offset(30)
    }
    
    quitButton.snp.makeConstraints {
      $0.leading.equalTo(logoutButton)
      $0.top.equalTo(logoutButton.snp.bottom).offset(30)
    }
  }
  
  /// 바인딩설정
  func setupBinding(){
    // 로그아웃 버튼
    logoutButton.rx
      .tap
      .subscribe(onNext: { _ in
        self.viewModel.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .logoutIsRequired)))
      })
      .disposed(by: disposeBag)
    
    // 탈퇴하기 버튼
    quitButton.rx
      .tap
      .subscribe(onNext: { _ in
        self.viewModel.steps.accept(AppStep.auth(.confirmDeleteAccountScreenIsRequired))
      })
      .disposed(by: disposeBag)

  }
}
