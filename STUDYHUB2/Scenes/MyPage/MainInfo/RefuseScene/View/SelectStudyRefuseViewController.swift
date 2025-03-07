//
//  RefuseBottomSheet.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/24.
//

import UIKit

import SnapKit
import Then

protocol RefuseBottomSheetDelegate: AnyObject {
  func didTapRefuseButton(withReason reason: String, reasonNum: Int, userId: Int)
}

/// 스터디 신청 거절사유 vc
final class SelectStudyRefuseViewController: UIViewController {
  weak var delegate: RefuseBottomSheetDelegate?
  
  /// 거절할 대상 유저의 ID
  var userId: Int
  
  /// 거절 사유 리스트
  var refuseList = ["이 스터디의 목표와 맞지 않아요",
                    "팀원 조건과 맞지 않아요 (학과, 성별 등)",
                    "소개글이 짧아서 어떤 분인지 알 수 없어요",
                    "기타 (직접 작성)"]
  
  private var selectedButtonTag: Int = -1
  
  /// 거절 사유 제목 라벨
  private lazy var titleLabel = UILabel().then {
    $0.text = "거절 사유"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 18)
  }
  
  /// 거절 사유 유의사항 라벨
  private lazy var descibeLabel = UILabel().then {
    $0.text = "해당 내용은 신청자에게 전송돼요"
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard", size: 12)
  }
  
  /// 거절 버튼
  private lazy var refuseButton: UIButton = UIButton().then {
    $0.setTitle("거절", for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    $0.setTitleColor(.o20, for: .normal)
    $0.addAction(UIAction { _ in
      self.refuseButtonTapped()
    }, for: .touchUpInside)
  }
  
  /// 거절사유 TableView
  private lazy var reasonTableView: UITableView = UITableView().then {
    $0.register(RefuseCell.self, forCellReuseIdentifier: RefuseCell.cellID)
    $0.backgroundColor = .white
    $0.separatorInset.left = 0
    $0.layer.cornerRadius = 10
  }
  
  init(userId: Int) {
    self.userId = userId
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupLayout()
    makeUI()
    
    reasonTableView.delegate = self
    reasonTableView.dataSource = self
  } // viewDidLoad
  
  // MARK: - setupLayout
  
  
  /// layout 설정
  func setupLayout(){
    [ titleLabel, descibeLabel, refuseButton, reasonTableView]
      .forEach { view.addSubview($0) }
  }
  
  // MARK: - makeUI
  
  /// UI설정
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
    
    descibeLabel.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
    }
    
    refuseButton.isEnabled = false
    refuseButton.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.top).offset(-10)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalTo(reasonTableView.snp.top).offset(-10)
    }
    
    reasonTableView.snp.makeConstraints {
      $0.top.equalTo(descibeLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

// MARK: - tableview


extension SelectStudyRefuseViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return refuseList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = reasonTableView.dequeueReusableCell(withIdentifier: RefuseCell.cellID,
                                                   for: indexPath) as! RefuseCell
    let refuseReason = refuseList[indexPath.row]
    cell.setReasonLabel(reason: refuseReason)
    
    cell.selectionStyle = .none
    cell.tag = indexPath.row
    cell.checkButton.addAction(UIAction {[weak self] _ in
      self?.handleButtonTap(tag: cell.tag)
    }, for: .touchUpInside)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func handleButtonTap(tag: Int) {
    for index in 0..<refuseList.count {
      if index != tag {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = reasonTableView.cellForRow(at: indexPath) as? RefuseCell {
          cell.checkButton.isSelected = false
          cell.checkButton.setImage(UIImage(named: "ButtonEmpty"), for: .normal)
        }
      }
    }
    
    selectedButtonTag = tag
    
    if let selectedCell = reasonTableView.cellForRow(at: IndexPath(row: tag, section: 0)) as? RefuseCell {
//      let image = selectedCell.checkButton.isSelected ? "ButtonChecked" : "ButtonEmpty"
      selectedCell.checkButton.isSelected.toggle()
      let imageName = selectedCell.checkButton.isSelected ? "ButtonChecked" : "ButtonEmpty"
      selectedCell.checkButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    updateRefuseButtonState()
  }

  /// 선택한 버튼에 따른 버튼 활성화
  func updateRefuseButtonState() {
    if selectedButtonTag != -1 {
      refuseButton.isEnabled = true
      refuseButton.setTitleColor(.o50, for: .normal)
    } else {
      refuseButton.isEnabled = false
      refuseButton.setTitleColor(.o20, for: .normal)
    }
  }
  
  /// 거절 버튼 탭
  func refuseButtonTapped() {
    self.dismiss(animated: true)
    
    let refuseReason = refuseList[selectedButtonTag]
    delegate?.didTapRefuseButton(
      withReason: refuseReason,
      reasonNum: selectedButtonTag,
      userId: userId
    )
  }
}

