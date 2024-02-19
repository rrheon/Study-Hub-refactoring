//
//  DetailRejectReasonViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/19.
//

import UIKit

import SnapKit

final class DetailRejectReasonViewController: NaviHelper {
  
  var rejectData: RejectReason? {
    didSet {
      titleLabel.text = rejectData?.studyTitle
      rejectReasonLabel.text = rejectData?.reason
    }
  }
  
  private lazy var titleLabel = createLabel(title: "Test",
                                            textColor: .bg80,
                                            fontType: "Pretendard-Medium",
                                            fontSize: 14)
  
  private lazy var rejectTitleLabel = createLabel(title: "스터디 팀장의 거절 이유예요 😢",
                                                  textColor: .black,
                                                  fontType: "Pretendard-SemiBold",
                                                  fontSize: 16)
  
  lazy var rejectReasonLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10))
    label.text = " 수락 대기 중 "
    label.textColor = .g80
    label.backgroundColor = .bg20
    label.layer.cornerRadius = 10
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var confirmButton: UIButton = {
    let button = UIButton()
    button.setTitle("확인", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o50
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      self.navigationController?.popViewController(animated: true)
    }, for: .touchUpInside)
    return button
  }()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupLayout()
    makeUI()
    
    navigationItemSetting()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      rejectTitleLabel,
      rejectReasonLabel,
      confirmButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
    
    rejectTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
    }
    
    rejectReasonLabel.snp.makeConstraints {
      $0.top.equalTo(rejectTitleLabel.snp.bottom).offset(30)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    confirmButton.snp.makeConstraints {
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(57)
      $0.bottom.equalToSuperview().offset(-50)
    }
  }
  
  // MARK: - navigation
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none

    settingNavigationTitle(title: "거절 이유")
  }
  
}
