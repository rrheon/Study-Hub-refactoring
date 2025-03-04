
import UIKit

import SnapKit
import RxSwift
import RxCocoa

/// 스터디 생성 VC
final class CreateStudyViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: CreateStudyViewModel

  /// 채팅방 링크, 스터디 제목, 스터디 소개 View
  private var studyInfoView: StudyInfoView
  
  /// 관련학과 선택 View
  private var seletMajorView: SelectMajorView
  
  /// 스터디 팀원 View
  private var studyMemeberView: StudyMemberView
  
  /// 스터디 방식 View
  private var studyWayView: StudyWayView
  
  /// 스터디 기간 View
  private var studyPeroioudView: StudyPeriodView
  
  /// 전체 StackView
  private lazy var pageStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
  
  let scrollView = UIScrollView()
  
  init(with viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    
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
  } // viewDidLoad
  
 
  // MARK: - setUpLayout
  
  func setUpLayout(){
    [ studyInfoView, seletMajorView, studyMemeberView, studyWayView, studyPeroioudView]
      .forEach { pageStackView.addArrangedSubview($0) }
    
    scrollView.addSubview(pageStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  
  ///UI 설정
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
  
  /// 네비게이션 바 세팅
  func setupNavigationbar() {
    let navigationTitle = viewModel.postedData.value == nil ? "스터디 만들기" : "수정하기"
    leftButtonSetting()
    settingNavigationTitle(title: navigationTitle)
    settingNavigationbar()
    
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    self.viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: true, animate: true))
#warning("수정하거나 작성하다가 나가면 경고창")
  }
  
  // MARK: - setupBinding
  
  /// 바인딩
  func setupBinding() {
    /// 학과가 선택된 경우
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
    
    /// 벌금 여부에 따른 UI 설정
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
  }
  
  
  // 뒤로가기 버튼 탭
  func backButtonTapped(){
    self.view.endEditing(true)
    
    viewModel.steps.accept(AppStep.popupScreenIsRequired(popupCase: .cancelModifyPost))
  }
}

// MARK: - PopupView Delgate


extension CreateStudyViewController: PopupViewDelegate {
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: true, animate: false))
  }
}
