
import UIKit

import SnapKit
import RxCocoa

final class EnterNicknameViewController: CommonNavi {

  let viewModel: EnterNicknameViewModel
  
  // MARK: - 화면구성
  private lazy var mainTitleView = AuthTitleView(pageNumber: "4/5",
                                                 pageTitle: "스터디 참여에 필요한 정보를 알려주세요",
                                                 pageContent: "성별은 추후에 수정이 불가해요")
  
  private lazy var textFieldValues = SetAuthTextFieldValue(labelTitle: "닉네임",
                                                           textFieldPlaceholder: "닉네임을 입력해주세요",
                                                           alertLabelTitle: "",
                                                           type: true)
  
  private lazy var nicknameTextField = AuthTextField(setValue: textFieldValues)
  
  private lazy var checkDuplicationButton = StudyHubButton(title: "중복 확인",
                                                           fontSize: 14,
                                                           radious: 4,
                                                           actionDelegate: self)
  // 닉네임 세는 라벨
  private lazy var characterCountLabel = createLabel(
    title: "0/10",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12)
  
  // 성별라벨
  private lazy var genderLabel = createLabel(
    title: "성별",
    textColor: .g50,
    fontType: "Pretendard-Medium",
    fontSize: 14)

  private lazy var choiceFemaleButton = createGenderButton("여자")
  private lazy var choiceMaleButton = createGenderButton("남자")
  
  // 다음 버튼
  private lazy var nextButton = StudyHubButton(title: "다음", actionDelegate: self)
 
  init(_ values: SignupDataProtocol) {
    self.viewModel = EnterNicknameViewModel(values)
    super.init()
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
    nicknameTextField.textField.delegate = self
  }
  
  // MARK: - 네비게이션 바
  func navigationSetting() {
    settingNavigationTitle(title: "회원가입")
    leftButtonSetting()
  }

  // MARK: - setUpLayout
  func setUpLayout(){
    [
      mainTitleView,
      nicknameTextField,
      checkDuplicationButton,
      characterCountLabel,
      genderLabel,
      choiceFemaleButton,
      choiceMaleButton,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainTitleView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
  
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
    
    choiceFemaleButton.snp.makeConstraints {
      $0.top.equalTo(genderLabel.snp.bottom).offset(20)
      $0.leading.equalTo(genderLabel.snp.leading)
      $0.width.equalTo(172)
      $0.height.equalTo(45)
    }
    
    choiceMaleButton.snp.makeConstraints {
      $0.top.equalTo(choiceFemaleButton)
      $0.leading.equalTo(choiceFemaleButton.snp.trailing).offset(10)
      $0.width.equalTo(172)
      $0.height.equalTo(45)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(55)
      $0.leading.trailing.equalTo(nicknameTextField)
    }
  }
  
  func createGenderButton(_ title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor.g60, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold",
                                     size: 16)
    button.backgroundColor = .g100
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.g80.cgColor
    button.layer.cornerRadius = 5
    return button
  }
  
  func setupBindings(){
    viewModel.femaleButtonStatus
      .subscribe { [weak self] in
        guard let self = self else { return }
        if $0 {
          genderButtonSetting(button: choiceFemaleButton,
                              backgroundColor: .o60,
                              titleColor: .o20,
                              borderColor: .o50)
          
          genderButtonSetting(button: choiceMaleButton,
                              backgroundColor: .g100,
                              titleColor: .g60,
                              borderColor: .g80)
          
          nextbuttonUIChange()
        }
      }.disposed(by: viewModel.disposeBag)
    
    viewModel.maleButtonStatus
      .subscribe { [weak self] in
        guard let self = self else { return }
        if $0 {
          genderButtonSetting(button: choiceMaleButton,
                              backgroundColor: .o60,
                              titleColor: .o20,
                              borderColor: .o50)
          
          genderButtonSetting(button: choiceFemaleButton,
                              backgroundColor: .g100,
                              titleColor: .g60,
                              borderColor: .g80)
         
          nextbuttonUIChange()
        }
      }.disposed(by: viewModel.disposeBag)
    
    viewModel.checkValidNickname
      .filter { $0 }
      .subscribe(onNext: { [weak self] in
        if $0 {
          guard let nickname = self?.nicknameTextField.getTextFieldValue() else { return }
          self?.viewModel.checkDuplicationNickname(nickname)
        }else {
          self?.failToCheckDuplicaiton(content: "이모티콘,특수문자,띄어쓰기는 사용할 수 없어요")
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.checkDuplicationNickname
      .subscribe(onNext: { [weak self] in
        if $0 == "Error"{
          self?.characterCountLabel.isHidden = true
          self?.nicknameTextField.alertLabelSetting(hidden: false,
                                                   title: "사용 가능한 닉네임이에요",
                                                   textColor: .g_10,
                                                   underLineColor: .g_10)
        } else {
          self?.failToCheckDuplicaiton(content: "이미 존재하는 닉네임이에요")
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isActivateNextButton
      .bind(to: nextButton.rx.isEnabled)
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    choiceMaleButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.genderButtonTapped(for: self!.viewModel.maleButtonStatus)
      }
      .disposed(by: viewModel.disposeBag)
    
    choiceFemaleButton.rx.tap
      .bind { [weak self] in
        self?.viewModel.genderButtonTapped(for: self!.viewModel.femaleButtonStatus)
      }
      .disposed(by: viewModel.disposeBag)
    
    checkDuplicationButton.rx.tap
      .bind { [weak self] in
        guard let nickname = self?.nicknameTextField.getTextFieldValue() else { return }
        self?.viewModel.checkValidNickname(nickname: nickname)
      }
      .disposed(by: viewModel.disposeBag)
  }

  func genderButtonSetting(button: UIButton,
                           backgroundColor: UIColor,
                           titleColor: UIColor,
                           borderColor: UIColor) {
      button.backgroundColor = backgroundColor
      button.setTitleColor(titleColor, for: .normal)
      button.layer.borderColor = borderColor.cgColor
  }
  
  // MARK: - 중복검사하는 기능
//  @objc func completeButtonTapped() {
//    guard let nickname = nicknameTextField.getTextFieldValue() else { return }
//    
//    checkValidandDuplication(nickname: nickname) { isValid in
//      if isValid {
//        DispatchQueue.main.async {
//          
//          self.characterCountLabel.isHidden = true
//          
//        
//          self.nicknameTextField.alertLabelSetting(hidden: false,
//                                              title: "사용 가능한 닉네임이에요",
//                                              textColor: .g_10,
//                                              underLineColor: .g_10)
//        }
//      }
//    }
//  }
  
  // MARK: - 닉네임 중복 확인
//  func checkValidandDuplication(nickname: String,
//                                completion: @escaping (Bool) -> Void) {
//    let checkNickname = checkValidNickname(nickname: nickname)
//    
//    if checkNickname == true {
//      viewModel.checkNicknameDuplication(nickName: nickname) { status in
//        // badrequest == 중복 , error == 가능
//        if status == "Error" {
//       
//          completion(true)
//        } else {
//          DispatchQueue.main.async {
//            self.failToCheckDuplicaiton(content: "이미 존재하는 닉네임이에요")
//          }
//          completion(false)
//        }
//      }
//    } else {
//      self.failToCheckDuplicaiton(content: "이모티콘,특수문자,띄어쓰기는 사용할 수 없어요")
//    }
//    completion(false)
//  }
//  
  // MARK: - 중복 확인에 실패
  func failToCheckDuplicaiton(content: String){
    self.characterCountLabel.isHidden = true
    
    nicknameTextField.alertLabelSetting(hidden: false,
                                        title: content,
                                        textColor: .r50,
                                        underLineColor: .r50)

    self.nextButton.backgroundColor = .o60
    self.nextButton.setTitleColor(.g90, for: .normal)
  }
  
//  @objc func nicknameTextfieldDidchange(){
//    guard let text = nicknameTextField.getTextFieldValue() else { return }
//
//    nextbuttonUIChange()
//  }
//  
  func nextbuttonUIChange(){
    nextButton.backgroundColor = .o50
    nextButton.setTitleColor(.white, for: .normal)
  }
  
  // MARK: - 다음 버튼
  func nextButtonTapped(){
    let signupDatas = SignupDats(password: nicknameTextField.getTextFieldValue())
    let departmentVC = DepartmentViewController(signupDatas)
    
    navigationController?.pushViewController(departmentVC, animated: true)
  }
}

extension EnterNicknameViewController: StudyHubButtonProtocol {
  func buttonTapped() {
    nextButtonTapped()
  }
}

extension EnterNicknameViewController {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    let changedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    characterCountLabel.text = "\(changedText.count)/10"
    characterCountLabel.changeColor(label: characterCountLabel,
                                    wantToChange: "\(changedText.count)",
                                    color: .white)
    return changedText.count <= 9
  }
}


