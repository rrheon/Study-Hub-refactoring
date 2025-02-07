
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class NotificationViewController: CommonNavi {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel = NotificationViewModel()

  private lazy var notificationCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.clipsToBounds = false

    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setupDelegate()
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  // MARK: - navigationbar 설정
  
  
  func setupNavigationbar() {
    settingNavigationTitle(title: "공지사항")
    leftButtonSetting()
  }

  // MARK: - makeUI
  
  
  func makeUI(){
    view.addSubview(notificationCollectionView)
    notificationCollectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  func setupBinding(){
    viewModel.noticeDatas
      .asDriver(onErrorJustReturn: [])
      .drive(notificationCollectionView.rx.items(
        cellIdentifier: NotificationCell.id,
        cellType: NotificationCell.self)
      ) { index, content , cell in
        cell.model = content
      }
      .disposed(by: disposeBag)
  }
  
  func setupActions() {
    notificationCollectionView.rx.modelSelected(ExpandedNoticeContent.self)
      .subscribe(onNext: { [weak self] data in
        guard let self = self else { return }
        viewModel.noticeCellTapped(data.noticeContent.title)
      })
      .disposed(by: disposeBag)
  }

  func setupDelegate(){
    notificationCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    notificationCollectionView.register(
      NotificationCell.self,
      forCellWithReuseIdentifier: NotificationCell.id
    )
  }
}

extension NotificationViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    
    let noticeData = viewModel.noticeDatas.value
    let isExpanded = noticeData[indexPath.row].isExpanded
    let content = noticeData[indexPath.row].noticeContent.content
    
    let height = viewModel.calculateContentHeight(
      content: content,
      width: collectionView.frame.width - 20
    )
    let cellHeight = isExpanded ? height + 100 : 86
    return CGSize(width: collectionView.frame.width, height: CGFloat(cellHeight))
  }
}

