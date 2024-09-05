
import UIKit

import SnapKit
import RxCocoa

final class StudyPeriodView: UIView {
  let viewModel: CreateStudyViewModel
  
  private lazy var periodTopDivideLine = createDividerLine(height: 8)

  private lazy var periodLabel = createLabel(
    title: "기간",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var periodUnderDividerLine = createDividerLine(height: 1)
  
  private lazy var startLabel = createLabel(
    title: "시작하는 날",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var startDateButton = createDateButton()
  
  private lazy var endLabel = createLabel(
    title: "종료하는 날",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var endDateButton = createDateButton()
  
  private lazy var completeButton = StudyHubButton(title: "완료하기")
  
  init(_ viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupDateButtonActions()
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      periodTopDivideLine,
      periodLabel,
      periodUnderDividerLine,
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
    periodTopDivideLine.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
    
    periodLabel.snp.makeConstraints {
      $0.top.equalTo(periodTopDivideLine.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    periodUnderDividerLine.snp.makeConstraints {
      $0.top.equalTo(periodLabel.snp.bottom).offset(11)
      $0.leading.trailing.equalToSuperview()
    }
    
    startLabel.snp.makeConstraints {
      $0.top.equalTo(periodUnderDividerLine.snp.bottom).offset(25)
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
    
    completeButton.unableButton(false, backgroundColor: .o30, titleColor: .white)
    completeButton.snp.makeConstraints {
      $0.top.equalTo(endDateButton.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(endDateButton)
      $0.height.equalTo(55)
    }
  }
  
  func createDateButton() -> UIButton {
    let button = UIButton()
    let image = UIImage(named: "RightArrow")
    button.setImage(image, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 320, bottom: 0, right: 10)
    button.setTitle("선택하기", for: .normal)
    button.contentHorizontalAlignment = .left
    button.setTitleColor(UIColor(hexCode: "#A1AAB0"), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    button.backgroundColor = .white
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexCode: "#D8DCDE").cgColor
    button.layer.cornerRadius = 5
    return button
  }
  
  func setupDateButtonActions() {
    setupButtonAction(
      startDateButton,
      selectedState: viewModel.isStartDateButton,
      otherState: viewModel.isEndDateButton
    )
    
    setupButtonAction(
      endDateButton,
      selectedState: viewModel.isEndDateButton,
      otherState: viewModel.isStartDateButton
    )
  }
  
  private func setupButtonAction(
    _ button: UIButton,
    selectedState: BehaviorRelay<Bool>,
    otherState: BehaviorRelay<Bool>
  ) {
    button.rx.tap
      .subscribe(onNext: { _ in
        selectedState.accept(true)
        otherState.accept(false)
        if button == self.startDateButton {
          self.viewModel.startDate.accept(self.startDateButton.titleLabel?.text ?? "선택하기")
        } else {
          self.viewModel.endDate.accept(self.endDateButton.titleLabel?.text ?? "선택하기")
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  private func setupBinding(){
    viewModel.startDate
      .asDriver(onErrorJustReturn: "선택하기")
      .drive(onNext: { [weak self] in
        self?.startDateButton.setTitle($0, for: .normal)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.endDate
      .asDriver(onErrorJustReturn: "선택하기")
      .drive(onNext: { [weak self] in
        self?.endDateButton.setTitle($0, for: .normal)
      })
      .disposed(by: viewModel.disposeBag)
  }
}

extension StudyPeriodView: CreateUIprotocol{}
