
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 스터디 팀원 View
final class StudyMemberView: UIView, UITextFieldDelegate {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: StudyFormViewModel
  
  /// 스터디 팀원 구분선
  private lazy var studyMemeberTopLine = StudyHubUI.createDividerLine(height: 8)
  
  /// 스터디 팀원 제목 라벨
  private lazy var studymemberLabel = UILabel().then {
    $0.text = "스터디 팀원"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 팀원 구분선
  private lazy var studyMemeberUnderLine = StudyHubUI.createDividerLine(height: 1)
  
  // MARK: - 인원
  
  
  /// 스터디 인원 제목 라벨
  private lazy var studymemberTitleLabel = UILabel().then {
    $0.text = "인원"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 인원 설명 라벨
  private lazy var studyMemberDescibeLabel = UILabel().then {
    $0.text = "본인 제외 최대 50명"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }

  /// 스터디 인원 TextField
  private lazy var studymemberTextField = StudyHubUI.createTextField(title: "스터디 인원을 알려주세요")
 
  /// 스터디인원 label
  private lazy var countLabel = UILabel().then {
    $0.text = "명"
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }
 
  /// 스터디 인원 Alert Lael
  private lazy var countAlert = UILabel().then {
    $0.text = "1명부터 가능해요(본인 제외)"
    $0.textColor = .r50
    $0.font = UIFont(name: "Pretendard", size: 12)
  }

  // MARK: - 성별
  
  /// 성별 제목 라벨
  private lazy var genderLabel = UILabel().then {
    $0.text = "성별"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

 /// 성별 내용 라벨
  private lazy var genderDescribeLabel = UILabel().then {
    $0.text = "참여자의 성별 선택"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
 
  /// 성별 선택 버튼
  private lazy var allGenderButton = StudyHubUI.createButton(title: "무관")
  private lazy var maleOnlyButton = StudyHubUI.createButton(title: "남자만")
  private lazy var femaleOnlyButton = StudyHubUI.createButton(title: "여자만")
  private lazy var genderButtonDividerLine = StudyHubUI.createDividerLine(height: 8)
 
  init(_ viewModel: StudyFormViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupModifyUI()
    
    studymemberTextField.delegate = self
    
    self.setupActions()
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 설정
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
  
  /// UI설정
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
  
  /// 스터디 수정 시 UI  설정
  func setupModifyUI(){
    guard let postValue = viewModel.postedData.value else { return }
    
    studymemberTextField.text = String(postValue.studyPerson)
       
    [ maleOnlyButton, femaleOnlyButton, allGenderButton]
      .forEach {
        if $0.titleLabel?.text == Utils.convertGenderType(postValue.filteredGender ?? ""){
          viewModel.selectedGenderButton.accept($0)
      }
    }
    
  }
  
  /// 바인딩
  func setupBinding(){
    /// 스터디 인원
    studymemberTextField.rx.text.orEmpty
      .compactMap({ Int($0) })
      .withUnretained(self)
      .subscribe(onNext: { (view, text) in
        var updatedData = view.viewModel.createStudyData.value
        updatedData?.studyPerson = text
        view.viewModel.createStudyData.accept(updatedData)
      })
      .disposed(by: disposeBag)
  }

  
  /// actions 설정
  func setupActions() {
    /// 선택한 성별버튼의 스트림 방출
    let allGenderTap = allGenderButton.rx.tap.map { self.allGenderButton }
    let maleOnlyTap = maleOnlyButton.rx.tap.map { self.maleOnlyButton }
    let femaleOnlyTap = femaleOnlyButton.rx.tap.map { self.femaleOnlyButton }
    
    /// 방출된 스트림 바인딩
    Observable.merge(allGenderTap, maleOnlyTap, femaleOnlyTap)
      .bind(to: viewModel.selectedGenderButton)
      .disposed(by: disposeBag)
    
    /// 선택된 성별 버튼
    viewModel.selectedGenderButton
      .compactMap({ $0 })
      .subscribe(onNext: { [weak self] btn in
        self?.updateButtonColors(with: btn)
        self?.updateGenderValue(with: btn)
      })
      .disposed(by: disposeBag)
  }
  
  /// 버튼 색상 업데이트
  func updateButtonColors(with selectedBtn: UIButton) {
    /// 선택한 버튼 색상 업데이트
    let buttons: [UIButton] = [allGenderButton, maleOnlyButton, femaleOnlyButton]
    
    buttons.forEach { button in
      let isSelected = button == selectedBtn
      
      button.layer.borderColor = isSelected ? UIColor.o40.cgColor : UIColor.bg50.cgColor
      button.setTitleColor(isSelected ? .o50 : .bg70, for: .normal)
    }
  }
  
  /// 버튼에 따라 성별 값 넣어주기
  func updateGenderValue(with selectedBtn: UIButton){
    /// 선택한 버튼에 따라 값 넣어주기
    var selectedGender: String
    
    switch selectedBtn {
      case allGenderButton:   selectedGender = "NULL"
      case maleOnlyButton:    selectedGender = "MALE"
      case femaleOnlyButton:  selectedGender = "FEMALE"
      default: return
    }
        
    var updatedData = viewModel.createStudyData.value
    updatedData?.gender = selectedGender
    viewModel.createStudyData.accept(updatedData)
  }

  /// 스터디인원제한
  func limitStudyMember(textField: UITextField){
    guard let number = Int(studymemberTextField.text ?? "0") else { return }

    /// 스터디 인원 1~50명 제한
    if !(1 < number && number < 51) {
      countAlert.isHidden = false
      
      studymemberTextField.layer.borderColor = UIColor.r50.cgColor
      studymemberTextField.text = ""
    } else {
      didEndEditing(view: textField)
      countAlert.isHidden = true
      
      /// 제한되는 범위에 속하지 않을 경우 값 넣어주기
      guard let studyPersonNum = textField.text,
            let _studyPersonNum = Int(studyPersonNum) else { return }
      var updatedData = viewModel.createStudyData.value
      updatedData?.studyPerson = _studyPersonNum
      viewModel.createStudyData.accept(updatedData)
    }
  }
  /// textField 입력 시
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditing(view: textField)
    countAlert.isHidden = true
    
    /// 스터디 인원 1~50명 제한
    limitStudyMember(textField: textField)
  }
  
  /// TextField입력 종료 시
  func textFieldDidEndEditing(_ textField: UITextField) {
    limitStudyMember(textField: textField)
  }
}

extension StudyMemberView: EditableViewProtocol {}
