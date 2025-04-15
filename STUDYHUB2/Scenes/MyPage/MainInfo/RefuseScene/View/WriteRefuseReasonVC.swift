
import UIKit

import SnapKit
import RxSwift
import RxFlow
import RxRelay
import Then

/// 거절사유 전달 delegate
protocol WriteRefuseReasonVCDelegate: AnyObject {
  func completeButtonTapped(reason: String, userId: Int)
}

/// 거절사유 작성 VC
final class WriteRefuseReasonVC: UIViewController, Stepper {
  var disposeBag: DisposeBag = DisposeBag()
  
  var steps: PublishRelay<Step> = PublishRelay<Step>()

  weak var delegate: WriteRefuseReasonVCDelegate?
  
  /// 스터디 신청한 유저의 ID
  var userId: Int = 0
  
  /// 거절 사유 작성 제목 라벨
  private lazy var titleLabel: UILabel = UILabel().then {
    $0.text = "해당 참여자를 거절하게 된 이유를 적어주세요 😢"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 16)
    $0.numberOfLines = 0
  }
  
  /// 거절 사유 작성 TextView
  private lazy var reasonTextView: UITextView = UITextView().then {
    $0.text = "ex) 욕설 등의 부적절한 말을 사용했습니다, 저희 스터디와 맞지 않습니다"
    $0.textColor = .bg70
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.bg50.cgColor
    $0.font = UIFont(name: "Pretendard", size: 16)
    $0.delegate = self
  }
  
  /// 거절사유 글자 갯수 제한 라벨
  private lazy var countContentLabel: UILabel = UILabel().then {
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard", size: 12)
    $0.text = "0/200"
  }
  
  /// 거절사유 경고  라벨
  private lazy var bottomLabel = UILabel().then {
    $0.text = "- 해당 내용은 사용자에게 전송돼요"
    $0.textColor = .bg60
    $0.font = UIFont(name: "Pretendard", size: 12)
  }
  
  /// 거절 완료 버튼
  private lazy var completeButton: UIButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .o30
    $0.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    $0.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    $0.isEnabled = false
    $0.layer.cornerRadius = 10
  }
  
  init(userId: Int) {
    self.userId = userId
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white

    setupUI()
    
    settingNavigationTitle(title: "거절사유")
    leftButtonSetting()
    
    registerTapGesture()
  }
  
  // MARK: - UI Setup
  
  
  /// UI설정
  private func setupUI() {
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    view.addSubview(reasonTextView)
    reasonTextView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-10)
      $0.height.equalTo(186)
    }
    
    view.addSubview(countContentLabel)
    countContentLabel.snp.makeConstraints {
      $0.trailing.equalTo(reasonTextView)
      $0.top.equalTo(reasonTextView.snp.bottom).offset(5)
    }

    view.addSubview(completeButton)
    completeButton.snp.makeConstraints {
      $0.bottom.equalTo(view.snp.bottom).offset(-20)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
    
    view.addSubview(bottomLabel)
    bottomLabel.snp.makeConstraints {
      $0.bottom.equalTo(completeButton.snp.top).offset(-30)
      $0.leading.equalTo(completeButton)
    }
  }

  
  // MARK: - Button Action
  
  
  @objc private func completeButtonTapped() {
    delegate?.completeButtonTapped(reason: reasonTextView.text, userId: userId)
    steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
}

// MARK: - textview
extension WriteRefuseReasonVC {
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
  
  func textView(_ textView: UITextView,
                shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    let currentText = textView.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    let changedText = currentText.replacingCharacters(in: stringRange, with: text)
    
    countContentLabel.text = "\(changedText.count)/200"
    countContentLabel.changeColor(wantToChange: "\(changedText.count)", color: .black)
    return changedText.count <= 199
  }
}

extension WriteRefuseReasonVC: KeyboardProtocol {}
