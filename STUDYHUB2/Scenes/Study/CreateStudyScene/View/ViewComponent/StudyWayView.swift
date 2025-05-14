
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then


/// 스터디 방법 View
final class StudyWayView: UIView, UITextFieldDelegate {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: StudyFormViewModel
  
  /// 스터디 방식 제목 라벨
  private lazy var studymethodLabel = UILabel().then {
    $0.text = "스터디 방식"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 구분선
  private lazy var studyMethodDivierLine = StudyHubUI.createDividerLine(height: 1)
  
  // MARK: - 대면 여부
  
  /// 대면 여부 라벨
  private lazy var meetLabel = UILabel().then {
    $0.text = "대면 여부"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 대면 여부 설명 라벨
  private lazy var meetDescribeLabel = UILabel().then {
    $0.text = "대면이나 혼합일 경우, 관련 내용에 대한 계획을 소개에 적어주세요"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
  /// 스터디 대면 방식 선택 버튼
  private lazy var contactButton = StudyHubUI.createButton(title: "대면")
  private lazy var untactButton = StudyHubUI.createButton(title: "비대면")
  private lazy var mixmeetButton = StudyHubUI.createButton(title: "혼합")
  
  // MARK: - 벌금
  
  
  /// 벌금 라벨
  private lazy var fineLabel = UILabel().then {
    $0.text = "벌금"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 벌금 있을 때의 버튼
  private lazy var haveFineButton = UIButton().then {
    $0.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    $0.tintColor = UIColor(hexCode: "#FF5530")
  }

  /// 벌금 있을 때의 라벨
  private lazy var haveFineLabel = UILabel().then {
    $0.text = "있어요"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 벌금 없을 때의 버튼
  private lazy var noFineButton = UIButton().then {
    $0.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
    $0.tintColor = UIColor(hexCode: "#FF5530")
  }

  /// 벌금 없을  때의 라벨
  private lazy var noFineLabel = UILabel().then {
    $0.text = "없어요"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }

  /// 벌금 종류 라벨
  private lazy var fineTypeLabel = UILabel().then {
    $0.text = "어떤 벌금인가요?"
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }

  /// 벌금 종류 입력 TextField
  private lazy var fineTypesTextField = StudyHubUI.createTextField(title: "지각비, 결석비 등")

  /// 금액 라벨
  private lazy var fineAmountLabel = UILabel().then {
    $0.text = "얼마인가요?"
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 벌금 입력 TextField
  private lazy var fineAmountTextField = StudyHubUI.createTextField(title: "금액을 알려주세요")
  
  /// 벌금 단위 라벨
  private lazy var fineAmountCountLabel = UILabel().then {
    $0.text = "원"
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }
  
  /// 최대 벌금 라벨
  private lazy var maxFineLabel = UILabel().then {
    $0.text = "최대 99,999원"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
  init(_ viewModel: StudyFormViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupDelegate()
    self.setupActions()
    self.setupBinding()
    self.setupModifyUI()

  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 설정
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
  
  /// UI 설정
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
      $0.leading.equalTo(haveFineButton.snp.trailing).offset(5)
    }
    
    noFineButton.snp.makeConstraints {
      $0.width.height.equalTo(32)
      $0.centerY.equalTo(haveFineButton)
      $0.leading.equalTo(haveFineLabel.snp.trailing).offset(20)
    }
    
    noFineLabel.snp.makeConstraints {
      $0.centerY.equalTo(noFineButton)
      $0.leading.equalTo(noFineButton.snp.trailing).offset(5)
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
    
    setupFineUI(true)
  }
  
  /// 바인딩
  func setupBinding(){
    /// 벌금 선택 여부에 따라 UI 변경
    viewModel.isFineButton
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] isFine in
        guard let self = self,
              let _isFine = isFine else { return }
        setupFineUI(!_isFine)
      })
      .disposed(by: disposeBag)
  }
  
  /// 수정 시 UI 설정
  func setupModifyUI(){
    guard let postValue = viewModel.postedData.value else { return }
   
    [ contactButton, untactButton, mixmeetButton]
      .forEach {
        if $0.titleLabel?.text == Utils.convertStudyWay(wayToStudy: postValue.studyWay ?? "") {
        updateButtonSelection(selectedButton: $0)
  
        viewModel.selectedStudyWayValue.accept($0)
      }
    }
    
    if postValue.penaltyWay != nil {
      viewModel.isFineButton.accept(true)
      fineTypesTextField.text = postValue.penaltyWay
      fineAmountTextField.text = String(postValue.penalty)
    } else {
      viewModel.isFineButton.accept(false)
    }
  }
  
  /// 버튼 Actions 설정
  func setupActions() {
    /// 스터디 방식 버튼 처리
    let mixBtnTap = mixmeetButton.rx.tap.map { self.mixmeetButton }
    let contactBtnTap = contactButton.rx.tap.map { self.contactButton }
    let untactBtnTap = untactButton.rx.tap.map { self.untactButton }
    
    
    /// 방출된 스트림 바인딩
    Observable.merge(mixBtnTap, contactBtnTap, untactBtnTap)
      .bind(to: viewModel.selectedStudyWayValue)
      .disposed(by: disposeBag)

    /// 스터디 방식 바인딩
    viewModel.selectedStudyWayValue
      .compactMap({ $0 })
      .subscribe(onNext: { [weak self] btn in
        self?.updateButtonColors(with: btn)
        self?.updateButtonSelection(selectedButton: btn)
      })
      .disposed(by: disposeBag)
  
    
    /// 벌금 선택 버튼 처리
    Observable.merge(
      haveFineButton.rx.tap.map { true },
      noFineButton.rx.tap.map { false }
    )
    .bind(to: viewModel.isFineButton)
    .disposed(by: disposeBag)
    
    /// 벌금 버튼 UI 업데이트 반영
    viewModel.isFineButton
      .withUnretained(self)
      .subscribe(onNext: { (view, selected) in
        guard let _selected = selected else { return }
        view.haveFineButton.setImage(UIImage(named: _selected ? "ButtonChecked" : "ButtonEmpty"),
                                     for: .normal)
        view.noFineButton.setImage(UIImage(named: _selected ? "ButtonEmpty" : "ButtonChecked"),
                                   for: .normal)
      })
      .disposed(by: disposeBag)
  }
  
  
  /// 버튼 색상 업데이트
  func updateButtonColors(with selectedBtn: UIButton) {
    /// 선택한 버튼 색상 업데이트
    let buttons: [UIButton] = [mixmeetButton, contactButton, untactButton]
    
    buttons.forEach { button in
      let isSelected = button == selectedBtn
      
      button.layer.borderColor = isSelected ? UIColor.o40.cgColor : UIColor.bg50.cgColor
      button.setTitleColor(isSelected ? .o50 : .bg70, for: .normal)
    }
  }
  

  /// 선택된 스터디방식에 따른 값 반환
  func studyWayButtonTapped(_ button: UIButton) -> String {
    switch button {
    case contactButton:    return "CONTACT"
    case untactButton:     return "UNTACT"
    default:               return "MIX"
    }
  }

  /// 버튼이 선택되었을 때 데이터 업데이트
  func updateButtonSelection(selectedButton: UIButton) {
    let studyWay = studyWayButtonTapped(selectedButton)

    var updatedData = viewModel.createStudyData.value
    updatedData?.studyWay = studyWay
    viewModel.createStudyData.accept(updatedData)
  }
  
  /// Delegate 설정
  func setupDelegate(){
    fineTypesTextField.delegate = self
    fineAmountTextField.delegate = self
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditing(view: textField)
  }
  
  /// 벌금의 최대 금액 제한
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == fineAmountTextField {
      if let number = Int(fineAmountTextField.text ?? "0"), number >= 99999 {
        fineAmountTextField.text = "99999"
      }
    }
    didEndEditing(view: textField)
  }
  
  /// TextField 별 입력
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let content = textField.text,
          var updatedData = viewModel.createStudyData.value else { return }
    
    /// 벌금 금액 업데이트
    if textField == fineAmountTextField {
      updatedData.penalty = Int(content) ?? 0
    } else if textField == fineTypesTextField {
      /// 벌금 설명 업데이트
      updatedData.penaltyWay = content
    }
    
    viewModel.createStudyData.accept(updatedData)
  }

  
  /// 벌금 있을 때 UI 설정
  func setupFineUI(_ hidden: Bool){
    [
      fineTypeLabel,
      fineTypesTextField,
      fineAmountLabel,
      fineAmountTextField,
      fineAmountCountLabel,
      maxFineLabel
    ].forEach {
      $0.isHidden = hidden
    }
  }
}

extension StudyWayView: EditableViewProtocol{}
