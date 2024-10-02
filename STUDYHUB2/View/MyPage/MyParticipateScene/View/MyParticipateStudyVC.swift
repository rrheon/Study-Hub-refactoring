
import UIKit
import SafariServices

import SnapKit
import RxCocoa

final class MyParticipateStudyVC: CommonNavi{
  let viewModel: MyParticipateStudyViewModel
  
  private lazy var totalPostCountLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var deleteAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체삭제", for: .normal)
    button.setTitleColor(UIColor.bg70, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    button.addAction(UIAction { _ in
      self.confirmDeleteAll()
    },for: .touchUpInside)
    return button
  }()
  
  private lazy var emptyImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MyParticipateEmptyImage")
    return imageView
  }()
  
  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "참여한 스터디가 없어요\n나와 맞는 스터디를 찾아 보세요!"
    label.numberOfLines = 0
    label.textColor = .bg70
    return label
  }()
  
  private lazy var participateCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .bg30
    return scrollView
  }()
  
  
  init(_ userData: BehaviorRelay<UserDetailData?>) {
    self.viewModel = MyParticipateStudyViewModel(userData)
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
    
    setupLayout()
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    [
      totalPostCountLabel,
      deleteAllButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    totalPostCountLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    deleteAllButton.snp.makeConstraints { make in
      make.top.equalTo(totalPostCountLabel)
      make.trailing.equalToSuperview().offset(-20)
      make.centerY.equalTo(totalPostCountLabel)
    }
  }
  
  private func registerCell() {
    participateCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    
    participateCollectionView.register(
      MyParticipateCell.self,
      forCellWithReuseIdentifier: MyParticipateCell.id
    )
  }
  
  func setupBinding(){
    viewModel.participateInfo
      .asDriver(onErrorJustReturn: [])
      .drive(participateCollectionView.rx.items(
        cellIdentifier: MyParticipateCell.id,
        cellType: MyParticipateCell.self)
      ) { index , content , cell in
        cell.model = content
        cell.delegate = self
        cell.contentView.isUserInteractionEnabled = false
      }.disposed(by: viewModel.disposeBag)
    
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
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    viewModel.isSuccessToDelete
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: {[weak self] result in
        switch result {
        case true:
          self?.showToast(message: "삭제가 완료됐어요.", imageCheck: true, alertCheck: true)
        case false:
          return
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - setupNavigationbar
  
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "참여한 스터디")
    leftButtonSetting()
  }
  
  func confirmDeleteAll(){
    let popupVC = PopupViewController(
      title: "스터디를 모두 삭제할까요?",
      desc: "삭제하면 채팅방을 다시 찾을 수 없어요"
    )

    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)

      self.viewModel.deleteAllParticipateList()
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
  
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
      showToast(message: "해당 주소를 사용할 수 없어요")
      return
    }
    
    let chatLinkSafariView = SFSafariViewController(url: chatURL as URL)
    self.present(chatLinkSafariView, animated: true)
  }

  func deleteButtonTapped(in cell: MyParticipateCell, postID: Int) {
    let popupVC = PopupViewController(
      title: "이 스터디를 삭제할까요?",
      desc: "삭제하면 채팅방을 다시 찾을 수 없어요"
    )
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)
      
      self.viewModel.deleteParticipateList(studyID: postID)
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
}

extension MyParticipateStudyVC: CreateUIprotocol {}
