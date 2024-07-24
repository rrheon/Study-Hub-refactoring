//
//  DeleteIDViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/05.
//

import UIKit

import SnapKit
import Moya

final class DeleteIDViewContoller: NaviHelper {
  
  private lazy var titleLabel = createLabel(title: "정말 탈퇴하시나요?\n회원님이 떠나신다니 너무 아쉬워요😢",
                                            textColor: .black,
                                            fontType: "Pretendard-Bold",
                                            fontSize: 20)
  private lazy var mainView: UIView = {
    let view = UIView()
    view.backgroundColor = .bg20
    view.layer.borderColor = UIColor.bg40.cgColor
    return view
  }()
  
  private lazy var infoTitleLabel = createLabel(title: "스터디 허브를 탈퇴하시면,",
                                                textColor: .black,
                                                fontType: "Pretendard-SemiBold",
                                                fontSize: 16)
  
  private lazy var infoDescriptionLabel1: UILabel = {
    let label = UILabel()
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.numberOfLines = 0
    label.text = """
          해당 계정으로 활동하신 모든 내역과 개인정보가 삭제되어 복구가 어려워요.
          """
    return label
  }()
  
  private lazy var infoDescriptionLabel2: UILabel = {
    let label = UILabel()
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.numberOfLines = 0
    label.text = """
          스터디에 참여한 참여자들의 정보를 다시 볼 수 없어요.
          맞춤 스터디 소식을 알려드릴 수 없어요.
          재가입 시, 다시 처음부터 계정 인증을 받아야 해요.
          """
    label.setLineSpacing(spacing: 40)

    return label
  }()
  
  private lazy var buttonStackView = createStackView(axis: .horizontal,
                                                     spacing: 8)
  
  private lazy var continueButton: UIButton = {
    let button = UIButton()
    button.setTitle("계속", for: .normal)
    button.setTitleColor(.bg80, for: .normal)
    button.backgroundColor = .bg30
    button.addAction(UIAction { _ in
      self.continueButtonTapped()
    }, for: .touchUpInside)
    button.layer.cornerRadius = 10
    return button
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .o50
    button.addAction(UIAction { _ in
      self.cancelButtonTapped()
    }, for: .touchUpInside)
    button.layer.cornerRadius = 10
    return button
  }()
  
  // MARK: - 계속 버튼을 누른 경우
  private lazy var enterPasswordLabel = createLabel(title: "비밀번호를 입력해주세요",
                                                    textColor: .black,
                                                    fontType: "Pretendard",
                                                    fontSize: 16)
  
  private lazy var enterPassowrdTextField = createTextField(title: "현재 비밀번호")
  
  private lazy var hidePasswordButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "CloseEyeImage"), for: .normal)
    button.addAction(UIAction{ _ in
      self.hidePasswordButtonTapped(self.hidePasswordButton)
    }, for: .touchUpInside)
    return button
  }()

  private lazy var quitButton: UIButton = {
    let button = UIButton()
    button.setTitle("탈퇴하기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .o30
    button.addAction(UIAction { _ in
      self.checkValidPassword()
    }, for: .touchUpInside)
    button.layer.cornerRadius = 10
    return button
  }()
  
  // MARK: - viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    buttonStackView.addArrangedSubview(continueButton)
    buttonStackView.addArrangedSubview(cancelButton)
    
    [
      titleLabel,
      mainView,
      infoTitleLabel,
      infoDescriptionLabel1,
      infoDescriptionLabel2,
      buttonStackView
    ].forEach {
      view.addSubview($0)
    }
  }
  // MARK: - makeUI
  func makeUI(){
    titleLabel.numberOfLines = 2
    titleLabel.changeColor(label: titleLabel,
                           wantToChange: "회원님이 떠나신다니 너무 아쉬워요😢",
                           color: .bg80,
                           font: UIFont(name: "Pretendard", size: 14),
                           lineSpacing: 10)
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
    
    mainView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(300)
    }
    
    infoTitleLabel.snp.makeConstraints {
      $0.top.equalTo(mainView.snp.top).offset(30)
      $0.leading.equalTo(mainView.snp.leading).offset(20)
      $0.trailing.equalTo(mainView.snp.trailing).offset(-20)
    }
    
    infoDescriptionLabel1.snp.makeConstraints {
      $0.top.equalTo(infoTitleLabel.snp.bottom).offset(35)
      $0.leading.equalTo(infoTitleLabel.snp.leading)
      $0.trailing.equalTo(mainView.snp.trailing).offset(-30)
    }
    
    infoDescriptionLabel2.snp.makeConstraints {
      $0.top.equalTo(infoDescriptionLabel1.snp.bottom).offset(35)
      $0.leading.equalTo(infoTitleLabel.snp.leading)
      $0.trailing.equalTo(mainView.snp.trailing).offset(-20)
    }
    
    buttonStackView.distribution = .fillEqually
    buttonStackView.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-60)
      $0.leading.equalTo(mainView.snp.leading)
      $0.trailing.equalTo(mainView.snp.trailing)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - 네비게이션바 재설정
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItem = .none
    settingNavigationTitle(title: "탈퇴하기",
                           font: "Pretendard-Bold",
                           size: 18)
  }
  
  // MARK: - 탈퇴 계속 진행 시
  func continueButtonTapped(){
    titleLabel.isHidden = true
    mainView.isHidden = true
    infoTitleLabel.isHidden = true
    infoDescriptionLabel1.isHidden = true
    infoDescriptionLabel2.isHidden = true
    buttonStackView.isHidden = true
    
    [
      enterPasswordLabel,
      enterPassowrdTextField,
      hidePasswordButton,
      quitButton
    ].forEach {
      view.addSubview($0)
    }
    
    enterPasswordLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    enterPassowrdTextField.addTarget(self,
                                   action: #selector(textFieldDidChange(_:)),
                                   for: .editingChanged)
    enterPassowrdTextField.isSecureTextEntry = true
    enterPassowrdTextField.snp.makeConstraints {
      $0.top.equalTo(enterPasswordLabel.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(50)
    }
    
    hidePasswordButton.snp.makeConstraints {
      $0.centerY.equalTo(enterPassowrdTextField)
      $0.trailing.equalTo(enterPassowrdTextField.snp.trailing).offset(-10)
    }
    
    quitButton.snp.makeConstraints {
      $0.top.equalTo(enterPassowrdTextField.snp.bottom).offset(30)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  func cancelButtonTapped(){
    self.dismiss(animated: true)
  }
  
  func hidePasswordButtonTapped(_ sender: UIButton){
    let isPasswordVisible = sender.isSelected
    
    // 모든 텍스트 필드에 대해서 isSecureTextEntry 속성을 변경하여 비밀번호 보이기/가리기 설정
    enterPassowrdTextField.isSecureTextEntry = !isPasswordVisible
    
    // 버튼의 상태 업데이트
    sender.isSelected = !isPasswordVisible
  }
  
  // MARK: - 비밀번호 일치여부 확인
  func checkValidPassword(){
    guard let password = enterPassowrdTextField.text else { return }
    print(password)
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.verifyPassword(_password: password)) { result in
      switch result {
      case .success(let response):
        // 성공시 - 확인 버튼 활성화, 실패 시 - 토스트 팝업 띄우기케이스를 나눠야할듯 200
        print(response.response)
        switch response.statusCode{
        case 200:
          self.quitButton.addAction(UIAction { _ in
            self.quitButtonTapped()
          }, for: .touchUpInside)
        default:
          self.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
        }
      case .failure(let response):
        print(response.response)
        self.showToast(message: "비밀번호가 일치하지 않아요. 다시 입력해주세요.", alertCheck: false)
      }
    }
  }
  
  func quitButtonTapped(){
    print("탈퇴하기 활성화")
//    let provider = MoyaProvider<networkingAPI>()
//    provider.request(.deleteID) {
//      switch $0 {
//      case .success(let response):
//        print(response)
//      case .failure(let response):
//        print(response)
//      }
//    }
    let popupVC = PopupViewController(title: "탈퇴가 완료됐어요",
                                      desc: "지금까지 스터디허브를 이용해 주셔서 감사합니다.",
                                      leftButtonTitle: "아니요",
                                      rightButtonTilte: "네",
                                      checkEndButton: true)
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.endButtonAction = { [weak self] in
      if let navigationController = self?.navigationController {
        navigationController.dismiss(animated: true)
        navigationController.popToRootViewController(animated: false)
       
        TokenManager.shared.deleteTokens()
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .overFullScreen
        navigationController.present(loginVC, animated: true, completion: nil)
      }
    }
  }
}

extension DeleteIDViewContoller{
  @objc func textFieldDidChange(_ textField: UITextField) {
    print(enterPassowrdTextField.text?.isEmpty)
    if enterPassowrdTextField.text?.isEmpty == false {
      quitButton.backgroundColor = .o50
      quitButton.isEnabled = true

    } else {
      quitButton.backgroundColor = .o30
      quitButton.isEnabled = false

    }
  }
}
