
import UIKit

import SnapKit
import RxFlow
import RxRelay
import Then

/// StudyHub - front - CheckRejectReasonScreen
/// - 스터디 거절 사유 자세히 보기 화면

final class DetailRejectReasonViewController: UIViewController, Stepper{
  var steps: PublishRelay<Step> = PublishRelay<Step>()

  /// 거절사유
  private var rejectData: RejectReason?
  
  /// 스터디 제목 라벨
  private lazy var titleLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }

  /// 거절 사유 제목 라벨
  private lazy var rejectTitleLabel = UILabel().then {
    $0.text = "스터디 팀장의 거절 이유예요 😢"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  
  /// 거절 사유 라벨
  lazy var rejectReasonLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    label.text = rejectData?.reason
    label.textColor = .g80
    label.backgroundColor = .bg20
    label.layer.cornerRadius = 10
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  /// 거절 확인버튼
  private lazy var confirmButton = StudyHubButton(title: "확인")
  
  init(rejectData: RejectReason) {
    self.rejectData = rejectData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    makeUI()

    setupNavigationbar()
  }
    
  // MARK: - makeUI
  
  /// UI 설정
  func makeUI(){
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
    
    view.addSubview(rejectTitleLabel)
    rejectTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
    }
    
    view.addSubview(rejectReasonLabel)
    rejectReasonLabel.snp.makeConstraints {
      $0.top.equalTo(rejectTitleLabel.snp.bottom).offset(30)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    view.addSubview(confirmButton)
    confirmButton.addAction(UIAction { _ in
      self.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
    }, for: .touchUpInside)
    confirmButton.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(57)
      $0.bottom.equalToSuperview().offset(-50)
    }
  }
  
  // MARK: - setupNavigationbar

  /// 네비게이션 바 설정
  func setupNavigationbar() {
    settingNavigationTitle(title: "거절 이유")
    leftButtonSetting()
    settingNavigationbar()
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
}
