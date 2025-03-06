
import UIKit

import SnapKit
import RxSwift
import RxRelay
import RxCocoa

/// 유저 프로필 View
final class ProfileComponentView: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: MyInfomationViewModel
  
  /// 프로필 이미지뷰
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
//    imageView.image = UIImage(named: "ProfileAvatar_change")
    
    return imageView
  }()
  
  /// 프로필 삭제 버튼
  private lazy var deleteButton = createButton(title: "삭제", titleColor: .bg70)
  
  /// 프로필 편집 버튼
  private lazy var editButton = createButton(title: "변경", titleColor: .o50)
  
  init(_ viewModel: MyInfomationViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    setUpLayout()
    makeUI()
    setupBinding()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// Layout 설정
  func setUpLayout(){
    [ profileImageView, deleteButton, editButton]
      .forEach { self.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  /// UI설정
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
  
  /// 이미지 삭제 / 편집 버튼 생성
  func createButton(title: String, titleColor: UIColor) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    button.setTitleColor(titleColor, for: .normal)
    return button
  }
  
  /// 바인딩
  func setupBinding(){
    /// 사용자의 프로필
    viewModel.userProfile
      .asDriver(onErrorJustReturn: UIImage(named: "ProfileAvatar_change")!)
      .drive(onNext: { [weak self] image in
        self?.profileImageView.image = image
        self?.profileImageView.layer.cornerRadius = 35
        self?.profileImageView.clipsToBounds = true
      })
      .disposed(by: disposeBag)
    }
  
  /// actions 설정
  func setupActions(){
    // 프로필 편집 버튼 탭
    editButton.rx
      .tap
      .subscribe(onNext: { _ in
      self.viewModel.steps.accept(AppStep.bottomSheetIsRequired(postOrCommnetID: 0, type: .editProfile))
    }).disposed(by: disposeBag)
    
    // 프로필 삭제 버튼 탭
    deleteButton.rx
      .tap
      .subscribe(onNext: { _ in
        self.viewModel.deleteProfile()
    }).disposed(by: disposeBag)
  }
}


