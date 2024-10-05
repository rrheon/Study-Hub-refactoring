import UIKit

import SnapKit
import RxRelay

final class ParticipateVC: CommonNavi {
  let viewModel: ParticipateViewModel
  
  // MARK: - UI세팅
  
  
  private lazy var titleLabel = createLabel(
    title: "자기소개나 스터디에 대한 의지를 스터디 팀장에게 알려 주세요! 💬",
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var reasonTextView: UITextView = {
    let textView = UITextView()
    textView.text =
    "ex) 안녕하세요, 저는 경영학부에 재학 중인 허브입니다! 지각이나 잠수 없이 열심히 참여하겠습니다. 잘 부탁드립니다 :)"
    textView.textColor = .bg70
    textView.layer.cornerRadius = 10
    textView.layer.borderWidth = 1
    textView.layer.borderColor = UIColor.bg50.cgColor
    textView.font = UIFont(name: "Pretendard", size: 14)
    textView.delegate = self
    return textView
  }()
  
  private lazy var countContentLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard", size: 12)
    label.text = "0/200"
    return label
  }()
  
  private lazy var bottomLabel = createLabel(
    title: "- 수락 여부는 알림으로 알려드려요\n- 채팅방 링크는 ‘마이페이지-참여한 스터디’에서 확인할 수 있어요",
    textColor: .bg60,
    fontType: "Pretendard",
    fontSize: 12
  )

  private lazy var completeButton = StudyHubButton(title: "완료")

  init(_ postData: BehaviorRelay<PostDetailData?>) {
    self.viewModel = ParticipateViewModel(postData)
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
    
    changeTitleLabelColor()
    
    setupLayout()
    makeUI()
    
    setupAction()
    setupBinding()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      reasonTextView,
      countContentLabel,
      bottomLabel,
      completeButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    titleLabel.numberOfLines = 0
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    reasonTextView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(titleLabel)
      $0.height.equalTo(170)
    }
    
    countContentLabel.snp.makeConstraints {
      $0.top.equalTo(reasonTextView.snp.bottom).offset(10)
      $0.trailing.equalTo(reasonTextView.snp.trailing)
    }
    
    bottomLabel.numberOfLines = 0
    bottomLabel.setLineSpacing(spacing: 5)
    bottomLabel.snp.makeConstraints {
      $0.bottom.equalTo(completeButton.snp.top).offset(-30)
      $0.leading.equalTo(completeButton)
    }
    
    completeButton.unableButton(false, backgroundColor: .o30, titleColor: .white)
    completeButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - 네비게이션 세팅
  
  
  func setupNavigationbar() {
    leftButtonSetting()
    settingNavigationTitle(title: "참여하기")
  }
  
  // MARK: - 메인라벨 텍스트 색상 변경
  
  
  func changeTitleLabelColor(){
    titleLabel.changeColor(wantToChange: "자기소개", color: .o50)
    titleLabel.changeColor(wantToChange: "스터디에 대한 의지", color: .o50)
  }
  
  // MARK: - setupBinding
  
  
  func setupBinding(){
    viewModel.isSuccessParticipate
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        if $0 {
          self?.navigationController?.popViewController(animated: true)
          self?.showToast(message: "참여 신청이 완료됐어요.", alertCheck: true)
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.userIntroduce
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] in
        let buttonHidden = $0.count > 0 ? true : false
        let buttonBackgroundColor: UIColor = $0.count > 0 ? .o50 : .o30
        self?.completeButton.unableButton(
          buttonHidden,
          backgroundColor: buttonBackgroundColor,
          titleColor: .white)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupAction(){
    completeButton.rx.tap
      .subscribe(onNext: { [ weak self] in
        self?.completeButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
    
    reasonTextView.rx.text.orEmpty
        .filter { [weak self] _ in
            return self?.reasonTextView.textColor == UIColor.black
        }
        .bind(to: viewModel.userIntroduce)
        .disposed(by: viewModel.disposeBag)

  }
  
  func completeButtonTapped(){
    guard let text = reasonTextView.text else { return }
  
    if text.count < 10 {
      showToast(message: "팀장이 회원님에 대해 알 수 있도록 10자 이상 적어주세요.", alertCheck: false)
    } else {
      viewModel.participateButtonTapped(text)
    }
  }
}

// MARK: - textview


extension ParticipateVC {
  override func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.bg70 {
      textView.text = nil
      textView.textColor = UIColor.black
      textView.layer.borderColor = UIColor.black.cgColor
            
      completeButton.isEnabled = true
      completeButton.backgroundColor = .o50
    }
  }
  
  override func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "ex) 욕설 등의 부적절한 말을 사용했습니다, 저희 스터디와 맞지 않습니다"
      textView.textColor = UIColor.bg70
      textView.layer.borderColor = UIColor.bg50.cgColor
      
      completeButton.isEnabled = false
      completeButton.backgroundColor = .o30
    }
  }
  
  func textView(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    let currentText = textView.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    let changedText = currentText.replacingCharacters(in: stringRange, with: text)
    
    countContentLabel.text = "\(changedText.count)/200"
    countContentLabel.changeColor(wantToChange: "\(changedText.count)", color: .black)
    return changedText.count <= 199
  }
}

extension ParticipateVC: CreateUIprotocol {}
