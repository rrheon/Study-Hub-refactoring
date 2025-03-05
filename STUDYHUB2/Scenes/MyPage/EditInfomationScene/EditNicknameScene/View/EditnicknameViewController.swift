
import UIKit

import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import Then

/// 유저 닉네임 수정 VC
final class EditnicknameViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()

  let viewModel: EditNicknameViewModel
  
  // MARK: - UI 앞화면에 데이터 동기화
  
  /// 제목 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = "새로운 닉네임을 알려주세요"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 16)
  }

  /// 새로운 닉네임 입력 TextField
  private lazy var newNickNameTextField = StudyHubUI.createTextField(
    title: viewModel.userData.value?.nickname ?? "없음"
  )
  
  
  /// 닉네임 길이 제한 라벨
  private lazy var characterCountLabel = UILabel().then {
    $0.text = "0/10"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard", size: 12)
  }
  
  /// 이미 존재하는 닉네임 경고 라벨
  private lazy var checkNicknameLabel = UILabel().then {
    $0.text = "이미 존재하는 닉네임이에요"
    $0.textColor = .r50
    $0.font = UIFont(name: "Pretendard", size: 12)
  }
  
  init(with viewModel: EditNicknameViewModel) {
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
    
    makeUI()
    
    setupBinding()
    setupAction()
  }// viewDidLoad
  

  // MARK: - makeUI
  
  
  /// UI 설정
  func makeUI(){
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    view.addSubview(newNickNameTextField)
    newNickNameTextField.delegate = self
    newNickNameTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    view.addSubview(characterCountLabel)
    characterCountLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(newNickNameTextField.snp.bottom).offset(10)
    }
    
    view.addSubview(checkNicknameLabel)
    checkNicknameLabel.isHidden = true
    checkNicknameLabel.snp.makeConstraints {
      $0.leading.equalTo(newNickNameTextField.snp.leading)
      $0.top.equalTo(newNickNameTextField.snp.bottom)
    }
  }
  
  // MARK: - setupNavigationbar
  
  /// 네비게이션 바 세팅
  func setupNavigationbar(){
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg", activate: false)
    settingNavigationTitle(title: "닉네임 변경")
    
    settingNavigationbar()
  }
 
  /// 네비게이션 바 왼쪽 아이탬 탭
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(animate: true))
  }
  
  /// 네비게이션 바 오른쪽 아이탬 탭
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
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
 
  
  /// 바인딩
  func setupBinding(){
    newNickNameTextField.rx.text.orEmpty
      .bind(to: viewModel.newNickname)
      .disposed(by: disposeBag)
  }
  
  // MARK: - setupAction
  
  /// action 설정
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
      .disposed(by: disposeBag)
    
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
      .disposed(by: disposeBag)
  }

  
  /// 닉네임 변경에 성공했을 경우
  func successToChangeNickname(){
    guard let newNickname = viewModel.newNickname.value else { return }
    viewModel.storeNicknameToServer(newNickname)
  
    ToastPopupManager.shared.showToast(message: "닉네임이 변경되었어요")
    self.navigationController?.popViewController(animated: true)
  }
  
  /// 닉네임 변경에 실패했을 경우
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
