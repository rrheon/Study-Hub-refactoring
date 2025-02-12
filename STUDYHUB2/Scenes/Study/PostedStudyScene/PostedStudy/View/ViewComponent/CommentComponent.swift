
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 게시글 댓글 component
final class PostedStudyCommentComponent: UIView {
  let disposeBag: DisposeBag = DisposeBag()
  var postedData: PostDetailData

  /// 댓글 라벨
  private lazy var commentLabel = UILabel().then {
    $0.text = "댓글 0"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
 
  /// 댓글 디테일 화면으로 이동 버튼
  lazy var moveToCommentViewButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "RightArrow"), for: .normal)
    $0.tintColor = .black
  }
  
  /// 댓글 라벨 스택뷰
  private lazy var commentLabelStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
  }
  
  /// 댓글 테이블 뷰
  lazy var commentTableView: UITableView =  UITableView().then {
    $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellID)
    $0.backgroundColor = .white
    $0.separatorStyle = .none
  }
  
  /// 댓글 스택뷰
  private lazy var commentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10
  }
  
  /// 구분선
  private lazy var divideLineTopTextField = StudyHubUI.createDividerLine(height: 1.0)
  
  /// 댓글 입력 TextField
  lazy var commentTextField = StudyHubUI.createTextField(title: "댓글을 입력해주세요")
  
  /// 댓글 작업 버튼
  lazy var commentButton = StudyHubButton(title: "등록")
  
  /// 구분 선
  private lazy var divideLineUnderTextField = StudyHubUI.createDividerLine(height: 8.0)
  
  /// 댓글 버튼 스택뷰
  private lazy var commentButtonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
  }
  
  init(with data: PostDetailData) {
    self.postedData = data
    
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
  
  /// layout 설정
  private func setupLayout() {
    /// 댓글 수 , 댓글 상세페이지 이동 버튼
    commentLabelStackView.addArrangedSubview(commentLabel)
    commentLabelStackView.addArrangedSubview(moveToCommentViewButton)
    
    /// 댓글 테이블 뷰
    commentStackView.addArrangedSubview(commentTableView)
    
    /// 댓글 입력 TextField, 버튼
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
  
  /// UI설정
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
//    viewModel.countComment
//      .asDriver(onErrorJustReturn: 0)
//      .drive(onNext: { [weak self] count in
//        self?.commentLabel.text = "댓글 \(count)"
//
//        let value = count <= 8 ? count : 8
//        self?.snp.remakeConstraints {
//          $0.height.equalTo(value * 86 + 160)
//        }
//        
//        self?.commentTableView.snp.remakeConstraints {
//          $0.height.equalTo(value * 86)
//        }
//      
//        let hideButton = count == 0 ? true : false
//        self?.moveToCommentViewButton.isHidden = hideButton
//      })
//      .disposed(by: disposeBag)
//    
//    viewModel.commentDatas
//      .bind(to: commentTableView.rx.items(
//        cellIdentifier: CommentCell.cellId,
//        cellType: CommentCell.self)) { index, content, cell in
//          cell.model = content
//          cell.userNickname = self.viewModel.userNickanme
//          cell.delegate = self
//          cell.selectionStyle = .none
//          cell.contentView.isUserInteractionEnabled = false
//        }
//        .disposed(by: disposeBag)
//    
//    commentTextField.rx.text.orEmpty
//      .bind(to: viewModel.commentTextFieldValue)
//      .disposed(by: disposeBag)
//    
//    viewModel.commentTextFieldValue
//      .subscribe(onNext: { [weak self] in
//        self?.commentButton.unableButton(
//          !$0.isEmpty,
//          backgroundColor: .o30,
//          titleColor: .white
//        )
//      })
//      .disposed(by: disposeBag)
//    
//    viewModel.isNeedFetch?
//      .asDriver(onErrorJustReturn: true)
//      .drive(onNext: { [weak self] in
//        if $0 == true{
//          self?.viewModel.fetchCommentDatas()
//        }
//      })
//      .disposed(by: disposeBag)
  }
  
  // MARK: - setupActions
  
  /// Actions 설정
  func setupActions(){
//    commentButton.rx.tap
//      .subscribe(onNext: { [weak self] in
//        guard let postID = self?.viewModel.postDatas.value?.postID,
//              let content = self?.viewModel.commentTextFieldValue.value,
//              let commentID = self?.viewModel.postOrCommentID else { return }
//        let title = self?.commentButton.currentTitle
//        
//        switch title {
//        case "수정":
//          self?.modifyComment(content: content, commentID: commentID)
//        case "등록":
//          self?.createComment(content: content, postID: postID)
//        case .none:
//          return
//        case .some(_):
//          return
//        }
//      })
//      .disposed(by: disposeBag)
//    
//    moveToCommentViewButton.rx.tap
//      .subscribe(onNext: { [weak self] in
//        guard let postID = self?.viewModel.postDatas.value?.postID else { return }
//        let commentVC = CommentViewController(
//          postId: postID,
//          nickname: self?.viewModel.userNickanme,
//          isNeedFetch: self?.viewModel.isNeedFetch ?? nil
//        )
//        commentVC.hidesBottomBarWhenPushed = true
//        self?.viewModel.moveToCommentVC.accept(commentVC)
//      })
//      .disposed(by: disposeBag)
  }
  
  func createComment(content: String, postID: Int) {
//    viewModel.commentManager.createComment(
//      content: content,
//      postID: postID
//    ) { [weak self] success in
//      guard success else { return }
//      self?.settingComment(mode: "생성")
//    }
  }
  
  func modifyComment(content: String, commentID: Int) {
//    viewModel.commentManager.modifyComment(
//      content: content,
//      commentID: commentID
//    ) { [weak self] success in
//      self?.settingComment(mode: "수정")
//    }
  }
  
  func settingComment(mode: String){
//    viewModel.fetchCommentDatas()
//    let message = mode == "생성" ? "댓글이 작성됐어요" : "댓글이 수정됐어요"
//    viewModel.showToastMessage.accept(message)
//    
//    commentButton.setTitle("등록", for: .normal)
//    commentTextField.text = nil
//    commentTextField.resignFirstResponder()
  }
}

extension PostedStudyCommentComponent: CommentCellDelegate {
  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
//    viewModel.showBottomSheet.accept(commentId)
  }
}

