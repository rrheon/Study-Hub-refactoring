
import UIKit

import SnapKit
import RxRelay
import RxSwift
import RxCocoa

final class EditMajorViewController: CommonNavi {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: EditMajorViewModel
  
  private lazy var titleLabel = createLabel(
    title: "변경할 학과를 알려주세요",
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 16
  )
  
  private lazy var majorTextField = createTextField(title: viewModel.getCurrentmajor())
  
  private lazy var searchButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "SearchImg"), for: .normal)
    return button
  }()
  
  private lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(SeletMajorCell.self, forCellReuseIdentifier: SeletMajorCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()
  
  init(_ userData: BehaviorRelay<UserDetailData?>) {
    self.viewModel = EditMajorViewModel(userData: userData)
    super.init(false)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setupLayout()
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    [
      titleLabel,
      majorTextField,
      searchButton,
      resultTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.leading.equalToSuperview().offset(30)
    }
    
    majorTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    searchButton.snp.makeConstraints {
      $0.centerY.equalTo(majorTextField)
      $0.trailing.equalToSuperview().offset(-30)
    }
    
    resultTableView.delegate = self
    resultTableView.isHidden = true
    resultTableView.snp.makeConstraints {
      $0.top.equalTo(majorTextField.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(majorTextField)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "학과 변경")
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg", activate: false)
  }
  
  // MARK: - setupBinding
  
  
  func setupBinding(){
    viewModel.matchedMajors
      .bind(to: resultTableView.rx.items(cellIdentifier: "CellId")) { index, department, cell in
        if !department.isEmpty {
          self.resultTableView.isHidden = false
          self.searchButton.setImage(UIImage(named: "DeleteImg"), for: .normal)
        }
        cell.textLabel?.text = department
        cell.textLabel?.textColor = .bg90
        cell.backgroundColor = .bg20
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    
    viewModel.enteredMajor
      .map { $0.isEmpty ? "SearchImg" : "DeleteImg" }
      .map { UIImage(named: $0) }
      .subscribe(onNext: { [weak self] image in
        self?.searchButton.setImage(image, for: .normal)
      })
      .disposed(by: disposeBag)
    
    majorTextField.rx.text.orEmpty
      .bind(onNext: { [weak self] text in
        self?.viewModel.searchMajorFromPlist(text)
      })
      .disposed(by: disposeBag)
    
    viewModel.isSuccessChangeMajor
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        switch $0 {
        case true:
          self?.showToast(message: "학과가 변경됐어요.", alertCheck: true)
          self?.navigationController?.popViewController(animated: true)
        case false:
          return
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - setupActions
  
  
  func setupActions(){
    resultTableView.rx.modelSelected(String.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        self?.majorTextField.text = item
        self?.resultTableView.isHidden = true
        self?.rightButtonSetting(imgName: "CompleteImage", activate: true)
      })
      .disposed(by: disposeBag)
    
    searchButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        guard let _ = self?.majorTextField.text?.isEmpty else { return }
        self?.majorTextField.text = ""
        self?.viewModel.searchMajorFromPlist("")
      })
      .disposed(by: disposeBag)
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    guard let major = majorTextField.text else { return }
    
    let result = viewModel.checkCurrentMajor(major)
    switch result {
    case true:
      viewModel.storeMajorToServer(major)
    case false:
      showToast(message: "기존 학과와 동일해요. 다시 선택해주세요", alertCheck: false)
      rightButtonSetting(imgName: "DeCompletedImg", activate: false)
    }
  }
}

// MARK: - cell 함수

extension EditMajorViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48
  }
}

extension EditMajorViewController: CreateUIprotocol {}
