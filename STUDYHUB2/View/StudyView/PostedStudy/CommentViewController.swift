//
//  CommentViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/11.
//

import UIKit

import SnapKit
import Moya

final class CommentViewController: NaviHelper {
  let detailPostDataManager = PostDetailInfoManager.shared
  
  var previousVC: PostedStudyViewController?
  var commentData: GetCommentList?
  var commentId: Int?
  var countComment: Int = 0 {
    didSet {
      self.navigationItem.title = "댓글 \(countComment)"
    }
  }
  var postId: Int = 0
  
  private lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommentCell.self,
                       forCellReuseIdentifier: CommentCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()

  private lazy var commentTableStackView = createStackView(axis: .horizontal,
                                                           spacing: 10)
  
  private lazy var commentTextField = createTextField(title: "댓글을 입력해주세요")
  
  private lazy var commentButton: UIButton = {
    let button = UIButton()
    button.setTitle("등록", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o30
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      if self.commentId != nil {
        self.modifyComment {
          self.afterCommentButtonTapped()
        }
      } else {
        self.commentButtonTapped {
          self.afterCommentButtonTapped()
        }
      }
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var commentButtonStackView = createStackView(axis: .horizontal,
                                                            spacing: 10)
  
  private lazy var grayDividerLine = UIView()
  
  // 전체 요소를 담는 스택
  private lazy var pageStackView = createStackView(axis: .vertical,
                                                   spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  // MARK: - 이전페이지로 넘어갈 때
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent { previousVC?.tableViewReload() }
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
        
    getCommentList {
      print(self.commentData)
      self.setupLayout()
      self.makeUI()
      self.commentTableView.reloadData()
    }
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    commentTableStackView.addArrangedSubview(commentTableView)
    
    // 버튼스텍뷰
    [
      commentTextField,
      commentButton
    ].forEach {
      commentButtonStackView.addArrangedSubview($0)
    }
    
    // 전체 페이지스텍 뷰
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
    let tableViewHeight = 86 * countComment
    
    commentTableStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    commentTableStackView.isLayoutMarginsRelativeArrangement = true
    
    commentTableView.snp.makeConstraints {
      $0.height.equalTo(tableViewHeight)
    }
    
    grayDividerLine.backgroundColor = .bg30
    grayDividerLine.snp.makeConstraints {
      $0.height.equalTo(1.0)
    }
    
    commentButton.isEnabled = false
    commentTextField.addTarget(self,
                            action: #selector(textFieldDidChange(_:)),
                            for: .editingChanged)
    
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
  
  // MARK: - navigationbar 재설정
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItems = .none
    
    settingNavigationTitle(title: "댓글 \(countComment)",
                           font: "Pretendard-Bold",
                           size: 18)
  }
  
  // MARK: - 댓글 작성하기
  func commentButtonTapped(completion: @escaping () -> Void){
    let provider = MoyaProvider<networkingAPI>()
    guard let content = commentTextField.text else { return }
    provider.request(.writeComment(_content: content, _postId: postId)) {
      switch $0 {
      case .success(let response):
        completion()
        return print(response.response)
      case .failure(let response):
        return print(response)
      }
      
    }
  }
  
  // MARK: - 댓글 수정하기
  func modifyComment(completion: @escaping () -> Void){
    guard let content = commentTextField.text else { return }
    
    commentButton.setTitle("수정", for: .normal)
    commentButton.addAction(UIAction { _ in
      let provider = MoyaProvider<networkingAPI>()
      provider.request(.modifyComment(_commentId: self.commentId ?? 0,
                                      _content: content)) {
        switch $0 {
        case .success(let response):
          print(response.response)
          completion()
        case .failure(let response):
          print(response.response)
        }
      }
    }, for: .touchUpInside)
  }
  
  // MARK: - 댓글 삭제하기
  func deleteComment(commentId: Int, completion: @escaping () -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.deleteComment(_commentId: commentId )) {
      switch $0 {
      case .success(let response):
        completion()
        print(response.response)
        print(response)
       
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  func afterCommentButtonTapped(){
    self.getCommentList {
      self.commentTableView.reloadData()
      
      self.tableViewResizing()
      
      let message = self.commentId == nil ? "댓글이 작성됐어요" : "댓글이 수정됐어요"
      self.showToast(message: message,imageCheck: false)

      self.commentButton.setTitle("등록", for: .normal)
      self.commentTextField.text = nil
      self.commentTextField.resignFirstResponder()
      self.commentId = nil
    }
  }
  
  // MARK: - 테이블뷰 사이즈 동적조절
  func tableViewResizing(){
    let tableViewHeight = 86 * (self.commentData?.content.count ?? 0)
    self.commentTableView.snp.updateConstraints {
      $0.height.equalTo(tableViewHeight)
    }
  }
  
  // MARK: - 댓글 리스트 가져오기
  func getCommentList(completion: @escaping () -> Void){
    detailPostDataManager.getCommentList(postId: postId,
                                         page: 0,
                                         size: 100) {
      
      self.commentData = self.detailPostDataManager.getCommentList()
      self.countComment = self.commentData?.content.count ?? 0
      self.commentTableView.reloadData()

      completion()
    }
  }
}

// MARK: - tableview
extension CommentViewController: UITableViewDelegate, UITableViewDataSource  {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return commentData?.content.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = commentTableView.dequeueReusableCell(withIdentifier: CommentCell.cellId,
                                                    for: indexPath) as! CommentCell
    cell.delegate = self
    cell.model = commentData?.content[indexPath.row]
    cell.selectionStyle = .none
    cell.contentView.isUserInteractionEnabled = false
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
}

// MARK: - 댓글 입력 시 버튼 활성화
extension CommentViewController {
  @objc func textFieldDidChange(_ textField: UITextField) {
    if textField.text?.isEmpty != true && textField.text != "댓글을 입력해주세요" {
      commentButton.backgroundColor = .o50
      commentButton.isEnabled = true
    }
  }
}

// MARK: - cell에 메뉴버튼 눌렀을 때
extension CommentViewController: CommentCellDelegate {
  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
    let bottomSheetVC = BottomSheet(postID: commentId)
    bottomSheetVC.delegate = self
    
    if #available(iOS 15.0, *) {
      if let sheet = bottomSheetVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return 228.0
          })]
        } else {
          // Fallback on earlier versions
        }
        sheet.largestUndimmedDetentIdentifier = nil
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheet.preferredCornerRadius = 20
      }
    } else {
      // Fallback on earlier versions
    }
    present(bottomSheetVC, animated: true, completion: nil)
  }
}

extension CommentViewController: BottomSheetDelegate {
  func firstButtonTapped(postID: Int?) {
    self.commentTextField.text = nil
    self.commentTextField.resignFirstResponder()
    let popupVC = PopupViewController(title: "댓글을 삭제할까요?",
                                      desc: "")
    popupVC.modalPresentationStyle = .overFullScreen

    self.present(popupVC, animated: true)
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true) {
        DispatchQueue.main.async {
          self.deleteComment(commentId: postID ?? 0) {
            self.getCommentList {
              self.showToast(message: "댓글이 삭제됐어요.",
                             imageCheck: false)
              self.tableViewResizing()
            }
          }
        }
      }
    }
  }
  
  func secondButtonTapped(postID: Int?) {
    commentButton.setTitle("수정", for: .normal)
    commentId = postID
  }
}

extension CommentViewController: CheckLoginDelegate {
  func checkLoginPopup(checkUser: Bool) {
    checkLoginStatus(checkUser: checkUser)
  }
}
