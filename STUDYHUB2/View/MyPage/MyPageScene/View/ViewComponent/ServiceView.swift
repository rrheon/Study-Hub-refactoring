
import UIKit

import SnapKit

final class ServiceView: UIView {
  
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
  
  init(){
    super.init(frame: .zero)
    setupLayout()
    makeUI()
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
  //  func serviceButtonTapped(){
//    let serviceVC = ServiceUseInfoViewContrller()
//    serviceVC.hidesBottomBarWhenPushed = true
//    self.navigationController?.pushViewController(serviceVC, animated: true)
//  }
//  
//  func informhandleButtonTapped(){
//    let infoVC = PersonalInfoViewController()
//    infoVC.hidesBottomBarWhenPushed = true
//    self.navigationController?.pushViewController(infoVC, animated: true)
//  }
//  
//
//  
//  // MARK: - 문의하기 버튼 탭
//  func inquiryButtonTapped(){
//    let inquiryVC = InquiryViewController()
//    inquiryVC.hidesBottomBarWhenPushed = true
//    navigationController?.pushViewController(inquiryVC, animated: true)
//  }
  
//  // MARK: - 이용방법 버튼 탭
//  func howToUseButtonTapped(){
//    let howtouseVC = HowToUseViewController(viewModel.checkLoginStatus.value)
//    howtouseVC.hidesBottomBarWhenPushed = true
//    navigationController?.pushViewController(howtouseVC, animated: true)
//  }
//  
//  func notificationButtonTapped(){
//    let notificationVC = NotificationViewController()
//    notificationVC.hidesBottomBarWhenPushed = true
//    navigationController?.pushViewController(notificationVC, animated: true)
//  }
}

extension ServiceView: CreateUIprotocol {}
