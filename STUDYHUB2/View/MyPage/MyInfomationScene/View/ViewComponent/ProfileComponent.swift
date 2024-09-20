
import UIKit

import SnapKit
import RxRelay
import RxCocoa

final class ProfileComponent: UIView {
  let viewModel: MyInfomationViewModel
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "ProfileAvatar_change")
    
    return imageView
  }()
  
  private lazy var deleteButton = createButton(title: "삭제", titleColor: .bg70)
  private lazy var editButton = createButton(title: "변경", titleColor: .o50)
  
  init(_ viewModel: MyInfomationViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    setUpLayout()
    makeUI()
    setupBinding()
    setupActions()
    
    viewModel.fetchUserProfile()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpLayout(){
    [
      profileImageView,
      deleteButton,
      editButton
    ].forEach {
      self.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.width.height.equalTo(80)
      $0.centerX.equalToSuperview()
    }
    
    deleteButton.snp.makeConstraints {
      $0.leading.equalTo(profileImageView.snp.leading).offset(-5)
      $0.top.equalTo(profileImageView.snp.bottom).offset(10)
      $0.width.equalTo(45)
      $0.height.equalTo(30)
    }
    
    editButton.snp.makeConstraints {
      $0.trailing.equalTo(profileImageView.snp.trailing).offset(5)
      $0.top.equalTo(profileImageView.snp.bottom).offset(10)
      $0.width.equalTo(45)
      $0.height.equalTo(30)
    }
  }
  
  func createButton(title: String, titleColor: UIColor) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    button.setTitleColor(titleColor, for: .normal)
    return button
  }
  
  func setupBinding(){
    viewModel.userProfile
      .asDriver(onErrorJustReturn: UIImage(named: "ProfileAvatar_change")!)
      .drive(onNext: { [weak self] image in
        self?.profileImageView.image = image
        self?.profileImageView.layer.cornerRadius = 35
        self?.profileImageView.clipsToBounds = true
      })
      .disposed(by: viewModel.disposeBag)
    }
  
  func setupActions(){
    let buttonList: [(UIButton, EditInfomationList)] = [
      (deleteButton, .deleteProfile),
      (editButton, .editProfile)
    ]
    
    buttonList.forEach { button, action in
      button.rx.tap
        .subscribe(onNext: {[weak self] in
          self?.viewModel.editButtonTapped.accept(action)
        })
        .disposed(by: viewModel.disposeBag)
    }

  }
}


