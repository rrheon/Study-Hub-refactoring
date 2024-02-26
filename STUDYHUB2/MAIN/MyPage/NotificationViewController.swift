
import UIKit

import SnapKit
import Moya

final class NotificationViewController: NaviHelper {
  
  var noticeDatas: [NoticeContent]? = []
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
    
    getNoticeData(page: 0, size: 10) { NoticeData in
      self.noticeDatas = NoticeData.content
      
      self.setupLayout()
      self.makeUI()
    }
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
  
  func getNoticeData(page: Int,
                     size: Int,
                     completion: @escaping(NoticeData) -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.getNotice(page: page, size: size)) { result in
      switch result {
      case .success(let response):
        do {
          let noticeData = try JSONDecoder().decode(NoticeData.self, from: response.data)
          completion(noticeData)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let response):
        print(response.response)
      }
    }
  }
}

// MARK: - cell 함수
extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return noticeDatas?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.cellId,
                                                  for: indexPath) as! NotificationCell
    cell.model = noticeDatas
    
    let isExpanded = selectedCellIndexPath == indexPath
    let detailText = isExpanded ? noticeDatas?[indexPath.row].content : nil
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
      let text = noticeDatas?[indexPath.row]
      
      expandedHeight =  defaultHeight + NotificationCell.calculateContentHeight(for: text?.content ?? "",
                                                                                width: maxWidth)
    } else {
      expandedHeight = defaultHeight
    }
    
    return CGSize(width: maxWidth, height: expandedHeight)
  }
}
