
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 북마크 VC
#warning("북마크 작업, ")
final class BookmarkViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: BookmarkViewModel

  /// 전체 북마크 갯수 라벨
  private lazy var totalCountLabel: UILabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 16)
  }

  /// 북마크 전체삭제 버튼
  private lazy var deleteAllButton: UIButton = UIButton().then {
    $0.setTitle("전체삭제", for: .normal)
    $0.setTitleColor(.bg70, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14)
    $0.frame = CGRect(x: 0, y: 0, width: 57, height: 30)
    $0.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
  }
  
  /// 북마크한 게시글이 없을 때 이미지뷰
  private lazy var emptyView = EmptyResultView(imageName: "EmptyBookMarkImg",
                                               title: "북마크 글이 없어요\n관심있는 스터디를 저장해 보세요!")

  /// 북마크한 게시글이 없을 때 로그인 버튼
  private lazy var loginButton = StudyHubButton(title: "로그인하기")
  
 /// 북마크한 스터디 컬렉션 뷰
  private lazy var bookMarkCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  private let scrollView: UIScrollView =  UIScrollView().then {
    $0.backgroundColor = .bg30
  }
  
  init(with viewModel: BookmarkViewModel){
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .bg30
    
    setupNavigationbar()
    
    setupLayout(count: 0)
    makeUI(loginStatus: viewModel.loginStatus, count: 0)
    
    setupBinding()
    setupActions()
    
    viewModel.fetchBookmarkData()
    
    registerCell()
  } // viewDidLoad
  
  // MARK: - 네비게이션 바
  
  /// 네비게이션 바 세팅
  func setupNavigationbar(){
    leftButtonSetting()
    settingNavigationTitle(title: "북마크")
    settingNavigationbar()
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  /// 네비게이션 바 왼쪽버튼 탭
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(AppStep.popCurrentScreen(navigationbarHidden: true))
  }
  
  /// 바인딩 설정
  func setupBinding(){
    // 북마크한 스터디의 갯수
    viewModel.totalCount
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, 0))
      .drive(onNext: { (vc, count) in
        vc.setupLayout(count: count)
        vc.makeUI(loginStatus: false, count: count)
      })
      .disposed(by: disposeBag)
    
    // 북마크한 스터디의 데이터
    viewModel.bookmarkDatas
      .asDriver(onErrorJustReturn: [])
      .drive(bookMarkCollectionView.rx.items(
        cellIdentifier: BookMarkCell.cellID,
        cellType: BookMarkCell.self)) { [weak self] index, content, cell in
          guard let self = self else { return }
          cell.model = content
          cell.postDelegate = self

        }
        .disposed(by: disposeBag)
    
//    viewModel.postData
//      .subscribe(onNext: { [weak self] in
//        if $0.close == true { return }
//        let username: String? = $0.postedUser.nickname
//        
//        if username == nil {
//          self?.showToast(message: "해당 post에 접근할 수 없습니다", imageCheck: false)
//          return
//        }
//        
//        let data = PostedStudyData(isUserLogin: true, postDetailData: $0)
//        let postedVC = PostedStudyViewController(data)
//        self?.navigationController?.pushViewController(postedVC, animated: true)
//      })
//      .disposed(by: disposeBag)
  }
  
  /// actions 설정
  func setupActions(){
    // 로그인 버튼 터치 시
    loginButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { vc, _ in
        vc.viewModel.steps.accept(AppStep.loginScreenIsRequired)
        _ = TokenManager.shared.deleteTokens()
      })
      .disposed(by: disposeBag)
    
    // 북마크한 스터디 셀을 터치 시
    bookMarkCollectionView.rx
      .modelSelected(BookmarkContent.self)
      .subscribe(onNext: { [weak self] in
        self?.viewModel.searchSingePostData(postID: $0.postID, loginStatus: true)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(count: Int){
    if count > 0 {
      [totalCountLabel, deleteAllButton, scrollView]
        .forEach { view.addSubview($0) }
      
      scrollView.addSubview(bookMarkCollectionView)
    } else {
      [ totalCountLabel, deleteAllButton, emptyView, loginButton]
        .forEach { view.addSubview($0) }
    }
  }
  
  // MARK: - makeUI
  /// UI설정
  func makeUI(loginStatus: Bool, count: Int){
    totalCountLabel.text = "전체 \(count)"
    totalCountLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      make.leading.equalToSuperview().offset(20)
    }
    
    deleteAllButton.snp.makeConstraints { make in
      make.centerY.equalTo(totalCountLabel)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
    }
    
    if count > 0 {
      bookMarkCollectionView.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(scrollView.snp.height)
      }
      
      scrollView.snp.makeConstraints { make in
        make.top.equalTo(totalCountLabel.snp.bottom).offset(20)
        make.leading.trailing.bottom.equalTo(view)
      }
    } else {
      noDataUI(loginStatus: loginStatus)
    }
  }
  
  /// 데이터가 없을 때 UI설정
  func noDataUI(loginStatus: Bool){
    emptyView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top).offset(150)
      $0.height.equalTo(250)
      $0.leading.trailing.equalToSuperview().inset(30)
    }

    loginButton.isHidden = loginStatus
    loginButton.snp.makeConstraints {
      $0.top.equalTo(emptyView.snp.bottom).offset(40)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(100)
      $0.height.equalTo(47)
    }
  }

  /// 셀 등록
  private func registerCell() {
    bookMarkCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    bookMarkCollectionView.register(
      BookMarkCell.self,
      forCellWithReuseIdentifier: BookMarkCell.cellID
    )
  }
    
  // MARK: - 북마크 전체 삭제
  
  /// 전체삭제 버튼 탭
  @objc func deleteAllButtonTapped(){
    // postID 수정 필요
    let popupVC = PopupViewController(title: "", desc: "북마크를 모두 삭제할까요?")
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = {
      BookmarkManager.shared.deleteAllBookmark {
        self.dismiss(animated: true)
        self.viewModel.getBookmarkList()
        self.totalCountLabel.text = "전체 0"
      }
      self.bookMarkCollectionView.isHidden = true
      self.noDataUI(loginStatus: true)
    }
  }

}

// MARK: - collectionView 사이즈


extension BookmarkViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 350, height: 210)
  }
}

// MARK: - 북마크 셀에서 Actions

extension BookmarkViewController {
  
  /// 북마크 셀에서 북마크 터치 시
  /// - Parameter postId: 포스트 아이디
  func bookmarkTapped(postId: Int) {
    viewModel.deleteButtonTapped(postID: postId)
  }
}

extension BookmarkViewController: ParticipatePostDelegate{
  
  /// 북마크 셀에서 참여하기 터치
  /// - Parameters:
  ///   - studyId: 스터디의 아이디
  ///   - postId: 포스트 아이디
  func participateButtonTapped(studyId: Int, postId: Int) {
//    StudyPostManager.shared.searchSinglePostData(postId: postId) { result in
//      if result.apply {
//        self.showToast(message: "이미 신청한 스터디예요.", imageCheck: false)
//        return
//      }
//      let postData = BehaviorRelay<PostDetailData?>(value: nil)
//      postData.accept(result)
//      
//      let participateVC = ParticipateVC(postData)
//   
//      self.navigationController?.pushViewController(participateVC, animated: true)
//    }
  }
}

extension BookmarkViewController: CreateUIprotocol {}
