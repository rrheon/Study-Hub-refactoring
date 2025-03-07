
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 서비스 View - 공지사항, 문의하기, 이용방법, 서비스 이용약관, 개인정보 처리방침
final class ServiceView: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: MyPageViewModel
  
  /// 전체 StackView
  private lazy var bottomButtonStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 5)
  
  /// 공지사항 버튼
  private lazy var notificationButton = createMypageButton(title: "공지사항")
  
  /// 문의하기 버튼
  private lazy var askButton = createMypageButton(title: "문의하기")
  
  /// 이용방법 버튼
  private lazy var howToUseButton = createMypageButton(title: "이용방법")
  
  /// 서비스 이용약관 버튼
  private lazy var serviceButton = createMypageButton(title: "서비스 이용약관")
  
  /// 개인정보 처리 방침 버튼
  private lazy var informhandleButton = createMypageButton(title: "개인정보 처리 방침")
  
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
  
  /// layout 설정
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

  /// UI 설정
  func makeUI(){
    bottomButtonStackView.distribution = .fillProportionally
    bottomButtonStackView.alignment = .leading
    bottomButtonStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  /// Mypage의 서비스 버튼 생성
  func createMypageButton(title: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setTitleColor(.bg90, for: .normal)
    return button
  }
  
  /// Actions 설정
  func setupActions(){
    // 공지사항버튼 탭
    notificationButton.rx
      .tap
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: .navToNoticeScreen, object: nil)
      })
      .disposed(by: disposeBag)
    
    // 문의하기 버튼 탭
    askButton.rx
      .tap
      .subscribe(onNext: { _ in
      NotificationCenter.default.post(name: .navToInquiryScreen, object: nil)
    })
    .disposed(by: disposeBag)
    
    // 이용방법 버튼 탭
    howToUseButton.rx
      .tap
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: .navToHowToUseScreen, object: nil)
      })
      .disposed(by: disposeBag)
    
    // 서비스이용약관 탭
    serviceButton.rx
      .tap
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: .navToSafariScreen,
                                        object: nil,
                                        userInfo: ["url" : self.viewModel.serviceURL])
      })
      .disposed(by: disposeBag)

    // 개인정보처리방침 탭
    informhandleButton.rx
      .tap
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: .navToSafariScreen,
                                        object: nil,
                                        userInfo: ["url" : self.viewModel.personalURL])
      })
      .disposed(by: disposeBag)
  }
}

