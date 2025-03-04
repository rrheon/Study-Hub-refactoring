
import Foundation

import SnapKit
import RxSwift
import RxCocoa

/// 비밀번호 수정 VC
final class EditPasswordViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: EditPasswordViewModel
  
  /// 첫 번째 View의 Value
  let firstTextFieldvalue = EditPasswordTextFieldValue(
    labelTitle: "새로운 비밀번호를 입력해주세요",
    textFieldTitle: "10자리 이상, 특수문자 포함 필수",
    alertContentToSuccess: "사용 가능한 비밀번호예요",
    alertContentToFail: "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)"
  )
  
  /// 첫 번째 비밀번호 입력 View
  private lazy var firstPasswordTextField = EditPasswordTextField(firstTextFieldvalue)
  
  /// 두 번째 View의 Value
  let secondTextFieldvalue = EditPasswordTextFieldValue(
    labelTitle: "새로운 비밀번호를 한 번 더 입력해주세요",
    textFieldTitle: "새 비밀번호 한 번 더 입력",
    alertContentToSuccess: "비밀번호가 일치해요",
    alertContentToFail: "비밀번호가 일치하지 않아요"
  )
  
  /// 두 번째 View의 Value
  private lazy var secondPasswordTextField = EditPasswordTextField(secondTextFieldvalue)
  
  init(with viewModel: EditPasswordViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    makeUI()
    
    setupActions()
    setupBinding()
  } // viewDidLoad
  
  
  /// UI 설정
  func makeUI(){
    view.addSubview(firstPasswordTextField)
    firstPasswordTextField.textField.delegate = self
    firstPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(100)
    }
    
    view.addSubview(secondPasswordTextField)
    secondPasswordTextField.textField.delegate = self
    secondPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(firstPasswordTextField.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(firstPasswordTextField)
      $0.height.equalTo(100)
    }
  }
  
  /// 네비게이션 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "비밀번호 변경")
    leftButtonSetting()
    rightButtonSetting(imgName: "DeCompletedImg", activate: false)
    
    settingNavigationbar()
  }
  
  /// 네비게이션 바 오른쪽 버튼 탭 -> 비밀번호 저장
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.storePasswordToServer()
  }

  
  /// 바인딩 설정
  func setupBinding(){
    firstPasswordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.firstPassword)
      .disposed(by: disposeBag)
    
    secondPasswordTextField.textField.rx.text.orEmpty
      .bind(to: viewModel.secondPassword)
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    // 첫 번째 TextFeild에 입력한 비밀번호
    viewModel.firstPassword
      .asDriver(onErrorJustReturn: "")
      .filter({ !$0.isEmpty })
      .drive(onNext: { [weak self] password in
        guard let self = self else { return }
        let checkValid = Utils.isValidPassword(password)
        
        checkValidPassword(textfield: firstPasswordTextField, checkValid: checkValid)
      })
      .disposed(by: disposeBag)
    
    // 두 번째 TextFeild에 입력한 비밀번호
    viewModel.secondPassword
      .asDriver(onErrorJustReturn: "")
      .filter({ !$0.isEmpty })
      .drive(onNext: { [weak self] password in
        guard let self = self else { return }
        let checkSamePassword = viewModel.checkSamePassword()
        
        checkValidPassword(textfield: secondPasswordTextField, checkValid: checkSamePassword)
        
        let rightButtonImg = checkSamePassword ? "CompleteImage" : "DeCompletedImg"
        rightButtonSetting(imgName: rightButtonImg, activate: checkSamePassword)
      })
      .disposed(by: disposeBag)
    
    // 비밀번호 변경 성공여부
    viewModel.isSuccessChangePassword
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] result in
        // 사용자 정보 가져오기
        UserProfileManager.shared.fetchUserInfoToServer { userData in
          // 성공 : 비로그인시 -> 로그인화면
          if userData.nickname == nil && result {
            NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
          // 성공 :로그인 시 -> 프로필 편집화면
          }else if userData.nickname != nil && result {
            self?.viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: false,
                                                                  animate: true))
          // 실패 -> 팝업
          }else {
            ToastPopupManager.shared.showToast(message: "비밀번호 변경에 실패했어요. 다시 시도해주세요.")
          }
        }
        NotificationCenter.default.post(name: .dismissCurrentFlow, object: nil)
        ToastPopupManager.shared.showToast(message: "비밀번호가 변경됐어요")
      })
      .disposed(by: disposeBag)
  }
  
  /// 비밀번호 유효성 체크
  func checkValidPassword(textfield: EditPasswordTextField, checkValid: Bool){
    switch checkValid {
    case true:
      textfield.alertLabelSetting(hidden: false, successOrFail: true, textColor: .g_10)
    case false:
      textfield.alertLabelSetting(hidden: false, successOrFail: false, textColor: .r50)
    }
  }
}

extension EditPasswordViewController {
  override func textFieldDidBeginEditing(_ textField: UITextField) {}
  override func textFieldDidEndEditing(_ textField: UITextField) {}
}

