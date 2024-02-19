import UIKit

import SnapKit

// searchResultCell이랑 같은 형식 , collectionview랑 추가버튼 같이 뜨게 수정해야함
final class StudyViewController: NaviHelper {
  let postDataManager = PostDataManager.shared
  let detailPostDataManager = PostDetailInfoManager.shared
  var recentDatas: PostDataContent?
  
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
    flowLayout.minimumLineSpacing = 10
    
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
      DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        self.setupLayout()
        self.makeUI()
      }
    }
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
        make.height.equalTo(1200)
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
    }else {
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
    print("아직")
  }
  
  @objc func addButtonTapped() {
    let createStudyVC = CreateStudyViewController()
    createStudyVC.hidesBottomBarWhenPushed = true
    createStudyVC.delegate = self
    navigationController?.pushViewController(createStudyVC, animated: true)
  }
  
  @objc func recentButtonTapped(){
    activityIndicator.startAnimating()
    
    postDataManager.getRecentPostDatas(hotType: "false") {
      self.recentDatas = self.postDataManager.getRecentPostDatas()
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
  
  @objc func popularButtonTapped(){
    postDataManager.getRecentPostDatas(hotType: "true") {
      self.recentDatas = self.postDataManager.getRecentPostDatas()
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
  
  // MARK: - 스크롤해서 네트워킹
  func fectMoreData(hotType: String){
    waitingNetworking()
    postDataManager.getRecentPostDatas(hotType: hotType,
                                       size: (recentDatas?.totalCount ?? 0) + 5) {
      self.recentDatas = self.postDataManager.getRecentPostDatas()
      DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        self.resultCollectionView.reloadData()
      }
    }
  }
}

// MARK: - collectionView
extension StudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    studyCount = recentDatas?.totalCount ?? 0
    return studyCount
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let postId = recentDatas?.postDataByInquiries.content[indexPath.row].postID else { return }
    print(postId)
    let postedVC = PostedStudyViewController(postID: postId)
    postedVC.hidesBottomBarWhenPushed = true
    postedVC.previousStudyVC = self
    
    loginManager.refreshAccessToken { loginStatus in
      self.detailPostDataManager.searchSinglePostData(postId: postId, loginStatus: loginStatus) {
        let cellData = self.detailPostDataManager.getPostDetailData()
        postedVC.postedData = cellData
      }
    }

    self.navigationController?.pushViewController(postedVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath)
    if let cell = cell as? SearchResultCell {
      let content = recentDatas?.postDataByInquiries.content[indexPath.row]
      
      cell.model = content
      cell.delegate = self
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
    if (resultCollectionView.contentOffset.y > (resultCollectionView.contentSize.height - resultCollectionView.bounds.size.height)){
      
      guard let last = recentDatas?.postDataByInquiries.last else { return }
      
      if !last {
        fectMoreData(hotType: "false")
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
