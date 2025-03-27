
import UIKit

import SnapKit
import RxCocoa
import RxSwift
import Then

/// 회원가입 - 4. 닉네임 입력 VC
final class EnterNicknameViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: EnterNicknameViewModel
  
  // MARK: - 화면구성
  
  /// main 타이틀 View
  private lazy var mainTitleView = AuthTitleView(
    pageNumber: "4/5",
    pageTitle: "스터디 참여에 필요한 정보를 알려주세요",
    pageContent: "성별은 추후에 수정이 불가해요"
  )
  
  /// 닉네임 TextField의 값
  private lazy var textFieldValues = SetAuthTextFieldValue(
    labelTitle: "닉네임",
    textFieldPlaceholder: "닉네임을 입력해주세요",
    alertLabelTitle: ""
  )
  
  /// 닉네임 TextField
  private lazy var nicknameTextField = AuthTextField(setValue: textFieldValues)
  
  /// 중복확인벝느
  private lazy var checkDuplicationButton = StudyHubButton(
    title: "중복 확인",
    fontSize: 14,
    radious: 4
  )

  /// 글자 수 세는 라벨
  internal lazy var characterCountLabel = UILabel().then {
    $0.text = "0/10"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
  /// 성별라벨
  private lazy var genderLabel = UILabel().then {
    $0.text = "성별"
    $0.textColor = .g50
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }

  /// 성별선택버튼 - 여자
  private lazy var femaleButton = createGenderButton("여자")

  /// 성별선택버튼 - 남자
  private lazy var maleButton = createGenderButton("남자")
  
  /// 다음 버튼
  private lazy var nextButton = StudyHubButton(title: "다음")
  
  init(with viewModel: EnterNicknameViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationSetting()
    
    setUpLayout()
    makeUI()
    
    setupBindings()
    setupActions()
    
    registerTapGesture()
  } // viewDidLoad
  
  // MARK: - 네비게이션 바
  
  /// 네비게이션 바 세팅
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }
  
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(SignupStep.popIsRequired)
  }
  
  
  // MARK: - setUpLayout
  
  /// Layout 설정
  func setUpLayout(){
    [
      mainTitleView,
      nicknameTextField,
      checkDuplicationButton,
      characterCountLabel,
      genderLabel,
      femaleButton,
      maleButton,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  /// Ui설정
  func makeUI(){
    /// 메인 타이틀 뷰
    mainTitleView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    nicknameTextField.textField.delegate = self
    nicknameTextField.snp.makeConstraints {
      $0.top.equalTo(mainTitleView.snp.bottom).offset(130)
      $0.leading.equalTo(mainTitleView.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(40)
    }
    
    checkDuplicationButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(nicknameTextField).offset(15)
      $0.width.equalTo(68)
      $0.height.equalTo(30)
    }
    
    characterCountLabel.snp.makeConstraints {
      $0.top.equalTo(checkDuplicationButton.snp.bottom).offset(10)
      $0.trailing.equalTo(nicknameTextField.snp.trailing)
    }
    
    genderLabel.snp.makeConstraints {
      $0.top.equalTo(characterCountLabel.snp.bottom).offset(69)
      $0.leading.equalTo(mainTitleView.snp.leading)
    }
    
    femaleButton.snp.makeConstraints {
      $0.top.equalTo(genderLabel.snp.bottom).offset(20)
      $0.leading.equalTo(genderLabel.snp.leading)
      $0.width.equalTo(172)
      $0.height.equalTo(45)
    }
    
    maleButton.snp.makeConstraints {
      $0.top.equalTo(femaleButton)
      $0.leading.equalTo(femaleButton.snp.trailing).offset(10)
      $0.width.equalTo(172)
      $0.height.equalTo(45)
    }
    
    nextButton.unableButton(false)
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(nicknameTextField)
    }
  }
  
  
  /// 성별버튼 생성
  /// - Parameter title: 제목
  /// - Returns: 성별버튼
  func createGenderButton(_ title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor.g60, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    button.backgroundColor = .g100
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.g80.cgColor
    button.layer.cornerRadius = 5
    return button
  }
  
  
  /// 성별버튼 터치 시 UI변경
  func changeButtonUI(selet button: UIButton, deselect otherButton: UIButton){
    genderButtonSetting(
      button: button,
      backgroundColor: .o60,
      titleColor: .o20,
      borderColor: .o50
    )
    
    genderButtonSetting(
      button: otherButton,
      backgroundColor: .g100,
      titleColor: .g60,
      borderColor: .g80
    )
  }
  
  /// 바인딩 설정
  func setupBindings(){
    /// 닉네임 TextFieldd 입력 시작 , 끝
    nicknameTextField.textField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        let isTextFieldEditing = vc.nicknameTextField.textField.isEditing
        
        let color: UIColor = isTextFieldEditing ? .g60 : .g100
        vc.nicknameTextField.alertLabelSetting(
          hidden: true,
          title: "",
          textColor: color,
          underLineColor: color)
      })
      .disposed(by: disposeBag)

    /// 선택한 성별에 따른 UI 처리
    viewModel.genderStatus
      .withUnretained(self)
      .subscribe { vc, selectedGender in
        switch selectedGender {
        case .female:  vc.changeButtonUI(selet: vc.femaleButton, deselect: vc.maleButton)
        case .male:    vc.changeButtonUI(selet: vc.maleButton, deselect: vc.femaleButton)
        case .none:    return
        }
      }.disposed(by: disposeBag)
    
    /// 유효한 닉네임 체크
    viewModel.checkValidNickname
      .withUnretained(self)
      .subscribe(onNext: { vc, isValidNickname in
        if isValidNickname {
          guard let nickname = vc.nicknameTextField.getTextFieldValue() else { return }
          vc.viewModel.checkDuplicationNickname(nickname)
        }else {
          vc.failToCheckDuplicaiton(content: "이모티콘,특수문자,띄어쓰기는 사용할 수 없어요")
        }
      })
      .disposed(by: disposeBag)
    
    /// 닉네임 중복여부에 따른 UI설정
    viewModel.checkDuplicationNickname
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: { vc, isDuplicatedNickname in
        if isDuplicatedNickname {
          vc.characterCountLabel.isHidden = true
          vc.nicknameTextField.alertLabelSetting(
            hidden: false,
            title: "사용 가능한 닉네임이에요",
            textColor: .g_10,
            underLineColor: .g_10)
        } else {
          vc.failToCheckDuplicaiton(content: "이미 존재하는 닉네임이에요")
        }
      })
      .disposed(by: disposeBag)
    
    /// 다음버튼 활성화 - 닉네임 , 성별 입력 시 활성화
    viewModel.isActivateNextButton
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: { vc, isNextBtnActivate in
        vc.nextButton.unableButton(isNextBtnActivate)
      })
      .disposed(by: disposeBag)
  }
  
  /// Actinos 설정
  func setupActions(){
    // 성별버튼 터치 - 남자
    maleButton.rx.tap
      .withUnretained(self)
      .bind { vc, _ in
        vc.viewModel.genderStatus.accept(.male)
      }
      .disposed(by: disposeBag)
    
    // 성별버튼 터치 - 여자
    femaleButton.rx.tap
      .withUnretained(self)
      .bind { vc, _ in
        vc.viewModel.genderStatus.accept(.female)
      }
      .disposed(by: disposeBag)
    
    // 중복 확인버튼 터치
    checkDuplicationButton.rx.tap
      .withUnretained(self)
      .bind { vc, _ in
        guard let nickname = vc.nicknameTextField.getTextFieldValue() else { return }
        vc.viewModel.checkValidNickname(nickname: nickname)
      }
      .disposed(by: disposeBag)
    
    // 다음버튼 터치
    nextButton.rx.tap
      .withUnretained(self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { vc, _ in
        vc.viewModel.steps.accept(SignupStep.enterMajorScreenIsRequired)
        
        // 닉네임 정보, 성별정보 전달
        EnterMajorViewModel.shared.gender = vc.viewModel.genderStatus.value.toServer
        EnterMajorViewModel.shared.nickname = vc.nicknameTextField.getTextFieldValue()
      })
      .disposed(by: disposeBag)
  }

  /// 성별버튼 세팅
  func genderButtonSetting(
    button: UIButton,
    backgroundColor: UIColor,
    titleColor: UIColor,
    borderColor: UIColor) {
      button.backgroundColor = backgroundColor
      button.setTitleColor(titleColor, for: .normal)
      button.layer.borderColor = borderColor.cgColor
    }
  
  // MARK: - 중복 확인에 실패
  
  /// 중복 확인에 실패
  func failToCheckDuplicaiton(content: String){
    self.characterCountLabel.isHidden = true
    
    nicknameTextField.alertLabelSetting(
      hidden: false,
      title: content,
      textColor: .r50,
      underLineColor: .r50
    )
    
    self.nextButton.backgroundColor = .o60
    self.nextButton.setTitleColor(.g90, for: .normal)
  }
}

extension EnterNicknameViewController {
#warning("따로 빼기 필요")
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    let changedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    characterCountLabel.text = "\(changedText.count)/10"
    characterCountLabel.changeColor(wantToChange: "\(changedText.count)", color: .white)
    return changedText.count <= 9
  }
}

extension EnterNicknameViewController: KeyboardProtocol {}

