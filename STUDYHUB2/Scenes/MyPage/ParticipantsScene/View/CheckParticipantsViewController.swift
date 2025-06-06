
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// StudyHub - front - StudyAttendeesScreen
/// - 스터디 참가자 확인 화면
/// - 종류 : 대기인원, 참여인원, 거절인원

final class CheckParticipantsViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: CheckParticipantsViewModel
  
  /// 상단 아이템 스택뷰
  /// - 대기 인원확인 버튼, 참여 인원 확인 버튼, 거절 인원확인 버튼
  private lazy var topItemStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  
  /// 대기 인원 확인 버튼
  private lazy var waitButton = createUIButton(title: "대기", titleColor: .black, underLine: true)

  /// 대기인원 Collection View
  private lazy var waitingCollectionView = createUICollectionView()

  /// 참여 인원 확인 버튼
  private lazy var participateButton = createUIButton(title: "참여")
  
  /// 참여인원 CollectionView
  private lazy var participateCollectionView = createUICollectionView()
  
  /// 거절 인원 확인 버튼
  private lazy var refuseButton = createUIButton(title: "거절")
  
  /// 거절인원  CollectionView
  private lazy var refuseCollectionView = createUICollectionView()
  
  private lazy var noParticipateImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "EmptyWaitIamge")
  }
  
  /// 참여자가 없을 때의 라벨
  private lazy var noParticipateLabel = UILabel().then {
    $0.text = "참여를 기다리는 대기자가 없어요."
    $0.textColor = .bg60
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  private let scrollView: UIScrollView = UIScrollView().then{
    $0.backgroundColor = .bg30
  }
 
  
  init(with viewModel: CheckParticipantsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
  } // viewDidLoad
  
  /// 참여,거절,대기 인원 확인 버튼 생성
  /// - Parameters:
  ///   - title: 버튼 제목
  ///   - titleColor: 버튼 색상 - 기본 bg70
  ///   - underLine: 버튼 아래 밑줄 여부
  func createUIButton(title: String, titleColor: UIColor = .bg70, underLine: Bool = false) -> UIButton{
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
  
  /// 참여,거절,대기 인원 확인 collectionView 생성
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
  
  /// layout 설정
  func setupLayout(){
    /// 상단 버튼 스택뷰 - 대기, 참여, 거절인원 확인 버튼
    [ waitButton, participateButton, refuseButton ]
      .forEach { topItemStackView.addArrangedSubview($0) }
    
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
    
    [ topItemStackView, scrollView ]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  
  /// UI 설정
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
  
  
  /// 바인딩 설정
  func setupBinding(){
    /// 대기인원 데이터
    viewModel.studyUserData
      .asDriver(onErrorJustReturn: [])
      .drive(self.waitingCollectionView.rx.items(
        cellIdentifier: WaitCell.cellID,
        cellType: WaitCell.self
      )) { index, content, cell in
        cell.model = content
        cell.delegate = self
      }
      .disposed(by: disposeBag)
    
    /// 참여인원 데이터
    viewModel.studyUserData
      .asDriver(onErrorJustReturn: [])
      .drive(self.participateCollectionView.rx.items(
        cellIdentifier: ParticipateCell.cellID,
        cellType: ParticipateCell.self
      )) { index, content, cell in
        cell.model = content
      }
      .disposed(by: self.disposeBag)
    
    /// 거절인원 데이터
    viewModel.studyUserData
      .asDriver(onErrorJustReturn: [])
      .drive(self.refuseCollectionView.rx.items(
        cellIdentifier: RefusePersonCell.cellID,
        cellType: RefusePersonCell.self
      )) { index, content, cell in
        cell.model = content
      }
      .disposed(by: self.disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    /// 총 인원 수
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
      .disposed(by: disposeBag)
    
    // 대기인원 버튼
    waitButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        self?.waitButtonTapped()
      })
      .disposed(by: disposeBag)
    
    // 참여인원 버튼
    participateButton.rx.tap
      .asDriver()
      .drive(onNext: { [weak self] in
        self?.participateButtonTapped()
      })
      .disposed(by: disposeBag)
    
    // 거절인원 버튼
    refuseButton.rx.tap
      .asDriver()
      .drive(onNext: {[weak self] in
        self?.refuseButtonTapped()
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - setupcollectionView
  
  /// cell 등록
  private func registerCell() {
    waitingCollectionView.delegate = self
    waitingCollectionView.register(
      WaitCell.self,
      forCellWithReuseIdentifier: WaitCell.cellID
    )
    
    participateCollectionView.delegate = self
    participateCollectionView.register(
      ParticipateCell.self,
      forCellWithReuseIdentifier: ParticipateCell.cellID
    )
    
    refuseCollectionView.delegate = self
    refuseCollectionView.register(
      RefusePersonCell.self,
      forCellWithReuseIdentifier: RefusePersonCell.cellID
    )
  }
  
  // MARK: - 네비게이션 바 설정
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "참여자")
    leftButtonSetting()
    settingNavigationbar()
  }
  
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
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
  
  /// 대기인원 탭
  func waitButtonTapped() {
    handleButtonTap(
      selectedButton: waitButton,
      hiddenCollectionViews: [participateCollectionView, refuseCollectionView],
      visibleCollectionView: waitingCollectionView,
      type: .standby
    )
  }
  
  /// 참여한 인원 탭
  func participateButtonTapped() {
    handleButtonTap(
      selectedButton: participateButton,
      hiddenCollectionViews: [waitingCollectionView, refuseCollectionView],
      visibleCollectionView: participateCollectionView,
      type: .accept
    )
  }
  
  /// 거절된 인원 버튼 탭
  func refuseButtonTapped() {
    handleButtonTap(
      selectedButton: refuseButton,
      hiddenCollectionViews: [waitingCollectionView, participateCollectionView],
      visibleCollectionView: refuseCollectionView,
      type: .reject
    )
  }
  
  /// 인원이 없을 때 UI 설정
  func setupUI(){
    let status = viewModel.buttonStatus
  
    switch status {
    case .accept:    self.noParticipateLabel.text = "참여 중인 팀원이 없어요."
    case .reject:    self.noParticipateLabel.text = "회원님이 거절한 참여자가 없어요."
    case .standby:   self.noParticipateLabel.text = "참여를 기다리는 대기자가 없어요."
    }
  }
}


// MARK: - 셀 크기


extension CheckParticipantsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    switch collectionView {
    case waitingCollectionView:        return CGSize(width: 350, height: 220)
    case participateCollectionView:    return CGSize(width: 335, height: 86)
    case refuseCollectionView:         return CGSize(width: 335, height: 174)
    default:                           return CGSize(width: 0, height: 0)
    }
  }
}


// MARK: - bottomSheet

// 내가 작성한 게시글 cell
extension CheckParticipantsViewController: ParticipantsCellDelegate {
  /// 거절버튼 탭 -> 거절사유 선택
  func refuseButtonTapped(userId: Int) {
    viewModel.steps.accept(AppStep.studyManagement(.refuseBottomSheetIsRequired(userId: userId)))
  }
  
  /// 수락버튼 탭
  func acceptButtonTapped(userId: Int) {
    viewModel.userID = userId
    viewModel.steps.accept(AppStep.navigation(. popupScreenIsRequired(popupCase: .acceptParticipant)))
  }
}

// MARK: - 신청 거절

extension CheckParticipantsViewController: RefuseBottomSheetDelegate {
  /// 기타사유로 거절이 아닌 경우
  func rejectPerson(_ reason: String, _ userId: Int){
    viewModel.userID = userId
    
    viewModel.rejectPerson(reason: reason) {
      self.waitButtonTapped()
    }
  }
  
  /// 기타 사유로 거절할 경우 -> 사유 작성 화면으로 이동
  func didTapRefuseButton(withReason reason: String, reasonNum: Int, userId: Int) {
    if reasonNum == 3 {
      viewModel.steps.accept(AppStep.studyManagement(.writeRefuseReasonScreenIsRequired(userId: userId)))
    } else {
      rejectPerson(reason, userId)
    }
  }
}

// MARK: - 스터디 신청 거절하기

extension CheckParticipantsViewController: WriteRefuseReasonVCDelegate {
  func completeButtonTapped(reason: String, userId: Int) {
    rejectPerson(reason, userId)
  }
}

// MARK: - PopupView

extension CheckParticipantsViewController: PopupViewDelegate {
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()

    viewModel.acceptPerson(completion: {
      self.waitButtonTapped()
    })
}
}

