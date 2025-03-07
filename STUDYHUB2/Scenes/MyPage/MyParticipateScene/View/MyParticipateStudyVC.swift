
import UIKit
import SafariServices

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 내가 참여한 스터디 VC
final class MyParticipateStudyVC: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: MyParticipateStudyViewModel
  
  /// 참여한 스터디 갯수 라벨
  private lazy var totalPostCountLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 참여한 스터디 모두 삭제 버튼
  private lazy var deleteAllButton: UIButton = UIButton().then {
    $0.setTitle("전체삭제", for: .normal)
    $0.setTitleColor(UIColor.bg70, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    $0.addAction(UIAction { _ in
      self.confirmDeleteAll()
    },for: .touchUpInside)
  }
  
  /// 참여한 스터디 collectionView
  private lazy var participateCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  
  /// 참여한 스터디가 없을 때의 이미지
  private lazy var emptyImage: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "MyParticipateEmptyImage")
  }
  
  /// 참여한 스터디가 없을 때의 라벨
  private lazy var emptyLabel: UILabel = UILabel().then {
    $0.text = "참여한 스터디가 없어요\n나와 맞는 스터디를 찾아 보세요!"
    $0.numberOfLines = 0
    $0.textColor = .bg70
  }
  
  private let scrollView: UIScrollView = UIScrollView().then {
    $0.backgroundColor = .bg30
  }
  
  init(with viewModel: MyParticipateStudyViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .bg30
    
    setupNavigationbar()
    
    registerCell()
    
    makeUI()
    
    setupBinding()
    setupActions()
  } // viewDidLoad

  
  // MARK: - makeUI
  
  /// UI 설정
  func makeUI(){
    view.addSubview(totalPostCountLabel)
    totalPostCountLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    view.addSubview(deleteAllButton)
    deleteAllButton.snp.makeConstraints { make in
      make.top.equalTo(totalPostCountLabel)
      make.trailing.equalToSuperview().offset(-20)
      make.centerY.equalTo(totalPostCountLabel)
    }
  }
  
  /// cell 등록
  private func registerCell() {
    participateCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    participateCollectionView.register(
      MyParticipateCell.self,
      forCellWithReuseIdentifier: MyParticipateCell.cellID
    )
  }
  
  /// 바인딩 설정
  func setupBinding(){
    viewModel.participateInfo
      .asDriver(onErrorJustReturn: [])
      .drive(participateCollectionView.rx.items(
        cellIdentifier: MyParticipateCell.cellID,
        cellType: MyParticipateCell.self)
      ) { index , content , cell in
        cell.model = content
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
      }.disposed(by: disposeBag)
    
    viewModel.countPostNumber
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: {[weak self] count in
        self?.totalPostCountLabel.text = "전체 \(count)"
        self?.totalPostCountLabel.changeColor(wantToChange: "\(count)", color: .black)
        switch count {
        case _ where count == 0:
          self?.noDataUI()
        default:
          self?.dataUI()
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// acionts 설정
  func setupActions(){
    viewModel.isSuccessToDelete
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] result in
        switch result {
        case true:
          ToastPopupManager.shared.showToast(message: "삭제가 완료됐어요.",
                                             imageCheck: true,
                                             alertCheck: true)
        case false:
          return
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - setupNavigationbar
  
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "참여한 스터디")
    leftButtonSetting()
    settingNavigationbar()
  }
  
  /// 네비게이션 바 왼쪽 버튼 탭 - 현재화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(animate: true))
  }
  
  
  /// 참여한 스터디 전체 삭제tr
  func confirmDeleteAll(){
    viewModel.steps.accept(AppStep.popupScreenIsRequired(popupCase: .deleteAllParticipatedStudies))
  }
  
  /// 참여한 스터디가 있을 때의 UI
  func dataUI(){
    view.addSubview(scrollView)
    scrollView.addSubview(participateCollectionView)
    
    participateCollectionView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(scrollView.snp.height)
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(totalPostCountLabel.snp.bottom).offset(20)
      $0.leading.trailing.bottom.equalTo(view)
    }
  }
  
  /// 참여한 스터디가 없을 때의 UI
  func noDataUI(){
    view.addSubview(emptyImage)
    emptyImage.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    view.addSubview(emptyLabel)
    emptyLabel.changeColor(
      wantToChange: "참여한 스터디가 없어요",
      color: .bg70,
      font: UIFont(name: "Pretendard-SemiBold", size: 16),
      lineSpacing: 5
    )
    emptyLabel.textAlignment = .center
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
  }
}

// MARK: - collectionView

extension MyParticipateStudyVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 181)
  }
}


extension MyParticipateStudyVC: MyParticipateCellDelegate {
  func moveToChatUrl(chatURL: NSURL) {
    guard UIApplication.shared.canOpenURL(chatURL as URL) else {
      ToastPopupManager.shared.showToast(message: "해당 주소를 사용할 수 없어요")
      return
    }
    
    let chatLinkSafariView = SFSafariViewController(url: chatURL as URL)
    self.present(chatLinkSafariView, animated: true)
  }
  
  func deleteButtonTapped(in cell: MyParticipateCell, postID: Int) {
    viewModel.selectedPostID = postID
    viewModel.steps.accept(AppStep.popupScreenIsRequired(popupCase: .deleteSingleParticipatedStudy))
  }
}

// MARK: - PopupView Delegate
  
  
extension MyParticipateStudyVC: PopupViewDelegate {
  // 오른쪽 버튼 탭 - 전체삭제 , 단일 삭제
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    
    switch popupCase{
    case .deleteAllParticipatedStudies:
      self.viewModel.deleteAllParticipateList()
    case .deleteSingleParticipatedStudy:
      guard let postID = viewModel.selectedPostID else { return }
      self.viewModel.deleteParticipateList(studyID: postID)
    default: return
    }
  }
}
  


// MARK: - 스크롤


extension MyParticipateStudyVC {
  
  /// 스크롤할 때 네트워킹 요청
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let scrollViewHeight = scrollView.frame.size.height
    let contentHeight = scrollView.contentSize.height
    let offsetY = scrollView.contentOffset.y
    
    // 바닥에서 50포인트 위에 도달했는지 체크
    if offsetY + scrollViewHeight >= contentHeight - 50 && viewModel.isInfiniteScroll == false {
      viewModel.getParticipatedList()
    }
  }
}
