
import UIKit

import SnapKit
import RxSwift
import RxCocoa

// 무한 스크롤로 바꿔야할듯

/// 북마크 VC
final class BookmarkViewController: CommonNavi {
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: BookmarkViewModel
  
  private lazy var totalCountLabel = createLabel(
    title: "전체 \(viewModel.totalCount)",
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var deleteAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체삭제", for: .normal)
    button.setTitleColor(.bg70, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 14)
    button.frame = CGRect(x: 0, y: 0, width: 57, height: 30)
    button.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var emptyMainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "EmptyBookMarkImg")
    return imageView
  }()
  
  private lazy var emptyMainLabel = createLabel(
    title: "북마크 글이 없어요\n관심있는 스터디를 저장해 보세요!",
    textColor: .bg70,
    fontType: "Pretendard",
    fontSize: 16
  )
  
  private lazy var loginButton = StudyHubButton(title: "로그인하기")
  
  private lazy var bookMarkCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .bg30
    return scrollView
  }()
  
  init(_ data: BookMarkDataProtocol){
    self.viewModel = BookmarkViewModel(data)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /// 뷰가 사라진 후
  /// - Parameter animated: animated 여부
  override func viewDidDisappear(_ animated: Bool) {
    viewModel.isNeedFetch.accept(true)
  }
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .bg30
    
    settingNavigationbar()
    
    setupBinding()
    setupActions()
    
    registerCell()
  } // viewDidLoad
  
  // MARK: - 네비게이션 바
  
  func settingNavigationbar(){
    leftButtonSetting()
    settingNavigationTitle(title: "북마크")
  }
  
  
  /// 바인딩 설정
  func setupBinding(){
    viewModel.totalCount
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self]  in
        self?.setupLayout(count: $0)
        self?.makeUI(loginStatus: self?.viewModel.loginStatus ?? false, count: $0)
      })
      .disposed(by: disposeBag)
    
    viewModel.bookmarkDatas
      .asDriver(onErrorJustReturn: [])
      .drive(bookMarkCollectionView.rx.items(
        cellIdentifier: BookMarkCell.id,
        cellType: BookMarkCell.self)) { [weak self] index, content, cell in
          guard let self = self else { return }
          cell.model = content
          cell.postDelegate = self
        }
        .disposed(by: disposeBag)
    
    viewModel.postData
      .subscribe(onNext: { [weak self] in
        if $0.close == true { return }
        let username: String? = $0.postedUser.nickname
        
        if username == nil {
          self?.showToast(message: "해당 post에 접근할 수 없습니다", imageCheck: false)
          return
        }
        
        let data = PostedStudyData(isUserLogin: true, postDetailData: $0)
        let postedVC = PostedStudyViewController(data)
        self?.navigationController?.pushViewController(postedVC, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  /// actions 설정
  func setupActions(){
    loginButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.loginButtonTapped()
      })
      .disposed(by: disposeBag)
    
    bookMarkCollectionView.rx.modelSelected(BookmarkContent.self)
      .subscribe(onNext: { [weak self] in
        self?.viewModel.searchSingePostData(postID: $0.postID, loginStatus: true)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - setupLayout
  func setupLayout(count: Int){
    if count > 0 {
      [
        totalCountLabel,
        deleteAllButton,
        scrollView
      ].forEach {
        view.addSubview($0)
      }
      
      scrollView.addSubview(bookMarkCollectionView)
    } else {
      [
        totalCountLabel,
        deleteAllButton,
        emptyMainImageView,
        emptyMainLabel
      ].forEach {
        view.addSubview($0)
      }
    }
  }
  
  // MARK: - makeUI
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
  
  private func registerCell() {
    bookMarkCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)

    bookMarkCollectionView.register(
      BookMarkCell.self,
      forCellWithReuseIdentifier: BookMarkCell.id
    )
  }
  
  func noDataUI(loginStatus: Bool){
    view.addSubview(emptyMainImageView)
    
    emptyMainImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-50)
    }
    
    view.addSubview(emptyMainLabel)
    emptyMainLabel.numberOfLines = 2
    emptyMainLabel.textAlignment = .center
    emptyMainLabel.changeColor(wantToChange: "관심있는 스터디를 저장해 보세요!", color: .bg60)
    emptyMainLabel.snp.makeConstraints { make in
      make.top.equalTo(emptyMainImageView.snp.bottom)
      make.centerX.equalTo(emptyMainImageView)
    }
    
    view.addSubview(loginButton)
    loginButton.isHidden = loginStatus
    loginButton.snp.makeConstraints {
      $0.top.equalTo(emptyMainLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(emptyMainLabel)
      $0.height.equalTo(47)
    }
  }
  
  // MARK: - 북마크 전체 삭제
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
  
  func loginButtonTapped(){
    self.dismiss(animated: true) {
      self.dismiss(animated: true)
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
