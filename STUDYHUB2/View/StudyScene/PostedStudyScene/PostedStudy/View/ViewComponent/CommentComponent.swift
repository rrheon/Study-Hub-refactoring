import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class PostedStudyCommentComponent: UIView {
  let viewModel: PostedStudyViewModel
  
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
  
  init(_ viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    
    super.init(frame: .zero)
    setupLayout()
    makeUI()
    setupBinding()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - setupLayout
  
  
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
  
  // MARK: - makeUI
  
  
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
  
  // MARK: -  setupBinding
  
  
  func setupBinding(){
    viewModel.countComment
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        self?.commentLabel.text = "댓글 \(count)"

        let value = count <= 8 ? count : 8
        self?.snp.remakeConstraints {
          $0.height.equalTo(value * 86 + 160)
        }
        
        self?.commentTableView.snp.remakeConstraints {
          $0.height.equalTo(value * 86)
        }
      
        let hideButton = count == 0 ? true : false
        self?.moveToCommentViewButton.isHidden = hideButton
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentDatas
      .bind(to: commentTableView.rx.items(
        cellIdentifier: CommentCell.cellId,
        cellType: CommentCell.self)) { index, content, cell in
          cell.model = content
          cell.userNickname = self.viewModel.userNickanme
          cell.delegate = self
          cell.selectionStyle = .none
          cell.contentView.isUserInteractionEnabled = false
        }
        .disposed(by: viewModel.disposeBag)
    
    commentTextField.rx.text.orEmpty
      .bind(to: viewModel.commentTextFieldValue)
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentTextFieldValue
      .subscribe(onNext: { [weak self] in
        self?.commentButton.unableButton(
          !$0.isEmpty,
          backgroundColor: .o30,
          titleColor: .white
        )
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isNeedFetch?
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: { [weak self] in
        if $0 {
          self?.viewModel.fetchCommentDatas()
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - setupActions
  
  
  func setupActions(){
    commentButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let postID = self?.viewModel.postDatas.value?.postID,
              let content = self?.viewModel.commentTextFieldValue.value,
              let commentID = self?.viewModel.postOrCommentID else { return }
        let title = self?.commentButton.currentTitle
        
        switch title {
        case "수정":
          self?.modifyComment(content: content, commentID: commentID)
        case "등록":
          self?.createComment(content: content, postID: postID)
        case .none:
          return
        case .some(_):
          return
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    moveToCommentViewButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let postID = self?.viewModel.postDatas.value?.postID else { return }
        let commentVC = CommentViewController(
          postId: postID,
          nickname: self?.viewModel.userNickanme,
          isNeedFetch: self?.viewModel.isNeedFetch ?? nil
        )
        commentVC.hidesBottomBarWhenPushed = true
        self?.viewModel.moveToCommentVC.accept(commentVC)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func createComment(content: String, postID: Int) {
    viewModel.commentManager.createComment(
      content: content,
      postID: postID
    ) { [weak self] success in
      guard success else { return }
      self?.settingComment(mode: "생성")
    }
  }
  
  func modifyComment(content: String, commentID: Int) {
    viewModel.commentManager.modifyComment(
      content: content,
      commentID: commentID
    ) { [weak self] success in
      self?.settingComment(mode: "수정")
    }
  }
  
  func settingComment(mode: String){
    viewModel.fetchCommentDatas()
    let message = mode == "생성" ? "댓글이 작성됐어요" : "댓글이 수정됐어요"
    viewModel.showToastMessage.accept(message)
    
    commentButton.setTitle("등록", for: .normal)
    commentTextField.text = nil
    commentTextField.resignFirstResponder()
  }
}

extension PostedStudyCommentComponent: CreateUIprotocol {}
extension PostedStudyCommentComponent: CommentCellDelegate {
  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
    viewModel.showBottomSheet.accept(commentId)
  }
}

