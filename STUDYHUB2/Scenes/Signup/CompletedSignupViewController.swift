
import UIKit

import SnapKit
import RxFlow
import RxRelay

/// 회원가입 완료 VC
final class CompletedSignupViewController: UIViewController, Stepper {
  var steps: PublishRelay<Step> = PublishRelay()
  
  
  // MARK: - 화면구성
  
  /// 회원가입 축하 이미지
  private lazy var mainImageView: UIImageView = UIImageView(
    image: UIImage(named: "SingupCompleteImage")
  )

  /// 회원가입 축하 문구 이미지
  private lazy var underMainImageView: UIImageView = UIImageView(
    image: UIImage(named: "UnderSingupCompleteImage")
  )
  
  /// 시작하기 버튼 - 로그인 화면으로 이동
  private lazy var startButton = StudyHubButton(title: "시작하기")
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    setUpLayout()
    makeUI()
    
    startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
  } // viewDidLoad
  
  // MARK: - setUpLayout
  
  
  /// layout 설정
  func setUpLayout(){
    [
      mainImageView,
      underMainImageView,
      startButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  /// UI 설정
  func makeUI(){
    mainImageView.backgroundColor = .black
    mainImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.height.width.equalTo(280)
    }
    
    underMainImageView.snp.makeConstraints {
      $0.top.equalTo(mainImageView.snp.bottom).offset(10)
      $0.centerX.equalTo(mainImageView)
    }
    
    startButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
    }
  }
  
  
  /// 시작 버튼 터치 시 화면이동
  @objc func startButtonTapped() {
    steps.accept(SignupStep.dismissIsRequired)
  }
}
