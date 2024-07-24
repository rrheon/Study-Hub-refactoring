
import UIKit

import SnapKit

final class DepartmentViewController: NaviHelper {
  
  let createAccountManager = CreateAccountManager.shared
  
  var resultDepartments: [String] = []
  
  var email: String?
  var password: String?
  var gender: String?
  var nickname: String?
  
  // MARK: - 화면구성
  private lazy var pageNumberLabel = createLabel(
    title: "5/5",
    textColor: .g60,
    fontType: "Pretendard-SemiBold",
    fontSize: 18)
  
  private lazy var titleLabel = createLabel(
    title: "학과를 알려주세요",
    textColor: .white,
    fontType: "Pretendard-Bold",
    fontSize: 20)
  
  private lazy var majorLabel = createLabel(
    title: "학과",
    textColor: .g50,
    fontType: "Pretendard-Medium",
    fontSize: 14)
  
  private lazy var majorTextfield: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(
      string: "학과를 입력해주세요",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80])
    textField.textColor = .white
    textField.backgroundColor = .black
    textField.addTarget(self,
                      action: #selector(majorTextfieldDidChange),
                      for: .editingChanged)

    return textField
  }()
  
  private lazy var searchButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "SearchImg_White"), for: .normal)
    button.addAction(UIAction { _ in
      self.searchButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var departmentUnderLineView: UIView = {
    let uiView = UIView()
    uiView.backgroundColor = .g100
    return uiView
  }()
  
  private lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomCell.self,
                       forCellReuseIdentifier: CustomCell.cellId)
    tableView.backgroundColor = .black
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()

  // 다음 버튼
  private lazy var nextButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("다음", for: .normal)
    button.setTitleColor(UIColor(hexCode: "#6F6F6F"), for: .normal)
    button.backgroundColor = UIColor(hexCode: "#6F2B1C")
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      self.nextButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - 네비게이션 바
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    
    self.navigationItem.title = "회원가입"
    self.navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
  }
  
  // MARK: - setuplayout
  func setUpLayout() {
    [
      pageNumberLabel,
      titleLabel,
      majorLabel,
      majorTextfield,
      searchButton,
      departmentUnderLineView,
      resultTableView,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    pageNumberLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(pageNumberLabel.snp.bottom).offset(10)
      $0.leading.equalTo(pageNumberLabel.snp.leading)
    }
    
    majorLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.leading.equalTo(titleLabel.snp.leading)
    }

    majorTextfield.snp.makeConstraints {
      $0.top.equalTo(majorLabel.snp.bottom).offset(20)
      $0.leading.equalTo(majorLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    searchButton.snp.makeConstraints {
      $0.centerY.equalTo(majorTextfield)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    departmentUnderLineView.snp.makeConstraints {
      $0.top.equalTo(majorTextfield.snp.bottom).offset(10)
      $0.leading.equalTo(majorTextfield.snp.leading)
      $0.trailing.equalToSuperview().offset(-10)
      $0.height.equalTo(1)
    }
    
    resultTableView.isHidden = true
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(departmentUnderLineView.snp.bottom).offset(10)
      make.leading.trailing.equalTo(majorTextfield)
      make.bottom.equalTo(nextButton.snp.top).offset(10)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(departmentUnderLineView)
    }
    
    majorTextfield.delegate = self
    
    resultTableView.delegate = self
    resultTableView.dataSource = self
    
  }
  
  // MARK: - 학과 입력시 실시간 반영
  @objc func majorTextfieldDidChange(){
    guard let keyword = majorTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    
    departmentUnderLineView.backgroundColor = .g60
    searchButton.setImage(UIImage(named: "DeleteImg"), for: .normal)
    let matchingDepartments = majorSet.filter { $0.contains(keyword) }
    
    if !matchingDepartments.isEmpty {
      searchTapped(department: matchingDepartments)
      
      nextButton.backgroundColor = .o50
      nextButton.setTitleColor(.white, for: .normal)
    }
    reloadTalbeView()
  }
  
  // MARK: - 입력할 때
  func searchTapped(department: [String]) {
    resultTableView.isHidden = false
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    resultDepartments = department
  }
  
  // MARK: - 서치버튼
  func searchButtonTapped(){
    if let isEmpty = majorTextfield.text?.isEmpty {
      if !isEmpty {
        majorTextfield.text = ""
      }
    }
  }

  // MARK: - 다음버튼
  func nextButtonTapped(){
   
    guard let email = email,
          let gender = gender,
          let nickname = nickname,
          let password = password,
          let originMajor = majorTextfield.text else { return }
    let major = convertMajor(originMajor, isEnglish: true)

    let accountData = CreateAccount(email: email,
                                    gender: gender,
                                    major: major,
                                    nickname: nickname,
                                    password: password)
    
    createAccountManager.createNewAccount(accountData: accountData) {
      let completeVC = CompleteViewController()
      completeVC.modalPresentationStyle = .fullScreen
      self.present(completeVC, animated: true)
    }
  }
}

// MARK: - tableview 함수
extension DepartmentViewController: UITableViewDelegate,
                                    UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resultDepartments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    
    cell.backgroundColor = .backgroundBlack
    cell.textColor = .white
    cell.selectionStyle = .none
    
    if indexPath.row < resultDepartments.count {
      let department = resultDepartments[indexPath.row]
      cell.name.text = department
    }
    
    return cell
  }
  
  // UITableViewDelegate 함수 (선택)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // resultDepartments가 nil이 아닌 경우에만 실행
    
    if indexPath.row < resultDepartments.count {
      let selectedMajor = resultDepartments[indexPath.row]
          
      majorTextfield.text = selectedMajor
      resultTableView.isHidden = true
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func reloadTalbeView(){
    resultTableView.reloadData()
  }
}
