
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then


/// 관련 학과선택 View
final class SelectMajorView: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: CreateStudyViewModel
  
  /// 구분선
  private lazy var selectMajorDividerLine = StudyHubUI.createDividerLine(height: 8)

  /// 관련 학과 선택 라벨
  private lazy var selectMajorLabel = UILabel().then {
    $0.text = "관련 학과 선택"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

 /// 선택된 학과 라벨
  private lazy var selectedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.clipsToBounds = true
    label.layer.cornerRadius = 15
    label.backgroundColor = .bg30
    label.textAlignment = .left
    label.adjustsFontSizeToFitWidth = true
    return label
  }()
  
  /// 학과 선택 취소 버튼
  private lazy var cancelButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "DeleteImg"), for: .normal)
  }
  
  /// 학과 선택 화면으로 이동 버튼
  private lazy var selectMajorButton: UIButton = UIButton().then {
   $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
   $0.tintColor = .black
  }
    
  init(_ viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupModifyUI()
    self.setupActions()
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 설정
  func setupLayout(){
    [ selectMajorDividerLine, selectMajorLabel, selectMajorButton]
      .forEach { self.addSubview($0) }
    
    selectedMajorLabel.isHidden = true
    cancelButton.isHidden = true
  }
  
  /// UI 설정
  func makeUI(){
    selectMajorDividerLine.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
    
    selectMajorLabel.snp.makeConstraints {
      $0.top.equalTo(selectMajorDividerLine.snp.bottom).offset(25)
      $0.leading.equalToSuperview().offset(20)
    }
    
    selectMajorButton.snp.makeConstraints {
      $0.centerY.equalTo(selectMajorLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
  
  /// 스터디 수정 시 UI 설정
  func setupModifyUI(){
    guard let postValue = viewModel.postedData.value else { return }
    let major = Utils.convertMajor(postValue.major, toEnglish: false)
    viewModel.selectedMajor.accept(major)
  }
  
  /// Actions 설정
  func setupActions(){
    /// 학과선택 버튼 -> 학과선택 화면으로 이동
    selectMajorButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (view ,_) in
        let major = view.viewModel.selectedMajor
        view.viewModel.steps.accept(AppStep.selectMajorScreenIsRequired(seletedMajor: major))
      })
      .disposed(by: disposeBag)
    
    /// 학과선택 취소버튼
    cancelButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.cancelButtonTapped()
      })
      .disposed(by: disposeBag)
  }
  
  /// 바인딩 설정
  func setupBinding(){
    /// 선택된 학과
    viewModel.selectedMajor
      .withUnretained(self)
      .subscribe(onNext: { (vc, major) in
        guard let _major = major else { return }
        let convertedMajor = Utils.convertMajor(_major, toEnglish: true)
        
        /// 스터디 데이터에 넣기
        var updatedData = vc.viewModel.createStudyData.value
        updatedData?.major = convertedMajor ?? ""
        vc.viewModel.createStudyData.accept(updatedData)
        
        /// 학과 UI 추가
        vc.addDepartmentButton(_major)
      })
      .disposed(by: disposeBag)
  }
  
  /// 학과 추가
  func addDepartmentButton(_ major: String) {
    selectedMajorLabel.text = "  \(major)  "

    self.addSubview(selectedMajorLabel)
    selectedMajorLabel.isHidden = false
    selectedMajorLabel.snp.makeConstraints { make in
      make.top.equalTo(selectMajorLabel.snp.bottom).offset(20)
      make.leading.equalTo(selectMajorLabel)
      make.height.equalTo(30)
    }
    
    self.addSubview(cancelButton)
    cancelButton.isHidden = false
    cancelButton.snp.makeConstraints { make in
      make.centerY.equalTo(selectedMajorLabel.snp.centerY)
      make.leading.equalTo(selectedMajorLabel.snp.trailing).offset(-30)
    }
    
    self.layoutIfNeeded()
  }
  
  /// 학과 취소 버튼
  @objc func cancelButtonTapped(){
    selectedMajorLabel.isHidden = true
    cancelButton.isHidden = true
    
    viewModel.selectedMajor.accept(nil)
    
    self.layoutIfNeeded()
  }
}

