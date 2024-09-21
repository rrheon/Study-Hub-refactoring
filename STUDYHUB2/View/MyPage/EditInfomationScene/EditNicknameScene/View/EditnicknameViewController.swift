
import UIKit

import SnapKit
import RxSwift
import RxRelay
import RxCocoa

final class EditnicknameViewController: CommonNavi {
  let viewModel: EditNicknameViewModel
  
  // MARK: - UI 앞화면에 데이터 동기화
  
  
  private lazy var titleLabel = createLabel(
    title: "새로운 닉네임을 알려주세요",
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 16
  )
  
  private lazy var newNickNameTextField = createTextField(
    title: viewModel.userData.value?.nickname ?? "없음"
  )
  
  private lazy var characterCountLabel = createLabel(
    title: "0/10",
    textColor: .bg70,
    fontType: "Pretendard",
    fontSize: 12
  )
  
  private lazy var checkNicknameLabel = createLabel(
    title: "이미 존재하는 닉네임이에요",
    textColor: .r50,
    fontType: "Pretendard",
    fontSize: 12
  )
  
  init(_ userData: BehaviorRelay<UserDetailData?>) {
    self.viewModel = EditNicknameViewModel(userData: userData)
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
    
    setUpLayout()
    makeUI()
    
    setupBinding()
    setupAction()
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
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
    
    checkNicknameLabel.isHidden = true
    checkNicknameLabel.snp.makeConstraints {
      $0.leading.equalTo(newNickNameTextField.snp.leading)
      $0.top.equalTo(newNickNameTextField.snp.bottom)
    }
  }
  
  // MARK: - setupNavigationbar
  
  
  func setupNavigationbar(){
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg", activate: false)
    settingNavigationTitle(title: "닉네임 변경")
  }
  
  
  func setupBinding(){
    newNickNameTextField.rx.text.orEmpty
      .bind(to: viewModel.newNickname)
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupAction(){
    viewModel.newNickname
      .asDriver()
      .drive(onNext: { [weak self] nickname in
        guard let newNickname = nickname, !newNickname.isEmpty else {
          self?.rightButtonSetting(imgName: "DeCompletedImg", activate: false)
          return
        }
        self?.rightButtonSetting(imgName: "CompleteImage", activate: true)
        self?.failToCheckNickname(borderColor: .bg50, text: "", alertHidden: true)
        self?.characterCountLabel.isHidden = false
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isCheckNicknameDuplication
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] result in
        switch result {
        case "Error":
          self?.successToChangeNickname()
        default:
          self?.rightButtonSetting(imgName: "DeCompletedImg", activate: false)
          self?.failToCheckNickname(borderColor: .r50, text: "이미 존재하는 닉네임이에요")
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    guard let newNickname = viewModel.newNickname.value else { return }

    let valid = self.viewModel.checkValidNickname(nickname: newNickname)

    switch valid {
    case true:
      viewModel.checkNicknameDuplication(newNickname)
    case false:
      rightButtonSetting(imgName: "DeCompletedImg", activate: false)
      failToCheckNickname(borderColor: .r50, text: "이모티콘, 특수문자, 띄어쓰기는 사용할 수 없어요")
    }
  }
  
  func successToChangeNickname(){
    guard let newNickname = viewModel.newNickname.value else { return }
    viewModel.storeNicknameToServer(newNickname)
  
    self.showToast(message: "닉네임이 변경되었어요", alertCheck: true)
    self.navigationController?.popViewController(animated: true)
  }
  
  func failToCheckNickname(borderColor: UIColor, text: String, alertHidden: Bool = false){
    newNickNameTextField.layer.borderColor = borderColor.cgColor
    self.checkNicknameLabel.text = text
    self.checkNicknameLabel.isHidden = alertHidden
    self.characterCountLabel.isHidden = !alertHidden
  }
}

extension EditnicknameViewController {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    let changedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    characterCountLabel.text = "\(changedText.count)/10"
    characterCountLabel.changeColor(wantToChange: "\(changedText.count)", color: .bg90)
    return changedText.count <= 9
  }
}

extension EditnicknameViewController: CreateUIprotocol {}
