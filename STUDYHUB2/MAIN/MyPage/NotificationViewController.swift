
import UIKit

import SnapKit

final class NotificationViewController: NaviHelper {
  let data = ["1","2","3"]
  let footerdata = ["f1","f2","f3" ]
  
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
    
  
  }
}

// MARK: - cell 함수
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = notificationTableView.dequeueReusableCell(withIdentifier: NotificationCell.cellId,
                                                         for: indexPath) as! NotificationCell
    cell.titleLabel.text = data[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    
  }
  
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
  
  func reloadTalbeView(){
    notificationTableView.reloadData()
  }
}

// 셀을 누르면 sectiondata에 상세내용을 추가/삭제하고 테이블뷰를 리로드?
extension NotificationViewController {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    return footerdata[section]
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    lazy var footerView = UIView()
    
    lazy var detailLabel = createLabel(title: footerdata[section],
                                       textColor: .black,
                                       fontType: "Pretendard",
                                       fontSize: 18)
    footerView.addSubview(detailLabel)
    detailLabel.snp.makeConstraints {
      $0.leading.equalTo(footerView.snp.leading).offset(10)
      $0.centerY.equalTo(footerView)
    }
    
    return footerView
  }
}
