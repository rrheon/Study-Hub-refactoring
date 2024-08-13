
import UIKit

import SnapKit

// 로그인, 비로그인 나눠야함
final class BookmarkViewController: NaviHelper {
  let detailPostDataManager = PostDetailInfoManager.shared
  
  var bookmarkDatas: BookmarkDatas?
  
  // MARK: - 화면 구성
  var defaultRequestNum = 100
  
  var countNumber: Int = 0 {
    didSet {
      totalCountLabel.text = "전체 \(countNumber)"
    }
  }
  private lazy var totalCountLabel = createLabel(title: "전체 \(countNumber)",
                                                 textColor: .bg80,
                                                 fontType: "Pretendard",
                                                 fontSize: 16)
  
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
  
  private lazy var emptyMainLabel = createLabel(title: "북마크 글이 없어요\n관심있는 스터디를 저장해 보세요!",
                                                textColor: .bg70,
                                                fontType: "Pretendard",
                                                fontSize: 16)
  
  private lazy var loginButton: UIButton = {
    let button = UIButton()
    button.setTitle("로그인하기", for: .normal)
    button.backgroundColor = .o50
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    button.layer.cornerRadius = 6
    button.addAction(UIAction { _ in
      self.loginButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
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
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .bg30
    
    navigationItemSetting()
    redesignNavigationbar()
    
    registerCell()
    
    loginStatus { result in
      if result {
        self.getBookmarkList(requestNum: self.defaultRequestNum) {
          self.setupLayout()
          self.makeUI(loginStatus: result)
        }
      } else {
        self.setupLayout()
        self.makeUI(loginStatus: result)
      }
    }
  }
  
  // MARK: - 네비게이션 바 재설정
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItems = .none
    
    settingNavigationTitle(title: "북마크")
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    if countNumber > 0 {
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
  func makeUI(loginStatus: Bool){
    totalCountLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      make.leading.equalToSuperview().offset(20)
    }
    
    deleteAllButton.snp.makeConstraints { make in
      make.centerY.equalTo(totalCountLabel)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
    }
    
    if countNumber > 0 {
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
    bookMarkCollectionView.delegate = self
    bookMarkCollectionView.dataSource = self
    
    bookMarkCollectionView.register(BookMarkCell.self,
                                    forCellWithReuseIdentifier: BookMarkCell.id)
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
    emptyMainLabel.changeColor(label: emptyMainLabel,
                               wantToChange: "관심있는 스터디를 저장해 보세요!", color: .bg60)
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
    let popupVC = PopupViewController(title: "",
                                      desc: "북마크를 모두 삭제할까요?",
                                      postID: 1, bottomeSheet: nil)
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = {
      self.bookmarkManager.deleteAllBookmark {
        self.dismiss(animated: true)
        self.getBookmarkList(requestNum: self.defaultRequestNum) {
          self.bookMarkCollectionView.reloadData()
        }
      }
      self.bookMarkCollectionView.isHidden = true
      self.noDataUI(loginStatus: true)
    }
  }
  
  // MARK: - 북마크 리스트 조회, 스크롤 말고 애초에 다 가져오자
  func getBookmarkList(requestNum: Int,
                       completion: @escaping () -> Void){
    bookmarkManager.getBookmarkList(0, requestNum) { result in
      self.bookmarkDatas = result
      self.countNumber = self.bookmarkDatas?.getBookmarkedPostsData.content.count ?? 0
      
      completion()
    }
  }
  
  func reloadBookmarkList(){
    getBookmarkList(requestNum: 100) {
      self.bookMarkCollectionView.reloadData()
    }
  }
  
  func loginButtonTapped(){
    self.dismiss(animated: true) {
      self.dismiss(animated: true)
    }
  }
}

// MARK: - collectionView
extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return countNumber 
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let postID = bookmarkDatas?.getBookmarkedPostsData.content[indexPath.row].postID else { return }
    
    detailPostDataManager.searchSinglePostData(postId: postID,
                                               loginStatus: true) {
      let postData = self.detailPostDataManager.getPostDetailData()
      if postData?.close == true { return }
      var username: String? = nil

      let postedVC = PostedStudyViewController(postID: postID)
      postedVC.previousBookMarkVC = self
      postedVC.postedData = postData
      
      username = postData?.postedUser.nickname
      
      if username == nil {
        self.showToast(message: "해당 post에 접근할 수 없습니다", imageCheck: false)
        return
      }
      self.navigationController?.pushViewController(postedVC, animated: true)
      
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookMarkCell.id,
                                                  for: indexPath)
    let bookmarkCellData = bookmarkDatas?.getBookmarkedPostsData.content[indexPath.row]
    
    if let cell = cell as? BookMarkCell {
      cell.model = bookmarkCellData
      cell.delegate = self
      cell.postDelegate = self
    }
  
    return cell
  }
}

// 셀의 각각의 크기
extension BookmarkViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 210)
  }
}

// MARK: - 북마크 탭
extension BookmarkViewController: BookMarkDelegate {
  func bookmarkTapped(postId: Int, userId: Int) {
    bookmarkButtonTapped(postId, userId) {
      self.getBookmarkList(requestNum: self.defaultRequestNum) {
        self.bookMarkCollectionView.reloadData()
        self.countNumber = self.bookmarkDatas?.totalCount ?? 0
        
      }
    }
  }
}

extension BookmarkViewController: ParticipatePostDelegate{
  func participateButtonTapped(studyId: Int, postId: Int) {
    detailPostDataManager.searchSinglePostData(postId: postId,
                                               loginStatus: true) {
      let checkApply = self.detailPostDataManager.getPostDetailData()?.apply

      if checkApply ?? false {
        self.showToast(message: "이미 신청한 스터디예요.", imageCheck: false)
        return
      }
      
      let participateVC = ParticipateVC()
      participateVC.studyId = studyId
      participateVC.postId = postId
      self.navigationController?.pushViewController(participateVC, animated: true)
    }
    
   
  }
}
