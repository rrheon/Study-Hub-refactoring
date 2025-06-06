
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// StudyHub - front - MyRequestScreen
/// - 내가 신청한. 스터디 리스트 화면

final class MyRequestListViewController: UIViewController {

  let disposeBag: DisposeBag = DisposeBag()

  let viewModel: MyRequestListViewModel

  /// 신청한 스터디 총 갯수 라벨
  private lazy var totalPostCountLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 신청한 스터디 collectionview
  private lazy var myStudyRequestCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 24
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  /// 신청한 스터디가 없을 때의 이미지
  private lazy var emptyImage: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "ApplyEmptyImg")
  }
  
  /// 신청한 스터디가 없을 때의 라벨
  private lazy var emptyLabel: UILabel = UILabel().then {
    $0.text = "참여한 스터디가 없어요\n나와 맞는 스터디를 찾아 보세요!"
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    $0.textColor = .bg70
  }

  init(with viewModel: MyRequestListViewModel) {
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
    
    setupActions()
    setupBinding()
  } // viewDidLoad
  
  // MARK: - makeUI
  
  
  /// UI 설정
  func makeUI(){
    view.addSubview(totalPostCountLabel)
    totalPostCountLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
    }
  }

  /// 바인딩 설정
  func setupBinding(){
    viewModel.requestStudyList
      .asDriver(onErrorJustReturn: [])
      .drive(myStudyRequestCollectionView.rx.items(
        cellIdentifier: MyRequestCell.cellID,
        cellType: MyRequestCell.self)
      ) { index, content, cell in
        cell.model = content
        cell.delegate = self
      }
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    viewModel.countPostNumber
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        guard let self = self else { return }
        totalPostCountLabel.text = "전체 \(count)"
        totalPostCountLabel.changeColor(wantToChange: "\(count)", color: .black)
        
        switch count {
        case _ where count == 0:      noDataUI()
        default:                      dataUI()
        }
      })
      .disposed(by: disposeBag)
    
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
  
  // MARK: - 네비게이션 설정
  

  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "신청 내역")
    leftButtonSetting()
    settingNavigationbar()
  }
  
  /// 네비게이션 바 왼쪽 버튼 탭 - 현재화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
                           
  /// 셀등록
  private func registerCell() {
    myStudyRequestCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    myStudyRequestCollectionView.register(
      MyRequestCell.self,
      forCellWithReuseIdentifier: MyRequestCell.cellID
    )
  }
  
  /// 데이터가 있을 때의 UI
  func dataUI(){
    view.addSubview(myStudyRequestCollectionView)
    myStudyRequestCollectionView.snp.makeConstraints {
      $0.top.equalTo(totalPostCountLabel.snp.bottom).offset(20)
      $0.leading.equalTo(totalPostCountLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview()
    }
  }
  
  /// 데이터가 없을 때의 UI
  func noDataUI(){
    myStudyRequestCollectionView.isHidden = true
    
    view.addSubview(emptyImage)
    emptyImage.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    view.addSubview(emptyLabel)
    emptyLabel.changeColor(
      wantToChange: "지금 스터디에 참여해보세요!",
      color: .bg60,
      font: UIFont(name: "Pretendard-Medium", size: 16),
      lineSpacing: 5
    )
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
  }
}

// MARK: - 스터디 셀 크기


extension MyRequestListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let model = viewModel.requestStudyList.value[indexPath.row]
    let cellHeight = model.inspection == "REJECT" ? 239 : 197
    return CGSize(width: 350, height: cellHeight)
  }
}

// MARK: - 신청한 스터디 셀


extension MyRequestListViewController: MyRequestCellDelegate {
  
  /// 거절된 이유 확인 -> 화면이동

  func moveToCheckRejectReason(studyId: Int) {
    self.viewModel.getRejectReason(studyId)
  }
  
  /// 신청한 스터디 삭제 탭 -> 팝업 띄우기
  func deleteButtonTapped(postID: Int) {
    viewModel.selectedPostID = postID
    viewModel.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .deleteSingleParticipatedStudy)))

  }
}

// MARK: - PopupView


extension MyRequestListViewController: PopupViewDelegate {
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    guard let postID = viewModel.selectedPostID else { return }
    
    self.viewModel.deleteMyReuest(postID)
  }
}

// MARK: - 스크롤


extension MyRequestListViewController {
  
  /// 스크롤할 때 네트워킹 요청
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let scrollViewHeight = scrollView.frame.size.height
    let contentHeight = scrollView.contentSize.height
    let offsetY = scrollView.contentOffset.y
    
    // 바닥에서 50포인트 위에 도달했는지 체크
    if offsetY + scrollViewHeight >= contentHeight - 50 && viewModel.isInfiniteScroll == false {
      viewModel.getRequestList()
    }
  }
}
