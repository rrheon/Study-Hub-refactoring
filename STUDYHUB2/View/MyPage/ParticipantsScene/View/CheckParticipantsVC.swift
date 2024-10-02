
import UIKit

import SnapKit
import RxCocoa

final class CheckParticipantsVC: CommonNavi {
  let viewModel: CheckParticipantsViewModel
  
  private lazy var topItemStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var waitButton = createUIButton(
    title: "대기",
    titleColor: .black,
    underLine: true
  )
  
  private lazy var participateButton = createUIButton(
    title: "참여",
    titleColor: .bg70,
    underLine: false
  )
  
  private lazy var refuseButton = createUIButton(
    title: "거절",
    titleColor: .bg70,
    underLine: false
  )
  
  private lazy var waitingCollectionView = createUICollectionView()
  private lazy var participateCollectionView = createUICollectionView()
  private lazy var refuseCollectionView = createUICollectionView()
  
  private lazy var noParticipateImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "EmptyWaitIamge")
    return imageView
  }()
  
  private lazy var noParticipateLabel = createLabel(
    title: "참여를 기다리는 대기자가 없어요.",
    textColor: .bg60,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .bg30
    return scrollView
  }()
  
  init(_ studyID: Int) {
    self.viewModel = CheckParticipantsViewModel(studyID)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    registerCell()
    
    setupLayout()
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  func createUIButton(title: String, titleColor: UIColor, underLine: Bool) -> UIButton{
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setUnderline()
    
    if !underLine {
      button.removeUnderline()
    }
    return button
  }
  
  func createUICollectionView() -> UICollectionView{
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    [
      waitButton,
      participateButton,
      refuseButton
    ].forEach {
      topItemStackView.addArrangedSubview($0)
    }
    
    [
      waitingCollectionView,
      participateCollectionView,
      refuseCollectionView,
      noParticipateImageView,
      noParticipateLabel
    ].forEach {
      scrollView.addSubview($0)
    }
    
    participateCollectionView.isHidden = true
    refuseCollectionView.isHidden = true
    noParticipateImageView.isHidden = true
    noParticipateLabel.isHidden = true
    
    [
      topItemStackView,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI() {
    topItemStackView.distribution = .fillEqually
    topItemStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    waitingCollectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.width.equalToSuperview()
      $0.height.equalTo(scrollView.snp.height)
    }
    
    participateCollectionView.snp.makeConstraints {
      $0.top.equalTo(waitingCollectionView.snp.top)
      $0.width.equalTo(waitingCollectionView.snp.width)
      $0.height.equalTo(waitingCollectionView.snp.height)
    }
    
    refuseCollectionView.snp.makeConstraints {
      $0.top.equalTo(waitingCollectionView.snp.top)
      $0.width.equalTo(waitingCollectionView.snp.width)
      $0.height.equalTo(waitingCollectionView.snp.height)
    }
    
    noParticipateImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-60)
    }
    
    noParticipateLabel.snp.makeConstraints {
      $0.top.equalTo(noParticipateImageView.snp.bottom).offset(40)
      $0.centerX.equalToSuperview()
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(topItemStackView.snp.bottom).offset(5)
      $0.leading.trailing.bottom.equalTo(view)
    }
  }
  
  // MARK: - setupBinding
  
  
  func setupBinding(){
    viewModel.waitingUserData
      .asDriver(onErrorJustReturn: [])
      .drive(self.waitingCollectionView.rx.items(
        cellIdentifier: WaitCell.id,
        cellType: WaitCell.self
      )) { index, content, cell in
        cell.model = content
        cell.delegate = self
      }
      .disposed(by: viewModel.disposeBag)
    
    viewModel.participateUserData
      .asDriver(onErrorJustReturn: [])
      .drive(self.participateCollectionView.rx.items(
        cellIdentifier: ParticipateCell.id,
        cellType: ParticipateCell.self
      )) { index, content, cell in
        cell.model = content
      }
      .disposed(by: self.viewModel.disposeBag)
    
    viewModel.refuseUserData
      .asDriver(onErrorJustReturn: [])
      .drive(self.refuseCollectionView.rx.items(
        cellIdentifier: RefusePersonCell.id,
        cellType: RefusePersonCell.self
      )) { index, content, cell in
        cell.model = content
      }
      .disposed(by: self.viewModel.disposeBag)
  }
  
  func setupActions(){
    viewModel.totalCount
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        
        let hidden = count == 0
        self?.noParticipateLabel.isHidden = !hidden
        self?.noParticipateImageView.isHidden = !hidden
        
        if count == 0 {
          self?.setupUI()
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    waitButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        self?.waitButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
    
    participateButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        self?.participateButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
    
    refuseButton.rx.tap
      .asDriver()
      .drive(onNext: {[weak self] in
        self?.refuseButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - setupcollectionView
  
  
  private func registerCell() {
    waitingCollectionView.delegate = self
    waitingCollectionView.register(
      WaitCell.self,
      forCellWithReuseIdentifier: WaitCell.id
    )
    
    participateCollectionView.delegate = self
    participateCollectionView.register(
      ParticipateCell.self,
      forCellWithReuseIdentifier: ParticipateCell.id
    )
    
    refuseCollectionView.delegate = self
    refuseCollectionView.register(
      RefusePersonCell.self,
      forCellWithReuseIdentifier: RefusePersonCell.id
    )
  }
  
  // MARK: - setupNavigationbar
  
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "참여자")
    leftButtonSetting()
  }
  
  
  // MARK: - 버튼 탭 공통 처리
  
  
  func handleButtonTap(
    selectedButton: UIButton,
    hiddenCollectionViews: [UICollectionView],
    visibleCollectionView: UICollectionView,
    type: ParticipateStatus
  ) {
    [
      waitButton,
      participateButton,
      refuseButton
    ].forEach {
      $0.removeUnderline()
    }
    
    selectedButton.resetUnderline()
    
    hiddenCollectionViews.forEach { $0.isHidden = true }
    visibleCollectionView.isHidden = false
    
    viewModel.getParticipateInfo(type: type)
  }
  
  func waitButtonTapped() {
    handleButtonTap(
      selectedButton: waitButton,
      hiddenCollectionViews: [participateCollectionView, refuseCollectionView],
      visibleCollectionView: waitingCollectionView,
      type: .standby
    )
  }
  
  func participateButtonTapped() {
    handleButtonTap(
      selectedButton: participateButton,
      hiddenCollectionViews: [waitingCollectionView, refuseCollectionView],
      visibleCollectionView: participateCollectionView,
      type: .accept
    )
  }
  
  func refuseButtonTapped() {
    handleButtonTap(
      selectedButton: refuseButton,
      hiddenCollectionViews: [waitingCollectionView, participateCollectionView],
      visibleCollectionView: refuseCollectionView,
      type: .reject
    )
  }
  
  func setupUI(){
    let status = viewModel.buttonStatus.description
  
    switch status {
    case "ACCEPT":
      self.noParticipateLabel.text = "참여 중인 팀원이 없어요."
    case "REJECT":
      self.noParticipateLabel.text = "회원님이 거절한 참여자가 없어요."
    default:
      self.noParticipateLabel.text = "참여를 기다리는 대기자가 없어요."
    }
  }
}

extension CheckParticipantsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case waitingCollectionView:
      return CGSize(width: 350, height: 220)
    case participateCollectionView:
      return CGSize(width: 335, height: 86)
    case refuseCollectionView:
      return CGSize(width: 335, height: 174)
    default:
      return CGSize(width: 0, height: 0)
    }
  }
}


// MARK: - bottomSheet


extension CheckParticipantsVC: ParticipantsCellDelegate {
  func refuseButtonTapped(in cell: WaitCell, userId: Int) {
    let bottomVC = RefuseBottomSheet(delegate: self, userId: userId)
    showBottomSheet(bottomSheetVC: bottomVC, size: 387.0)
    present(bottomVC, animated: true, completion: nil)
  }
  
  // MARK: - 수락버튼
  
  
  func acceptButtonTapped(in cell: WaitCell, userId: Int) {
    let popupVC = PopupViewController(
      title: "이 신청자를 수락할까요?",
      desc: "수락 후,취소가 어려워요",
      leftButtonTitle: "아니요",
      rightButtonTilte: "수락"
    )
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = { [weak self] in
      guard let self = self else { return }
      
      let personData = AcceptStudy(rejectedUserId: userId, studyId: viewModel.studyID)
      viewModel.participateManager.acceptApplyUser(personData: personData) {
        popupVC.dismiss(animated: true)
        self.showToast(message: "수락이 완료됐어요", alertCheck: true)
        self.waitButtonTapped()
      }
    }
  }
}

// MARK: - 거절(기타사유)로 할 경우 화면이동


extension CheckParticipantsVC: RefuseBottomSheetDelegate {
  func rejectPerson(_ reason: String, _ userId: Int){
    let personData = RejectStudy(
      rejectReason: reason,
      rejectedUserId: userId,
      studyId: viewModel.studyID
    )
    
    viewModel.participateManager.rejectApplyUser(personData: personData) {
      self.showToast(message: "거절이 완료됐어요", alertCheck: true)
      self.waitButtonTapped()
    }
  }
  
  func didTapRefuseButton(withReason reason: String, reasonNum: Int, userId: Int) {
    if reasonNum == 3 {
      let refuseWriteVC = WriteRefuseReasonVC(delegate: self, userId: userId)
      moveToOtherVCWithSameNavi(vc: refuseWriteVC, hideTabbar: false)
    } else {
      rejectPerson(reason, userId)
    }
  }
}

extension CheckParticipantsVC: WriteRefuseReasonVCDelegate {
  func completeButtonTapped(reason: String, userId: Int) {
    rejectPerson(reason, userId)
  }
}

extension CheckParticipantsVC: ShowBottomSheet {}
