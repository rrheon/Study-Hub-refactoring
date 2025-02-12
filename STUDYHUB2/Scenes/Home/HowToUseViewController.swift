
import UIKit

import RxFlow
import RxRelay
import SnapKit
import Then

/// 이용방법 VC
final class HowToUseViewController: UIViewController, Stepper {
  var steps: PublishRelay<Step>
  
  let loginStatus: Bool
  
  // MARK: - 화면구성
  
  /// 이용방법 이미지를 담을 스택뷰
  private let totalStackView: UIStackView = UIStackView().then{
    $0.axis = .vertical
    $0.spacing = 0
    $0.alignment = .fill
    $0.distribution = .fillProportionally
  }
  
  /// 이용방법 이미지
  private lazy var howToUseImg1 = createImageView("HowToUseImg1")
  private lazy var howToUseImg2 = createImageView("HowToUseImg2")
  private lazy var howToUseImg3 = createImageView("HowToUseImg3")
  private lazy var howToUseImg4 = createImageView("HowToUseImg4")
  private lazy var howToUseImg5 = createImageView("HowToUseImg5")
  private lazy var howToUseImg6 = createImageView("HowToUseImg6")
  private lazy var howToUseImg7 = createImageView("HowToUseImg7")
  private lazy var howToUseImg8 = createImageView("HowToUseImg8")
  
  /// 게시글 작성하기 버튼
  private lazy var writeButton = StudyHubButton(title: "작성하기")
  
  private let scrollView: UIScrollView = UIScrollView()
  
  init(_ loginStatus: Bool) {
    self.loginStatus = loginStatus
    self.steps = PublishRelay<Step>()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewdidload
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    
    setupNavigationbar()
    
    setUpLayout()
    makeUI()
    
    writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
  } // viewDidLoad
  
  // MARK: - navigationbar
  
  /// 네비게이션 바 세팅
  func setupNavigationbar() {
    leftButtonSetting()
    settingNavigationTitle(title: "이용방법")

    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  /// 네비게이션 바 왼쪽 탭 - 현재 화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    steps.accept(AppStep.popCurrentScreen)
  }
  
  // MARK: - setupLayout
  
  /// layout 설정
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
      totalStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(totalStackView)
  }

  // MARK: - makeUI
  
  /// Ui 설정
  func makeUI(){
    /// 전체 스택뷰
    totalStackView.snp.makeConstraints {
      $0.top.equalTo(scrollView)
      $0.bottom.equalTo(scrollView.contentLayoutGuide)
      $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
    }
    
    /// 이미지1
    howToUseImg1.snp.makeConstraints { make in
      make.height.equalTo(305)
    }

    /// 작성하기 버튼
    writeButton.snp.makeConstraints { make in
      make.height.equalTo(55)
    }
    
    /// 스크롤 뷰
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  /// 이용방법 이미지 생성하기
  func createImageView(_ imageName: String) -> UIImageView{
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }
  
  // MARK: - 작성하기버튼
  
  /// 작성하기 버튼 탭
  @objc func writeButtonTapped() {
    loginStatus ? moveToCreateStudyVC() : showPopupView()
  }
  
  func moveToCreateStudyVC(){
    let createStudyVC = CreateStudyViewController(mode: .POST)
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
