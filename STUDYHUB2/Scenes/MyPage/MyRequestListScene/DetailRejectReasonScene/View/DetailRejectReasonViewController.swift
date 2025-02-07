
import UIKit

import SnapKit

final class DetailRejectReasonViewController: CommonNavi {
  
  private var rejectData: RejectReason?
  
  private lazy var titleLabel = createLabel(
    title: rejectData?.studyTitle,
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var rejectTitleLabel = createLabel(
    title: "스터디 팀장의 거절 이유예요 😢",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  lazy var rejectReasonLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    label.text = rejectData?.reason
    label.textColor = .g80
    label.backgroundColor = .bg20
    label.layer.cornerRadius = 10
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var confirmButton = StudyHubButton(title: "확인")
  
  init(rejectData: RejectReason) {
    self.rejectData = rejectData
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupLayout()
    makeUI()

    setupNavigationbar()
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    [
      titleLabel,
      rejectTitleLabel,
      rejectReasonLabel,
      confirmButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
    
    rejectTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
    }
    
    rejectReasonLabel.snp.makeConstraints {
      $0.top.equalTo(rejectTitleLabel.snp.bottom).offset(30)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    confirmButton.addAction(UIAction { _ in
      self.navigationController?.popViewController(animated: true)
    }, for: .touchUpInside)
    confirmButton.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(57)
      $0.bottom.equalToSuperview().offset(-50)
    }
  }
  
  // MARK: - setupNavigationbar

  
  func setupNavigationbar() {
    settingNavigationTitle(title: "거절 이유")
    leftButtonSetting()
  }
}

extension DetailRejectReasonViewController: CreateUIprotocol {}
