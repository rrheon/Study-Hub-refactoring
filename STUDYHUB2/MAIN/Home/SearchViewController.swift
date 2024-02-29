
import UIKit

import SnapKit
import Moya

final class SearchViewController: NaviHelper {
  // MARK: - 화면구성, tapbar도 같이 나오게 수정해야함
  let detailPostDataManager = PostDetailInfoManager.shared
  let postDataManager = PostDataManager.shared
  
  var searchKeyword: String?
  var pageCount: Int = 0
  var isInfiniteScroll = true
  var searchType: String = "false"
  var totalDatas: [Content]? = []
  var loginStatus: Bool = false
  var dataEmptyCheck: Bool = false
  
  private lazy var studyCellCount: Int = self.searchResultData?.totalCount ?? 0

  var recommendData: RecommendList?
  var searchResultData: PostDataContent?
  
  init(keyword: String? = nil) {
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - 서치바
  private let searchBar = UISearchBar.createSearchBar(placeholder: "스터디와 관련된 학과를 입력해주세요")
  
  private lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomCell.self,
                       forCellReuseIdentifier: CustomCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()
  
  // MARK: - 서치바에서 검색할 때
  private lazy var allButton: UIButton = {
    let button = UIButton()
    button.setTitle("제목", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium",
                                     size: 14)
    button.backgroundColor = .black
    button.layer.cornerRadius = 20
    button.addAction(UIAction { _ in
      self.allButtonTapped()
    }, for: .touchUpInside)
    
    return button
  }()
  
  private lazy var popularButton: UIButton = {
    let button = UIButton()
    button.setTitle("인기", for: .normal)
    button.setTitleColor(.bg90, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium",
                                     size: 14)
    button.backgroundColor = .bg30
    button.layer.cornerRadius = 20
    button.addAction(UIAction { _ in
      self.popularButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var majorButton: UIButton = {
    let button = UIButton()
    button.setTitle("학과", for: .normal)
    button.setTitleColor(.bg90, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium",
                                     size: 14)
    button.backgroundColor = .bg30
    button.layer.cornerRadius = 20
    button.addAction(UIAction { _ in
      self.majorButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var emptyImage = UIImage(named: "EmptyStudy")
  private lazy var emptyImageView = UIImageView(image: emptyImage)
  
  private lazy var emptyLabel = createLabel(
    title: "관련 스터디가 없어요\n지금 스터디를 만들어보세요!",
    textColor: .bg60,
    fontType: "Pretendard-SemiBold",
    fontSize: 16)
  
  private lazy var resultCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 20
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    
    return view
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .white
    return scrollView
  }()
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    let test = CommonNetworking.shared
    test.delegate = self
    
    navigationItemSetting()
    redesignNavigationbar()
    
    redesignSearchBar()
    
    loginManager.refreshAccessToken { result in
      self.loginStatus = result
    }
    
    self.setUpLayout()
    self.makeUI()
  }
  
  func makeUI() {
    searchBar.delegate = self
    
    resultTableView.delegate = self
    resultTableView.dataSource = self
    
    resultCollectionView.delegate = self
    resultCollectionView.dataSource = self
    
    resultCollectionView.register(SearchResultCell.self,
                                  forCellWithReuseIdentifier: SearchResultCell.id)
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(10)
      make.leading.trailing.equalTo(searchBar).offset(10)
      make.bottom.equalTo(view).offset(-10)
    }
    
    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
  }
  
  func setUpLayout() {
    [
      searchBar,
      resultTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - 서치바 재설정
  func redesignSearchBar(){
    searchBar.placeholder = "관심있는 스터디를 검색해 보세요"
    
    if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.backgroundColor = .bg30
      searchBarTextField.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
  // MARK: -  네비게이션바 재설정
  func redesignNavigationbar(){
    let bookMarkImg = UIImage(named: "BookMarkImg")?.withRenderingMode(.alwaysOriginal)
    lazy var bookMark = UIBarButtonItem(
      image: bookMarkImg,
      style: .plain,
      target: self,
      action: #selector(bookmarkpageButtonTapped))
    bookMark.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    
    navigationItem.rightBarButtonItem = bookMark
  }
  
  // MARK: - 북마크 아이콘 터치
  @objc func bookmarkpageButtonTapped() {
    let bookmarkViewController = BookmarkViewController(postID: 0)
    navigationController?.pushViewController(bookmarkViewController, animated: true)
  }
  
  func buttonTapped(hot: String, titleAndMajor: String){
    resultCollectionView.setContentOffset(CGPoint.zero, animated: false)
    pageCount = 0
    self.postDataManager.getPostData(hot: hot,
                                     text: self.searchKeyword,
                                     page: pageCount,
                                     size: 5,
                                     titleAndMajor: titleAndMajor,
                                     loginStatus: false) { PostDataContent in
      self.searchResultData = PostDataContent
      self.totalDatas = []
      
      self.totalDatas?.append(contentsOf: PostDataContent.postDataByInquiries.content)
      DispatchQueue.main.async {
        self.resultCollectionView.reloadData()
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
      }
      
      self.resultCollectionView.isHidden = false
      [
        self.emptyImageView,
        self.emptyLabel
      ].forEach {
        $0.isHidden = true
      }
    return
      self.dataEmptyCheck = true
    }
    
    if dataEmptyCheck {
      resultCollectionView.isHidden = true
      [
        emptyImageView,
        emptyLabel
      ].forEach {
        view.addSubview($0)
        $0.isHidden = false
      }
      
      emptyImageView.snp.makeConstraints {
        $0.centerY.equalToSuperview().offset(-30)
        $0.centerX.equalToSuperview()
      }

      emptyLabel.snp.makeConstraints {
        $0.top.equalTo(emptyImageView.snp.bottom).offset(10)
        $0.centerX.equalTo(emptyImageView)
      }
    }
  }
  
  // MARK: - 전체버튼 눌렸을 때
  func allButtonTapped() {
    updateButtonColors(selectedButton: allButton,
                       deselectedButtons: [popularButton, majorButton])
    
    buttonTapped(hot: "false", titleAndMajor: "true")
  }
  
  // MARK: - 인기버튼 눌렸을 때
  func popularButtonTapped() {
    updateButtonColors(selectedButton: popularButton,
                       deselectedButtons: [allButton, majorButton])
    
    buttonTapped(hot: "true", titleAndMajor: "true")

  }
  
  // MARK: - 학과버튼 눌렸을 때
  func majorButtonTapped() {
    updateButtonColors(selectedButton: majorButton,
                       deselectedButtons: [allButton, popularButton])
    
    buttonTapped(hot: "false", titleAndMajor: "false")
  }
  
  // 버튼 색상 업데이트 함수
  private func updateButtonColors(selectedButton: UIButton, deselectedButtons: [UIButton]) {
    
    selectedButton.setTitleColor(.white, for: .normal)
    selectedButton.backgroundColor = .black
    
    for button in deselectedButtons {
      button.setTitleColor(.bg90, for: .normal)
      button.backgroundColor = .bg30
    }
  }
  
  // MARK: - 추천어 검색하기
  func searchRecommend(keyword: String , completion: @escaping () -> Void){
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.recommendSearch(_keyword: keyword)) {
      switch $0 {
      case .success(let response):
        do {
          let recommendList = try JSONDecoder().decode(RecommendList.self, from: response.data)
          self.recommendData = recommendList
          
          completion()
          
          DispatchQueue.main.async {
            self.resultTableView.reloadData()
          }
        } catch {
          print("Failed to decode JSON: \(error)")
        }
      case .failure(let response):
        print(response.response)
      }
    }
  }
  
  // MARK: - 검색결과가 없을 때
  func noSearchDataUI(){
    if self.recommendData?.recommendList.count == 0 {
      [
        emptyImageView,
        emptyLabel
      ].forEach {
        view.addSubview($0)
        $0.isHidden = false
      }
      
      emptyImageView.snp.makeConstraints {
        $0.centerY.equalToSuperview().offset(-30)
        $0.centerX.equalToSuperview()
      }
      
      emptyLabel.numberOfLines = 0
      emptyLabel.textAlignment = .center
      emptyLabel.snp.makeConstraints {
        $0.top.equalTo(emptyImageView.snp.bottom).offset(10)
        $0.centerX.equalTo(emptyImageView)
      }
    } else {
      [
        emptyImageView,
        emptyLabel
      ].forEach {
        $0.isHidden = true
      }
    }
  }
  
  // MARK: - 검색 후 추천어를 눌렀을 때
  func updateUI(){
    resultTableView.isHidden = true
    resultCollectionView.isHidden = false
    
    [
      allButton,
      popularButton,
      majorButton,
      scrollView
    ].forEach {
      $0.isHidden = false
    }
    
    navigationItem.rightBarButtonItems = .none
    
    navigationController?.navigationBar.topItem?.title = "검색결과"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    
    [
      allButton,
      popularButton,
      majorButton,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(resultCollectionView)
    
    allButton.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.leading.equalTo(searchBar.snp.leading).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    popularButton.snp.makeConstraints {
      $0.top.equalTo(allButton)
      $0.leading.equalTo(allButton.snp.trailing).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    majorButton.snp.makeConstraints {
      $0.top.equalTo(allButton)
      $0.leading.equalTo(popularButton.snp.trailing).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    resultCollectionView.reloadData()
    resultCollectionView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(scrollView.snp.height)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(allButton.snp.bottom).offset(20)
      make.leading.trailing.equalTo(view)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  func fetchData(keyword: String, page: Int, size: Int, titleAndMajor: String){
    loginManager.refreshAccessToken { result in
      self.postDataManager.getPostData(hot: "false",
                                       text: keyword,
                                       page: page,
                                       size: size,
                                       titleAndMajor: titleAndMajor,
                                       loginStatus: result) { result in
        self.totalDatas?.append(contentsOf: result.postDataByInquiries.content)
        self.studyCellCount = self.totalDatas?.count ?? 0
        
        self.updateUI()
        self.searchBar.text = keyword
      }
    }
  }
}

// MARK: - 서치바 함수
extension SearchViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을 때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    searchBar.resignFirstResponder()
    
    resultTableView.isHidden = false
    
    [
      allButton,
      popularButton,
      majorButton,
      scrollView
    ].forEach {
      $0.isHidden = true
    }
    searchRecommend(keyword: keyword) {
      self.searchKeyword = keyword
      self.noSearchDataUI()
    }
  }
}

// MARK: - tableView cell 함수
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recommendData?.recommendList.count ?? 0
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    resultCollectionView.isHidden = true
    
    let imageView = UIImageView()
    cell.model = recommendData
    imageView.image = UIImage(named: "ScearchImgGray")
    
    cell.contentView.addSubview(imageView)
    cell.name.text = recommendData?.recommendList[indexPath.row]
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalTo(cell.contentView)
    }
    
    cell.backgroundColor = .white
    
    return cell
  }
  
  // UITableViewDelegate 함수 (선택)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let keyword = recommendData?.recommendList[indexPath.row] else { return }
    searchKeyword = keyword
    fetchData(keyword: keyword, page: 0, size: 5, titleAndMajor: "true")
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func reloadTalbeView(){
    resultTableView.reloadData()
  }

}

// MARK: - collectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    studyCellCount = totalDatas?.count ?? 0
    return studyCellCount
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let postID = totalDatas?[indexPath.row].postID else { return }
    let postedVC = PostedStudyViewController(postID: postID)
    postedVC.previousSearchVC = self
    postedVC.hidesBottomBarWhenPushed = true
    
    var username: String? = nil
    
    loginManager.refreshAccessToken { loginStatus in
      self.detailPostDataManager.searchSinglePostData(postId: postID, loginStatus: loginStatus) {
        let cellData = self.detailPostDataManager.getPostDetailData()
        postedVC.postedData = cellData
        username = cellData?.postedUser.nickname
        
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
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath) as! SearchResultCell
    cell.delegate = self
    let content = totalDatas?[indexPath.row]
    cell.model = content
    cell.loginStatus = loginStatus
    
    return cell
  }
}

// 셀의 각각의 크기
extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 247)
  }
}

// MARK: - 북마크 관련
extension SearchViewController: BookMarkDelegate {
  func bookmarkTapped(postId: Int, userId: Int) {
    self.bookmarkButtonTapped(postId, userId) {

    }
  }
}

extension SearchViewController: CheckLoginDelegate {
  func checkLoginPopup(checkUser: Bool) {
    searchBar.text = nil
    searchBar.resignFirstResponder()
    
    checkLoginStatus(checkUser: checkUser)
  }
  
}

extension SearchViewController {
  // MARK: - 네트워킹 기다릴 때
   func waitingNetworking(){
     view.addSubview(activityIndicator)
     
     activityIndicator.snp.makeConstraints {
       $0.centerX.centerY.equalToSuperview()
     }
     
     activityIndicator.startAnimating()
   }
   
   func addPageCount(completion: @escaping (Int) -> Void){
     pageCount += 1
     completion(pageCount)
   }
   
   
   // MARK: - 스크롤해서 네트워킹
  func fetchMoreData(hotType: String, titleAndMajor: String){
    addPageCount { pageCount in
      self.waitingNetworking()
      
      self.postDataManager.getPostData(hot: "false",
                                       text: self.searchKeyword,
                                       page: pageCount,
                                       size: 5,
                                       titleAndMajor: titleAndMajor,
                                       loginStatus: false) { PostDataContent in
        
        self.totalDatas?.append(contentsOf: PostDataContent.postDataByInquiries.content)
        
        DispatchQueue.main.async {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            
            self.updateCollectionViewHeight()
            self.resultCollectionView.reloadData()
            self.isInfiniteScroll = true
          }
        }
      }
    }
  }
   
   // MARK: - 스크롤 제약 업데이트
   func updateCollectionViewHeight() {
     // 기존의 제약 조건을 찾아 업데이트
     let existingConstraint = resultCollectionView.constraints.first { constraint in
       return constraint.firstAttribute == .height && constraint.relation == .equal
     }
     
     if let existingConstraint = existingConstraint {
       // 기존의 제약 조건이 존재하는 경우, 해당 제약 조건을 업데이트
       existingConstraint.constant = calculateNewCollectionViewHeight()
     } else {
       // 기존의 제약 조건이 존재하지 않는 경우, 새로운 제약 조건 추가
       resultCollectionView.snp.makeConstraints { make in
         make.height.equalTo(calculateNewCollectionViewHeight())
       }
     }
     
     
     // 레이아웃 업데이트
     self.view.layoutIfNeeded()
   }
   
   // MARK: - 스크롤 시 셀 높이 계산
   func calculateNewCollectionViewHeight() -> CGFloat {
     // resultCollectionView의 셀 개수에 따라 새로운 높이 계산
     let cellHeight: CGFloat = 247
     let spacing: CGFloat = 10
     let numberOfCells = searchResultData?.totalCount ?? 0
     let newHeight = CGFloat(numberOfCells) * cellHeight + CGFloat(numberOfCells - 1) * spacing
     
     studyCellCount = numberOfCells
     return newHeight
   }
}

extension SearchViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height)){
      
      if isInfiniteScroll {
        isInfiniteScroll = false
        
        fetchMoreData(hotType: searchType, titleAndMajor: "true")
      }
    }
  }
}
