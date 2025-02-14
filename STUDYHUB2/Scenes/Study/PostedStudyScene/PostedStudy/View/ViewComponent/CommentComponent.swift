
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

#warning("댓글 작업하기")
/// 게시글 댓글 component
final class PostedStudyCommentComponent: UIView {
  let disposeBag: DisposeBag = DisposeBag()
  var viewModel: PostedStudyViewModel
  
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
  private lazy var commentLabelStackView = StudyHubUI.createStackView(axis: .horizontal,
                                                                      spacing: 10)

  /// 댓글 테이블 뷰
  lazy var commentTableView: UITableView =  UITableView().then {
    $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.cellID)
    $0.backgroundColor = .white
    $0.separatorStyle = .none
  }
  
  /// 댓글 스택뷰
  private lazy var commentStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
  
  /// 구분선
  private lazy var divideLineTopTextField = StudyHubUI.createDividerLine(height: 1.0)
  
  /// 댓글 입력 TextField
  lazy var commentTextField = StudyHubUI.createTextField(title: "댓글을 입력해주세요")
  
  /// 댓글 작업 버튼
  lazy var commentButton = StudyHubButton(title: "등록")
  
  /// 구분 선
  private lazy var divideLineUnderTextField = StudyHubUI.createDividerLine(height: 8.0)
  
  /// 댓글 버튼 스택뷰
  private lazy var commentBtnStackView = StudyHubUI.createStackView(axis: .horizontal,spacing: 8)

  
  init(with viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    
    super.init(frame: .zero)
    
    setupLayout()
    makeUI()
    setupBinding()
    setupActions()
    
    commentTextField.delegate = self
    
    commentButton.unableButton(false, backgroundColor: .o30, titleColor: .white)
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
    commentBtnStackView.addArrangedSubview(commentTextField)
    commentBtnStackView.addArrangedSubview(commentButton)
    
    [
      commentLabelStackView,
      commentStackView,
      divideLineTopTextField,
      commentBtnStackView,
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
    
    commentBtnStackView.snp.makeConstraints {
      $0.top.equalTo(divideLineTopTextField.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
    
    divideLineUnderTextField.snp.makeConstraints {
      $0.top.equalTo(commentBtnStackView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  // MARK: -  setupBinding
  
  /// 바인딩
  func setupBinding(){

    /// 댓글 갯수
    viewModel.commentCount
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] count in
        self?.commentLabel.text = "댓글 \(count)"

        let value: Int = count  <= 8 ? count : 8
        self?.snp.remakeConstraints {
          $0.height.equalTo(value * 86 + 160)
        }
        
        self?.commentTableView.snp.remakeConstraints {
          $0.height.equalTo(value * 86)
        }
      
        let hideButton = count == 0 ? true : false
        self?.moveToCommentViewButton.isHidden = hideButton
      })
      .disposed(by: disposeBag)
    
    /// 댓글 데이터들 바인딩
    viewModel.commentDatas
      .compactMap { $0 }
      .bind(to: commentTableView.rx.items(
        cellIdentifier: CommentCell.cellID,
        cellType: CommentCell.self)
      ) { index, content, cell in
        cell.model = content
        cell.delegate = self
        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false
      }
      .disposed(by: disposeBag)

    viewModel.loginUserData
      .asDriver()
      .drive(onNext: { _ in
        self.commentTableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - setupActions
  
  /// Actions 설정
  func setupActions(){
    
    // 댓글 작성 / 수정 버튼 탭
    commentButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (vc, _) in
        
        guard let commentContent = vc.commentTextField.text,
              let title = vc.commentButton.currentTitle else { return }
        
        /// 버튼 제목에 따라 다른 댓글 작업 수행
        switch title {
          case "수정":        vc.viewModel.modifyComment(content: commentContent)
          case "등록":        vc.viewModel.createNewComment(with: commentContent)
          default: return
        }
        vc.settingComment()
      })
      .disposed(by: disposeBag)

    // 모든 댓글 VC로 이동
    moveToCommentViewButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (vc, _) in
        vc.viewModel.steps.accept(
          AppStep.commentDetailScreenIsRequired(postID: vc.viewModel.postID))
      })
      .disposed(by: disposeBag)
  }
  
  func settingComment(){
    /// PushlishRelay 로 댓글데이터 처리 -> 초기값이 없어서 UI가 께짐
    /// BehaviorRelay로 처리 -> 초기값을 빈 배열로 설정해서 UI를 잡고 데이터를 넣어줌
    /// 다시 불러오지 말고 마지막 데이터 교체해주기 x -> 댓글 ID를 알 수 없음
//    viewModel.fetchCommentDatas()
//    let message = mode == "생성" ? "댓글이 작성됐어요" : "댓글이 수정됐어요"
//    viewModel.showToastMessage.accept(message)
//    
//    commentButton.setTitle("등록", for: .normal)
    commentTextField.text = nil
    commentTextField.resignFirstResponder()
  }
}

// MARK: - 댓글 Cell Delegate


/// 댓글 편집관련
extension PostedStudyCommentComponent: CommentCellDelegate {
  
  /// 메뉴버튼 탭
  /// - Parameter commentID: 댓글의 ID
  func menuButtonTapped(commentID: Int) {
    /// BottomSheet 띄우기
    viewModel.steps.accept(AppStep.bottomSheetIsRequired(postOrCommnetID: commentID,
                                                          type: .postOrComment))
  }
}

// MARK: - TextField Delegate


/// 댓글 입력 TextField Delegate - 댓글 입력 시 버튼 활성화
extension PostedStudyCommentComponent: UITextFieldDelegate {
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
