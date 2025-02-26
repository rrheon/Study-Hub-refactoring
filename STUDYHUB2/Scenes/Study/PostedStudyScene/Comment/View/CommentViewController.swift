

import UIKit

import SnapKit
import RxSwift
import RxCocoa

/// 전체 댓글 VC
final class CommentViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: CommentViewModel
  
  /// 댓글 tableview
  private lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellID)
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    
    tableView.delegate = self
    return tableView
  }()
  
  /// tableView 스택
  private lazy var commentTableStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  
  /// 댓글 입력 TextField
  private lazy var commentTextField = StudyHubUI.createTextField(title: "댓글을 입력해주세요")
  
  /// 댓글 등록, 수정 버튼
  var commentButton = StudyHubButton(title: "등록")
  
  /// 댓글 버튼 스택뷰
  private lazy var commentButtonStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  
  /// 구분선
  private lazy var grayDividerLine = StudyHubUI.createDividerLine(bgColor: .bg30, height: 1.0)
  
  /// 전체 스택뷰
  private lazy var pageStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
  
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  init(with viewModel: CommentViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    commentTextField.delegate = self
    commentButton.unableButton(false, backgroundColor: .o30, titleColor: .white)
  } // viewDidLoad
  
  // MARK: - setupLayout
  
  /// layout 설정
  func setupLayout(){
    commentTableStackView.addArrangedSubview(commentTableView)
    
    /// 댓글 버튼 스택뷰
    [ commentTextField, commentButton]
      .forEach { commentButtonStackView.addArrangedSubview($0) }
    
    /// 전체 스택뷰
    [ commentTableStackView, grayDividerLine, commentButtonStackView]
      .forEach { pageStackView.addArrangedSubview($0) }
    
    scrollView.addSubview(pageStackView)
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  
  /// UI설정
  func makeUI(){
    let tableViewHeight = 86 * (viewModel.commentDatas.value?.count ?? 0)
    
    commentTableStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    commentTableStackView.isLayoutMarginsRelativeArrangement = true
    
    commentTableView.snp.makeConstraints {
      $0.height.equalTo(tableViewHeight)
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
  
  /// 네비게이션바 설정
  func setupNavigationbar(){
    settingNavigationTitle(title: "댓글 \(viewModel.commentDatas.value?.count ?? 0)")
    leftButtonSetting()
  }
  
  /// 네비게이션 바 왼쪽 버튼 탭 - 현재화면 pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: false))
  }
  
  /// 바인딩
  func setupBinding(){
//    commentTextField.rx.text.orEmpty
//      .bind(to: viewModel.commentContent)
//      .disposed(by: disposeBag)
    
    /// 댓글 리스트
    viewModel.commentDatas
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: [])
      .drive(commentTableView.rx.items(
        cellIdentifier: CommentCell.cellID,
        cellType: CommentCell.self)
      ) { index, content, cell in
        cell.model = content
        cell.delegate = self
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
      }
      .disposed(by: disposeBag)
    
    /// 댓글 갯수
    viewModel.commentCount
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        self?.settingNavigationTitle(title: "댓글 \(count)")
        self?.tableViewResizing(count)
      })
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    /// 댓글 입력, 수정버튼
    commentButton.rx.tap
      .subscribe(onNext: { [weak self] in
//        guard let self = self else { return }
//        guard let commentID = viewModel.commentID else {
//          viewModel.createComment()
//          return
//        }
//        viewModel.modifyComment(commentID)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - 테이블뷰 사이즈 동적조절
  
  
  /// 테이블 뷰 사이즈 조절
  /// - Parameter count: 댓글 갯수
  func tableViewResizing(_ count: Int){
    let tableViewHeight = 86 * count
    self.commentTableView.snp.updateConstraints {
      $0.height.equalTo(tableViewHeight)
    }
  }
}

// MARK: - tableview

/// 테이블 뷰 높이
extension CommentViewController: UITableViewDelegate  {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
}

/// 댓글 셀의 Delegate
extension CommentViewController: CommentCellDelegate {
  /// 메뉴 버튼 탭 -> bottomSheet
  func menuButtonTapped(commentID: Int) {
    /// BottomSheet 띄우기
    viewModel.steps.accept(AppStep.bottomSheetIsRequired(postOrCommnetID: commentID,
                                                         type: .managementComment))
  }
}

/// bottomSheet의 Delegate
extension CommentViewController: BottomSheetDelegate {
  /// BottomSheet의 첫 번째 버튼 탭 - 댓글 삭제
  /// - Parameter postOrCommentID: commentID
  func firstButtonTapped(postOrCommentID: Int, bottomSheetCase: BottomSheetCase) {
    viewModel.deleteComment(with: postOrCommentID)
  }
  
  /// BottomSheet의 두 번째 버튼 탭 - 댓글 수정
  /// - Parameter postOrCommentID: commentID
  func secondButtonTapped(postOrCommentID: Int, bottomSheetCase: BottomSheetCase) {
    commentButton.setTitle("수정", for: .normal)
    viewModel.commentID = postOrCommentID
  }
//  func firstButtonTappeㅇ {
//    self.commentTextField.text = nil
//    self.commentTextField.resignFirstResponder()
//    let popupVC = PopupViewController(title: "댓글을 삭제할까요?", desc: "")
//    popupVC.modalPresentationStyle = .overFullScreen
//    
//    self.present(popupVC, animated: true)
//    
////    popupVC.popupView.rightButtonAction = {
////      self.viewModel.deleteComment(commentId: postID)
////      self.navigationController?.dismiss(animated: true)
////    }
//  }
//  
//  func secondButtonTapped(postID: Int, checkPost: Bool) {
//    commentButton.setTitle("수정", for: .normal)
//    viewModel.commentID = postID
//  }
}

/// 댓글 입력 TextField Delegate - 댓글 입력 시 버튼 활성화
extension CommentViewController {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    /// 댓글 내용
    let comment: String? = textField.text
    
    /// 버튼활성화 여부
    let activateBtn: Bool = comment?.isEmpty == nil || comment != "" ? true : false
    
    /// 버튼 활성화에 따른 배경색
    let backgroundColor: UIColor = activateBtn ? .o60 : .o30
    
    commentButton.unableButton(activateBtn, backgroundColor: backgroundColor, titleColor: .white)
  }
  
}
