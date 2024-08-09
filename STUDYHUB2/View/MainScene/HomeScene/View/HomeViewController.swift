
import UIKit

import SnapKit
import RxCocoa

final class HomeViewController: CommonNavi {

  let viewModel: HomeViewModel
  
  // MARK: - 화면구성

  private lazy var mainStackView = createStackView(axis: .vertical, spacing: 10)

  private let mainImageView: UIImageView = {
    let mainImageView = UIImageView(image: UIImage(named: "MainImg"))
    mainImageView.clipsToBounds = true
    return mainImageView
  }()

  let detailsButton = StudyHubButton(title: "알아보기", radious: 5)

  // MARK: - 서치바
  private let searchBar = UISearchBar.createSearchBar(placeholder: "스터디와 관련된 학과를 입력해주세요")
  
  private lazy var newStudyLabel = createHomeLabel(title: "NEW! 모집 중인 스터디예요", changeLength: 4)

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
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var newStudyTopStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var newStudyTotalStackView = createStackView(axis: .vertical, spacing: 10)
  
  // MARK: - 마감이 입박한 스터디
  private let deadLineImg: UIImageView = {
    let smallImageView = UIImageView(image: UIImage(named: "FireImg"))
    smallImageView.contentMode = .scaleAspectFit
    smallImageView.tintColor = UIColor(hexCode: "FF5935")
    return smallImageView
  }()
  
  private lazy var deadLineLabel = createHomeLabel(title: "마감이 임박한 스터디예요", changeLength: 2)

  private lazy var deadLineCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var deadLineStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var totalStackView = createStackView(axis: .vertical,spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  init(_ loginStatus: Bool) {
    self.viewModel = HomeViewModel(loginStatus: loginStatus)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: -  viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    navigationController?.navigationBar.backgroundColor = .black
    
    let test = CommonNetworking.shared
    test.delegate = self
    
    setupBindings()
    setupCollectionView()
    setupActions()
   
    setUpLayout()
    makeUI()
    
    redesignNavigationbar()
    redesignSearchBar()
  }
  
  func homeTapBarTapped(){
    reloadHomeVCCells()
  }
  
  // MARK: - setuplayout
  func setUpLayout(){
    scrollView.addSubview(mainImageView)
    scrollView.addSubview(detailsButton)
    detailsButton.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)

    [
      newStudyLabel,
      allButton
    ].forEach {
      newStudyTopStackView.addArrangedSubview($0)
    }
    
    let spaceView = UIView()
    
    [
      newStudyTopStackView,
      spaceView,
      recrutingCollectionView
    ].forEach {
      newStudyTotalStackView.addArrangedSubview($0)
    }
    
    let spaceView1 = UIView()
    
    [
      deadLineImg,
      deadLineLabel,
      spaceView1
    ].forEach {
      deadLineStackView.addArrangedSubview($0)
    }
    
    [
      mainStackView,
      searchBar,
      newStudyTotalStackView,
      deadLineStackView,
      deadLineCollectionView
    ].forEach {
      totalStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(totalStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(scrollView)
    }
    
    detailsButton.snp.makeConstraints {
     $0.leading.equalTo(mainImageView.snp.leading).offset(20)
     $0.bottom.equalTo(mainImageView.snp.bottom).offset(-30)
     $0.width.equalTo(110)
     $0.height.equalTo(39)
    }
    
    searchBar.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    searchBar.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    newStudyTotalStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    newStudyTotalStackView.isLayoutMarginsRelativeArrangement = true
    
    recrutingCollectionView.snp.makeConstraints {
      $0.height.equalTo(171)
    }
    
    deadLineStackView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 10, right: 20)
    deadLineStackView.isLayoutMarginsRelativeArrangement = true
    
    deadLineCollectionView.snp.makeConstraints {
      $0.height.equalTo(500)
    }
    
    totalStackView.snp.makeConstraints {
     $0.top.equalTo(mainImageView.snp.bottom)
     $0.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
     $0.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    scrollView.backgroundColor = .white
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view)
    }
  }
  
  func createHomeLabel(title: String, changeLength: Int) -> UILabel {
    let newStudyLabel = UILabel()
    newStudyLabel.text = title
    newStudyLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
    newStudyLabel.textColor = .black
    
    let attributedText = NSMutableAttributedString(string: title)
    attributedText.addAttribute(.foregroundColor,
                                value: UIColor(hexCode: "FF5935"),
                                range: NSRange(location: 0, length: changeLength))
    newStudyLabel.attributedText = attributedText
    return newStudyLabel
  }
  
  // MARK: - 네비게이션바 재설정
  func redesignNavigationbar(){
    leftButtonSetting(imgName: "LogoImage", activate: false)
    rightButtonSetting(imgName: "BookMarkImg")
  }
  
  private func setupCollectionView() {
    recrutingCollectionView.tag = 1
    deadLineCollectionView.tag = 2
    
    recrutingCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    deadLineCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    
    recrutingCollectionView.register(RecruitPostCell.self,
                                     forCellWithReuseIdentifier: RecruitPostCell.id)
    deadLineCollectionView.register(DeadLineCell.self,
                                    forCellWithReuseIdentifier: DeadLineCell.id)
  }
  
  func setupBindings(){
    viewModel.newPostDatas
      .map { Array($0.prefix(5)) }
      .bind(to: recrutingCollectionView.rx.items(
        cellIdentifier: RecruitPostCell.id,
        cellType: RecruitPostCell.self)) { index, content, cell in
          cell.model = content
          cell.delegate = self
          cell.loginStatus = self.viewModel.checkLoginStatus.value
        }
        .disposed(by: viewModel.disposeBag)
    
    viewModel.deadlinePostDatas
      .map { Array($0.prefix(4)) }
      .bind(to: deadLineCollectionView.rx.items(
        cellIdentifier: DeadLineCell.id,
        cellType: DeadLineCell.self)) { index, content, cell in
          cell.model = content
          cell.delegate = self
          cell.loginStatus = self.viewModel.checkLoginStatus.value
        }
        .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    recrutingCollectionView.rx.modelSelected(Content.self)
      .subscribe(onNext: { [weak self] item in
        print("Selected item: \(item)")
      })
      .disposed(by: viewModel.disposeBag)
    
  }
  
  // MARK: - 알아보기로 이동하는 함수
  
  @objc func detailsButtonTapped() {
    let detailsViewController = DetailsViewController()
    detailsViewController.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(detailsViewController, animated: true)
  }
  
  // MARK: -  북마크 버튼 탭
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
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
  
  // MARK: - allbuttonTapped
  
  func allButtonTapped(){
    if let tabBarController = self.tabBarController {
      tabBarController.selectedIndex = 1
    }
  }
}

// MARK: - 서치바 관련

extension HomeViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    let searchViewController = SearchViewController()
    searchViewController.hidesBottomBarWhenPushed = false
    self.navigationController?.pushViewController(searchViewController, animated: true)
    return false
  }
  
  func reloadHomeVCCells(){
    self.recrutingCollectionView.reloadData()
    self.deadLineCollectionView.reloadData()
  }
}

// MARK: - collectionView
//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

//  
//  func collectionView(_ collectionView: UICollectionView,
//                      didSelectItemAt indexPath: IndexPath) {
//    var postID: Int? = nil
//    var username: String? = nil
//    
//    if collectionView.tag == 1 {
//      guard let newPostID = newPostDatas?.postDataByInquiries.content[indexPath.row].postID else { return }
//      postID = newPostID
//    } else {
//      guard let deadLinePostID = deadlinePostDatas?.postDataByInquiries.content[indexPath.row].postID else { return }
//      postID = deadLinePostID
//    }
//    
//    let postedVC = PostedStudyViewController(postID: postID)
// 
//    postedVC.previousHomeVC = self
//    postedVC.hidesBottomBarWhenPushed = true
//    
//    commonNetworking.refreshAccessToken { loginStatus in
//      self.detailPostDataManager.searchSinglePostData(postId: postID ?? 0,
//                                                 loginStatus: loginStatus) {
//        let cellData = self.detailPostDataManager.getPostDetailData()
//        username = cellData?.postedUser.nickname
//      
//        postedVC.postedData = cellData
//     
//        if username == nil {
//          self.showToast(message: "해당 post에 접근할 수 없습니다",imageCheck: false)
//          return
//        }
//        
//        self.navigationController?.pushViewController(postedVC, animated: true)
//      }
//    }
//  }
//
//
//// 셀을 클릭 -> 북마크 저장 삭제 -> 북마크 여부 조회 -> 결과에 따라 변경
//// 셀을 슬라이드하면 데이터가 리로드되서 북마크 터치한 결과가 반영이 안된다.
//  func reloadHomeVCCells(){
//    self.recrutingCollectionView.reloadData()
//    self.deadLineCollectionView.reloadData()
//  }
//}
//
//// 셀의 각각의 크기
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

//// MARK: - 북마크 관련
//extension HomeViewController: BookMarkDelegate {
//  func bookmarkTapped(postId: Int, userId: Int) {
//    bookmarkButtonTapped(postId, userId) {
//      self.fetchData(loginStatus: true)
//    }
//  }
//}

extension HomeViewController: CheckLoginDelegate {
  func checkLoginPopup(checkUser: Bool) {
//    checkLoginStatus(checkUser: checkUser)
  }
}

extension HomeViewController: BookMarkDelegate {
  func bookmarkTapped(postId: Int, userId: Int) {
    
  }
}
