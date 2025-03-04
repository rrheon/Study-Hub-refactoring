
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 문의하기 VC
final class InquiryViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
 
  let viewModel: InquiryViewModel
  
  /// 문의사항 제목 라벨
  private lazy var titleLabel = UILabel().then{
    $0.text = "제목"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 문의사항 제목 입력 TextField
  private lazy var titleTextField = StudyHubUI.createTextField(title: "제목을 입력해주세요")
  
  /// 문의사항 내용 라벨
  private lazy var contentLabel = UILabel().then{
    $0.text = "내용"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 문의사항 입력 TextView
  private let initialContent = "이용하며 생긴 불편한 점이나 궁금한 점을 자세하게 적어주시면 빠르게 도움을 드릴게요"
  private lazy var contentTextView: UITextView = UITextView().then {
    $0.text = initialContent
    $0.textColor = .bg70
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.bg50.cgColor
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    $0.delegate = self
  }
  
  /// 이메일 라벨
  private lazy var emailLabel = UILabel().then{
    $0.text = "이메일"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 이메일 입력 TextField
  private lazy var emailTextField = StudyHubUI.createTextField(title: "답변을 받으실 이메일을 입력해주세요")
  
  /// 문의하기버튼
  private lazy var inquiryButton = StudyHubButton(title: "문의하기")
  
  
  init(with viewModel: InquiryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewdidload
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  // MARK: - setupNavigationbar
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "문의하기")
    leftButtonSetting()
    settingNavigationbar()
  }
  
  /// 네비게이션 바 왼쪽 버튼 탭 - 현재화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: true, animate: true))
  }

  // MARK: - makeUI
  
  /// UI 설정
  func makeUI(){
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    view.addSubview(titleTextField)
    titleTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    view.addSubview(contentLabel)
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    view.addSubview(contentTextView)
    contentTextView.delegate = self
    contentTextView.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(170)
    }
    
    view.addSubview(emailLabel)
    emailLabel.snp.makeConstraints {
      $0.top.equalTo(contentTextView.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    view.addSubview(emailTextField)
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(emailLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    view.addSubview(inquiryButton)
    inquiryButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  /// 바인딩 설정
  func setupBinding(){
    titleTextField.rx.text.orEmpty
      .bind(to: viewModel.titleValue)
      .disposed(by: disposeBag)
    
    contentTextView.rx.text.orEmpty
      .bind(to: viewModel.contentValue)
      .disposed(by: disposeBag)
    
    emailTextField.rx.text.orEmpty
      .bind(to: viewModel.emailValue)
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    inquiryButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.viewModel.inquiryToServer()
      })
      .disposed(by: disposeBag)
    
    viewModel.isSuccessToInquiry
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [ weak self] result in
        switch result {
        case true:
          self?.navigationController?.popViewController(animated: true)
          ToastPopupManager.shared.showToast(message: "문의가 정상적으로 접수됐어요.")
        case false:
          return
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.isInquiryButtonEnable
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        self?.inquiryButton.unableButton($0, backgroundColor: .o30, titleColor: .white)
      })
      .disposed(by: disposeBag)
  }
  
  override func textViewDidBeginEditing(_ textView: UITextView) {
    didBeginEditing(view: textView)
  }
  
  override func textViewDidEndEditing(_ textView: UITextView) {
    didEndEditing(
      view: textView,
      placeholderText: initialContent
    )
  }
}

extension InquiryViewController: EditableViewProtocol {}
