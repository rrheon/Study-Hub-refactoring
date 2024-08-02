
import UIKit

import SnapKit

final class CompleteViewController: UIViewController {
  
  // MARK: - 화면구성
  private lazy var mainImageView: UIImageView = UIImageView(
    image: UIImage(named: "SingupCompleteImage"))

  private lazy var underMainImageView: UIImageView = UIImageView(
    image: UIImage(named: "UnderSingupCompleteImage"))
  
  private lazy var startButton = StudyHubButton(title: "시작하기", actionDelegate: self)
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
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
  func makeUI(){
    mainImageView.backgroundColor = .black
    mainImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(150)
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
  
  // MARK: - 함수
  @objc func startButtonTapped() {
    let ViewController = LoginViewController()
    
    let navigationController = UINavigationController(rootViewController: ViewController)
    navigationController.modalPresentationStyle = .fullScreen
    
    present(navigationController, animated: true, completion: nil)
  }
}

extension CompleteViewController: StudyHubButtonProtocol {
  func buttonTapped() {
    startButtonTapped()
  }
}
