
import UIKit

import SnapKit
import RxCocoa

final class SelectMajorView: UIView {
  let viewModel: CreateStudyViewModel
  
  private lazy var selectMajorDividerLine = createDividerLine(height: 8)

  private lazy var selectMajorLabel = createLabel(
    title: "관련 학과 선택",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var selectedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    let img = UIImage(named: "DeleteImg")
    button.setImage(img, for: .normal)
    return button
  }()
  
  private lazy var selectMajorButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    button.tintColor = .black
    return button
  }()
    
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
  
  func setupLayout(){
    [
      selectMajorDividerLine,
      selectMajorLabel,
      selectMajorButton
    ].forEach {
      self.addSubview($0)
    }
    
    selectedMajorLabel.isHidden = true
    cancelButton.isHidden = true
  }
  
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
  
  func setupModifyUI(){
    guard let postValue = viewModel.postedData.value else { return }
    let major = convertMajor(postValue.major, toEnglish: false)
    viewModel.selectedMajor.accept(major)
  }
  
  func setupActions(){
    selectMajorButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.viewModel.isMoveToSeletMajor.accept(true)
      })
      .disposed(by: viewModel.disposeBag)
    
    cancelButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.cancelButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupBinding(){
    viewModel.selectedMajor
      .subscribe(onNext: { [weak self] in
        guard let major = $0 else { return }
        self?.addDepartmentButton(major)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func addDepartmentButton(_ major: String) {
    selectedMajorLabel.text = "  \(major)  "
    selectedMajorLabel.clipsToBounds = true
    selectedMajorLabel.layer.cornerRadius = 15
    selectedMajorLabel.backgroundColor = .bg30
    selectedMajorLabel.textAlignment = .left
    selectedMajorLabel.adjustsFontSizeToFitWidth = true
    
    self.addSubview(selectedMajorLabel)
    self.addSubview(cancelButton)
    
    selectedMajorLabel.isHidden = false
    selectedMajorLabel.snp.makeConstraints { make in
      make.top.equalTo(selectMajorLabel.snp.bottom).offset(20)
      make.leading.equalTo(selectMajorLabel)
      make.height.equalTo(30)
    }
    
    cancelButton.isHidden = false
    cancelButton.snp.makeConstraints { make in
      make.centerY.equalTo(selectedMajorLabel.snp.centerY)
      make.leading.equalTo(selectedMajorLabel.snp.trailing).offset(-30)
    }
    
    self.layoutIfNeeded()
  }
  
  @objc func cancelButtonTapped(){
    selectedMajorLabel.isHidden = true
    cancelButton.isHidden = true
    
    viewModel.selectedMajor.accept(nil)
    
    self.layoutIfNeeded()
  }
}

extension SelectMajorView: CreateUIprotocol {}
extension SelectMajorView: ConvertMajor {}
