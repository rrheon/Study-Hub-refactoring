
import UIKit

import SnapKit

final class NotificationViewController: NaviHelper {
  
  let data = ["사과", "배", "수박"]
  let footerdata = ["사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과사과",
                    "f2","f3" ]
  var selectedCellIndexPath: IndexPath?
  
  private lazy var notificationCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(NotificationCell.self,
                            forCellWithReuseIdentifier: NotificationCell.cellId)
    
    collectionView.backgroundColor = .white
    return collectionView
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
    view.addSubview(notificationCollectionView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    notificationCollectionView.delegate = self
    notificationCollectionView.dataSource = self
    
    notificationCollectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalTo(view).offset(-10)
    }
  }
}

// MARK: - cell 함수
extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.cellId,
                                                  for: indexPath) as! NotificationCell
    cell.titleLabel.text = data[indexPath.row]
    
    let isExpanded = selectedCellIndexPath == indexPath
    let detailText = isExpanded ? footerdata[indexPath.row] : nil
    cell.configureWithDetail(detailText, isExpanded: isExpanded)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    if let selected = selectedCellIndexPath, selected == indexPath {
      selectedCellIndexPath = nil
    } else {
      selectedCellIndexPath = indexPath
    }
    collectionView.reloadData()
  }
  
}

// MARK: - cell확장
extension NotificationViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let maxWidth = collectionView.frame.width
    let defaultHeight: CGFloat = 86
    let expandedHeight: CGFloat
    
    if let selected = selectedCellIndexPath, selected == indexPath {
      let text = footerdata[indexPath.row]
      expandedHeight =  defaultHeight + NotificationCell.calculateContentHeight(for: text,
                                                                                width: maxWidth)
    } else {
      expandedHeight = defaultHeight
    }
    
    return CGSize(width: maxWidth, height: expandedHeight)
  }
}
