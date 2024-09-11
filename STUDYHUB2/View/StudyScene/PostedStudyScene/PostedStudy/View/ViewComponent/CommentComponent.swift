import UIKit

import SnapKit

final class PostedStudyCommentComponent: UIView, CreateUIprotocol {
  
  lazy var countComment: Int = 0 {
    didSet {
      updateCommentLabel()
      tableViewResizing()
    }
  }
  
  private lazy var commentLabel = createLabel(
    title: "댓글 0",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  lazy var moveToCommentViewButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .black
    button.isHidden = countComment == 0
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
  private lazy var divideLineTopTextField = createDividerLine(height: 1.0)
  lazy var commentTextField = createTextField(title: "댓글을 입력해주세요")
  lazy var commentButton = StudyHubButton(title: "등록")
  private lazy var divideLineUnderTextField = createDividerLine(height: 8.0)
  private lazy var commentButtonStackView = createStackView(axis: .horizontal, spacing: 8)
  
  init() {
    super.init(frame: .zero)
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    commentLabelStackView.addArrangedSubview(commentLabel)
    commentLabelStackView.addArrangedSubview(moveToCommentViewButton)
    
    commentStackView.addArrangedSubview(commentTableView)
    
    commentButtonStackView.addArrangedSubview(commentTextField)
    commentButtonStackView.addArrangedSubview(commentButton)
    
    [
      commentLabelStackView,
      commentStackView,
      divideLineTopTextField,
      commentButtonStackView,
      divideLineUnderTextField
    ].forEach {
      addSubview($0)
    }
  }
  
  private func makeUI() {
    commentTableView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
    }
    
    commentLabelStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(20)
    }
    
    commentStackView.snp.makeConstraints {
      $0.top.equalTo(commentLabelStackView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(10)
    }
    
    divideLineTopTextField.snp.makeConstraints {
      $0.top.equalTo(commentTableView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
    
    commentTextField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalTo(commentButton.snp.leading).offset(-10)
      $0.height.equalTo(42)
    }
    
    commentButton.snp.makeConstraints {
      $0.height.equalTo(42)
      $0.width.equalTo(65)
    }
    
    commentButtonStackView.snp.makeConstraints {
      $0.top.equalTo(divideLineTopTextField.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    divideLineUnderTextField.snp.makeConstraints {
      $0.top.equalTo(commentButtonStackView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func updateCommentLabel() {
    commentLabel.text = "댓글 \(countComment)"
    moveToCommentViewButton.isHidden = countComment == 0
  }
  
  func tableViewResizing() {
    let tableViewHeight = 86 * countComment
    commentTableView.snp.updateConstraints {
      $0.height.equalTo(tableViewHeight)
    }
  }
}
