//
//  EditMajorViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/12/27.
//

import UIKit

import SnapKit
import Moya

final class EditMajorViewController: NaviHelper {
  let commonNetworking = CommonNetworking.shared
  
  var beforeMajor: String?
  var changedMajor: String?
  var previousVC: MyInformViewController?
  
  var resultDepartments: [String] = []
  
  private lazy var titleLabel = createLabel(title: "변경할 학과를 알려주세요",
                                            textColor: .black,
                                            fontType: "Pretendard-Bold",
                                            fontSize: 16)
  
  private lazy var searchController = UISearchBar.createSearchBar(placeholder: beforeMajor ?? "없음")
  
  private lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomCell.self,
                       forCellReuseIdentifier: CustomCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent {
      var major = convertMajor(changedMajor ?? "", isEnglish: false)
      if major != "" {
        previousVC?.major = major
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      searchController,
      resultTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI() {
    searchController.delegate = self
    
    resultTableView.delegate = self
    resultTableView.dataSource = self
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(30)
    }
    
    searchController.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
  
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItem = .none
    
    settingNavigationTitle(title: "학과 변경",
                           font: "Pretendard-Bold",
                           size: 18)
    
    let completeImg = UIImage(named: "DeCompletedImg")?.withRenderingMode(.alwaysOriginal)
    let completeButton = UIBarButtonItem(image: completeImg,
                                         style: .plain,
                                         target: self,
                                         action: #selector(completeButtonTapped))
    navigationItem.rightBarButtonItem = completeButton
  }
  
  @objc func completeButtonTapped(){
    print("완료버튼")
    if beforeMajor == searchController.text {
      showToast(message: "기존 학과와 동일해요. 다시 선택해주세요", alertCheck: false)
    } else {
      guard var changeMajor = searchController.text else { return }
      changeMajor = changeMajor.convertMajor(changeMajor, isEnglish: true)
      print(changeMajor)
      commonNetworking.moyaNetworking(networkingChoice: .editUserMaojr(_major: changeMajor),
                                      needCheckToken: true) { result in
        switch result {
        case .success(let response):
          print(response.response)
          self.changedMajor = changeMajor
          self.showToast(message: "학과가 변경됐어요.", alertCheck: true)
          self.navigationController?.popViewController(animated: true)
          
        case let .failure(error):
          print(error.localizedDescription)
        }
      }
    }
  }
}

// MARK: - searchbar
extension EditMajorViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을 때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    
    let matchingDepartments = majorSet.filter { $0.contains(keyword) }
    
    if matchingDepartments.isEmpty {
      print("검색 결과가 없음")
      // 검색 결과가 없을 때의 처리를 할 수 있습니다.
    } else {
      print("검색 결과: \(matchingDepartments)")
      searchTapped(department: matchingDepartments)
    }
    
    reloadTalbeView()
  }
  
  func searchTapped(department: [String]){
    resultTableView.isHidden = false
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    view.addSubview(resultTableView)
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(searchController.snp.bottom).offset(10)
      make.leading.trailing.equalTo(searchController)
      make.bottom.equalTo(view).offset(-10)
    }
    resultDepartments = department
  }
}

// MARK: - cell 함수
extension EditMajorViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return resultDepartments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    
    cell.backgroundColor = .bg20
    
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
      
      guard let beforeMajor = beforeMajor else { return }
      print(beforeMajor == selectedMajor)
      if beforeMajor == selectedMajor {
        let completeImg = UIImage(named: "DeCompletedImg")?.withRenderingMode(.alwaysOriginal)
        let completeButton = UIBarButtonItem(image: completeImg,
                                             style: .plain,
                                             target: self,
                                             action: #selector(completeButtonTapped))

        navigationItem.rightBarButtonItem = completeButton
      } else {
        let completeImg = UIImage(named: "CompleteImage")?.withRenderingMode(.alwaysOriginal)
        let completeButton = UIBarButtonItem(image: completeImg,
                                             style: .plain,
                                             target: self,
                                             action: #selector(completeButtonTapped))
        completeButton.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = completeButton
      }
      
      searchController.text = selectedMajor
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
