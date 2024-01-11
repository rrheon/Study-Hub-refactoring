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
  
  var commentData: GetCommentList?
  var countComment: Int = 0
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

  private lazy var commentTextField = createTextField(title: "댓글을 입력해주세요")
  
  private lazy var commentButton: UIButton = {
    let button = UIButton()
    button.setTitle("등록", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o30
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      self.commentButtonTapped {
        self.getCommentList {
          self.commentTableView.reloadData()
          
          let tableViewHeight = 86 * (self.commentData?.content.count ?? 0)
          self.commentTableView.snp.updateConstraints {
            $0.height.equalTo(tableViewHeight)
          }
        }
      }
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var grayDividerLine = UIView()

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
    
    setupLayout()
    makeUI()
    
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      commentTableView,
      grayDividerLine,
      commentTextField,
      commentButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    let tableViewHeight = 86 * countComment
    
    commentTableView.snp.makeConstraints {
      $0.height.equalTo(tableViewHeight)
      $0.leading.equalToSuperview().offset(20)
    }
    
    grayDividerLine.backgroundColor = .bg30
    grayDividerLine.snp.makeConstraints {
      $0.top.equalTo(commentTableView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1.0)
    }
    
    commentTextField.snp.makeConstraints {
      $0.top.equalTo(grayDividerLine.snp.bottom).offset(10)
      $0.leading.equalTo(commentTableView.snp.leading)
      $0.width.equalTo(262)
      $0.height.equalTo(42)
    }
    
    commentButton.snp.makeConstraints {
      $0.top.equalTo(commentTextField.snp.top)
      $0.leading.equalTo(commentTextField.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().offset(-10)
      $0.height.equalTo(42)
      $0.height.equalTo(65)
    }
    
  }
  
  // MARK: - navigationbar 재설정
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItems = .none
    self.navigationItem.title = "댓글 \(countComment)"
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
  
  // MARK: - 댓글 리스트 가져오기
  func getCommentList(completion: @escaping () -> Void){
    detailPostDataManager.getCommentList(postId: postId,
                                         page: 0,
                                         size: 8) {
      self.commentData = self.detailPostDataManager.getCommentList()
      self.countComment = self.commentData?.content.count ?? 0
      
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
    
    cell.model = commentData?.content[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
}
