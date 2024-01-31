//
//  InformationViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/31.
//

import UIKit

import SnapKit

final class NotificationViewController: NaviHelper {
  
  private lazy var notificationTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(NotificationCell.self,
                       forCellReuseIdentifier: NotificationCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItemSetting()
    
    view.backgroundColor = .white

    setupLayout()
    makeUI()
  }
  
  // MARK: - navigationbar 설정
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    settingNavigationTitle(title: "공지사항")
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    view.addSubview(notificationTableView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    notificationTableView.delegate = self
    notificationTableView.dataSource = self
    
    notificationTableView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview()
      $0.bottom.equalTo(view).offset(-10)
    }
    
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
}

// MARK: - cell 함수
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = notificationTableView.dequeueReusableCell(withIdentifier: NotificationCell.cellId,
                                                   for: indexPath) as! NotificationCell
    return cell
  }
  
  // UITableViewDelegate 함수 (선택)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // resultDepartments가 nil이 아닌 경우에만 실행
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
  
  func reloadTalbeView(){
    notificationTableView.reloadData()
  }
  
}
