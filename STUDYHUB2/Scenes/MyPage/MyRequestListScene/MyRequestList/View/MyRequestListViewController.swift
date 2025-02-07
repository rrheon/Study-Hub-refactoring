
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class MyRequestListViewController: CommonNavi {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: MyRequestListViewModel
  
  private lazy var totalPostCountLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var emptyImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ApplyEmptyImg")
    return imageView
  }()
  
  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "참여한 스터디가 없어요\n나와 맞는 스터디를 찾아 보세요!"
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    label.textColor = .bg70
    return label
  }()
  
  private lazy var myStudyRequestCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 24
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  init(_ userData: BehaviorRelay<UserDetailData?>) {
    self.viewModel = MyRequestListViewModel(userData)
    super.init()
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
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    view.addSubview(totalPostCountLabel)
    totalPostCountLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
    }
  }

  func setupBinding(){
    viewModel.requestStudyList
      .asDriver(onErrorJustReturn: [])
      .drive(myStudyRequestCollectionView.rx.items(
        cellIdentifier: MyRequestCell.id,
        cellType: MyRequestCell.self)
      ) { index, content, cell in
        cell.model = content
        cell.delegate = self
      }
      .disposed(by: disposeBag)
  }
  
  func setupActions(){
    viewModel.countPostNumber
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        guard let self = self else { return }
        totalPostCountLabel.text = "전체 \(count)"
        totalPostCountLabel.changeColor(wantToChange: "\(count)", color: .black)
        
        switch count {
        case _ where count == 0:
          noDataUI()
        default:
          dataUI()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.isSuccessToDelete
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] result in
        switch result {
        case true:
          self?.showToast(message: "삭제가 완료됐어요.", imageCheck: true, alertCheck: true)
        case false:
          return
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.rejectReason
      .asDriver(onErrorJustReturn: RejectReason(reason: "실패", studyTitle: "실패"))
      .drive(onNext: { [weak self] reason in
        self?.moveToOtherVCWithSameNavi(
          vc: DetailRejectReasonViewController(rejectData: reason),
          hideTabbar: true
        )
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - 네비게이션 설정
  
  
  func setupNavigationbar() {
    settingNavigationTitle(title: "신청 내역")
    leftButtonSetting()
  }
  
  private func registerCell() {
    myStudyRequestCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    myStudyRequestCollectionView.register(
      MyRequestCell.self,
      forCellWithReuseIdentifier: MyRequestCell.id
    )
  }
  
  func dataUI(){
    view.addSubview(myStudyRequestCollectionView)
    myStudyRequestCollectionView.snp.makeConstraints {
      $0.top.equalTo(totalPostCountLabel.snp.bottom).offset(20)
      $0.leading.equalTo(totalPostCountLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview()
    }
  }
  
  func noDataUI(){
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

extension MyRequestListViewController: MyRequestCellDelegate {
  func moveToCheckRejectReason(studyId: Int) {
    self.viewModel.getRejectReason(studyId)
  }
  
  func deleteButtonTapped(in cell: MyRequestCell, postID: Int) {
    let popupVC = PopupViewController(title: "이 스터디를 삭제할까요?", desc: "")
    
    popupVC.modalPresentationStyle = .overFullScreen
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)
      self.viewModel.deleteMyReuest(postID)
    }
    self.present(popupVC, animated: false)
  }
}

extension MyRequestListViewController: CreateUIprotocol {}
