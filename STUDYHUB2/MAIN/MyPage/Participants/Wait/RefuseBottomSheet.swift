//
//  RefuseBottomSheet.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/24.
//

import UIKit

import SnapKit

protocol RefuseBottomSheetDelegate: AnyObject {
  func didTapRefuseButton(withReason reason: String, reasonNum: Int, userId: Int)
}

final class RefuseBottomSheet: UIViewController {
  weak var delegate: RefuseBottomSheetDelegate?
  var userId: Int = 0
  
  var refuseList = ["이 스터디의 목표와 맞지 않아요",
                    "팀원 조건과 맞지 않아요 (학과, 성별 등)",
                    "소개글이 짧아서 어떤 분인지 알 수 없어요",
                    "기타 (직접 작성)"]
  
  private var selectedButtonTag: Int = -1
  
  private lazy var titleLabel = createLabel(title: "거절 사유",
                                            textColor: .black,
                                            fontType: "Pretendard",
                                            fontSize: 18)
  private lazy var descibeLabel = createLabel(title: "해당 내용은 신청자에게 전송돼요",
                                              textColor: .bg70,
                                              fontType: "Pretendard",
                                              fontSize: 12)
  
  private lazy var refuseButton: UIButton = {
    let button = UIButton()
    button.setTitle("거절", for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.setTitleColor(.o20, for: .normal)
    button.addAction(UIAction { _ in
      self.refuseButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var reasonTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(RefuseCell.self,
                       forCellReuseIdentifier: RefuseCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupLayout()
    makeUI()
    
    reasonTableView.delegate = self
    reasonTableView.dataSource = self
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      descibeLabel,
      refuseButton,
      reasonTableView
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
extension RefuseBottomSheet: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return refuseList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = reasonTableView.dequeueReusableCell(withIdentifier: RefuseCell.cellId,
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
      selectedCell.checkButton.isSelected.toggle()
      selectedCell.checkButton.setImage(selectedCell.checkButton.isSelected ? UIImage(named: "ButtonChecked") : UIImage(named: "ButtonEmpty"), for: .normal)
    }
    
    updateRefuseButtonState()
  }

  
  func updateRefuseButtonState() {
    if selectedButtonTag != -1 {
      refuseButton.isEnabled = true
      refuseButton.setTitleColor(.o50, for: .normal)
    } else {
      refuseButton.isEnabled = false
      refuseButton.setTitleColor(.o20, for: .normal)
    }
  }
  
  func refuseButtonTapped() {
    self.dismiss(animated: true)
    
    let refuseReason = refuseList[selectedButtonTag]
    delegate?.didTapRefuseButton(withReason: refuseReason, reasonNum: selectedButtonTag, userId: userId)
  }
}

