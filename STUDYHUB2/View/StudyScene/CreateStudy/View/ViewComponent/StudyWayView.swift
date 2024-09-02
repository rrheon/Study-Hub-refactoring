import UIKit
import SnapKit

final class StudyWayView: UIView {

  let viewModel: CreateStudyViewModel
  
  private lazy var studymethodLabel = createLabel(
    title: "스터디 방식",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var studyMethodDivierLine = createDividerLine(height: 1)
  
  // MARK: - 대면 여부
  private lazy var meetLabel = createLabel(
    title: "대면 여부",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var meetDescribeLabel = createLabel(
    title: "대면이나 혼합일 경우, 관련 내용에 대한 계획을 소개에 적어주세요",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var contactButton = createButton(title: "대면")
  private lazy var untactButton = createButton(title: "비대면")
  private lazy var mixmeetButton = createButton(title: "혼합")
  
  // MARK: - 벌금
  private lazy var fineLabel = createLabel(
    title: "벌금",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var haveFineButton = createFineButton()

  private lazy var haveFineLabel = createLabel(
    title: "있어요",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var noFineButton = createFineButton()

  private lazy var noFineLabel = createLabel(
    title: "없어요",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var fineDividerLine = createDividerLine(height: 8)
  
  // MARK: - 벌금 있을 때
  private lazy var fineTypeLabel = createLabel(
    title: "어떤 벌금인가요?",
    textColor: .bg90,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var fineTypesTextField = createTextField(title: "지각비, 결석비 등")

  private lazy var fineAmountLabel = createLabel(
    title: "얼마인가요?",
    textColor: .bg90,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var fineAmountTextField = createTextField(title: "금액을 알려주세요")
  
  private lazy var fineAmountCountLabel = createLabel(
    title: "원",
    textColor: .bg80,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var maxFineLabel = createLabel(
    title: "최대 99,999원",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  init(_ viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    self.setupLayout()
    self.makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      studymethodLabel,
      studyMethodDivierLine,
      meetLabel,
      meetDescribeLabel,
      mixmeetButton,
      contactButton,
      untactButton,
      fineLabel,
      haveFineButton,
      haveFineLabel,
      noFineButton,
      noFineLabel,
      fineDividerLine,
      fineTypeLabel,
      fineTypesTextField,
      fineAmountLabel,
      fineAmountTextField,
      fineAmountCountLabel,
      maxFineLabel
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    studymethodLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    studyMethodDivierLine.snp.makeConstraints {
      $0.top.equalTo(studymethodLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    meetLabel.snp.makeConstraints {
      $0.top.equalTo(studyMethodDivierLine.snp.bottom).offset(20)
      $0.leading.equalTo(studymethodLabel)
    }
    
    meetDescribeLabel.snp.makeConstraints {
      $0.top.equalTo(meetLabel.snp.bottom).offset(8)
      $0.leading.equalTo(studymethodLabel)
    }
    
    mixmeetButton.snp.makeConstraints {
      $0.width.equalTo(60)
      $0.height.equalTo(35)
      $0.top.equalTo(meetDescribeLabel.snp.bottom).offset(10)
      $0.leading.equalTo(studymethodLabel)
    }
    
    contactButton.snp.makeConstraints {
      $0.width.equalTo(60)
      $0.height.equalTo(35)
      $0.top.equalTo(mixmeetButton)
      $0.leading.equalTo(mixmeetButton.snp.trailing).offset(10)
    }
    
    untactButton.snp.makeConstraints {
      $0.width.equalTo(65)
      $0.height.equalTo(35)
      $0.top.equalTo(mixmeetButton)
      $0.leading.equalTo(contactButton.snp.trailing).offset(10)
    }
    
    fineLabel.snp.makeConstraints {
      $0.top.equalTo(mixmeetButton.snp.bottom).offset(20)
      $0.leading.equalTo(studymethodLabel)
    }
    
    haveFineButton.snp.makeConstraints {
      $0.width.height.equalTo(32)
      $0.top.equalTo(fineLabel.snp.bottom).offset(10)
      $0.leading.equalTo(studymethodLabel)
    }
    
    haveFineLabel.snp.makeConstraints {
      $0.centerY.equalTo(haveFineButton)
      $0.leading.equalTo(haveFineButton.snp.trailing).offset(10)
    }
    
    noFineButton.snp.makeConstraints {
      $0.width.height.equalTo(32)
      $0.centerY.equalTo(haveFineButton)
      $0.leading.equalTo(haveFineLabel.snp.trailing).offset(20)
    }
    
    noFineLabel.snp.makeConstraints {
      $0.centerY.equalTo(noFineButton)
      $0.leading.equalTo(noFineButton.snp.trailing).offset(10)
    }
    
    fineTypeLabel.snp.makeConstraints {
      $0.top.equalTo(haveFineButton.snp.bottom).offset(20)
      $0.leading.equalTo(studymethodLabel)
    }
    
    fineTypesTextField.snp.makeConstraints {
      $0.top.equalTo(fineTypeLabel.snp.bottom).offset(8)
      $0.leading.equalTo(studymethodLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    fineAmountLabel.snp.makeConstraints {
      $0.top.equalTo(fineTypesTextField.snp.bottom).offset(20)
      $0.leading.equalTo(studymethodLabel)
    }
    
    fineAmountTextField.snp.makeConstraints {
      $0.top.equalTo(fineAmountLabel.snp.bottom).offset(8)
      $0.leading.equalTo(studymethodLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.equalTo(120)
      $0.height.equalTo(50)
    }
    
    fineAmountCountLabel.snp.makeConstraints {
      $0.centerY.equalTo(fineAmountTextField)
      $0.leading.equalTo(fineAmountTextField.snp.trailing).offset(-20)
    }
    
    maxFineLabel.snp.makeConstraints {
      $0.top.equalTo(fineAmountTextField.snp.bottom).offset(8)
      $0.leading.equalTo(studymethodLabel)
    }
    
    fineDividerLine.snp.makeConstraints {
      $0.top.equalTo(maxFineLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func createFineButton() -> UIButton {
    let button = UIButton()
    button.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    button.setImage(UIImage(named: "ButtonChecked"), for: .selected)
    button.tintColor = UIColor(hexCode: "#FF5530")
    return button
  }
}

extension StudyWayView: CreateUIprotocol{}
