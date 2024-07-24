//
//  CheckParticipantsVC.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/24.
//

import UIKit

import SnapKit

final class CheckParticipantsVC: NaviHelper {
  let participateManager = ParticipateManager.shared
  let myReqeustManager = MyRequestManager.shared
  var studyID: Int = 0
  var setting: SettinInspection = .standby
  lazy var settingValue = setting.description
  
  var applyUserData: TotalApplyUserData?
  
  private lazy var topItemStackView = createStackView(axis: .horizontal,
                                                      spacing: 10)
  private lazy var waitButton: UIButton = {
    let button = UIButton()
    button.setTitle("대기", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setUnderline()
    button.addAction(UIAction { [weak self] _ in
      self?.waitButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var participateButton: UIButton = {
    let button = UIButton()
    button.setTitle("참여", for: .normal)
    button.setTitleColor(UIColor.bg70, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setUnderline()
    button.removeUnderline()
    button.addAction(UIAction { [weak self] _ in
      self?.participateButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var refuseButton: UIButton = {
    let button = UIButton()
    button.setTitle("거절", for: .normal)
    button.setTitleColor(UIColor.bg70, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setUnderline()
    button.removeUnderline()
    button.addAction(UIAction { [weak self] _ in
      self?.refusetButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  // MARK: - 참여자 있을 때
  private lazy var waitingCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
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
  
  private lazy var refuseCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  // MARK: - 참여자 없을 때
  private lazy var noParticipateImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "EmptyWaitIamge")
    return imageView
  }()

  private lazy var noParticipateLabel = createLabel(title: "참여를 기다리는 대기자가 없어요.",
                                                    textColor: .bg60,
                                                    fontType: "Pretendard-SemiBold",
                                                    fontSize: 16)
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .bg30
    return scrollView
  }()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
    
    getParticipateInfo(type: settingValue.description) {
      DispatchQueue.main.async {
        self.setupLayout()
        self.makeUI()
        
        self.registerCell()
      }
    }
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
      $0.top.equalToSuperview().offset(10)
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
    
    if self.applyUserData?.applyUserData.content.count == 0 {
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
  
  // MARK: - collectionView
  private func registerCell() {
    waitingCollectionView.tag = 1
    waitingCollectionView.delegate = self
    waitingCollectionView.dataSource = self
    waitingCollectionView.register(WaitCell.self,
                                   forCellWithReuseIdentifier: WaitCell.id)
    
    participateCollectionView.tag = 2
    participateCollectionView.delegate = self
    participateCollectionView.dataSource = self
    participateCollectionView.register(ParticipateCell.self,
                                       forCellWithReuseIdentifier: ParticipateCell.id)
    
    refuseCollectionView.tag = 3
    refuseCollectionView.delegate = self
    refuseCollectionView.dataSource = self
    refuseCollectionView.register(RefusePersonCell.self,
                                  forCellWithReuseIdentifier: RefusePersonCell.id)
  }
  
  // MARK: - 네비게이션바 재설정
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItems = .none
    settingNavigationTitle(title: "참여자",
                           font: "Pretendard-Bold",
                           size: 18)
  }
  
  // MARK: - 참여자 데이터 가져오기
  func getParticipateInfo(type: String,
                          completion: @escaping () -> Void){
    participateManager.getApplyUserData(inspection: type,
                                        page: 0,
                                        size : 50,
                                        studyID) { result in
      self.applyUserData = result
    
      completion()
    }
  }
  
  func participateTypeButton(type: SettinInspection,
                             collectionView: UICollectionView){
    setting = type
    settingValue = setting.description
    
    getParticipateInfo(type: settingValue) { [weak self] in
      if self?.applyUserData?.applyUserData.content.count == 0 {
        collectionView.isHidden = true
        
        if self?.settingValue == "ACCEPT" {
          self?.noParticipateLabel.text = "참여 중인 팀원이 없어요."
        } else if self?.settingValue == "REJECT" {
          self?.noParticipateLabel.text = "회원님이 거절한 참여자가 없어요."
        } else {
          self?.noParticipateLabel.text = "참여를 기다리는 대기자가 없어요."
        }
        self?.noParticipateLabel.isHidden = false
        self?.noParticipateImageView.isHidden = false
      } else {
        self?.noParticipateLabel.isHidden = true
        self?.noParticipateImageView.isHidden = true
        
        collectionView.isHidden = false
        collectionView.reloadData()
      }
    }
  }
  
  // MARK: - 대기인원버튼
  func waitButtonTapped(){
    waitButton.resetUnderline()

    self.refuseButton.removeUnderline()
    self.participateButton.removeUnderline()
    
    waitingCollectionView.isHidden = false
    participateCollectionView.isHidden = true
    refuseCollectionView.isHidden = true
    
    participateTypeButton(type: .standby,
                          collectionView: waitingCollectionView)
  }
  
  // MARK: - 참여인원 버튼
  func participateButtonTapped(){
    participateButton.resetUnderline()

    self.refuseButton.removeUnderline()
    self.waitButton.removeUnderline()
    
    waitingCollectionView.isHidden = true
    participateCollectionView.isHidden = false
    refuseCollectionView.isHidden = true
    
 
    participateTypeButton(type: .accept,
                          collectionView: participateCollectionView)
  }
  
  // MARK: - 거절된 인원버튼
  func refusetButtonTapped(){
    refuseButton.resetUnderline()

    self.waitButton.removeUnderline()
    self.participateButton.removeUnderline()
  
    waitingCollectionView.isHidden = true
    participateCollectionView.isHidden = true
    refuseCollectionView.isHidden = false
    
    participateTypeButton(type: .reject,
                          collectionView: refuseCollectionView)
  }
}

// MARK: - CollectionView
extension CheckParticipantsVC: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return applyUserData?.applyUserData.numberOfElements ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell {
    if collectionView.tag == 1 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitCell.id,
                                                    for: indexPath) as! WaitCell
      cell.delegate = self
    
      if let content = applyUserData?.applyUserData.content {
        cell.model = content
      }
      print(cell.model)
      return cell

    } else if collectionView.tag == 2{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParticipateCell.id,
                                                    for: indexPath) as! ParticipateCell
      
      if let content = applyUserData?.applyUserData.content {
        cell.model = content
      }
      print(cell.model)

      return cell

    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RefusePersonCell.id,
                                                    for: indexPath) as! RefusePersonCell
      if let content = applyUserData?.applyUserData.content {
        cell.model = content
      }
      print(cell.model)

      return cell
    }
  }
}

// 셀의 각각의 크기
extension CheckParticipantsVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.tag == 1 {
      return CGSize(width: 350, height: 220)
    } else if collectionView.tag == 2 {
      return CGSize(width: 335, height: 86)
    } else {
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
    
    if #available(iOS 15.0, *) {
      if let sheet = bottomVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return 387
          })]
        } else {
          // Fallback on earlier versions
        }
        sheet.largestUndimmedDetentIdentifier = nil
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheet.preferredCornerRadius = 20
      }
    } else {
      // Fallback on earlier versions
    }
    present(bottomVC, animated: true, completion: nil)
  }
  
  // MARK: - 수락버튼
  func acceptButtonTapped(in cell: WaitCell, userId: Int) {
    let popupVC = PopupViewController(title: "이 신청자를 수락할까요?",
                                      desc: "수락 후,취소가 어려워요",
                                      leftButtonTitle: "아니요",
                                      rightButtonTilte: "수락")
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = { [weak self] in
      guard let self = self else { return }
    
      let personData = AcceptStudy(rejectedUserId: userId,
                                   studyId: self.studyID)
      self.participateManager.acceptApplyUser(personData: personData) {
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
    let personData = RejectStudy(rejectReason: reason,
                                 rejectedUserId: userId,
                                 studyId: studyID)
    print(personData)
    participateManager.rejectApplyUser(personData: personData) {
      self.showToast(message: "거절이 완료됐어요", alertCheck: true)
      self.waitButtonTapped()

    }
  }
  
  func didTapRefuseButton(withReason reason: String,
                          reasonNum: Int,
                          userId: Int) {
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
