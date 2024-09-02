
import UIKit

import SnapKit

final class StudyPeriodView: UIView {
  let viewModel: CreateStudyViewModel
  
  private lazy var periodLabel = createLabel(
    title: "기간",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var periodDividerLine = createDividerLine(height: 1)
  
  private lazy var startLabel = createLabel(
    title: "시작하는 날",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var startDateButton = createDateButton(selector: #selector(calendarButtonTapped))
  
  private lazy var endLabel = createLabel(
    title: "종료하는 날",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var endDateButton = createDateButton(selector: #selector(calendarButtonTapped))
  
  private lazy var completeButton = StudyHubButton(title: "완료하기")
  
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
      periodLabel,
      periodDividerLine,
      startLabel,
      startDateButton,
      endLabel,
      endDateButton,
      completeButton
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    periodLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    periodDividerLine.snp.makeConstraints {
      $0.top.equalTo(periodLabel.snp.bottom).offset(11)
      $0.leading.trailing.equalToSuperview()
    }
    
    startLabel.snp.makeConstraints {
      $0.top.equalTo(periodDividerLine.snp.bottom).offset(25)
      $0.leading.equalTo(periodLabel)
    }
    
    startDateButton.snp.makeConstraints {
      $0.top.equalTo(startLabel.snp.bottom).offset(10)
      $0.leading.equalTo(periodLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    endLabel.snp.makeConstraints {
      $0.top.equalTo(startDateButton.snp.bottom).offset(25)
      $0.leading.equalTo(periodLabel)
    }
    
    endDateButton.snp.makeConstraints {
      $0.top.equalTo(endLabel.snp.bottom).offset(10)
      $0.leading.equalTo(periodLabel)
      $0.trailing.equalTo(startDateButton)
      $0.height.equalTo(50)
    }
    
    completeButton.snp.makeConstraints {
      $0.top.equalTo(endDateButton.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(endDateButton)
      $0.height.equalTo(55)
    }
  }
  
  func createDateButton(selector: Selector) -> UIButton {
    // 버튼 초기화
    let button = UIButton()
    
    // 버튼에 이미지 설정
    let image = UIImage(named: "RightArrow")
    button.setImage(image, for: .normal)
    
    // 버튼의 이미지 위치 조절
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 320, bottom: 0, right: 10)
    
    // 버튼의 나머지 속성 설정
    button.setTitle("선택하기", for: .normal)
    button.contentHorizontalAlignment = .left
    button.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    button.backgroundColor = .white
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
    button.layer.cornerRadius = 5
    button.addTarget(self, action: selector, for: .touchUpInside)
    
    return button
  }
  
  @objc func calendarButtonTapped(_ sender: Any) {
    let calendarVC = CalendarViewController()
//    calendarVC.delegate = self
    calendarVC.selectedStatDate = startDateButton.titleLabel?.text ?? ""
    
    if (sender as AnyObject).tag == 1 {
      calendarVC.buttonSelect = true
    } else {
      calendarVC.buttonSelect = false
    }
    showBottomSheet(bottomSheetVC: calendarVC, size: 400.0)
//    self.present(calendarVC, animated: true, completion: nil)
  }
}

extension StudyPeriodView: CreateUIprotocol{}
extension StudyPeriodView: ShowBottomSheet{}

