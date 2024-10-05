
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SeletMajorViewController: CommonNavi {
  let viewModel: SeletMajorViewModel
  
  private lazy var searchController = createSearchBar(placeholder: "스터디와 관련된 학과를 입력해주세요")
  
  private lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(SeletMajorCell.self, forCellReuseIdentifier: SeletMajorCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()
  
  private lazy var describeLabel = createLabel(
    title: "- 관련학과는 1개만 선택할 수 있어요 \n- 다양한 학과와 관련된 스터디라면, '공통'을 선택해 주세요",
    textColor: .bg60,
    fontType: "Pretendard",
    fontSize: 12
  )

  private lazy var selectMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    let img = UIImage(named: "DeleteImg")
    button.setImage(img, for: .normal)
    button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    return button
  }()
  
  init(seletedMajor: BehaviorRelay<String?>) {
    self.viewModel = SeletMajorViewModel(enteredMajor: seletedMajor)
    super.init()
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
  }
  
  // MARK: - setupLayout
  
  func setupLayout(){
    [
      searchController,
      describeLabel
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
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
  
  func setupDelegate(){
    searchController.delegate = self
    resultTableView.delegate = self
  }
  
  // MARK: - setupNavigationbar
  
  func setupNavigationbar() {
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg.png", activate: false)

    settingNavigationTitle(title: "관련학과")
  }
  
  // 네비게이션 오른쪽 버튼을 누르면 이전 화면에 뜰 수 있도록 설정하기
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    viewModel.enteredMajor.accept(viewModel.selectedMajor)
    self.navigationController?.popViewController(animated: true)
  }
  
  func setupActions(){
    resultTableView.rx.modelSelected(String.self)
      .subscribe(onNext: { [weak self] in
        self?.cellTapped(selectedCell: $0)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.matchedMajors
      .subscribe(onNext: { [weak self] in
        if !$0.isEmpty {
          self?.searchTapped(department: $0)
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupBinding(){
    viewModel.matchedMajors
      .asDriver(onErrorJustReturn: [])
      .drive(resultTableView.rx.items(
        cellIdentifier: SeletMajorCell.cellId,
        cellType: SeletMajorCell.self)) { index , content ,cell in
          cell.model = content
          cell.backgroundColor = .bg20
          cell.textColor = .black
        }
        .disposed(by: viewModel.disposeBag)
  }
  
  @objc func cancelButtonTapped(){
    describeLabel.isHidden = false
    selectMajorLabel.isHidden = true
    cancelButton.isHidden = true
    resultTableView.isHidden = true
    
    viewModel.selectedMajor = ""
  }
}

extension SeletMajorViewController: UISearchBarDelegate, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48.0
  }
  
  // 검색(Search) 버튼을 눌렀을 때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    viewModel.searchMajorFromPlist(keyword)
  }
  
  func searchTapped(department: [String]){
    describeLabel.isHidden = true
    selectMajorLabel.isHidden = true
    cancelButton.isHidden = true
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
  func cellTapped(selectedCell: String) {
    if selectMajorLabel.text != nil {
      showToast(message: "관련학과는 1개만 선택이 가능해요", alertCheck: false)
      return
    }
    
    updateNavigationbar(selectedCell)
    viewModel.selectedMajor = selectedCell
    
    let labelSize = calculateLabelSize(for: selectedCell, font: selectMajorLabel.font!)
    
    configureSelectMajorLabel(with: selectedCell, size: labelSize)
    
    resultTableView.isHidden = true
    cancelButton.isHidden = false
    
    layoutSelectMajorLabel(labelSize: labelSize)
    layoutCancelButton()
  }
  
  private func updateNavigationbar(_ selectedCell: String){
    let image = selectedCell.isEmpty ? "DeCompletedImg.png" : "CompleteImage.png"
    rightButtonSetting(imgName: image, activate: !selectedCell.isEmpty)
  }
  
  private func calculateLabelSize(for text: String, font: UIFont) -> CGSize {
    return (text as NSString).size(withAttributes: [.font: font])
  }
  
  private func configureSelectMajorLabel(with text: String, size: CGSize) {
    selectMajorLabel.text = text
    selectMajorLabel.clipsToBounds = true
    selectMajorLabel.layer.cornerRadius = 15
    selectMajorLabel.backgroundColor = .bg30
    selectMajorLabel.textAlignment = .left
    selectMajorLabel.isHidden = false
  }
  
  private func layoutSelectMajorLabel(labelSize: CGSize) {
    view.addSubview(selectMajorLabel)
    selectMajorLabel.snp.makeConstraints { make in
      make.top.equalTo(describeLabel.snp.bottom).offset(-30)
      make.leading.equalTo(searchController).offset(10)
      make.width.equalTo(labelSize.width + 40)
      make.height.equalTo(30)
    }
  }
  
  private func layoutCancelButton() {
    view.addSubview(cancelButton)
    cancelButton.snp.makeConstraints { make in
      make.centerY.equalTo(selectMajorLabel.snp.centerY)
      make.leading.equalTo(selectMajorLabel.snp.trailing).offset(-25)
    }
    
    view.layoutIfNeeded()
  }
}

extension SeletMajorViewController: CreateUIprotocol {}
