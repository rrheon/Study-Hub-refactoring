
import UIKit

import SnapKit

final class NicknameViewController: NaviHelper {
  
  let editUserInfo = EditUserInfoManager.shared
  var email: String?
  var password: String?
  var gender: String?
  
  // MARK: - 화면구성
  private lazy var pageNumberLabel = createLabel(
    title: "4/5",
    textColor: .g60,
    fontType: "Pretendard-SemiBold",
    fontSize: 18)
  
  private lazy var titleLabel = createLabel(
    title: "스터디 참여에 필요한 정보를 알려주세요",
    textColor: .white,
    fontType: "Pretendard-Bold",
    fontSize: 20)
  
  private lazy var underTitleLabel = createLabel(
    title: "성별은 추후에 수정이 불가해요",
    textColor: .g40,
    fontType: "Pretendard-Medium",
    fontSize: 14)
  
  // 닉네임 입력
  private lazy var nicknameLabel = createLabel(
    title: "닉네임",
    textColor: .g50,
    fontType: "Pretendard-Medium",
    fontSize: 14)
  
  private lazy var nicknameTextfield: UITextField = {
    let textField = UITextField()
    textField.attributedPlaceholder = NSAttributedString(
      string: "닉네임을 입력해주세요.",
      attributes: [NSAttributedString.Key.foregroundColor: UIColor.g80])
    textField.textColor = .white
    textField.backgroundColor = .black
    textField.addTarget(self,
                        action: #selector(nicknameTextfieldDidchange),
                        for: .editingDidEnd)
    return textField
  }()
  
  // 중복확인 버튼
  private lazy var checkDuplicationButton: UIButton = {
    let button = UIButton()
    button.setTitle("중복 확인", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium",
                                     size: 14)
    button.backgroundColor = .o50
    button.layer.cornerRadius = 4
    button.addAction(UIAction { _ in
      self.completeButtonTapped()
    }, for: .touchUpInside
    )
    return button
  }()
  
  private lazy var nicknameUnderLineView: UIView = {
    let uiView = UIView()
    uiView.backgroundColor = .g100
    return uiView
  }()
  
  private lazy var nicknameStatusLabel = createLabel(
    title: "이미 존재하는 닉네임이예요",
    textColor: .r50,
    fontType: "Pretendard-Medium",
    fontSize: 12)
  
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
  
  // 성별선택 버튼
  private lazy var choiceFemaleButton: UIButton = {
    let button = UIButton()
    button.setTitle("여자", for: .normal)
    button.setTitleColor(UIColor.g60, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold",
                                     size: 16)
    button.backgroundColor = .g100
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.g80.cgColor
    button.layer.cornerRadius = 5
    button.addAction(UIAction { _ in
      self.genderButtonTapped(button)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var choiceMaleButton: UIButton = {
    let button = UIButton()
    button.setTitle("남자", for: .normal)
    button.setTitleColor(UIColor.g60, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold",
                                     size: 16)
    button.backgroundColor = .g100
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.g80.cgColor
    button.layer.cornerRadius = 5
    button.addAction(UIAction { _ in
      self.genderButtonTapped(button)
    }, for: .touchUpInside)
    return button
  }()
  
  // 다음 버튼
  private lazy var nextButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("다음", for: .normal)
    button.setTitleColor(UIColor(hexCode: "#6F6F6F"), for: .normal)
    button.backgroundColor = UIColor(hexCode: "#6F2B1C")
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      self.nextButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - 네비게이션 바
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    
    self.navigationItem.title = "회원가입"
    self.navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      pageNumberLabel,
      titleLabel,
      underTitleLabel,
      nicknameLabel,
      nicknameTextfield,
      checkDuplicationButton,
      nicknameUnderLineView,
      characterCountLabel,
      nicknameStatusLabel,
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
    pageNumberLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(pageNumberLabel.snp.bottom).offset(10)
      $0.leading.equalTo(pageNumberLabel.snp.leading)
    }
    
    underTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(underTitleLabel.snp.bottom).offset(30)
      $0.leading.equalTo(underTitleLabel.snp.leading)
    }
    
    nicknameTextfield.delegate = self
    nicknameTextfield.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom).offset(20)
      $0.leading.equalTo(nicknameLabel.snp.leading)
    }
    
    checkDuplicationButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalTo(nicknameTextfield)
      $0.width.equalTo(68)
      $0.height.equalTo(30)
    }
    
    nicknameUnderLineView.snp.makeConstraints {
      $0.top.equalTo(nicknameTextfield.snp.bottom).offset(10)
      $0.leading.equalTo(nicknameTextfield.snp.leading)
      $0.trailing.equalToSuperview().offset(-10)
      $0.height.equalTo(1)
    }
    
    nicknameStatusLabel.isHidden = true
    nicknameStatusLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameUnderLineView.snp.bottom).offset(5)
      $0.leading.equalTo(nicknameUnderLineView.snp.leading)
    }
    
    characterCountLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameUnderLineView.snp.bottom).offset(5)
      $0.trailing.equalTo(nicknameUnderLineView.snp.trailing)
    }
    
    genderLabel.snp.makeConstraints {
      $0.top.equalTo(nicknameUnderLineView.snp.bottom).offset(70)
      $0.leading.equalTo(nicknameLabel.snp.leading)
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
      $0.leading.trailing.equalTo(nicknameUnderLineView)
    }
  }
  
  // MARK: - 성별 선택
  func genderButtonTapped(_ sender: UIButton) {
    if sender == choiceFemaleButton {
      choiceFemaleButton.backgroundColor = .o60
      choiceFemaleButton.setTitleColor(.o20, for: .normal)
      choiceFemaleButton.layer.borderColor = UIColor.o50.cgColor
      
      choiceMaleButton.backgroundColor = .g100
      choiceMaleButton.setTitleColor(.g60, for: .normal)
      choiceMaleButton.layer.borderColor = UIColor.g80.cgColor
      
      gender = "FEMALE"
    } else if sender == choiceMaleButton {
      choiceMaleButton.backgroundColor = .o60
      choiceMaleButton.setTitleColor(.o20, for: .normal)
      choiceMaleButton.layer.borderColor = UIColor.o50.cgColor
      
      choiceFemaleButton.backgroundColor = .g100
      choiceFemaleButton.setTitleColor(.g60, for: .normal)
      choiceFemaleButton.layer.borderColor = UIColor.g80.cgColor

      gender = "MALE"
    }
    
    nextbuttonUIChange()
  }
  
  // MARK: - 유효성 검사
  func checkValidNickname(nickname: String) -> Bool {
    let pattern = "^[a-zA-Z0-9가-힣]*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: nickname.utf16.count)
    
    return regex?.firstMatch(in: nickname, options: [], range: range) != nil ? true : false
  }
  
  // MARK: - 중복검사하는 기능
  @objc func completeButtonTapped() {
    guard let nickname = nicknameTextfield.text else { return }
    
    checkValidandDuplication(nickname: nickname) { isValid in
      if isValid {
        DispatchQueue.main.async {
          self.nicknameUnderLineView.backgroundColor = .g_10
          
          self.characterCountLabel.isHidden = true
          
          self.nicknameStatusLabel.isHidden = false
          self.nicknameStatusLabel.textColor = .g_10
          self.nicknameStatusLabel.text = "사용 가능한 닉네임이에요"
        }
      }
    }
  }
  
  // MARK: - 닉네임 중복 확인
  func checkValidandDuplication(nickname: String,
                                completion: @escaping (Bool) -> Void) {
    let checkNickname = checkValidNickname(nickname: nickname)
    
    if checkNickname == true {
      editUserInfo.checkNicknameDuplication(nickName: nickname) { status in
        // badrequest == 중복 , error == 가능
        if status == "Error" {
       
          completion(true)
        } else {
          DispatchQueue.main.async {
            self.failToCheckDuplicaiton(content: "이미 존재하는 닉네임이에요")
          }
          completion(false)
        }
      }
    } else {
      self.failToCheckDuplicaiton(content: "이모티콘,특수문자,띄어쓰기는 사용할 수 없어요")
    }
    completion(false)
  }
  
  // MARK: - 중복 확인에 실패
  func failToCheckDuplicaiton(content: String){
    self.nicknameUnderLineView.backgroundColor = .r50
    
    self.characterCountLabel.isHidden = true
    
    self.nicknameStatusLabel.textColor = .r50
    self.nicknameStatusLabel.isHidden = false
    self.nicknameStatusLabel.text = content
    
    self.nextButton.backgroundColor = .o60
    self.nextButton.setTitleColor(.g90, for: .normal)
  }
  
  @objc func nicknameTextfieldDidchange(){
    guard let text = nicknameTextfield.text,
          let gender = gender else { return }

    nextbuttonUIChange()
  }
  
  func nextbuttonUIChange(){
    nextButton.backgroundColor = .o50
    nextButton.setTitleColor(.white, for: .normal)
  }
  
  // MARK: - 다음 버튼
  func nextButtonTapped(){
    guard let choiceGender = gender,
          let nickname = nicknameTextfield.text else { return }
    
    if nicknameStatusLabel.textColor == .g_10 {
      let departmentVC = DepartmentViewController()
      departmentVC.email = email
      departmentVC.password = password
      departmentVC.nickname = nickname
      departmentVC.gender = gender
      
      navigationController?.pushViewController(departmentVC, animated: true)
    }
  }
}

extension NicknameViewController {
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


