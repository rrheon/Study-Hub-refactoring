import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class CreateStudyViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: CreateStudyViewModel

  private var studyInfoView: StudyInfoView
  private var seletMajorView: SelectMajorView
  private var studyMemeberView: StudyMemberView
  private var studyWayView: StudyWayView
  private var studyPeroioudView: StudyPeriodView
  
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  
  let scrollView = UIScrollView()
  
  init(postedData: BehaviorRelay<PostDetailData?>? = nil, mode: PostActionList) {
    self.viewModel = CreateStudyViewModel(postedData, mode: mode)
    self.studyInfoView = StudyInfoView(viewModel)
    self.seletMajorView = SelectMajorView(viewModel)
    self.studyMemeberView = StudyMemberView(viewModel)
    self.studyWayView = StudyWayView(viewModel)
    self.studyPeroioudView = StudyPeriodView(viewModel)

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
    
    setUpLayout()
    makeUI()
    
    setupBinding()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      studyInfoView,
      seletMajorView,
      studyMemeberView,
      studyWayView,
      studyPeroioudView
    ].forEach {
      pageStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(pageStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    studyInfoView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(33)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(550)
    }
    
    seletMajorView.snp.makeConstraints {
      $0.top.equalTo(studyInfoView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(80)
    }
    
    studyMemeberView.snp.makeConstraints {
      $0.top.equalTo(seletMajorView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(354)
    }
    
    studyWayView.snp.makeConstraints {
      $0.top.equalTo(studyMemeberView.snp.bottom).offset(11)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(230)
    }
    
    studyPeroioudView.snp.makeConstraints {
      $0.top.equalTo(studyWayView.snp.bottom).offset(11)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(440)
    }
    
    pageStackView.snp.makeConstraints {
     $0.top.equalTo(scrollView.contentLayoutGuide)
     $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
     $0.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }
  
  func setupNavigationbar() {
    let navigationTitle = viewModel.postedData.value == nil ? "스터디 만들기" : "수정하기"
    leftButtonSetting()
    settingNavigationTitle(title: navigationTitle)
  }
  
  func leftButtonTapped(_ sender: UIBarButtonItem) {
    guard let _ = viewModel.postedData.value else {
      return
    }
    
//    viewModel.comparePostData() ? super.leftButtonTapped(sender) : backButtonTapped()
  }

  
  // MARK: - setupBinding
  
  func setupBinding() {
    viewModel.isMoveToSeletMajor
      .subscribe(onNext: { [weak self] _ in
        self?.departmentArrowButtonTapped()
      })
      .disposed(by: disposeBag)
    
    viewModel.selectedMajor
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self]  in
        guard let self = self else { return }
        let height = (($0?.isEmpty) != nil) ? 120 : 80
        self.seletMajorView.snp.updateConstraints {
          $0.height.equalTo(height)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.isFineButton
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self]  in
        guard let self = self else { return }
        let height = $0 ? 450 : 230
        self.studyWayView.snp.updateConstraints {
          $0.height.equalTo(height)
        }
      })
      .disposed(by: disposeBag)
    
    [
      viewModel.isStartDateButton,
      viewModel.isEndDateButton
    ].forEach {
      $0.asDriver(onErrorJustReturn: false)
        .drive(onNext: { [weak self] in
          if $0 {
            self?.calendarButtonTapped()
          }
        })
        .disposed(by: disposeBag)
    }
    
    viewModel.isSuccessCreateStudy
      .subscribe(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: false)
      })
      .disposed(by: disposeBag)
    
    viewModel.isSuccessModifyStudy
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.navigationController?.popViewController(animated: true)
        self.showToast(message: "글이 수정됐어요.", alertCheck: true)
      })
      .disposed(by: disposeBag)
  }

  @objc func departmentArrowButtonTapped() {
    let departmentselectVC = SeletMajorViewController(seletedMajor: viewModel.selectedMajor)
    
//    if let navigationController = self.navigationController {
//      navigationController.pushViewController(departmentselectVC, animated: true)
//    } else {
//      let navigationController = UINavigationController(rootViewController: departmentselectVC)
//      navigationController.modalPresentationStyle = .fullScreen
//      present(navigationController, animated: true, completion: nil)
//    }
  }
  
  @objc func calendarButtonTapped() {
    let calendarVC = CalendarViewController(viewModel: viewModel)

    showBottomSheet(bottomSheetVC: calendarVC, size: 400.0)
    self.present(calendarVC, animated: true, completion: nil)
  }
  
  func backButtonTapped(){
    self.view.endEditing(true)
    
    let popupVC = PopupViewController(
      title: "수정을 취소할까요?",
      desc: "취소할 시 내용이 저장되지 않아요",
      leftButtonTitle: "아니요",
      rightButtonTilte: "네"
    )
    popupVC.modalPresentationStyle = .overFullScreen
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: false) {
        self.navigationController?.popViewController(animated: true)
      }
    }
    self.present(popupVC, animated: true)
  }
}

extension CreateStudyViewController: ShowBottomSheet{}
extension CreateStudyViewController: CreateUIprotocol {}
