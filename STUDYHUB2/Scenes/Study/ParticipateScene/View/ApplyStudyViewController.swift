import UIKit

import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import Then

/// 스터디 참여하기 VC
final class ApplyStudyViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: ApplyStudyViewModel
  
  // MARK: - UI세팅
  
  
  /// 스터디 참여 제목 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = "자기소개나 스터디에 대한 의지를 스터디 팀장에게 알려 주세요! 💬"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 16)
  }
 
  /// 스터디 참여 이유 TextView
  private lazy var reasonTextView: UITextView = UITextView().then {
    $0.text = "ex) 안녕하세요, 저는 경영학부에 재학 중인 허브입니다! 지각이나 잠수 없이 열심히 참여하겠습니다. 잘 부탁드립니다 :)"
    $0.textColor = .bg70
    $0.layer.cornerRadius = 10
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.bg50.cgColor
    $0.font = UIFont(name: "Pretendard", size: 14)
    $0.delegate = self
  }
  
  /// 스터디 참여 이유 글자 갯수 카운트 라벨
  private lazy var countContentLabel: UILabel = UILabel().then {
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard", size: 12)
    $0.text = "0/200"
  }
  
  /// 스터디 참여 정보 라벨
  private lazy var bottomLabel: UILabel = UILabel().then {
    $0.textColor = .bg60
    $0.font = UIFont(name: "Pretendard", size: 12)
    $0.text =  "- 수락 여부는 알림으로 알려드려요\n- 채팅방 링크는 ‘마이페이지-참여한 스터디’에서 확인할 수 있어요"
  }

  /// 스터디 참여 신청완료버튼
  private lazy var completeButton = StudyHubButton(title: "완료")

  init(with viewModel: ApplyStudyViewModel) {
    self.viewModel = viewModel
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
    
    changeTitleLabelColor()
    
    setupLayout()
    makeUI()
    
    setupAction()
    setupBinding()
    
    registerTapGesture()
  } // viewDidLoad
  
  // MARK: - setupLayout
  
  /// Loyout 설정
  func setupLayout(){
    [ titleLabel, reasonTextView, countContentLabel, bottomLabel, completeButton]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  /// UI 설정
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
  
  /// 네비게이션 바 세팅
  func setupNavigationbar() {
    leftButtonSetting()
    settingNavigationTitle(title: "참여하기")
    settingNavigationbar()
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
  
  // MARK: - 메인라벨 텍스트 색상 변경
  
  /// 라벨 색상 변경
  func changeTitleLabelColor(){
    titleLabel.changeColor(wantToChange: "자기소개", color: .o50)
    titleLabel.changeColor(wantToChange: "스터디에 대한 의지", color: .o50)
  }
  
  // MARK: - setupBinding
  
  /// 바인딩
  func setupBinding(){
    viewModel.isSuccessParticipate
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] result in
        if result {
          self?.viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: false)))

          ToastPopupManager.shared.showToast(message: "참여 신청이 완료됐어요.")
        }
      })
      .disposed(by: disposeBag)
    
//    /// 사용자의 소개 내용
//    viewModel.userIntroduce
//      .asDriver(onErrorJustReturn: "")
//      .drive(onNext: { [weak self] in
//        let buttonHidden = $0.count > 0 ? true : false
//        let buttonBackgroundColor: UIColor = $0.count > 0 ? .o50 : .o30
//        self?.completeButton.unableButton(
//          buttonHidden,
//          backgroundColor: buttonBackgroundColor,
//          titleColor: .white)
//      })
//      .disposed(by: disposeBag)
    
    reasonTextView.rx.text.orEmpty
      .filter { [weak self] _ in
        return self?.reasonTextView.textColor == UIColor.black
      }
      .bind(to: viewModel.userIntroduce)
      .disposed(by: disposeBag)

  }
  
  /// Actions 설정
  func setupAction(){
    /// 스터디 신청 완료버튼
    completeButton.rx.tap
      .subscribe(onNext: { [ weak self] in
        self?.completeButtonTapped()
      })
      .disposed(by: disposeBag)
  }
  
  
  /// 스터디 신청 완료버튼 탭
  func completeButtonTapped(){
    guard let text = reasonTextView.text else { return }
  
    /// 스터디 신청 사유 글자갯수 제한
    if text.count < 10 {
      ToastPopupManager.shared.showToast(message: "팀장이 회원님에 대해 알 수 있도록 10자 이상 적어주세요.",
                                         alertCheck: false)
    } else {
      viewModel.participateButtonTapped(text)
    }
  }
}

// MARK: - Extension


extension ApplyStudyViewController {
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
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,replacementText text: String) -> Bool {
    let currentText = textView.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    let changedText = currentText.replacingCharacters(in: stringRange, with: text)
    
    countContentLabel.text = "\(changedText.count)/200"
    countContentLabel.changeColor(wantToChange: "\(changedText.count)", color: .black)
    return changedText.count <= 199
  }
}

extension ApplyStudyViewController: KeyboardProtocol {}
