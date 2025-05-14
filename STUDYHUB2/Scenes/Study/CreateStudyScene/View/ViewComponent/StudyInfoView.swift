
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 채팅방 링크, 스터디 제목, 스터디 소개 View
final class StudyInfoView: UIView, UITextFieldDelegate, UITextViewDelegate {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: StudyFormViewModel

  // MARK: - 채팅방 링크 UI
  
  
  /// 채팅방 링크 제목 라벨
  private lazy var chatLinkLabel = UILabel().then {
    $0.text = "채팅방 링크"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 채팅방 링크 설명 라벨
  private lazy var chatLinkdescriptionLabel = UILabel().then {
    $0.text = "참여코드가 없는 카카오톡 오픈 채팅방 링크로 첨부"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }

  /// 채팅방 입력 TextField
  private lazy var chatLinkTextField = StudyHubUI.createTextField(title: "채팅방 링크를 첨부해 주세요")
  
  /// 채팅방 링크 구분선
  private lazy var chatLinkDividerLine = StudyHubUI.createDividerLine(height: 8)

  // MARK: - 스터디 제목, 스터디 소개 UI
  
  /// 스터디 제목 라벨
  private lazy var studytitleLabel = UILabel().then {
    $0.text = "스터디 제목"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 스터디 제목 TextField
  private lazy var studytitleTextField = StudyHubUI.createTextField(title: "제목을 적어주세요")

  /// 스터디 소개 라벨
  private lazy var studyIntroduceLabel = UILabel().then {
    $0.text = "스터디 소개"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }

  /// 스터디 소개 TextView
  private lazy var studyIntroduceTextView: UITextView = {
    let tv = UITextView()
    tv.text = "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
    tv.textColor = .bg70
    tv.font = UIFont.systemFont(ofSize: 15)
    tv.layer.borderWidth = 0.5
    tv.layer.borderColor = UIColor.lightGray.cgColor
    tv.layer.cornerRadius = 5.0
//    tv.adjustUITextViewHeight()
    return tv
  }()
  
  init(_ viewModel: StudyFormViewModel) {
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
  
  /// layout 설정
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
  
  /// UI설정
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
  
  /// 바인딩
  func setupBinding() {
    /// 채팅방 링크
    chatLinkTextField.rx.text.orEmpty
      .withUnretained(self)
      .subscribe(onNext: { (view, text) in
        var updatedData = view.viewModel.createStudyData.value
        updatedData?.chatUrl = text
        view.viewModel.createStudyData.accept(updatedData)
      })
      .disposed(by: disposeBag)
    
    /// 스터디 제목
    studytitleTextField.rx.text.orEmpty
      .withUnretained(self)
      .subscribe(onNext: { (view, text) in
        var updatedData = view.viewModel.createStudyData.value
        updatedData?.title = text
        view.viewModel.createStudyData.accept(updatedData)
      })
      .disposed(by: disposeBag)
    
    /// 스터디 소개
    studyIntroduceTextView.rx.text.orEmpty
      .withUnretained(self)
      .subscribe(onNext: { (view, text) in
        var updatedData = view.viewModel.createStudyData.value
        updatedData?.content = text
        view.viewModel.createStudyData.accept(updatedData)
      })
      .disposed(by: disposeBag)
  }

  /// Delegate 설정
  func setupDelegate(){
    chatLinkTextField.delegate = self
    studytitleTextField.delegate = self
    studyIntroduceTextView.delegate = self
  }
  
  /// 스터디 수정 UI 설정
  func setupModifyUI(){
    guard let postValue = viewModel.postedData.value else { return }
    chatLinkTextField.text = postValue.chatUrl
    studytitleTextField.text = postValue.title
    studyIntroduceTextView.text = postValue.content
    studyIntroduceTextView.textColor = .black
  }
  
  /// TextField 입력 시작 시
  func textFieldDidBeginEditing(_ textField: UITextField) {
    didBeginEditing(view: textField)
  }
  
  /// TextField 입력 종료 시
  func textFieldDidEndEditing(_ textField: UITextField) {
    didEndEditing(view: textField)
  }
  
  /// TextView 입력 시작 시
  func textViewDidBeginEditing(_ textView: UITextView) {
    didBeginEditing(view: textView)
  }
  
  /// TextView 입력 종료 시
  func textViewDidEndEditing(_ textView: UITextView) {
    didEndEditing(
      view: textView,
      placeholderText: "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
    )
  }
}

extension StudyInfoView: EditableViewProtocol {}
