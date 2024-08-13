//
//  PostedStudyCommonetComponent.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/13/24.
//

import UIKit

final class PostedStudyCommonetComponent: UIView,
                                          CreateLabel,
                                          CreateStackView,
                                          CreateTextField,
                                          CreateDividerLine {
  private lazy var countComment: Int = 0
  
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
  private lazy var grayDividerLine4 = createDividerLine(height: 8.0)
  
  private lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    return tableView
  }()
  
  private lazy var commentStackView = createStackView(axis: .vertical, spacing: 10)
  
  private lazy var commentTextField = createTextField(title: "댓글을 입력해주세요")
  
  private lazy var commentButton: UIButton = {
    let button = UIButton()
    button.setTitle("등록", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o30
    button.layer.cornerRadius = 10
    return button
  }()
  
  private lazy var commentButtonStackView = createStackView(axis: .horizontal, spacing: 8)
  
  private lazy var grayDividerLine5 = createDividerLine(height: 8.0)
  
  init(){
    super.init(frame: .null)
    setupLayout()
    makeUI()
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
  }
  
  func makeUI(){
    let tableViewHeight = 86 * countComment
    
    commentTableView.snp.makeConstraints {
      $0.height.equalTo(tableViewHeight)
    }
    
    commentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 20)
    commentStackView.isLayoutMarginsRelativeArrangement = true
    
    commentButton.isEnabled = false
    
    commentButtonStackView.distribution = .fillProportionally
    commentButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    commentButtonStackView.isLayoutMarginsRelativeArrangement = true
    
    commentTextField.snp.makeConstraints {
      $0.height.equalTo(42)
    }
    
//    commentTextField.addTarget(self,
//                               action: #selector(textFieldDidChange(_:)),
//                               for: .editingDidBegin)
  }
}
