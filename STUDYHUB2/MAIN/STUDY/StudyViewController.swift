import UIKit

import SnapKit

// searchResultCell이랑 같은 형식 , collectionview랑 추가버튼 같이 뜨게 수정해야함
final class StudyViewController: NaviHelper {
  let postDataManager = PostDataManager.shared
  let detailPostDataManager = PostDetailInfoManager.shared
  var recentDatas: PostDataContent?
  var totalDatas: [Content]? = []
  
  var pageCount: Int = 0
  var isInfiniteScroll = true
  var searchType: String = "false"
  var loginStatus: Bool = false
  
  private lazy var recentButton: UIButton = {
    let button = UIButton()
    button.setTitle("   전체   ", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    button.backgroundColor = .black
    button.layer.cornerRadius = 15
    button.addTarget(self, action: #selector(recentButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var popularButton: UIButton = {
    let button = UIButton()
    button.setTitle("   인기   ", for: .normal)
    button.setTitleColor(.bg90, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    button.backgroundColor = .bg30
    button.layer.cornerRadius = 15
    button.addTarget(self, action: #selector(popularButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var studyCount: Int = recentDatas?.totalCount ?? 0
  
  private lazy var emptyImage = UIImage(named: "EmptyStudy")
  private lazy var emptyImageView = UIImageView(image: emptyImage)
  
  private lazy var describeLabel = createLabel(
    title: "관련 스터디가 없어요\n지금 스터디를 만들어\n  팀원을 구해보세요!",
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 12)
  
  // 스터디가 있는 경우
  private lazy var contentView = UIView()
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
  
  private lazy var addButton: UIButton = {
    let addButton = UIButton(type: .system)
    addButton.setTitle("+", for: .normal)
    addButton.setTitleColor(.white, for: .normal)
    addButton.backgroundColor = UIColor(hexCode: "FF5935")
    addButton.layer.cornerRadius = 30
    addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    return addButton
  }()
  
  // 네트워킹 불러올 때
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    waitingNetworking()
    
    navigationItemSetting()
    redesignNavigationbar()
    
    setupCollectionView()
    
    self.postDataManager.getRecentPostDatas(hotType: "false") {
      self.recentDatas = self.postDataManager.getRecentPostDatas()
      
      guard let recentData = self.recentDatas else { return }
      
      
      self.totalDatas?.append(contentsOf: recentData.postDataByInquiries.content)
      
      DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        self.setupLayout()
        self.makeUI()
      }
    }
    
    loginManager.refreshAccessToken { result in
      self.loginStatus = result
    }
  }
  
  func studyTapBarTapped(){
    recentButtonTapped()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    if studyCount > 0 {
      [
        recentButton,
        popularButton,
        scrollView
      ].forEach {
        view.addSubview($0)
      }
      
      scrollView.addSubview(contentView)
      contentView.addSubview(resultCollectionView)
      contentView.addSubview(addButton)
    }else {
      [
        recentButton,
        popularButton,
        emptyImageView,
        describeLabel,
        addButton
      ].forEach {
        view.addSubview($0)
      }
    }
  }
  
  func setupCollectionView(){
    resultCollectionView.delegate = self
    resultCollectionView.dataSource = self
    
    resultCollectionView.register(SearchResultCell.self,
                                  forCellWithReuseIdentifier: SearchResultCell.id)
  }
  // MARK: - makeUI
  func makeUI(){
    recentButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.leading.equalToSuperview().offset(20)
      make.height.equalTo(34)
      make.width.equalTo(57)
    }
    
    popularButton.snp.makeConstraints { make in
      make.top.equalTo(recentButton)
      make.leading.equalTo(recentButton.snp.trailing).offset(10)
      make.height.equalTo(34)
      make.width.equalTo(57)
    }
    
    if studyCount > 0 {
      resultCollectionView.snp.makeConstraints { make in
        make.top.equalTo(contentView).offset(20)
        make.leading.trailing.equalTo(contentView)
        make.width.equalToSuperview()
        //        make.height.equalTo(1200)
        make.bottom.equalTo(addButton.snp.top).offset(-20) // 여백 추가
      }
      
      addButton.snp.makeConstraints { make in
        make.width.height.equalTo(60)
        make.bottom.equalTo(scrollView.frameLayoutGuide).offset(-30)
        make.trailing.equalTo(scrollView.frameLayoutGuide).offset(-30)
      }
      
      contentView.snp.makeConstraints { make in
        make.edges.equalTo(scrollView.contentLayoutGuide)
        make.width.equalTo(scrollView.frameLayoutGuide)
        make.height.equalTo(1200)
      }
      
      scrollView.snp.makeConstraints { make in
        make.top.equalTo(recentButton.snp.bottom).offset(10)
        make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
      }
    } else {
      emptyImageView.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-50)
      }
      
      describeLabel.numberOfLines = 3
      describeLabel.changeColor(label: describeLabel,
                                wantToChange: "지금 스터디를 만들어\n  팀원을 구해보세요!",
                                color: .changeInfo)
      describeLabel.snp.makeConstraints { make in
        make.top.equalTo(emptyImageView.snp.bottom).offset(10)
        make.centerX.equalTo(emptyImageView)
      }
      
      addButton.snp.makeConstraints { make in
        make.width.height.equalTo(60) // Increase width and height as needed
        make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        make.trailing.equalTo(view).offset(-16)
      }
    }
  }
  
  // MARK: -  네비게이션바 재설정
  func redesignNavigationbar(){
    let logoImg = UIImage(named: "StudyImg")?.withRenderingMode(.alwaysOriginal)
    let logo = UIBarButtonItem(image: logoImg, style: .done, target: nil, action: nil)
    logo.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    logo.isEnabled = false
    
    let bookMarkImg = UIImage(named: "SearchImg_White")?.withRenderingMode(.alwaysOriginal)
    lazy var bookMark = UIBarButtonItem(
      image: bookMarkImg,
      style: .plain,
      target: self,
      action: #selector(searchButtonTapped))
    bookMark.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    
    
    navigationItem.leftBarButtonItem = logo
    navigationItem.rightBarButtonItem = bookMark
  }
  
  @objc func searchButtonTapped() {
    let searchVC = SearchViewController()
    searchVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(searchVC, animated: true)
  }
  
  // MARK: - 게시글 작성 버튼 탭
  @objc func addButtonTapped() {
    loginStatus { loginCheck in
      if loginCheck {
        let createStudyVC = CreateStudyViewController()
        createStudyVC.hidesBottomBarWhenPushed = true
        createStudyVC.delegate = self
        self.navigationController?.pushViewController(createStudyVC, animated: true)
      } else {
        let popupVC = PopupViewController(
          title: "로그인이 필요해요",
          desc: "계속하시려면 로그인을 해주세요!",
          leftButtonTitle: "취소",
          rightButtonTilte: "로그인")
        
        popupVC.popupView.rightButtonAction = {
          self.dismiss(animated: true) {
            self.dismiss(animated: true)
          }
        }
        
        popupVC.modalPresentationStyle = .overFullScreen
        self.present(popupVC, animated: false)
      }
    }
  }
  
  // MARK: - 최신버튼 탭
  @objc func recentButtonTapped(){
    activityIndicator.startAnimating()
    
    postDataManager.getRecentPostDatas(hotType: "false") {
      self.searchType = "false"
      self.recentDatas = self.postDataManager.getRecentPostDatas()
      
      self.totalDatas = []
      
      guard let datas = self.recentDatas?.postDataByInquiries.content else { return }
      self.totalDatas?.append(contentsOf: datas)
      
      DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        self.resultCollectionView.reloadData()
      }
    }
    popularButton.setTitleColor(.bg90, for: .normal)
    popularButton.backgroundColor = .bg30
    
    recentButton.setTitleColor(.white, for: .normal)
    recentButton.backgroundColor = .black
  }
  
  // MARK: - 인기버튼 탭
  @objc func popularButtonTapped(){
    resultCollectionView.setContentOffset(CGPoint.zero, animated: false)

    postDataManager.getRecentPostDatas(hotType: "true") {
      self.searchType = "true"

      self.recentDatas = self.postDataManager.getRecentPostDatas()
      self.totalDatas = []
      
      guard let datas = self.recentDatas?.postDataByInquiries.content else { return }
      self.totalDatas?.append(contentsOf: datas)
      
      DispatchQueue.main.async {
        self.resultCollectionView.reloadData()
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
      }
    }
    recentButton.setTitleColor(.bg90, for: .normal)
    recentButton.backgroundColor = .bg30
    
    popularButton.setTitleColor(.white, for: .normal)
    popularButton.backgroundColor = .black
  }
  
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
  func fetchMoreData(hotType: String){

    addPageCount { pageCount in
      self.waitingNetworking()
      self.postDataManager.getRecentPostDatas(hotType: hotType,
                                              page: pageCount,
                                              size: 5) {

        guard let recentData = self.recentDatas else { return }
        
        self.recentDatas = self.postDataManager.getRecentPostDatas()
        
        self.totalDatas?.append(contentsOf: recentData.postDataByInquiries.content)
        
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
    
    // 다른 View들의 제약 조건 수정
    addButton.snp.updateConstraints { make in
      make.bottom.equalTo(scrollView.frameLayoutGuide).offset(-30)
    }
    
    contentView.snp.updateConstraints { make in
      make.height.equalTo(calculateNewCollectionViewHeight())
    }
    
    // 레이아웃 업데이트
    self.view.layoutIfNeeded()
  }
  
  // MARK: - 스크롤 시 셀 높이 계산
  func calculateNewCollectionViewHeight() -> CGFloat {
    // resultCollectionView의 셀 개수에 따라 새로운 높이 계산
    let cellHeight: CGFloat = 247
    let spacing: CGFloat = 10
    let numberOfCells = recentDatas?.postDataByInquiries.number ?? 0
    let newHeight = CGFloat(numberOfCells) * cellHeight + CGFloat(numberOfCells - 1) * spacing
    studyCount = numberOfCells
    return newHeight
  }
}

// MARK: - collectionView
extension StudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    studyCount = totalDatas?.count ?? 0
    return studyCount
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let postId = totalDatas?[indexPath.row].postID else { return }
    let postedVC = PostedStudyViewController(postID: postId)
    postedVC.hidesBottomBarWhenPushed = true
    postedVC.previousStudyVC = self

    var username: String? = nil

    loginManager.refreshAccessToken { loginStatus in
      self.detailPostDataManager.searchSinglePostData(postId: postId, loginStatus: loginStatus) {
        let cellData = self.detailPostDataManager.getPostDetailData()
        postedVC.postedData = cellData
        
        username = cellData?.postedUser.nickname

        if username == nil {
          self.showToast(message: "해당 post에 접근할 수 없습니다", imageCheck: false)
          return
        }
        self.navigationController?.pushViewController(postedVC, animated: true)

      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath)
    if let cell = cell as? SearchResultCell {
      //      let content = recentDatas?.postDataByInquiries.content[indexPath.row]
      let content = totalDatas?[indexPath.row]
      cell.model = content
      cell.delegate = self
      cell.loginStatus = loginStatus
    }
    
    return cell
  }
}

// 셀의 각각의 크기
extension StudyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: 350, height: 247)
    
  }
}

// MARK: - 스크롤할 때 네트워킹 요청
extension StudyViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height)){
      
      if isInfiniteScroll {
        isInfiniteScroll = false
        
        fetchMoreData(hotType: searchType)
      }
    }
  }
}

extension StudyViewController: AfterCreatePost {
  func afterCreatePost(postId: Int) {
    let postedVC = PostedStudyViewController()
    detailPostDataManager.searchSinglePostData(postId: postId, loginStatus: false) {
      let postData = self.detailPostDataManager.getPostDetailData()
      postedVC.postedData = postData
    }
    navigationController?.pushViewController(postedVC, animated: false)
    
    showToast(message: "글 작성이 완료됐어요",imageCheck: true, alertCheck: true)
  }
}

// MARK: - 북마크 관련
extension StudyViewController: BookMarkDelegate {
  func bookmarkTapped(postId: Int, userId: Int) {
    self.bookmarkButtonTapped(postId,userId) { 
      //      self.resultCollectionView.reloadData()
    }
  }
}

extension StudyViewController: CheckLoginDelegate {
  func checkLoginPopup(checkUser: Bool) {
    checkLoginStatus(checkUser: checkUser)
  }
}
