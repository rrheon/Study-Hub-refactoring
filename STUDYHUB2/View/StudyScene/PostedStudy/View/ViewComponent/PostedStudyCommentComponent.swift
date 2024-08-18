//
//  PostedStudyCommonetComponent.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

import SnapKit

final class PostedStudyCommentComponent: UIView, CreateUIprotocol {

  lazy var countComment: Int = 0 {
    didSet {
      setupLayout()
      makeUI()
      
      commentLabel.text = "댓글 \(countComment)"
    }
  }
  
  private lazy var commentLabel = createLabel(
    title: "댓글 0",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var moveToCommentViewButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  private lazy var commentLabelStackView = createStackView(axis: .horizontal, spacing: 10)
  
  lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    return tableView
  }()
  
  private lazy var commentStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var commentTextField = createTextField(title: "댓글을 입력해주세요")
  private lazy var commentButton = StudyHubButton(title: "등록")
  private lazy var commentButtonStackView = createStackView(axis: .horizontal, spacing: 8)
    
  init(){
    super.init(frame: .zero)
  
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      commentLabel,
      moveToCommentViewButton
    ].forEach {
      commentLabelStackView.addArrangedSubview($0)
    }
    
    if countComment == 0 {
      moveToCommentViewButton.isHidden = true
    }
    
    commentStackView.addArrangedSubview(commentTableView)
    
    [
      commentTextField,
      commentButton
    ].forEach {
      commentButtonStackView.addArrangedSubview($0)
    }
    
    [
      commentLabelStackView,
      commentStackView,
      commentButtonStackView
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    let tableViewHeight = 86 * countComment
    
    commentTableView.snp.makeConstraints {
      $0.height.equalTo(tableViewHeight)
      $0.leading.equalToSuperview().inset(10)
    }
    
    commentLabelStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(20)
    }
    
    commentStackView.snp.makeConstraints {
      $0.top.equalTo(commentLabelStackView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    commentButton.snp.makeConstraints {
      $0.height.equalTo(42)
      $0.width.equalTo(65)
    }
    
    commentButtonStackView.snp.makeConstraints {
      $0.top.equalTo(commentStackView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
}
