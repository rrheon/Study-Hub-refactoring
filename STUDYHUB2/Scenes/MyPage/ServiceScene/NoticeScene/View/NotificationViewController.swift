
import UIKit

import SnapKit
import RxSwift
import RxCocoa

/// 공지사항 VC
final class NotificationViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  var viewModel: NotificationViewModel

  /// 공지사항 CollectionView
  private lazy var notificationCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.clipsToBounds = false

    return collectionView
  }()
  
  init(with viewModel: NotificationViewModel){
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setupDelegate()
    makeUI()
    
    setupBinding()
    setupActions()
  } //viewDidLoad
  
  
  // MARK: - navigationbar 설정
  

  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "공지사항")
    leftButtonSetting()
    settingNavigationbar()
  }
  
  /// 네비게이션 바 왼쪽 버튼 탭 - 현재화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(animate: true))
  }
  
  
  // MARK: - makeUI
  
  /// UI설정
  func makeUI(){
    view.addSubview(notificationCollectionView)
    notificationCollectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  /// 바인딩 설정
  func setupBinding(){
    viewModel.noticeDatas
      .asDriver(onErrorJustReturn: [])
      .drive(notificationCollectionView.rx.items(
        cellIdentifier: NotificationCell.cellID,
        cellType: NotificationCell.self)
      ) { index, content , cell in
        cell.model = content
      }
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions() {
    notificationCollectionView.rx.modelSelected(ExpandedNoticeContent.self)
      .subscribe(onNext: { [weak self] data in
        guard let self = self else { return }
        viewModel.noticeCellTapped(data.noticeContent.title)
      })
      .disposed(by: disposeBag)
  }

  /// deletgaet 설정
  func setupDelegate(){
    notificationCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    notificationCollectionView.register(
      NotificationCell.self,
      forCellWithReuseIdentifier: NotificationCell.cellID
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

