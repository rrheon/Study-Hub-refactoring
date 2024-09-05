import UIKit

import SnapKit
import RxSwift
import RxCocoa

// 전처리
#if DEBUG

import SwiftUI
@available(iOS 13.0, *)

// UIViewControllerRepresentable을 채택
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    // _ uiViewController: UIViewController로 지정
    func updateUIViewController(_ uiViewController: UIViewController , context: Context) {
        
    }
    // makeui
    func makeUIViewController(context: Context) -> UIViewController {
    // Preview를 보고자 하는 Viewcontroller 이름
    // e.g.)
      var test = PublishRelay<String>()

      return CreateStudyViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    
    @available(iOS 13.0, *)
    static var previews: some View {
        // UIViewControllerRepresentable에 지정된 이름.
        ViewControllerRepresentable()

// 테스트 해보고자 하는 기기
            .previewDevice("iPhone 11")
    }
}
#endif

// postedVC에서 옵저버블 하나 받기
// 날짜 선택하는 거 수정 -> 날짜 선택 버튼 탭 -> viewmodel에서 반응 -> vc에서 바텀시트 띄어서 처리 -> viewmodel로 날짜받음-> 각 view에 적용
// 스크롤할 때 네비게이션 바 색상 변경 이슈있음
protocol AfterCreatePost: AnyObject {
  func afterCreatePost(postId: Int)
}

// 캘린더 커스텀하기, 캘린더 선택 버튼 수정
final class CreateStudyViewController: CommonNavi {
  let viewModel: CreateStudyViewModel

  private var studyInfoView: StudyInfoView
  private var seletMajorView: SelectMajorView
  private var studyMemeberView: StudyMemberView
  private var studyWayView: StudyWayView
  private var studyPeroioudView: StudyPeriodView
  
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  
  let scrollView = UIScrollView()
  
  init(_ postedData: PostDetailData? = nil){
    self.viewModel = CreateStudyViewModel(postedData)
    self.studyInfoView = StudyInfoView(viewModel)
    self.seletMajorView = SelectMajorView(viewModel)
    self.studyMemeberView = StudyMemberView(viewModel)
    self.studyWayView = StudyWayView(viewModel)
    self.studyPeroioudView = StudyPeriodView(viewModel)

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
        
    setUpLayout()
    makeUI()
    
    setupBinding()
    
    setScrollViewSingTap()
  }
  
  func setScrollViewSingTap(){
    let singleTapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(myTapMethod)
    )
    singleTapGestureRecognizer.numberOfTapsRequired = 1
    singleTapGestureRecognizer.isEnabled = true
    singleTapGestureRecognizer.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(singleTapGestureRecognizer)
  }
  
  @objc func myTapMethod(sender: UITapGestureRecognizer) {self.view.endEditing(true)}
  
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
    leftButtonSetting()
    settingNavigationTitle(title: "스터디 만들기")
  }
  
  // MARK: - setupBinding
  
  func setupBinding() {
    viewModel.postedData
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] postData in
        guard let data = postData else { return }
//        self?.postModify(data)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isMoveToSeletMajor
      .subscribe(onNext: { [weak self] _ in
        self?.departmentArrowButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.seletedMajor
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] _ in
        guard let self = self else { return }

        self.seletMajorView.snp.updateConstraints {
          $0.height.equalTo(100)
        }
        uiAnimation()
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isFineButton
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self]  in
        guard let self = self else { return }
        let height = $0 ? 450 : 230
        self.studyWayView.snp.updateConstraints {
          $0.height.equalTo(height)
        }
        uiAnimation()
      })
      .disposed(by: viewModel.disposeBag)
    
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
        .disposed(by: viewModel.disposeBag)
    }
  }

  @objc func departmentArrowButtonTapped() {
    let departmentselectVC = SeletMajorViewController(seletedMajor: viewModel.seletedMajor)
    
    if let navigationController = self.navigationController {
      navigationController.pushViewController(departmentselectVC, animated: true)
    } else {
      let navigationController = UINavigationController(rootViewController: departmentselectVC)
      navigationController.modalPresentationStyle = .fullScreen
      present(navigationController, animated: true, completion: nil)
    }
  }
  
  func uiAnimation(){
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func calendarButtonTapped() {
    let calendarVC = CalendarViewController(viewModel: viewModel)

    showBottomSheet(bottomSheetVC: calendarVC, size: 400.0)
    self.present(calendarVC, animated: true, completion: nil)
  }
}

extension CreateStudyViewController: ShowBottomSheet{}
