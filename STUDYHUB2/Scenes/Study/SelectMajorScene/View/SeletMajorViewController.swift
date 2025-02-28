
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 학과 선택VC
final class SeletMajorViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: SeletMajorViewModel
  
  /// 학과선택 서치바
  private lazy var searchController = StudyHubUI.createSearchBar(
    placeholder: "스터디와 관련된 학과를 입력해주세요"
  )
  
  /// 검색한 학과 TableView
  private lazy var resultTableView: UITableView = UITableView().then {
    $0.register(SeletMajorCell.self, forCellReuseIdentifier: SeletMajorCell.cellId)
    $0.backgroundColor = .white
    $0.separatorInset.left = 0
    $0.layer.cornerRadius = 10
  }
  
  /// 학과 선택관련 설명 라벨
  private lazy var describeLabel = UILabel().then {
    $0.text = "- 관련학과는 1개만 선택할 수 있어요 \n- 다양한 학과와 관련된 스터디라면, '공통'을 선택해 주세요"
    $0.textColor = .bg60
    $0.font = UIFont(name: "Pretendard", size: 12)
  }

  /// 선택된 학과 라벨
  private lazy var selectMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  /// 학과 선택취소 버튼
  private lazy var cancelButton: UIButton = UIButton().then {
    let img = UIImage(named: "DeleteImg")
    $0.setImage(img, for: .normal)
    $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
  }
  
  init(with viewModel: SeletMajorViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: .none)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setupLayout()
    makeUI()
    
    setupDelegate()
    setupActions()
    setupBinding()
  } // viewDidLoad
  
  // MARK: - setupLayout
  
  
  /// layout 설정
  func setupLayout(){
    [ searchController, describeLabel]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  
  /// UI 설정
  func makeUI() {
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.width.equalToSuperview().multipliedBy(0.95)
    }
    
    describeLabel.numberOfLines = 2
    describeLabel.snp.makeConstraints { make in
      make.top.equalTo(searchController.snp.bottom).offset(10)
      make.leading.equalTo(searchController.snp.leading)
    }
  }
  
  /// delegate 설정
  func setupDelegate(){
    searchController.delegate = self
    resultTableView.delegate = self
  }
  
  // MARK: - setupNavigationbar
  
  /// 네비게이션바 세팅
  func setupNavigationbar() {
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg.png", activate: false)

    settingNavigationTitle(title: "관련학과")
  }
  
  /// 네비게이션 바 왼쪽 아이템 터치
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: false))
  }
  
  // 네비게이션 오른쪽 버튼을 누르면 이전 화면에 뜰 수 있도록 설정하기
  /// 네비게이션 바 오른쪽 버튼 터치
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    /// 선택한 학과 데이터 넣어주기
    viewModel.enteredMajor.accept(viewModel.selectedMajor)
    
    /// 현재 화면 pop
    viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: false))
  }
  
  /// Actions 설정
  func setupActions(){
    /// 학과 결과 tableView
    resultTableView.rx.modelSelected(String.self)
      .withUnretained(self)
      .subscribe(onNext: { (vc, selectedMajor) in
        vc.cellTapped(with: selectedMajor)
      })
      .disposed(by: disposeBag)
    
    /// 검색한 학과가 학과리스트에 일치하는지 여부
    viewModel.matchedMajors
      .subscribe(onNext: { [weak self] in
        if !$0.isEmpty {
          self?.searchTapped(department: $0)
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 바인딩
  func setupBinding(){
    /// 일치하는 학과
    viewModel.matchedMajors
      .asDriver(onErrorJustReturn: [])
      .drive(resultTableView.rx.items(
        cellIdentifier: SeletMajorCell.cellId,
        cellType: SeletMajorCell.self)) { index , content ,cell in
          cell.model = content
          cell.backgroundColor = .bg20
          cell.textColor = .black
        }
        .disposed(by: disposeBag)
  }
  
  /// 선택된 학과 취소 탭
  @objc func cancelButtonTapped(){
    describeLabel.isHidden = false
    selectMajorLabel.isHidden = true
    cancelButton.isHidden = true
    resultTableView.isHidden = true
    
    viewModel.selectedMajor = ""
  }
}

extension SeletMajorViewController: UISearchBarDelegate, UITableViewDelegate {
  
  /// 검색된 학과 셀의 크기
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48.0
  }
  
  /// 서치바 검색 시 실시간으로 입력값과 같은 학과를 출력
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    viewModel.searchMajorFromPlist(keyword)
  }

  
  /// 학과 검색 탭
  /// - Parameter department: 검색된 학과들
  func searchTapped(department: [String]){
    [describeLabel, selectMajorLabel, cancelButton]
      .forEach { $0.isHidden = true }
  
    resultTableView.isHidden = false
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    view.addSubview(resultTableView)
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(describeLabel.snp.bottom).offset(-30)
      make.leading.trailing.equalTo(searchController)
      make.bottom.equalTo(view).offset(-10)
    }
  }
}

// MARK: - cell 함수

extension SeletMajorViewController {
  
  /// 학과 셀 터치 시
  /// - Parameter selectedCell: 선택된 학과
  func cellTapped(with selectedMajor: String) {
    /// 학과 1개이상 선택 시
    if selectMajorLabel.text != nil {
      showToast(message: "관련학과는 1개만 선택이 가능해요", alertCheck: false)
      return
    }
    
    /// 학과 선택에 따라 네비게이션 바 오른쪽 버튼 세팅
    let image = selectedMajor.isEmpty ? "DeCompletedImg.png" : "CompleteImage.png"
    rightButtonSetting(imgName: image, activate: !selectedMajor.isEmpty)
    
    viewModel.selectedMajor = selectedMajor
    
    /// 선택된 학과에 따른 라벨 설정
    setupSelectMajorLabel(with: selectedMajor)
    
    /// 선택된 학과에 따른 라벨 layout설정
    setupSelectedMajorLaout(with: selectedMajor)
    
    resultTableView.isHidden = true
    cancelButton.isHidden = false
  }
  
  
  /// 선택된 학과라벨 설정
  /// - Parameters:
  ///   - text: 학과
  ///   - size: 라벨 사이즈
  private func setupSelectMajorLabel(with text: String) {
    selectMajorLabel.text = text
    selectMajorLabel.clipsToBounds = true
    selectMajorLabel.layer.cornerRadius = 15
    selectMajorLabel.backgroundColor = .bg30
    selectMajorLabel.textAlignment = .left
    selectMajorLabel.isHidden = false
  }
  
  
  /// 선택된 학과 layout설정
  /// - Parameter labelSize: 라벨의 크기
  private func setupSelectedMajorLaout(with selectedMajor: String) {
    let labelSize = (selectedMajor as NSString).size(withAttributes: [.font: selectMajorLabel.font!])
    
    /// 선택된 학과라벨
    view.addSubview(selectMajorLabel)
    selectMajorLabel.snp.makeConstraints { make in
      make.top.equalTo(describeLabel.snp.bottom).offset(-30)
      make.leading.equalTo(searchController).offset(10)
      make.width.equalTo(labelSize.width + 40)
      make.height.equalTo(30)
    }
    
    /// 선택취소버튼
    view.addSubview(cancelButton)
    cancelButton.snp.makeConstraints { make in
      make.centerY.equalTo(selectMajorLabel.snp.centerY)
      make.leading.equalTo(selectMajorLabel.snp.trailing).offset(-25)
    }
    
    view.layoutIfNeeded()
  }
}
