
import UIKit

import SnapKit

final class ServiceView: UIView {
  let viewModel: MyPageViewModel
  private lazy var bottomButtonStackView = createStackView(axis: .vertical, spacing: 5)
  
  private lazy var notificationButton = createMypageButton(title: "공지사항")
  private lazy var askButton = createMypageButton(title: "문의하기")
  private lazy var howToUseButton = createMypageButton(title: "이용방법")
  private lazy var serviceButton = createMypageButton(title: "서비스 이용약관")
  private lazy var informhandleButton = createMypageButton(title: "개인정보 처리 방침")
  
  func createMypageButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setTitleColor(.bg90, for: .normal)
    return button
  }
  
  init(_ viewModel: MyPageViewModel){
    self.viewModel = viewModel
    super.init(frame: .zero)
    setupLayout()
    makeUI()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      notificationButton,
      askButton,
      howToUseButton,
      serviceButton,
      informhandleButton
    ].forEach {
      bottomButtonStackView.addArrangedSubview($0)
    }
    
    self.addSubview(bottomButtonStackView)
  }
  
  func makeUI(){
    bottomButtonStackView.distribution = .fillProportionally
    bottomButtonStackView.alignment = .leading
    bottomButtonStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func setupActions(){
    let buttonActions: [(UIButton, Service)] = [
      (notificationButton, .notice),
      (askButton, .inquiry),
      (howToUseButton, .howToUse),
      (serviceButton, .termsOfService),
      (informhandleButton, .privacyPolicy)
    ]
    
    buttonActions.forEach { button, activity in
      button.rx.tap
        .subscribe(onNext: { [weak self] in
          self?.viewModel.seletService(activity)
        })
        .disposed(by: viewModel.disposeBag)
    }
  }
}

extension ServiceView: CreateUIprotocol {}
