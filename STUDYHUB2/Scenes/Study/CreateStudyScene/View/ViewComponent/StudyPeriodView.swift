
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 스터디 기간 View
final class StudyPeriodView: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: CreateStudyViewModel
  
  /// 구분선
  private lazy var periodTopDivideLine = StudyHubUI.createDividerLine(height: 8)

  /// 기간 라벨
  private lazy var periodLabel = UILabel().then {
    $0.text = "기간"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 구분선
  private lazy var periodUnderDividerLine = StudyHubUI.createDividerLine(height: 1)
  
  /// 스터디 시작하는 날짜 라벨
  private lazy var startLabel = UILabel().then {
    $0.text = "시작하는 날"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 시작하는 날짜 선택 버튼
  private lazy var startDateButton = createDateButton()
  
  /// 스터디 종료하는 날짜 라벨
  private lazy var endLabel = UILabel().then {
    $0.text = "종료하는 날"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 종료하는 날짜 선택 버튼
  private lazy var endDateButton = createDateButton()
  
  /// 스터디 생성 완료하기 버튼
  private lazy var completeButton = StudyHubButton(title: "완료하기")
  
  init(_ viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupModifyUI()
    self.setupBinding()
    self.setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Layout 설정
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
  
  /// UI설정
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
    
    completeButton.snp.makeConstraints {
      $0.top.equalTo(endDateButton.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(endDateButton)
      $0.height.equalTo(55)
    }
  }
  
  /// 수정 시 UI 설정
  func setupModifyUI(){
    guard let postValue = viewModel.postedData.value else { return }
    let changedStartDate = viewModel.changeDate(postValue.studyStartDate)
    startDateButton.setTitle(changedStartDate, for: .normal)
    viewModel.startDate.accept(changedStartDate)
    
    let changedEndDate = viewModel.changeDate(postValue.studyEndDate)
    endDateButton.setTitle(changedEndDate, for: .normal)
    viewModel.endDate.accept(changedEndDate)
  }

  /// 날짜 선택 버튼 생성하기
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

  /// 날짜 선택 버튼 action 설정하기
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
      .disposed(by: disposeBag)
    
    
  }
  
  /// Actions 설정
  func setupActions(){
  
    /// 시작날짜 선택 버튼 탭
    startDateButton.rx.tap
      .withUnretained(self)
      .subscribe { (view, _) in
        view.viewModel.steps.accept(AppStep.calendarIsRequired(viewModel: view.viewModel,
                                                               selectType: true))
      }
      .disposed(by: disposeBag)
    
    /// 종료날짜 선택 버튼 탭
    endDateButton.rx.tap
      .withUnretained(self)
      .subscribe { (view, _) in
        view.viewModel.steps.accept(AppStep.calendarIsRequired(viewModel: view.viewModel,
                                                               selectType: false))

      }
      .disposed(by: disposeBag)
    
    
    /// 게시글 작성버튼 탭
    completeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        // 게시글 디테일 -> 수정
        guard let _ = self?.viewModel.postedData.value else {
          self?.viewModel.createNewStudyPost()
          return
        }
        
        self?.viewModel.modifyStudyPost()
      })
      .disposed(by: disposeBag)

  }
  
  /// 바인딩
  private func setupBinding(){
    /// 스터디 시작날짜
    viewModel.startDate
      .asDriver(onErrorJustReturn: "선택하기")
      .drive(onNext: { [weak self] startDate in
        guard let self = self else { return }
        uiUpdate(startDateButton, title: startDate)
        
        if startDate != "선택하기" {
          var updatedData = viewModel.createStudyData.value
          updatedData?.studyStartDate = startDate
          viewModel.createStudyData.accept(updatedData)
        }
      })
      .disposed(by: disposeBag)
    
    /// 스터디 종료날짜
    viewModel.endDate
      .asDriver(onErrorJustReturn: "선택하기")
      .drive(onNext: { [weak self] endDate in
        guard let self = self else { return }
        uiUpdate(endDateButton, title: endDate)
        
        if endDate != "선택하기" {
          var updatedData = viewModel.createStudyData.value
          updatedData?.studyEndDate = endDate
          viewModel.createStudyData.accept(updatedData)
        }
      })
      .disposed(by: disposeBag)
    
    /// 스터디 생성 데이터
    viewModel.createStudyData
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, nil))
      .drive(onNext: { (view,createData) in
        /// 생성가능 여부 체크
        let checkValid = view.viewModel.checkValidCreateStudyData(with: createData)
        
        /// 완료버튼 활성화 여부 체크
        let backgroundColor: UIColor = checkValid ? .o50 : .o30
        view.completeButton.unableButton(checkValid,
                                         backgroundColor: backgroundColor,
                                         titleColor: .white)
      })
      .disposed(by: disposeBag)
  }
  
  func uiUpdate(_ button: UIButton, title: String){
    let titleColor: UIColor = title == "선택하기" ? .bg70 : .black
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
  }
}
