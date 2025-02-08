
import UIKit

import SnapKit
import RxCocoa
import RxSwift

/// 회원가입 - 5. 학과입력 VC
final class DepartmentViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: EnterDepartmentViewModel
    
  // MARK: - 화면구성
  private lazy var mainTitleView = AuthTitleView(
    pageNumber: "5/5",
    pageTitle:  "학과를 알려주세요",
    pageContent: nil
  )
  
  private lazy var textFieldValue = SetAuthTextFieldValue(
    labelTitle: "헉과",
    textFieldPlaceholder: "학과를 입력해주세요")
  
  private lazy var majorTextField = AuthTextField(setValue: textFieldValue)
  
  private lazy var searchButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "SearchImg_White"), for: .normal)
    return button
  }()

  private lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(SeletMajorCell.self, forCellReuseIdentifier: SeletMajorCell.cellId)
    tableView.backgroundColor = .black
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()

  private lazy var nextButton = StudyHubButton(title: "다음")
  
  init(with viewModel: EnterDepartmentViewModel) {
    self.viewModel = viewModel
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
    
    setupBindings()
    setupActions()
  }
  
  // MARK: - 네비게이션 바
  func navigationItemSetting() {
    leftButtonSetting()
    settingNavigationTitle(title: "회원가입")
  }
  
  // MARK: - setuplayout
  func setUpLayout() {
    [
      mainTitleView,
      majorTextField,
      searchButton,
      resultTableView,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainTitleView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
      $0.height.equalTo(75)
    }

    majorTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(40)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(40)
    }
    
    searchButton.snp.makeConstraints {
      $0.centerY.equalTo(majorTextField).offset(15)
      $0.trailing.equalToSuperview().offset(-30)
    }

    resultTableView.isHidden = true
    resultTableView.snp.makeConstraints {
      $0.top.equalTo(majorTextField.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(majorTextField)
      $0.bottom.equalTo(nextButton.snp.top).offset(10)
    }
    
    nextButton.unableButton(false)
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(majorTextField)
    }
  }
  
  func setupBindings(){
    viewModel.matchedMajors
      .bind(to: resultTableView.rx.items(cellIdentifier: "CellId")) { index, department, cell in
        if !department.isEmpty {
          self.resultTableView.isHidden = false
          self.searchButton.setImage(UIImage(named: "DeleteImg"), for: .normal)
        }
        cell.textLabel?.text = department
        cell.backgroundColor = .backgroundBlack
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    
    viewModel.enteredMajor
      .map { $0.isEmpty ? "SearchImg_White" : "DeleteImg" }
      .map { UIImage(named: $0) }
      .subscribe(onNext: { [weak self] image in
        self?.searchButton.setImage(image, for: .normal)
      })
      .disposed(by: disposeBag)
    
    majorTextField.textField.rx.text.orEmpty
      .bind(onNext: { [weak self] text in
        self?.viewModel.searchMajorFromPlist(text)
      })
      .disposed(by: disposeBag)
    
    viewModel.isSuccessCreateAccount
      .subscribe(onNext: { [weak self] _ in
//        self?.moveToOtherVC(vc: CompleteViewController(), naviCheck: false)
//        let vc = CompletedSignupViewController()
//        vc.modalPresentationStyle = .fullScreen
//        self?.present(vc, animated: true)
        self?.viewModel.steps.accept(SignupStep.completeSignupIsRequired)
      })
      .disposed(by: disposeBag)
  }
  
  func setupActions(){
    resultTableView.rx.modelSelected(String.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        self?.majorTextField.textField.text = item
        self?.nextButton.unableButton(true)
        self?.resultTableView.isHidden = true
      })
      .disposed(by: disposeBag)
    
    searchButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        guard let _ = self?.majorTextField.getTextFieldValue()?.isEmpty else { return }
        self?.majorTextField.textField.text = ""
        self?.viewModel.searchMajorFromPlist("")
        self?.nextButton.unableButton(false)
      })
      .disposed(by: disposeBag)
    
    nextButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let major = self?.majorTextField.getTextFieldValue() else { return }
        self?.viewModel.createAccount(major)
      })
      .disposed(by: disposeBag)
  }
}

extension DepartmentViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48.0
  }
}
