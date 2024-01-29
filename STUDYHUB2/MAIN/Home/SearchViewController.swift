import UIKit

import SnapKit
import Moya

final class SearchViewController: NaviHelper {
  // MARK: - 화면구성, tapbar도 같이 나오게 수정해야함
  let detailPostDataManager = PostDetailInfoManager.shared
  let postDataManager = PostDataManager.shared
  var keyword: String?
  var recommendData: RecommendList?
  var searchResultData: PostDataContent? {
    didSet{
      countLabel.text = "\(searchResultData?.totalCount ?? 0)개"
    }
  }
  
  init(keyword: String? = nil) {
    self.keyword = keyword
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
    button.setTitle("전체", for: .normal)
    button.setTitleColor(.bg90, for: .normal)
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
      self.majroButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var countLabel = createLabel(title: "4개",
                                            textColor: .bg80,
                                            fontType: "Pretendard-Medium",
                                            fontSize: 14)
  
  private lazy var resultCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    
    return view
  }()
  
  private lazy var divideLine = createDividerLine(height: 1)
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .white
    return scrollView
  }()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    redesignNavigationbar()
    
    redesignSearchBar()
    
    setUpLayout()
    makeUI()
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
  
  @objc func bookmarkpageButtonTapped() {
    let bookmarkViewController = BookmarkViewController(postID: 0)
    let navigationController = UINavigationController(rootViewController: bookmarkViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true, completion: nil)
  }
  
  // MARK: - 전체버튼 눌렸을 때
  func allButtonTapped(){
    print("1")
    allButton.setTitleColor(.black, for: .normal)
    popularButton.setTitleColor(.bg70, for: .normal)
    
  }
  
  // MARK: - 인기버튼 눌렸을 때
  func popularButtonTapped(){
    print("2")
    allButton.setTitleColor(.bg70, for: .normal)
    popularButton.setTitleColor(.black, for: .normal)
  }
  
  // MARK: - 학과버튼 눌렸을 때
  func majroButtonTapped(){
    print("2")
    allButton.setTitleColor(.bg70, for: .normal)
    popularButton.setTitleColor(.black, for: .normal)
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
  
  // MARK: - 검색 후 추천어를 눌렀을 때
  func updateUI(){
    resultTableView.isHidden = true
    
    navigationItem.rightBarButtonItems = .none
    
    navigationController?.navigationBar.topItem?.title = "검색결과"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

    [
      allButton,
      popularButton,
      majorButton,
      countLabel,
      divideLine,
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
    
    countLabel.snp.makeConstraints { make in
      make.centerY.equalTo(allButton)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    divideLine.backgroundColor = .bg30
    divideLine.snp.makeConstraints { make in
      make.top.equalTo(allButton.snp.bottom).offset(10)
      make.leading.trailing.equalTo(searchBar)
    }
    
    resultCollectionView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(scrollView.snp.height)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(divideLine.snp.bottom).offset(10)
      make.leading.trailing.bottom.equalTo(view)
    }
  }
}

// MARK: - 서치바 함수
extension SearchViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을 때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    
    searchRecommend(keyword: keyword) {
      print("검색완료")
    }
  }
  
}

// MARK: - tableView cell 함수
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recommendData?.recommendList.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    
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
    postDataManager.getPostData(hot: "true",
                                text: keyword,
                                page: 0,
                                size: 5,
                                titleAndMajor: "true") { result in
      self.searchResultData = result
      self.updateUI()
    }
   
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
    return searchResultData?.totalCount ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let postID = searchResultData?.postDataByInquiries.content[indexPath.row].postID else { return }
    let postedVC = PostedStudyViewController(postID: postID)
    postedVC.hidesBottomBarWhenPushed = true
    
    detailPostDataManager.searchSinglePostData(postId: postID) {
      let cellData = self.detailPostDataManager.getPostDetailData()
      postedVC.postedData = cellData
    }
  
    self.navigationController?.pushViewController(postedVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath) as! SearchResultCell
    cell.model = searchResultData?.postDataByInquiries.content[indexPath.row]
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

