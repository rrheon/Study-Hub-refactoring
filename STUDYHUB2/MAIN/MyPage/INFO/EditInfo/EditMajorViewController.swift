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
  var beforeMajor: String?
  var changedMajor: String?
  var previousVC: MyInformViewController?
  
  private lazy var majorSet = ["공연예술과", "IBE전공", "건설환경공학", "건축공학",
                               "경영학부", "경제학과", "국어교육과", "국어국문학과",
                               "기계공학과","데이터과학과","도시건축학","도시공학과",
                               "도시행정학과","독어독문학과","동북아통상전공","디자인학부",
                               "무역학부","문헌정보학과","물리학과","미디어커뮤니케이션학과",
                               "바이오-로봇 시스템 공학과","법학부", "불어불문학과","사회복지학과",
                               "산업경영공학과","생명공학부(나노바이오공학전공)","생명공학부(생명공학전공)",
                               "생명과학부(분자의생명전공)","생명과학부(생명과학전공)","서양화전공(조형예술학부)",
                               "세무회계학과","소비자학과","수학과","수학교육과", "스마트물류공학전공", "스포츠과학부",
                               "신소재공학과","안전공학과","에너지화학공학","역사교육과","영어교육과","영어영문학과",
                               "운동건강학부","유아교육과","윤리교육과","일본지역문화학과","일어교육과","임베디드시스템공과",
                               "전기공학과","전자공학과","정보통신학과","정치외교학과","중어중국학과","창의인개발학과",
                               "체육교육과","컴퓨터공학부","테크노경영학과","패션산업학과","한국화전공(조형예술학부)",
                               "해양학과","행정학과","화학과","환경공학"]
  
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
    navigationItem.title = "학과 변경"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    
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
      let provider = MoyaProvider<networkingAPI>()
      provider.request(.editUserMaojr(_major: changeMajor)) { result in
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
