
import UIKit

import SnapKit
import RxCocoa

final class CommentViewController: CommonNavi {
  let viewModel: CommentViewModel
  
  private lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    
    tableView.delegate = self
    return tableView
  }()
  
  private lazy var commentTableStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var commentTextField = createTextField(title: "댓글을 입력해주세요")
  private lazy var commentButton = StudyHubButton(title: "등록")
  private lazy var commentButtonStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var grayDividerLine = UIView()
  
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  init(postId: Int, nickname: String?, isNeedFetch: PublishRelay<Bool>?) {
    self.viewModel = CommentViewModel(isNeedFetch: isNeedFetch ?? nil, postID: postId)
    
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - 이전페이지로 넘어갈 때
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    viewModel.isNeedFetch?.accept(true)
  }
  
  // MARK: - viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    
    setupLayout()
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    commentTableStackView.addArrangedSubview(commentTableView)
    
    [
      commentTextField,
      commentButton
    ].forEach {
      commentButtonStackView.addArrangedSubview($0)
    }
    
    [
      commentTableStackView,
      grayDividerLine,
      commentButtonStackView
    ].forEach {
      pageStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(pageStackView)
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  
  
  func makeUI(){
    let tableViewHeight = 86 * viewModel.commentCount.value
    
    commentTableStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    commentTableStackView.isLayoutMarginsRelativeArrangement = true
    
    commentTableView.snp.makeConstraints {
      $0.height.equalTo(tableViewHeight)
    }
    
    grayDividerLine.backgroundColor = .bg30
    grayDividerLine.snp.makeConstraints {
      $0.height.equalTo(1.0)
    }
    
    commentButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    commentButtonStackView.isLayoutMarginsRelativeArrangement = true
    
    commentTextField.snp.makeConstraints {
      $0.height.equalTo(42)
    }
    
    commentButton.snp.makeConstraints {
      $0.width.equalTo(65)
      $0.height.equalTo(42)
    }
    
    pageStackView.snp.makeConstraints {
      $0.top.equalTo(scrollView.contentLayoutGuide)
      $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view)
    }
  }
  
  // MARK: - setupNavigationbar
  
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "댓글 \(viewModel.commentCount.value)")
    leftButtonSetting()
  }
  
  func setupBinding(){
    commentTextField.rx.text.orEmpty
      .bind(to: viewModel.commentContent)
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentList
      .asDriver(onErrorJustReturn: [])
      .drive(commentTableView.rx.items(
        cellIdentifier: CommentCell.cellId,
        cellType: CommentCell.self)
      ) { index, content, cell in
        cell.model = content
        cell.userNickname = self.viewModel.userData?.nickname
        cell.delegate = self
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
      }
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    viewModel.commentCount
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        self?.settingNavigationTitle(title: "댓글 \(count)")
        self?.tableViewResizing(count)
      })
      .disposed(by: viewModel.disposeBag)
    
    commentButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        guard let commentID = viewModel.commentID else {
          viewModel.createComment()
          return
        }
        viewModel.modifyComment(commentID)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentActionStatus
      .subscribe(onNext: { [weak self] status in
        guard let self = self else { return }
        
        let message: String
        switch status {
        case .create:
          message = "댓글이 작성됐어요"
        case .delete:
          message = "댓글이 삭제됐어요."
        case .modify:
          message = "댓글이 수정됐어요"
        }
        self.commentTextField.text = nil
        self.commentTextField.resignFirstResponder()
        self.viewModel.commentID = nil
        
        self.showToast(message: message, imageCheck: false)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentContent
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: { [weak self] content in
        guard let self = self else { return }
        guard let hidden = content?.isEmpty else {
          commentButton.unableButton(true)
          return
        }
        commentButton.unableButton(!hidden,backgroundColor: .o30, titleColor: .white)
      })
      .disposed(by: viewModel.disposeBag)
    
    
  }
  
  // MARK: - 테이블뷰 사이즈 동적조절
  
  
  func tableViewResizing(_ count: Int){
    let tableViewHeight = 86 * count
    self.commentTableView.snp.updateConstraints {
      $0.height.equalTo(tableViewHeight)
    }
  }
}

// MARK: - tableview


extension CommentViewController: UITableViewDelegate  {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
}

extension CommentViewController: CommentCellDelegate {
  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
    let bottomSheetVC = BottomSheet(postID: commentId, checkPost: false)
    bottomSheetVC.delegate = self
    showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    present(bottomSheetVC, animated: true, completion: nil)
  }
}

extension CommentViewController: BottomSheetDelegate {
  func firstButtonTapped(postID: Int, checkPost: Bool) {
    self.commentTextField.text = nil
    self.commentTextField.resignFirstResponder()
    let popupVC = PopupViewController(title: "댓글을 삭제할까요?", desc: "")
    popupVC.modalPresentationStyle = .overFullScreen
    
    self.present(popupVC, animated: true)
    
    popupVC.popupView.rightButtonAction = {
      self.viewModel.deleteComment(commentId: postID)
      self.navigationController?.dismiss(animated: true)
    }
  }
  
  func secondButtonTapped(postID: Int, checkPost: Bool) {
    commentButton.setTitle("수정", for: .normal)
    viewModel.commentID = postID
  }
}

extension CommentViewController: CheckLoginDelegate { }
extension CommentViewController: ShowBottomSheet { }
extension CommentViewController: CreateUIprotocol { }
