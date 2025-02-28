
import UIKit

import SnapKit
import RxRelay
import RxSwift
import RxCocoa
import Then

/// 학과 수정 라벨
final class EditMajorViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: EditMajorViewModel
  
  /// 학과 변경 제목 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = "변경할 학과를 알려주세요"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 16)
  }
  
  /// 새로운 학과 입력
  private lazy var majorTextField = StudyHubUI.createTextField(title: viewModel.getCurrentmajor())
  
  /// 검색버튼
  private lazy var searchButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "SearchImg"), for: .normal)
  }
  
  /// 검색한 학과 tableView
  private lazy var resultTableView: UITableView = UITableView().then {
    $0.register(SeletMajorCell.self, forCellReuseIdentifier: SeletMajorCell.cellId)
    $0.backgroundColor = .white
    $0.separatorInset.left = 0
    $0.layer.cornerRadius = 10
  }
  
  init(with viewModel: EditMajorViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
  } // viewDidLoad
  
  // MARK: - setupLayout
  
  
  /// layout 설정
  func setupLayout(){
    [ titleLabel, majorTextField, searchButton, resultTableView ]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  /// UI 설정
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
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "학과 변경")
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg", activate: false)
  }
  
  /// 네비게이션 바 오른쪽 버튼 탭
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
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
  
  

  // MARK: - setupBinding
  
  /// 바인딩
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
  
  /// actions 설정
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
}

// MARK: - cell 함수

extension EditMajorViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48
  }
}

