
import UIKit

import SnapKit

final class HomeViewController: NaviHelper {
  let postDataManager = PostDataManager.shared
  let detailPostDataManager = PostDetailInfoManager.shared
  let ueserInfoManager = UserInfoManager.shared
  
  var newPostDatas: PostDataContent?
  var deadlinePostDatas: PostDataContent?
  var loginStatus: Bool = false
  
  // MARK: - 화면구성
  private lazy var mainStackView = createStackView(axis: .vertical,
                                                   spacing: 10)
  private let mainImageView: UIImageView = {
    let mainImageView = UIImageView(image: UIImage(named: "MainImg"))
    
    mainImageView.clipsToBounds = true
    return mainImageView
  }()
  
  private lazy var detailsButton: UIButton = {
    let detailsButton = UIButton(type: .system)
    detailsButton.setTitle("알아보기", for: .normal)
    detailsButton.setTitleColor(.white, for: .normal)
    detailsButton.backgroundColor = UIColor(hexCode: "FF5935")
    detailsButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold",
                                            size: 20)
    detailsButton.layer.cornerRadius = 8
    detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
    return detailsButton
  }()
  
  // MARK: - 서치바
  private let searchBar = UISearchBar.createSearchBar(placeholder: "스터디와 관련된 학과를 입력해주세요")
  
  // MARK: - 모집 중인 스터디
  private let newStudyLabel: UILabel = {
    let newStudyLabel = UILabel()
    newStudyLabel.text = "NEW! 모집 중인 스터디예요"
    newStudyLabel.font = UIFont(name: "Pretendard-Bold",
                                size: 20)
    newStudyLabel.textColor = .black
    
    let attributedText = NSMutableAttributedString(string: "NEW! 모집 중인 스터디예요")
    attributedText.addAttribute(.foregroundColor,
                                value: UIColor(hexCode: "FF5935"),
                                range: NSRange(location: 0, length: 4))
    newStudyLabel.attributedText = attributedText
    return newStudyLabel
  }()
  
  private lazy var allButton: UIButton = {
    let button = UIButton()
    
    let title = "전체"
    let image = UIImage(named: "RightArrow")
    
    button.semanticContentAttribute = .forceLeftToRight
    button.contentHorizontalAlignment = .left
    
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor.g60, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    button.setImage(image, for: .normal)
    
    let spacing: CGFloat = 8
    
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: 0)
    button.addAction(UIAction { _ in
      self.allButtonTapped()
    } , for: .touchUpInside)
    return button
  }()
  
  // MARK: - collectionview
  private lazy var recrutingCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50
    //    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var newStudyTopStackView = createStackView(axis: .horizontal,
                                                          spacing: 10)
  private lazy var newStudyTotalStackView = createStackView(axis: .vertical,
                                                            spacing: 10)
  
  // MARK: - 마감이 입박한 스터디
  private let deadLineImg: UIImageView = {
    let smallImageView = UIImageView(image: UIImage(named: "FireImg"))
    smallImageView.contentMode = .scaleAspectFit
    smallImageView.tintColor = UIColor(hexCode: "FF5935")
    return smallImageView
  }()
  
  private let deadLineLabel: UILabel = {
    let textLabel = UILabel()
    textLabel.text = "마감이 임박한 스터디예요"
    textLabel.font = UIFont.boldSystemFont(ofSize: 20)
    textLabel.textColor = .black
    
    let textAttributedText = NSMutableAttributedString(string: "마감이 임박한 스터디예요")
    textAttributedText.addAttribute(.foregroundColor, value: UIColor(hexCode: "FF5935"),
                                    range: NSRange(location: 0, length: 2))
    textLabel.attributedText = textAttributedText
    
    return textLabel
  }()
  
  private lazy var deadLineCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10// cell사이의 간격 설정
    //    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var deadLineStackView = createStackView(axis: .horizontal,
                                                       spacing: 10)
  
  
  private lazy var totalStackView = createStackView(axis: .vertical,
                                                    spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  // MARK: -  viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    let test = CommonNetworking.shared
    test.delegate = self
    
    navigationItemSetting()
    redesignNavigationbar()
    
    redesignSearchBar()
    
    setupDelegate()
    registerCell()
    
    settingUI()
  }
  
  func homeTapBarTapped(){
    reloadHomeVCCells()

  }
  
  // MARK: - UI세팅
  func settingUI(){
    ueserInfoManager.getUserInfo { userInfo in
      if userInfo?.nickname != nil {
        self.fetchData(loginStatus: true) {
          print("로그인")
          self.loginStatus = true
          self.setUpLayout()
          self.makeUI()
        }
      }else {
        self.fetchData(loginStatus: false) {
          print("비로그인")
          self.setUpLayout()
          self.makeUI()
        }
      }
    }
  }
  
  // MARK: - setuplayout
  func setUpLayout(){
    
    scrollView.addSubview(mainImageView)
    scrollView.addSubview(detailsButton)
    
    let newStudyDataView = [newStudyLabel, allButton]
    for view in newStudyDataView {
      newStudyTopStackView.addArrangedSubview(view)
    }

    let spaceView = UIView()
    let newStudyTotalDataView = [newStudyTopStackView, spaceView, recrutingCollectionView]
    for view in newStudyTotalDataView {
      newStudyTotalStackView.addArrangedSubview(view)
    }
    
    let spaceView1 = UIView()
    let deadLineViewData = [deadLineImg, deadLineLabel, spaceView1]
    for view in deadLineViewData {
      deadLineStackView.addArrangedSubview(view)
    }
    
    let totalViewData = [mainStackView, searchBar,
                         newStudyTotalStackView, deadLineStackView,
                         deadLineCollectionView]
    for view in totalViewData {
      totalStackView.addArrangedSubview(view)
    }
    
    scrollView.addSubview(totalStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainImageView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(scrollView)
    }
    
    detailsButton.snp.makeConstraints { make in
      make.leading.equalTo(mainImageView.snp.leading).offset(20)
      make.bottom.equalTo(mainImageView.snp.bottom).offset(-30)
      make.width.equalTo(110)
      make.height.equalTo(39)
    }
    
    searchBar.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    searchBar.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    newStudyTotalStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    newStudyTotalStackView.isLayoutMarginsRelativeArrangement = true
    
    recrutingCollectionView.snp.makeConstraints { make in
      make.height.equalTo(171)
    }
    
    deadLineStackView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 10, right: 20)
    deadLineStackView.isLayoutMarginsRelativeArrangement = true
    
    // 셀 전체의 크기
    deadLineCollectionView.snp.makeConstraints { make in
      make.height.equalTo(500)
    }
    
    totalStackView.snp.makeConstraints { make in
      make.top.equalTo(mainImageView.snp.bottom)
      make.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }
  
  // MARK: - 네비게이션바 재설정
  func redesignNavigationbar(){
    // 네비게이션 왼쪽아이템
    
    let logoImg = UIImage(named: "LogoImage")?.withRenderingMode(.alwaysOriginal)
    let logo = UIBarButtonItem(image: logoImg, style: .done, target: nil, action: nil)
    logo.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    logo.isEnabled = false
    
    let mainTitleImg = UIImage(named: "MainTitle")?.withRenderingMode(.alwaysOriginal)
    let mainTitle = UIBarButtonItem(image: mainTitleImg, style: .done, target: nil, action: nil)
    mainTitle.imageInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
    mainTitle.isEnabled = false
    
    let bookMarkImg = UIImage(named: "BookMarkImg")?.withRenderingMode(.alwaysOriginal)
    lazy var bookMark = UIBarButtonItem(
      image: bookMarkImg,
      style: .plain,
      target: self,
      action: #selector(bookmarkpageButtonTapped))
    bookMark.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    
    navigationItem.leftBarButtonItems = [logo, mainTitle]
    navigationItem.rightBarButtonItem = bookMark
  }
  
  // MARK: - 알아보기로 이동하는 함수
  @objc func detailsButtonTapped() {
    let detailsViewController = DetailsViewController()
    detailsViewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(detailsViewController, animated: true)
  }
  
// MARK: -  북마크 버튼 탭
  @objc func bookmarkpageButtonTapped() {
    let bookmarkViewController = BookmarkViewController()
    bookmarkViewController.navigationItem.title = "북마크"
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    bookmarkViewController.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(bookmarkViewController, animated: true)
  }
  
  // MARK: - 서치바 재설정
  func redesignSearchBar(){
    searchBar.placeholder = "관심있는 스터디를 검색해 보세요"
    
    if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.backgroundColor = .bg30
      searchBarTextField.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
  // MARK: - setupDelegate
  private func setupDelegate() {
    recrutingCollectionView.tag = 1
    deadLineCollectionView.tag = 2
    
    recrutingCollectionView.delegate = self
    recrutingCollectionView.dataSource = self
    
    searchBar.delegate = self
    
    deadLineCollectionView.delegate = self
    deadLineCollectionView.dataSource = self
    
  }
  
  // MARK: - registerCell
  private func registerCell() {
    recrutingCollectionView.register(RecruitPostCell.self,
                                     forCellWithReuseIdentifier: RecruitPostCell.id)
    
    deadLineCollectionView.register(DeadLineCell.self,
                                    forCellWithReuseIdentifier: DeadLineCell.id)
  }

  // MARK: - collectionview 데이터 불러오기
  func fetchData(loginStatus: Bool,
                 completion: @escaping () -> Void) {
    DispatchQueue.global().async {
      self.postDataManager.getNewPostData(loginStatus) {
        self.newPostDatas = self.postDataManager.getNewPostDatas()
        
        self.postDataManager.getDeadLinePostData(loginStatus){
          self.deadlinePostDatas = self.postDataManager.getDeadLinePostDatas()
          DispatchQueue.main.async {
            self.recrutingCollectionView.reloadData()
            self.deadLineCollectionView.reloadData()
            completion()
          }
        }
      }
    }
  }
  
  // MARK: - allbuttonTapped
  func allButtonTapped(){
    if let tabBarController = self.tabBarController {
      tabBarController.selectedIndex = 1
    }
  }
}

// MARK: - 서치바 관련
extension HomeViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을 때 호출되는 메서드
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    let searchViewController = SearchViewController()
    searchViewController.hidesBottomBarWhenPushed = false
    self.navigationController?.pushViewController(searchViewController, animated: true)
    return false
  }
}

// MARK: - collectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if collectionView.tag == 1 {
      return 5
    } else if collectionView.tag == 2 {
      return 4
    }
    else {
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    var postID: Int? = nil
    var username: String? = nil
    if collectionView.tag == 1 {
      guard let newPostID = newPostDatas?.postDataByInquiries.content[indexPath.row].postID else { return }
      postID = newPostID
    } else {
      guard let deadLinePostID = deadlinePostDatas?.postDataByInquiries.content[indexPath.row].postID else { return }
      postID = deadLinePostID
    }
    
    let postedVC = PostedStudyViewController(postID: postID)
 
    postedVC.previousHomeVC = self
    postedVC.hidesBottomBarWhenPushed = true
    
    loginManager.refreshAccessToken { loginStatus in
      self.detailPostDataManager.searchSinglePostData(postId: postID ?? 0,
                                                 loginStatus: loginStatus) {
        let cellData = self.detailPostDataManager.getPostDetailData()
        username = cellData?.postedUser.nickname
      
        postedVC.postedData = cellData
     
        if username == nil {
          self.showToast(message: "해당 post에 접근할 수 없습니다",imageCheck: false)
          return
        }
        
        self.navigationController?.pushViewController(postedVC, animated: true)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView.tag == 1 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitPostCell.id,
                                                    for: indexPath)

      if let cell = cell as? RecruitPostCell {
        let content = newPostDatas?.postDataByInquiries.content[indexPath.row]
        
        cell.model = content
        cell.delegate = self
        cell.loginStatus = loginStatus
      }

      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeadLineCell.id,
                                                    for: indexPath)
      if let cell = cell as? DeadLineCell {
        let content = deadlinePostDatas?.postDataByInquiries.content[indexPath.row]
        cell.model = content
        cell.delegate = self
        cell.loginStatus = loginStatus
      }
      return cell
    }
  }
// 셀을 클릭 -> 북마크 저장 삭제 -> 북마크 여부 조회 -> 결과에 따라 변경
// 셀을 슬라이드하면 데이터가 리로드되서 북마크 터치한 결과가 반영이 안된다.
  func reloadHomeVCCells(){
    fetchData(loginStatus: true) {
      self.recrutingCollectionView.reloadData()
      self.deadLineCollectionView.reloadData()
    }
  }
}

// 셀의 각각의 크기
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.tag == 1 {
      return CGSize(width: 250, height: collectionView.frame.height)
    } else if collectionView.tag == 2 {
      return CGSize(width: 335, height: 84)
    } else {
      return CGSize(width: 335, height: collectionView.frame.height)
    }
  }
}

// MARK: - 북마크 관련
extension HomeViewController: BookMarkDelegate {
  func bookmarkTapped(postId: Int, userId: Int) {
    bookmarkButtonTapped(postId, userId) {
      self.fetchData(loginStatus: true) {
        print("rr")
      }
    }
  }
}

extension HomeViewController: CheckLoginDelegate {
  func checkLoginPopup(checkUser: Bool) {
    checkLoginStatus(checkUser: checkUser)
  }
}
