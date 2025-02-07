
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class InquiryViewController: CommonNavi {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel = InquiryViewModel()
  
  private lazy var titleLabel = createLabel(
    title: "제목",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var titleTextField = createTextField(title: "제목을 입력해주세요")
  
  private lazy var contentLabel = createLabel(
    title: "내용",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private let initialContent = "이용하며 생긴 불편한 점이나 궁금한 점을 자세하게 적어주시면 빠르게 도움을 드릴게요"
  private lazy var contentTextView: UITextView = {
    let textView = UITextView()
    textView.text = initialContent
    textView.textColor = .bg70
    textView.layer.cornerRadius = 10
    textView.layer.borderWidth = 1
    textView.layer.borderColor = UIColor.bg50.cgColor
    textView.font = UIFont(name: "Pretendard-Medium", size: 14)
    textView.delegate = self
    return textView
  }()
  
  private lazy var emailLabel = createLabel(
    title: "이메일",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var emailTextField = createTextField(title: "답변을 받으실 이메일을 입력해주세요")
  
  private lazy var inquiryButton = StudyHubButton(title: "문의하기")
  
  // MARK: - viewdidload
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setupLayout()
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  // MARK: - setupNavigationbar
  
  
  func setupNavigationbar() {
    settingNavigationTitle(title: "문의하기")
    leftButtonSetting()
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    [
      titleLabel,
      titleTextField,
      contentLabel,
      contentTextView,
      emailLabel,
      emailTextField,
      inquiryButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    titleTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    contentTextView.delegate = self
    contentTextView.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(170)
    }
    
    emailLabel.snp.makeConstraints {
      $0.top.equalTo(contentTextView.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(emailLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    inquiryButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
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
          self?.showToast(message: "문의가 정상적으로 접수됐어요.", imageCheck: true, alertCheck: true)
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

extension InquiryViewController: CreateUIprotocol {}
extension InquiryViewController: EditableViewProtocol {}
