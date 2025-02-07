
import UIKit

import SnapKit

final class ConfirmDeleteViewController: CommonNavi {
  private lazy var titleLabel = createLabel(
    title: "정말 탈퇴하시나요?\n회원님이 떠나신다니 너무 아쉬워요😢",
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 20
  )
  private lazy var mainView: UIView = {
    let view = UIView()
    view.backgroundColor = .bg20
    view.layer.borderColor = UIColor.bg40.cgColor
    return view
  }()
  
  private lazy var infoTitleLabel = createLabel(
    title: "스터디 허브를 탈퇴하시면,",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var infoDescriptionLabel1: UILabel = {
    let label = UILabel()
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.numberOfLines = 0
    label.text = "해당 계정으로 활동하신 모든 내역과 개인정보가 삭제되어 복구가 어려워요."
    return label
  }()
  
  private lazy var infoDescriptionLabel2: UILabel = {
    let label = UILabel()
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.numberOfLines = 0
    label.text = """
          스터디에 참여한 참여자들의 정보를 다시 볼 수 없어요.
          맞춤 스터디 소식을 알려드릴 수 없어요.
          재가입 시, 다시 처음부터 계정 인증을 받아야 해요.
          """
    label.setLineSpacing(spacing: 40)

    return label
  }()
  
  private lazy var buttonStackView = createStackView(axis: .horizontal, spacing: 8)
  
  private lazy var continueButton: UIButton = {
    let button = UIButton()
    button.setTitle("계속", for: .normal)
    button.setTitleColor(.bg80, for: .normal)
    button.backgroundColor = .bg30
    button.layer.cornerRadius = 10
    return button
  }()
  
  private lazy var cancelButton = StudyHubButton(title: "취소")
  
  // MARK: - setupLayout
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    setupLayout()
    makeUI()
    
    settingNavigationBar()
    setupButtonActions()
  }

  func settingNavigationBar(){
    leftButtonSetting()
    
    settingNavigationTitle(title: "탈퇴하기")
  }
  
  func setupLayout(){
    buttonStackView.addArrangedSubview(continueButton)
    buttonStackView.addArrangedSubview(cancelButton)
    
    [
      titleLabel,
      mainView,
      infoTitleLabel,
      infoDescriptionLabel1,
      infoDescriptionLabel2,
      buttonStackView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    titleLabel.numberOfLines = 2
    titleLabel.changeColor(
      wantToChange: "회원님이 떠나신다니 너무 아쉬워요😢",
      color: .bg80,
      font: UIFont(name: "Pretendard", size: 14),
      lineSpacing: 13
    )
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
    
    mainView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(300)
    }
    
    infoTitleLabel.snp.makeConstraints {
      $0.top.equalTo(mainView.snp.top).offset(30)
      $0.leading.equalTo(mainView.snp.leading).offset(20)
      $0.trailing.equalTo(mainView.snp.trailing).offset(-20)
    }
    
    infoDescriptionLabel1.snp.makeConstraints {
      $0.top.equalTo(infoTitleLabel.snp.bottom).offset(35)
      $0.leading.equalTo(infoTitleLabel.snp.leading)
      $0.trailing.equalTo(mainView.snp.trailing).offset(-30)
    }
    
    infoDescriptionLabel2.snp.makeConstraints {
      $0.top.equalTo(infoDescriptionLabel1.snp.bottom).offset(35)
      $0.leading.equalTo(infoTitleLabel.snp.leading)
      $0.trailing.equalTo(mainView.snp.trailing).offset(-20)
    }
    
    buttonStackView.distribution = .fillEqually
    buttonStackView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-60)
      $0.leading.equalTo(mainView.snp.leading)
      $0.trailing.equalTo(mainView.snp.trailing)
      $0.height.equalTo(55)
    }
  }
  
  func setupButtonActions(){
    continueButton.addAction(UIAction { _ in
      self.moveToOtherVCWithSameNavi(vc: DeleteAccountViewController(), hideTabbar: true)
    }, for: .touchUpInside)
    
    cancelButton.addAction(UIAction { _ in
      self.navigationController?.popViewController(animated: true)
    }, for: .touchUpInside)
  }
}

extension ConfirmDeleteViewController: CreateUIprotocol {}
