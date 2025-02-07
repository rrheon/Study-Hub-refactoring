
import UIKit

import SnapKit
import RxSwift
import RxRelay

final class ExitComponent: UIView {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: MyInfomationViewModel
  
  private lazy var dividerLine = createDividerLine(height: 10)
  private lazy var logoutButton = createMypageButton(title: "로그아웃")
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
  
  func createMypageButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setTitleColor(.bg90, for: .normal)
    return button
  }
  
  
  // MARK: - setUpLayout
  
  
  func setUpLayout(){
    [
      dividerLine,
      logoutButton,
      quitButton
    ].forEach {
      self.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
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
  
  func setupBinding(){
    let buttonList: [(UIButton, EditInfomationList)] = [
      (logoutButton, .logout),
      (quitButton, .deleteAccount)
    ]
    
    buttonList.forEach { button , action in
      button.rx.tap
        .subscribe(onNext: {[weak self] in
          self?.viewModel.editButtonTapped.accept(action)
        })
        .disposed(by: disposeBag)
    }
  }
}

extension ExitComponent: CreateDividerLine {}
