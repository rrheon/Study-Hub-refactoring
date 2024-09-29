
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
    setupBinding()
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
  
  
  func makeUI(_ count: Int) {
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
    
    if count == 0 {
      noParticipateLabel.isHidden = false
      noParticipateImageView.isHidden = false
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
  
  func setupBinding(){
    viewModel.applyUserData
      .asDriver(onErrorJustReturn: [])
      .drive(waitingCollectionView.rx.items(
        cellIdentifier: WaitCell.id,
        cellType: WaitCell.self
      )) { index, content, cell in
        cell.model = content
        cell.delegate = self
      }
      .disposed(by: viewModel.disposeBag)
    
    viewModel.applyUserData
      .asDriver(onErrorJustReturn: [])
      .drive(participateCollectionView.rx.items(
        cellIdentifier: ParticipateCell.id,
        cellType: ParticipateCell.self
      )) { index, content, cell in
        cell.model = content
      }
      .disposed(by: viewModel.disposeBag)
    
    viewModel.applyUserData
      .asDriver(onErrorJustReturn: [])
      .drive(refuseCollectionView.rx.items(
        cellIdentifier: RefusePersonCell.id,
        cellType: RefusePersonCell.self
      )) { index, content, cell in
        cell.model = content
      }
      .disposed(by: viewModel.disposeBag)
    
    viewModel.totalCount
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        self?.setupLayout()
        self?.makeUI(count)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - collectionView
  
  
  private func setupCollectionView(
    _ collectionView: UICollectionView,
    tag: Int,
    cellType: UICollectionViewCell.Type,
    cellIdentifier: String
  ) {
    collectionView.tag = tag
    collectionView.delegate = self
    collectionView.register(cellType, forCellWithReuseIdentifier: cellIdentifier)
    //    collectionView.rx
    //      .setDelegate(self)
    //      .disposed(by: viewModel.disposeBag)
  }
  
  private func registerCell() {
    setupCollectionView(
      waitingCollectionView,
      tag: 1,
      cellType: WaitCell.self,
      cellIdentifier: WaitCell.id
    )
    
    setupCollectionView(
      participateCollectionView,
      tag: 2,
      cellType: ParticipateCell.self,
      cellIdentifier: ParticipateCell.id
    )
    
    setupCollectionView(
      refuseCollectionView,
      tag: 3,
      cellType: RefusePersonCell.self,
      cellIdentifier: RefusePersonCell.id
    )
  }
  
  
  // MARK: - setupNavigationbar
  
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "참여자")
    leftButtonSetting()
  }
  
  //  func participateTypeButton(type: SettinInspection, collectionView: UICollectionView){
  //    setting = type
  //    settingValue = setting.description
  //
  //    getParticipateInfo(type: settingValue) { [weak self] in
  //      if self?.applyUserData?.applyUserData.content.count == 0 {
  //        collectionView.isHidden = true
  //
  //        if self?.settingValue == "ACCEPT" {
  //          self?.noParticipateLabel.text = "참여 중인 팀원이 없어요."
  //        } else if self?.settingValue == "REJECT" {
  //          self?.noParticipateLabel.text = "회원님이 거절한 참여자가 없어요."
  //        } else {
  //          self?.noParticipateLabel.text = "참여를 기다리는 대기자가 없어요."
  //        }
  //        self?.noParticipateLabel.isHidden = false
  //        self?.noParticipateImageView.isHidden = false
  //      } else {
  //        self?.noParticipateLabel.isHidden = true
  //        self?.noParticipateImageView.isHidden = true
  //
  //        collectionView.isHidden = false
  //        collectionView.reloadData()
  //      }
  //    }
  //  }
  
  // MARK: - 대기인원버튼
  func waitButtonTapped(){
    waitButton.resetUnderline()
    
    self.refuseButton.removeUnderline()
    self.participateButton.removeUnderline()
    
    waitingCollectionView.isHidden = false
    participateCollectionView.isHidden = true
    refuseCollectionView.isHidden = true
    
    //    participateTypeButton(type: .standby, collectionView: waitingCollectionView)
  }
  
  // MARK: - 참여인원 버튼
  func participateButtonTapped(){
    participateButton.resetUnderline()
    
    self.refuseButton.removeUnderline()
    self.waitButton.removeUnderline()
    
    waitingCollectionView.isHidden = true
    participateCollectionView.isHidden = false
    refuseCollectionView.isHidden = true
    
    
    //    participateTypeButton(type: .accept, collectionView: participateCollectionView)
  }
  
  // MARK: - 거절된 인원버튼
  func refusetButtonTapped(){
    refuseButton.resetUnderline()
    
    self.waitButton.removeUnderline()
    self.participateButton.removeUnderline()
    
    waitingCollectionView.isHidden = true
    participateCollectionView.isHidden = true
    refuseCollectionView.isHidden = false
    
    //    participateTypeButton(type: .reject, collectionView: refuseCollectionView)
  }
}


extension CheckParticipantsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView.tag {
    case 1:
      return CGSize(width: 350, height: 220)
    case 2:
      return CGSize(width: 335, height: 86)
    default:
      return CGSize(width: 335, height: 174)
    }
  }
}

// MARK: - bottomSheet


extension CheckParticipantsVC: ParticipantsCellDelegate {
  func refuseButtonTapped(in cell: WaitCell, userId: Int) {
    let bottomVC = RefuseBottomSheet()
    bottomVC.delegate = self
    bottomVC.userId = userId
    
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
    
    //    popupVC.popupView.rightButtonAction = { [weak self] in
    //      guard let self = self else { return }
    //
    //      let personData = AcceptStudy(rejectedUserId: userId,
    //                                   studyId: self.studyID)
    //      self.participateManager.acceptApplyUser(personData: personData) {
    //        popupVC.dismiss(animated: true)
    //        self.showToast(message: "수락이 완료됐어요", alertCheck: true)
    //        self.waitButtonTapped()
    //      }
    //    }
  }
}

// MARK: - 거절(기타사유)로 할 경우 화면이동


extension CheckParticipantsVC: RefuseBottomSheetDelegate {
  func rejectPerson(_ reason: String, _ userId: Int){
    //    let personData = RejectStudy(
    //      rejectReason: reason,
    //      rejectedUserId: userId,
    //      studyId: studyID
    //    )
    //
    //    participateManager.rejectApplyUser(personData: personData) {
    //      self.showToast(message: "거절이 완료됐어요", alertCheck: true)
    //      self.waitButtonTapped()
    //    }
  }
  
  func didTapRefuseButton(withReason reason: String, reasonNum: Int, userId: Int) {
    if reasonNum == 3 {
      let refuseWriteVC = WriteRefuseReasonVC()
      refuseWriteVC.delegate = self
      refuseWriteVC.userId = userId
      
      if let navigationController = self.navigationController {
        navigationController.pushViewController(refuseWriteVC, animated: true)
      } else {
        self.present(refuseWriteVC, animated: true, completion: nil)
      }
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
