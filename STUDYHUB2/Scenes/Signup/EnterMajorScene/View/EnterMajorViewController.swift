
import UIKit

import SnapKit
import RxCocoa
import RxSwift
import Then

/// StudyHub - front - SignupScreen - 05
/// -  학과입력 화면
final class EnterMajorViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: EnterMajorViewModel
    
  // MARK: - 화면구성
  
  /// 메인타이틀뷰
  private lazy var mainTitleView = AuthTitleView(
    pageNumber: "5/5",
    pageTitle:  "학과를 알려주세요",
    pageContent: nil
  )
  
  /// 학과 TextField의 값
  private lazy var textFieldValue = SetAuthTextFieldValue(
    labelTitle: "헉과",
    textFieldPlaceholder: "학과를 입력해주세요"
  )
  
  /// 학과입력 TextField
  private lazy var majorTextField = AuthTextField(setValue: textFieldValue)

  /// 검색버튼
  private lazy var searchButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "SearchImg_White"), for: .normal)
  }

  /// 학과검색 결과 TableView
  private lazy var resultTableView: UITableView = UITableView().then {
    $0.register(SeletMajorCell.self, forCellReuseIdentifier: SeletMajorCell.cellId)
    $0.backgroundColor = .black
    $0.separatorInset.left = 0
    $0.layer.cornerRadius = 10
  }

  /// 다음 버튼
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  init(with viewModel: EnterMajorViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - ViewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    makeUI()
    
    setupBindings()
    setupActions()
    
    registerTapGesture()
  } //viewDidLoad
  
  
  // MARK: - 네비게이션 바 세팅
  
  
  /// 네비게이션 바 세팅
  func navigationItemSetting() {
    leftButtonSetting()
    settingNavigationTitle(title: "회원가입")
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(SignupStep.popIsRequired)
  }
  
  
  // MARK: - makeUI
  
  
  /// UI 세팅
  func makeUI(){
    view.addSubview(mainTitleView)
    mainTitleView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
      $0.height.equalTo(75)
    }
    
    view.addSubview(majorTextField)
    majorTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(40)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(40)
    }
    
    view.addSubview(searchButton)
    searchButton.snp.makeConstraints {
      $0.centerY.equalTo(majorTextField).offset(15)
      $0.trailing.equalToSuperview().offset(-30)
    }

    view.addSubview(nextButton)
    nextButton.unableButton(false)
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(majorTextField)
    }
    
    view.addSubview(resultTableView)
    resultTableView.isHidden = true
    resultTableView.snp.makeConstraints {
      $0.top.equalTo(majorTextField.snp.bottom).offset(30)
      $0.leading.trailing.equalTo(majorTextField)
      $0.bottom.equalTo(nextButton.snp.top).offset(10)
    }
  }
  
  
  /// 바인딩
  func setupBindings(){
    /// 검색된 학과에 tableView 바인딩
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
    
    /// 입력된 학과
    viewModel.enteredMajor
      .map { $0.isEmpty ? "SearchImg_White" : "DeleteImg" }
      .map { UIImage(named: $0) }
      .subscribe(onNext: { [weak self] image in
        self?.searchButton.setImage(image, for: .normal)
      })
      .disposed(by: disposeBag)
    
    /// 학과입력 TextField
    majorTextField.textField.rx.text.orEmpty
      .withUnretained(self)
      .bind(onNext: { vc, text in
        vc.viewModel.searchMajorFromPlist(text)
      })
      .disposed(by: disposeBag)
    
//    /// 계정 생성 여부
//    viewModel.isSuccessCreateAccount
//      .withUnretained(self)
//      .subscribe(onNext: { vc,  _ in
//        vc.viewModel.steps.accept(SignupStep.completeSignupIsRequired)
//      })
//      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    /// 학과 검색 결과 셀 터치 시
    resultTableView.rx.modelSelected(String.self)
      .withUnretained(self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { vc, item in
        vc.majorTextField.textField.text = item
        vc.nextButton.unableButton(true)
        vc.resultTableView.isHidden = true
      })
      .disposed(by: disposeBag)
    
    /// 검색버튼 터치 시
    searchButton.rx.tap
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { vc, _ in
        if vc.majorTextField.getTextFieldValue()?.isEmpty == false {
          vc.majorTextField.textField.text = ""
          vc.viewModel.searchMajorFromPlist("")
          vc.nextButton.unableButton(false)
        }
      })
      .disposed(by: disposeBag)

    /// 다음 버튼 터치 시
    nextButton.rx.tap
      .withUnretained(self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { vc, _ in
        guard let major = vc.majorTextField.getTextFieldValue() else { return }
        vc.viewModel.createAccount(major)
      })
      .disposed(by: disposeBag)
  }
}

extension EnterMajorViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48.0
  }
}

extension EnterMajorViewController: KeyboardProtocol {}
