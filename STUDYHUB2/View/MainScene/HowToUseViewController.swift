import UIKit

import SnapKit
import Then

final class HowToUseViewController: CommonNavi {

  let loginStatus: Bool
  
  // MARK: - 화면구성
  private let headerContentStackView: UIStackView = {
    let headerContentStackView = UIStackView()
    headerContentStackView.axis = .vertical
    headerContentStackView.spacing = 0
    return headerContentStackView
  }()
  
  private lazy var howToUseImg1 = createImageView("HowToUseImg1")
  private lazy var howToUseImg2 = createImageView("HowToUseImg2")
  private lazy var howToUseImg3 = createImageView("HowToUseImg3")
  private lazy var howToUseImg4 = createImageView("HowToUseImg4")
  private lazy var howToUseImg5 = createImageView("HowToUseImg5")
  private lazy var howToUseImg6 = createImageView("HowToUseImg6")
  private lazy var howToUseImg7 = createImageView("HowToUseImg7")
  private lazy var howToUseImg8 = createImageView("HowToUseImg8")
  
  private lazy var writeButton = StudyHubButton(title: "작성하기")
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()
  
  init(_ loginStatus: Bool) {
    self.loginStatus = loginStatus
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - navigationbar
  func navigationItemSetting() {
    leftButtonSetting()
    settingNavigationTitle(title: "이용방법")
  }
  
  // MARK: - setupLayout
  func setUpLayout(){
    view.backgroundColor = .white
    view.addSubview(scrollView)

    [
      howToUseImg1,
      howToUseImg2,
      howToUseImg3,
      howToUseImg4,
      howToUseImg5,
      howToUseImg6,
      howToUseImg7,
      howToUseImg8,
      writeButton
    ].forEach {
      headerContentStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(headerContentStackView)
  }

  // MARK: - makeui
  func makeUI(){
    headerContentStackView.snp.makeConstraints { make in
      make.top.equalTo(scrollView)
      make.leading.trailing.bottom.equalTo(scrollView)
      make.width.equalTo(scrollView)
    }
    
    howToUseImg1.snp.makeConstraints { make in
      make.height.equalTo(305)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    howToUseImg2.snp.makeConstraints { make in
      make.height.equalTo(650)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    howToUseImg3.snp.makeConstraints { make in
      make.height.equalTo(600)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    howToUseImg4.snp.makeConstraints { make in
      make.height.equalTo(900)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    howToUseImg5.snp.makeConstraints { make in
      make.height.equalTo(300)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    howToUseImg6.snp.makeConstraints { make in
      make.height.equalTo(400)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    howToUseImg7.snp.makeConstraints { make in
      make.height.equalTo(700)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    howToUseImg8.snp.makeConstraints { make in
      make.height.equalTo(250)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
    writeButton.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(howToUseImg8.snp.bottom).offset(40)
      make.leading.equalTo(headerContentStackView).offset(20)
      make.trailing.equalTo(headerContentStackView)
      make.height.equalTo(55)
      make.width.equalTo(400)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.leading.trailing.bottom.equalTo(view)
    }
  }

  func createImageView(_ imageName: String) -> UIImageView{
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }
  
  // MARK: - 작성하기버튼
  @objc func writeButtonTapped() {
    loginStatus ? moveToCreateStudyVC() : showPopupView()
  }
  
  func moveToCreateStudyVC(){
    let createStudyVC = CreateStudyViewController()
    createStudyVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(createStudyVC, animated: true)
  }
 
  func showPopupView(){
    let popupVC = PopupViewController(
      title: "로그인이 필요해요",
      desc: "계속하시려면 로그인을 해주세요!",
      leftButtonTitle: "취소",
      rightButtonTilte: "로그인")
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true) {
        self.dismiss(animated: true)
      }
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
}
