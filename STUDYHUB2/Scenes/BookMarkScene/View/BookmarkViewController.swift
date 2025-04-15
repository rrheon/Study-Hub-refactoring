
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
    
    viewModel.getBookmarkList()

    setupNavigationbar()
  
    setupBinding()
    setupActions()
        
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
    viewModel.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
  }
  
  /// 바인딩 설정
  func setupBinding(){
    // 북마크한 스터디의 갯수
    viewModel.totalCount
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, 0))
      .drive(onNext: { (vc, count) in
        vc.setupLayout(count: count)
        vc.makeUI(count: count)
        
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
          cell.delegate = self
        }
        .disposed(by: disposeBag)
    
//    // 로그인 여부에 따른 데이터 설정
//    viewModel.loginStatus
//      .observe(on: MainScheduler.instance)
//      .subscribe(onNext: { loginStatus in
//        if !loginStatus {
//          self.noDataUI(loginStatus: !loginStatus)
//        }
//      })
//      .disposed(by: disposeBag)

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
        vc.viewModel.steps.accept(AppStep.auth(.loginScreenIsRequired))
        _ = TokenManager.shared.deleteTokens()
      })
      .disposed(by: disposeBag)
    
    // 북마크한 스터디 셀을 터치 시
    bookMarkCollectionView.rx
      .modelSelected(BookmarkContent.self)
      .subscribe(onNext: { [weak self] postCellData in
        self?.viewModel.steps.accept(AppStep.study(.studyDetailScreenIsRequired(postID: postCellData.postID)))
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
  func makeUI(count: Int){
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
    }else {
      emptyView.snp.makeConstraints {
        $0.top.equalTo(view.snp.top).offset(150)
        $0.height.equalTo(250)
        $0.leading.trailing.equalToSuperview().inset(30)
      }
      
      noDataUI(loginStatus: viewModel.loginStatus.value)
    }
  }
  
  /// 데이터가 없을 때 UI설정
  func noDataUI(loginStatus: Bool){
    
    loginButton.isHidden = loginStatus
    loginButton.snp.makeConstraints {
      $0.top.equalTo(emptyView.snp.bottom).offset(40)
      $0.centerX.equalTo(emptyView.snp.centerX)
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
    viewModel.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .deleteAllBookmarks)))
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


extension BookmarkViewController: BookmarkCellDelegate {
  func bookmarkBtnTapped(postId: Int) {
    viewModel.deleteSingleBtnTapped(postID: postId)
  }
  
  
  /// 북마크 셀에서 참여하기 터치
  /// - Parameters:
  ///   - studyId: 스터디의 아이디
  ///   - postId: 포스트 아이디
  func participateBtnTapped(studyId: Int, postId: Int) {
    viewModel.applyStudyBtnTppaed(postID: postId)
  }
}

// MARK: - PopupView


extension BookmarkViewController: PopupViewDelegate {
  func rightBtnTapped(defaultBtnAction: () -> (), popupCase: PopupCase) {
    defaultBtnAction()
    self.viewModel.deleteAllBtnTapped()
    self.totalCountLabel.text = "전체 0"
    self.bookMarkCollectionView.isHidden = true
    
    view.addSubview(emptyView)
    emptyView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top).offset(150)
      $0.height.equalTo(250)
      $0.leading.trailing.equalToSuperview().inset(30)
    }
  }
}



// MARK: - 스크롤


extension BookmarkViewController {
  
  /// 스크롤할 때 네트워킹 요청
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let scrollViewHeight = scrollView.frame.size.height
    let contentHeight = scrollView.contentSize.height
    let offsetY = scrollView.contentOffset.y
    
    // 바닥에서 50포인트 위에 도달했는지 체크
    if offsetY + scrollViewHeight >= contentHeight - 50 && viewModel.isInfiniteScroll == false {
      print("바닥에서 50포인트 위에 도달! ")
      
      viewModel.getBookmarkList()
    }
  }
}
