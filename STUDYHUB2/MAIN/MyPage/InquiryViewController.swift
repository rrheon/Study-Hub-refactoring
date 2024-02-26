//
//  InquiryViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/02.
//

import UIKit

import SnapKit
import Moya

final class InquiryViewController: NaviHelper {
  private lazy var titleLabel = createLabel(title: "제목",
                                            textColor: .black,
                                            fontType: "Pretendard-SemiBold",
                                            fontSize: 16)
  
  private lazy var titleTextField = createTextField(title: "제목을 입력해주세요")
  
  private lazy var contentLabel = createLabel(title: "내용",
                                              textColor: .black,
                                              fontType: "Pretendard-SemiBold",
                                              fontSize: 16)
  
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
  
  private lazy var emailLabel = createLabel(title: "이메일",
                                            textColor: .black,
                                            fontType: "Pretendard-SemiBold",
                                            fontSize: 16)
  
  private lazy var emailTextField = createTextField(title: "답변을 받으실 이메일을 입력해주세요")
  
  private lazy var inquiryButton: UIButton = {
    let button = UIButton()
    button.setTitle("문의하기", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o30
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      self.inquiryButtonTapped()
    }, for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  // MARK: - viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - 네비게이션바
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    settingNavigationTitle(title: "문의하기")
    
    navigationItem.rightBarButtonItem = .none
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
      $0.top.equalToSuperview().offset(20)
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
  
  // MARK: - 문의하기 버튼 탭
  func inquiryButtonTapped(){
    let commonNetwork = CommonNetworking.shared
    guard let content = contentTextView.text,
          let title = titleTextField.text,
          let email = emailTextField.text else { return }
    
    commonNetwork.moyaNetworking(networkingChoice: .inquiryQuestion(
      content: content,
      title: title,
      toEmail: email)) { result in
        switch result {
        case .success(let response):
          
          self.navigationController?.popViewController(animated: true)
          
          self.showToast(message: "문의가 정상적으로 접수됐어요.",
                         imageCheck: true,
                         alertCheck: true)
        case .failure(let response):
          print(response.response)
        }
      }
  }
}

extension InquiryViewController {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    updateInquiryButtonState()
    return true
  }
  
  func textViewDidChange(_ textView: UITextView) {
    updateInquiryButtonState()
  }
  
  override func textViewDidBeginEditing(_ textView: UITextView) {
    super.textViewDidBeginEditing(textView)
    
    textView.text = ""
    textView.textColor = .black
  }
  
  private func updateInquiryButtonState() {
    let titleText = titleTextField.text ?? ""
    let emailText = emailTextField.text ?? ""
    let contentText = contentTextView.text ?? ""
    
    let isEmpty = titleText.isEmpty || emailText.isEmpty ||
    (contentText.isEmpty || contentText == initialContent)
    
    inquiryButton.isEnabled = !isEmpty
    inquiryButton.backgroundColor = isEmpty ? .o30 : .o50
  }
  
  
  override func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = initialContent
      textView.textColor = .bg70
    }
    textView.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상을 초기화 (투명)
    textView.layer.borderWidth = 1.0 // 테두리 두께 초기화
  }
}
