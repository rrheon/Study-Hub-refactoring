
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
    settingNavigationbar()
    
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  /// 네비게이션 바 왼쪽 탭 - 현재 화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    steps.accept(AppStep.popCurrentScreen(navigationbarHidden: true, animate: true))
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
      howToUseImg8
    ].forEach {
      totalStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(totalStackView)
    scrollView.addSubview(writeButton)
  }

  // MARK: - makeUI
  
  func makeUI() {
    /// 스크롤 뷰
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    /// 전체 스택뷰 (스크롤 가능한 영역)
    totalStackView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    /// 이미지1
    howToUseImg1.snp.makeConstraints { make in
      make.height.equalTo(305)
    }
    
    /// 작성하기 버튼
    writeButton.snp.makeConstraints { make in
      make.top.equalTo(totalStackView.snp.bottom).offset(-40)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.height.equalTo(55)
    }
  }

  /// 이용방법 이미지 생성하기
  func createImageView(_ imageName: String) -> UIImageView{
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }
  
  // MARK: - 작성하기버튼
  
  /// 작성하기 버튼 탭
  @objc func writeButtonTapped() {
    // 로그인이 된 경우 스터디 생성 화면 띄우기
    if loginStatus {
      steps.accept(AppStep.studyFormScreenIsRequired(data: nil))
      // 비로그인의 경우 로그인 화면으로 이동
    }else {
      steps.accept(AppStep.popupScreenIsRequired(popupCase: .requireLogin))
    }
  }
}

// MARK: - popupView Delegate


extension HowToUseViewController: PopupViewDelegate {
  // 로그인 화면으로 이동
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
  }
}
