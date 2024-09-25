
import UIKit

import SnapKit
import RxCocoa

final class StudyInfoView: UIView, UITextFieldDelegate, UITextViewDelegate {
  let viewModel: CreateStudyViewModel
    
  private lazy var chatLinkLabel = createLabel(
    title: "채팅방 링크",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var chatLinkdescriptionLabel = createLabel(
    title: "참여코드가 없는 카카오톡 오픈 채팅방 링크로 첨부",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var chatLinkTextField = createTextField(title: "채팅방 링크를 첨부해 주세요")
  private lazy var chatLinkDividerLine = createDividerLine(height: 8)
    
  private lazy var studytitleLabel = createLabel(
    title: "스터디 제목",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var studytitleTextField = createTextField(title: "제목을 적어주세요")

  private lazy var studyIntroduceLabel = createLabel(
    title: "스터디 소개",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  let textViewContent = "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
  private lazy var studyIntroduceTextView: UITextView = {
    let tv = UITextView()
    tv.text = textViewContent
    tv.textColor = UIColor.lightGray
    tv.font = UIFont.systemFont(ofSize: 15)
    tv.layer.borderWidth = 0.5
    tv.layer.borderColor = UIColor.lightGray.cgColor
    tv.layer.cornerRadius = 5.0
    tv.adjustUITextViewHeight()
    return tv
  }()
  
  init(_ viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    self.setupLayout()
    self.makeUI()
    self.setupModifyUI()
    self.setupDelegate()
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      chatLinkLabel,
      chatLinkdescriptionLabel,
      chatLinkTextField,
      chatLinkDividerLine,
      studytitleLabel,
      studytitleTextField,
      studyIntroduceLabel,
      studyIntroduceTextView
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    chatLinkLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    chatLinkdescriptionLabel.snp.makeConstraints {
      $0.top.equalTo(chatLinkLabel.snp.bottom).offset(8)
      $0.leading.equalTo(chatLinkLabel)
    }
    
    chatLinkTextField.clearButtonMode = .whileEditing
    chatLinkTextField.snp.makeConstraints {
      $0.top.equalTo(chatLinkdescriptionLabel.snp.bottom).offset(17)
      $0.leading.equalTo(chatLinkLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    chatLinkDividerLine.snp.makeConstraints {
      $0.top.equalTo(chatLinkTextField.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview()
    }
    
    studytitleLabel.snp.makeConstraints {
      $0.top.equalTo(chatLinkDividerLine.snp.bottom).offset(32)
      $0.leading.equalTo(chatLinkLabel)
    }

    studytitleTextField.snp.makeConstraints {
      $0.top.equalTo(studytitleLabel.snp.bottom).offset(20)
      $0.leading.equalTo(chatLinkLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    studyIntroduceLabel.snp.makeConstraints {
      $0.top.equalTo(studytitleTextField.snp.bottom).offset(20)
      $0.leading.equalTo(chatLinkLabel)
    }
    
    studyIntroduceTextView.snp.makeConstraints {
      $0.top.equalTo(studyIntroduceLabel.snp.bottom).offset(17)
      $0.leading.equalTo(chatLinkLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(170)
    }
  }
  
  func setupBinding(){
    chatLinkTextField.rx.text.orEmpty
      .bind(to: viewModel.chatLinkValue)
      .disposed(by: viewModel.disposeBag)
    
    studytitleTextField.rx.text.orEmpty
      .bind(to: viewModel.studyTitleValue)
      .disposed(by: viewModel.disposeBag)
    
    studyIntroduceTextView.rx.text.orEmpty
      .bind(to: viewModel.studyIntroduceValue)
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupDelegate(){
    chatLinkTextField.delegate = self
    studytitleTextField.delegate = self
    studyIntroduceTextView.delegate = self
  }
  
  func setupModifyUI(){
    guard let postValue = viewModel.postedData.value else { return }
    chatLinkTextField.text = postValue.chatURL
    studytitleTextField.text = postValue.title
    studyIntroduceTextView.text = postValue.content
    studyIntroduceTextView.textColor = .black
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditing(view: textField)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    didEndEditing(view: textField)
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    didBeginEditing(view: textView)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    didEndEditing(
      view: textView,
      placeholderText: "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
    )
  }
}

extension StudyInfoView: CreateUIprotocol {}
extension StudyInfoView: EditableViewProtocol {}
