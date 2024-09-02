import UIKit

import SnapKit
import RxSwift
import RxCocoa

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
    let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod))
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
    
    [
      pageStackView
    ].forEach {
      scrollView.addSubview($0)
    }
    
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
      $0.height.equalTo(480)
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
    settingNavigationTitle(title: "게시글 작성하기")
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
  }

  @objc func departmentArrowButtonTapped() {
    let departmentselectVC = DepartmentselectViewController()
    departmentselectVC.previousVC = self
    
    if let navigationController = self.navigationController {
      navigationController.pushViewController(departmentselectVC, animated: true)
    } else {
      let navigationController = UINavigationController(rootViewController: departmentselectVC)
      navigationController.modalPresentationStyle = .fullScreen
      present(navigationController, animated: true, completion: nil)
    }
  }
}

// MARK: - textField 0 입력 시
//extension CreateStudyViewController {
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
//    self.view.endEditing(true)
//  }
//  
//  func textViewDidChange(_ textView: UITextView) {
//    if textView == studyProduceTextView {
//      checkButtonActivation()
//      updateTextViewHeight()
//    }
//  }
//  
//  private func updateTextViewHeight() {
//    let fixedWidth = studyProduceTextView.frame.size.width
//    let newSize = studyProduceTextView.sizeThatFits(CGSize(width: fixedWidth,
//                                                           height: CGFloat.greatestFiniteMagnitude))
//    let newHeight = max(newSize.height, 170)
//    studyProduceTextView.delegate = self
//    studyProduceTextView.constraints.forEach { constraint in
//      if constraint.firstAttribute == .height {
//        constraint.constant = newHeight
//      }
//    }
//  }
//  
//  @objc func textFieldDidChange(_ textField: UITextField) {
//    let monitoredTextFields: [UITextField] = [
//      chatLinkTextField,
//      studymemberTextField,
//      studytitleTextField,
//      fineAmountTextField,
//      fineTypesTextField
//    ]
//    
//    if monitoredTextFields.contains(textField) {
//      checkButtonActivation()
//    }
//  }
//  
//  
//  
//  override func textFieldDidEndEditing(_ textField: UITextField) {
//    if textField == fineAmountTextField {
//      if let text = fineAmountTextField.text,
//         let number = Int(text),
//         number >= 99999 {
//        fineAmountTextField.text = "99999"
//      }
//    }
//    
//    if textField == studymemberTextField,
//       let text = textField.text,
//       let number = Int(text),
//       !(2...50).contains(number){
//      countAlert.isHidden = false
//      studymemberTextField.layer.borderColor = UIColor.r50.cgColor
//      
//      scrollView.addSubview(countAlert)
//      
//      countAlert.snp.makeConstraints { make in
//        make.top.equalTo(studymemberTextField.snp.bottom)
//        make.leading.equalTo(studymemberTextField)
//      }
//      studymemberTextField.text = ""
//    }
//    else {
//      studymemberTextField.layer.borderColor = UIColor.bg50.cgColor
//      
//      countAlert.isHidden = true
//    }
//  }
//}
//
//// MARK: - 캘린더에서 선택한 날짜로 바꿈
//extension CreateStudyViewController: ChangeDateProtocol {
//  func dataSend(data: String, buttonTag: Int) {
//    if buttonTag == 1 {
//      startDateButton.setTitle(data, for: .normal)
//      self.startDateCheck = data
//    } else if buttonTag == 2 {
//      endDateButton.setTitle(data, for: .normal)
//      self.endDateCheck = data
//    }
//  }
//}
