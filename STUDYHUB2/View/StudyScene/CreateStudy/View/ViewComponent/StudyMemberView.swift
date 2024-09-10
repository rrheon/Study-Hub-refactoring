
import UIKit

import SnapKit
import RxCocoa

final class StudyMemberView: UIView, UITextFieldDelegate {

  let viewModel: CreateStudyViewModel
  
  private lazy var studyMemeberTopLine = createDividerLine(height: 8)
  private lazy var studymemberLabel = createLabel(
    title: "스터디 팀원",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  private lazy var studyMemeberUnderLine = createDividerLine(height: 1)
  
  // MARK: - 인원
  private lazy var studymemberTitleLabel = createLabel(
    title: "인원",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var studyMemberDescibeLabel = createLabel(
    title: "본인 제외 최대 50명",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
    
  private lazy var studymemberTextField = createTextField(title: "스터디 인원을 알려주세요")
  
  private lazy var countLabel = createLabel(
    title: "명",
    textColor: .bg80,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var countAlert = createLabel(
    title: "1명부터 가능해요(본인 제외)",
    textColor: .r50,
    fontType: "Pretendard",
    fontSize: 12
  )
  
  // MARK: - 성별
  private lazy var genderLabel = createLabel(
    title: "성별",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var genderDescribeLabel = createLabel(
    title: "참여자의 성별 선택",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var allGenderButton = createButton(title: "무관")
  private lazy var maleOnlyButton = createButton(title: "남자만")
  private lazy var femaleOnlyButton = createButton(title: "여자만")
  private lazy var genderButtonDividerLine = createDividerLine(height: 8)
 
  init(_ viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupDelegate()
    self.setupActions()
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      studyMemeberTopLine,
      studymemberLabel,
      studyMemeberUnderLine,
      studymemberTitleLabel,
      studyMemberDescibeLabel,
      studymemberTextField,
      countLabel,
      countAlert,
      genderLabel,
      genderDescribeLabel,
      allGenderButton,
      maleOnlyButton,
      femaleOnlyButton,
      genderButtonDividerLine
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    studyMemeberTopLine.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
    
    studymemberLabel.snp.makeConstraints {
      $0.top.equalTo(studyMemeberTopLine.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    studyMemeberUnderLine.snp.makeConstraints {
      $0.top.equalTo(studymemberLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
    
    studymemberTitleLabel.snp.makeConstraints {
      $0.top.equalTo(studyMemeberUnderLine.snp.bottom).offset(33)
      $0.leading.equalTo(studymemberLabel)
    }
    
    studyMemberDescibeLabel.snp.makeConstraints {
      $0.top.equalTo(studymemberTitleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(studymemberLabel)
    }
    
    studymemberTextField.snp.makeConstraints {
      $0.top.equalTo(studyMemberDescibeLabel.snp.bottom).offset(10)
      $0.leading.equalTo(studymemberLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    countLabel.snp.makeConstraints {
      $0.centerY.equalTo(studymemberTextField)
      $0.trailing.equalTo(studymemberTextField.snp.trailing).offset(-10)
    }
    
    countAlert.isHidden = true
    countAlert.snp.makeConstraints {
      $0.top.equalTo(studymemberTextField.snp.bottom)
      $0.leading.equalTo(studymemberTextField)
    }
    
    genderLabel.snp.makeConstraints {
      $0.top.equalTo(studymemberTextField.snp.bottom).offset(33)
      $0.leading.equalTo(studymemberLabel)
    }
    
    genderDescribeLabel.snp.makeConstraints {
      $0.top.equalTo(genderLabel.snp.bottom).offset(8)
      $0.leading.equalTo(studymemberLabel)
    }
    
    allGenderButton.snp.makeConstraints {
      $0.top.equalTo(genderDescribeLabel.snp.bottom).offset(11)
      $0.height.equalTo(35)
      $0.width.equalTo(65)
      $0.leading.equalTo(studymemberLabel)
    }
    
    maleOnlyButton.snp.makeConstraints {
      $0.top.equalTo(genderDescribeLabel.snp.bottom).offset(11)
      $0.height.equalTo(35)
      $0.width.equalTo(65)
      $0.leading.equalTo(allGenderButton.snp.trailing).offset(10)
    }
    
    femaleOnlyButton.snp.makeConstraints {
      $0.top.equalTo(genderDescribeLabel.snp.bottom).offset(11)
      $0.height.equalTo(35)
      $0.width.equalTo(65)
      $0.leading.equalTo(maleOnlyButton.snp.trailing).offset(10)
    }
    
    genderButtonDividerLine.snp.makeConstraints {
      $0.top.equalTo(allGenderButton.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func setupBinding(){
    studymemberTextField.rx.text.orEmpty
      .map({ Int($0) })
      .bind(to: viewModel.studyMemberValue)
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions() {
    let buttonsWithStates: [(UIButton, BehaviorRelay<Bool>)] = [
      (allGenderButton, viewModel.isAllGenderButton),
      (maleOnlyButton, viewModel.isMaleOnlyButton),
      (femaleOnlyButton, viewModel.isFemaleOnlyButton)
    ]
    
    buttonsWithStates.forEach { button, state in
      button.rx.tap
        .subscribe(onNext: { [weak self] in
          guard let self = self else { return }
          self.updateButtonSelection(selectedButton: button)
        })
        .disposed(by: viewModel.disposeBag)
    }
  }
  
  func updateButtonColors() {
    let buttonsWithStates: [(UIButton, Bool)] = [
      (allGenderButton, viewModel.isAllGenderButton.value),
      (maleOnlyButton, viewModel.isMaleOnlyButton.value),
      (femaleOnlyButton, viewModel.isFemaleOnlyButton.value)
    ]
    
    buttonsWithStates.forEach { button, isSelected in
      button.layer.borderColor = isSelected ? UIColor.o40.cgColor : UIColor.bg50.cgColor
      button.setTitleColor(isSelected ? .o50 : .bg70, for: .normal)
    }
  }
  
  func updateButtonSelection(selectedButton: UIButton) {
    viewModel.isAllGenderButton.accept(selectedButton == allGenderButton)
    viewModel.isMaleOnlyButton.accept(selectedButton == maleOnlyButton)
    viewModel.isFemaleOnlyButton.accept(selectedButton == femaleOnlyButton)
    
    let selectedGender = genderButtonTapped(selectedButton)
    viewModel.seletedGenderValue.accept(selectedGender)
    
    updateButtonColors()
  }
  
  func genderButtonTapped(_ button: UIButton) -> String {
    switch button {
    case maleOnlyButton:
      return "MALE"
    case femaleOnlyButton:
      return "FEMALE"
    default:
      return "NULL"
    }
  }

  func setupDelegate(){
    studymemberTextField.delegate = self
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditing(view: textField)
    countAlert.isHidden = true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let number = Int(studymemberTextField.text ?? "0") else { return }
    
    if !(0 < number && number < 51) {
      countAlert.isHidden = false
      
      studymemberTextField.layer.borderColor = UIColor.r50.cgColor
      studymemberTextField.text = ""
    } else {
      didEndEditing(view: textField)
      countAlert.isHidden = true
    }
  }
}

extension StudyMemberView: CreateUIprotocol {}
extension StudyMemberView: EditableViewProtocol {}
