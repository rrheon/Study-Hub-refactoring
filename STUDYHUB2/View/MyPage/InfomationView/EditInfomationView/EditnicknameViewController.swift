import UIKit

import SnapKit
import Moya

final class EditnicknameViewController: NaviHelper {
  
  
  let editUserInfo = EditUserInfoManager.shared
  var changeNickname: String?
  
  // MARK: - UI
  private lazy var titleLabel = createLabel(title: "새로운 닉네임을 알려주세요",
                                            textColor: .black,
                                            fontType: "Pretendard-Bold",
                                            fontSize: 16)
  
  private lazy var newNickNameTextField = createTextField(title: changeNickname ?? "없음")
  
  private lazy var characterCountLabel = createLabel(title: "0/10",
                                                     textColor: .bg70,
                                                     fontType: "Pretendard",
                                                     fontSize: 12)
  
  private lazy var checkNicknameLabel = createLabel(title: "이미 존재하는 닉네임이에요",
                                                    textColor: .r50,
                                                    fontType: "Pretendard",
                                                    fontSize: 12)
  
  var previousVC: MyInformViewController?

  // MARK: - viewWillDisappear
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent { previousVC?.nickname = changeNickname }
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    [
      titleLabel,
      newNickNameTextField,
      characterCountLabel,
      checkNicknameLabel
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
    
    newNickNameTextField.delegate = self
    newNickNameTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    characterCountLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(newNickNameTextField.snp.bottom).offset(10)
    }
    
    checkNicknameLabel.snp.makeConstraints {
      $0.leading.equalTo(newNickNameTextField.snp.leading)
      $0.top.equalTo(newNickNameTextField.snp.bottom)
    }
    checkNicknameLabel.isHidden = true
  }
  
  // MARK: - navigation
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItem = .none

    settingNavigationTitle(title: "닉네임 변경",
                           font: "Pretendard-Bold",
                           size: 18)
    changeRightNavigationItem(complete: false)
  }
  
  // MARK: - 중복검사하는 기능 - 못하고 있음, 특문 이런거 확인하는 기능, 닉네임이 변경가능할 때
  @objc func completeButtonTapped() {
    guard let nickname = newNickNameTextField.text else { return }

    checkValidandDuplication(nickname: nickname) { isValid in      
      if isValid {
        self.editUserInfo.editUserNickname(nickname) {
          DispatchQueue.main.async {
            self.changeNickname = nickname
            self.showToast(message: "닉네임이 변경되었어요", alertCheck: true)
          
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    }
  }

  // MARK: - 닉네임 중복 확인
  func checkValidandDuplication(nickname: String, completion: @escaping (Bool) -> Void) {
    let checkNickname = checkValidNickname(nickname: nickname)

    if checkNickname == true {
      editUserInfo.checkNicknameDuplication(nickName: nickname) { status in
        print(status)
        // badrequest == 중복 , error == 가능
        if status == "Error" {
          print("변경가능")
          DispatchQueue.main.async {
            self.newNickNameTextField.layer.borderColor = UIColor.bg50.cgColor
            self.changeRightNavigationItem(complete: true)
            
            self.checkNicknameLabel.isHidden = true
            self.characterCountLabel.isHidden = false
          }
          
          completion(true)
        } else {
          DispatchQueue.main.async {
            self.changeRightNavigationItem(complete: false)
            
            self.newNickNameTextField.layer.borderColor = UIColor.r50.cgColor
            self.checkNicknameLabel.text = "이미 존재하는 닉네임이에요"
            
            self.checkNicknameLabel.isHidden = false
            self.characterCountLabel.isHidden = true
          }
          completion(false)
        }
      }
    } else {
      changeRightNavigationItem(complete: false)
      
      checkNicknameLabel.isHidden = false
      characterCountLabel.isHidden = true
      
      checkNicknameLabel.text = "이모티콘, 특수문자, 띄어쓰기는 사용할 수 없어요"
      newNickNameTextField.layer.borderColor = UIColor.r50.cgColor
    }
    completion(false)
  }
  
  // MARK: - 오른쪽 버튼 활성화, 비활성화
  func changeRightNavigationItem(complete: Bool){
    if complete == true {
      let completeImg = UIImage(named: "CompleteImage")?.withRenderingMode(.alwaysOriginal)
      let completeButton = UIBarButtonItem(image: completeImg,
                                           style: .plain,
                                           target: self,
                                           action: #selector(completeButtonTapped))
      navigationItem.rightBarButtonItem = completeButton
    } else {
      let completeImg = UIImage(named: "DeCompletedImg")?.withRenderingMode(.alwaysOriginal)
      let completeButton = UIBarButtonItem(image: completeImg,
                                           style: .plain,
                                           target: self,
                                           action: nil)
      completeButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
      navigationItem.rightBarButtonItem = completeButton
    }
  }
  
  // MARK: - 유효성 검사
  func checkValidNickname(nickname: String) -> Bool {
    let pattern = "^[a-zA-Z0-9가-힣]*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: nickname.utf16.count)

    return regex?.firstMatch(in: nickname, options: [], range: range) != nil ? true : false
  }
}

extension EditnicknameViewController {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if let text = textField.text, !text.isEmpty {
      // 텍스트 필드에 값이 있을 때
     changeRightNavigationItem(complete: true)
    } else {
      // 텍스트 필드가 비어 있을 때
      changeRightNavigationItem(complete: true)
    }
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    let changedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    characterCountLabel.text = "\(changedText.count)/10"
    characterCountLabel.changeColor(label: characterCountLabel,
                                    wantToChange: "\(changedText.count)",
                                    color: .bg90)
    return changedText.count <= 9
  }
}
