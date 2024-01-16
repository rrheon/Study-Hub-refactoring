import UIKit

import SnapKit
import Moya

final class SearchViewController: NaviHelper {
  // MARK: - 화면구성, tapbar도 같이 나오게 수정해야함
  let detailPostDataManager = PostDetailInfoManager.shared
  var keyword: String?
  var recommendData: RecommendList?
  
  init(keyword: String? = nil) {
    self.keyword = keyword
    super.init()
    print(keyword)
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
  private lazy var recentButton: UIButton = {
    let button = UIButton()
    button.setTitle("최신순", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16)
    button.frame = CGRect(x: 0, y: 0, width: 57, height: 30)
    button.addTarget(self, action: #selector(recentButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  let separateLine = UIView()
  
  private lazy var popularButton: UIButton = {
    let button = UIButton()
    button.setTitle("인기순", for: .normal)
    button.setTitleColor(.bg70, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16)
    button.frame = CGRect(x: 0, y: 0, width: 57, height: 30)
    button.addTarget(self, action: #selector(popularButtonTapped), for: .touchUpInside)
    
    return button
  }()
  
  private lazy var countLabel = createLabel(title: "4개",
                                            textColor: .bg80,
                                            fontType: "Pretendard",
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
    
    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
  }
  
  func setUpLayout() {
    view.addSubview(searchBar)
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
    
    let alertBellImg = UIImage(named: "BellImgWithWhite")?.withRenderingMode(.alwaysOriginal)
    lazy var alertBell = UIBarButtonItem(
      image: alertBellImg,
      style: .plain,
      target: self,
      action: nil)
    alertBell.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    navigationItem.rightBarButtonItems = [alertBell, bookMark]
  }
  
  @objc func bookmarkpageButtonTapped() {
    let bookmarkViewController = BookmarkViewController(postID: 0)
    let navigationController = UINavigationController(rootViewController: bookmarkViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true, completion: nil)
  }
  
  @objc func recentButtonTapped(){
    print("1")
    recentButton.setTitleColor(.black, for: .normal)
    popularButton.setTitleColor(.bg70, for: .normal)
    
  }
  
  @objc func popularButtonTapped(){
    print("2")
    recentButton.setTitleColor(.bg70, for: .normal)
    popularButton.setTitleColor(.black, for: .normal)
  }
  
  // MARK: - 추천어 검색하기
  func searchRecommend(){
    guard let keyword = keyword else { return }
    print(keyword)
    let provider = MoyaProvider<networkingAPI>()
    provider.request(.recommendSearch(_keyword: keyword)) {
      switch $0 {
      case .success(let response):
        do {
          let recommendList = try JSONDecoder().decode(RecommendList.self, from: response.data)
          self.recommendData = recommendList
          print(recommendList)
        } catch {
          print("Failed to decode JSON: \(error)")
        }
        print(response.response)
      case .failure(let response):
        print(response.response)
      }
    }
  }
}

extension SearchViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을 때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    
    print(keyword)
    searchTapped(keyword: keyword)
    searchRecommend()
  }
  
  func searchTapped(keyword: String){
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    view.addSubview(resultTableView)
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(10)
      make.leading.trailing.equalTo(searchBar)
      make.bottom.equalTo(view).offset(-10)
    }
    
  }
}

// MARK: - tableView cell 함수
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    
    let imageView = UIImageView()
    cell.model = recommendData
    imageView.image = UIImage(named: "ScearchImgGray")
    cell.contentView.addSubview(imageView)
    
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalTo(cell.contentView)
    }
    
    cell.backgroundColor = .white
    
    return cell
  }
  
  // UITableViewDelegate 함수 (선택)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    resultTableView.isHidden = true
    
    navigationItem.rightBarButtonItems = .none
    
    navigationController?.navigationBar.topItem?.title = "검색결과"
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    
    view.addSubview(recentButton)
    view.addSubview(separateLine)
    view.addSubview(popularButton)
    view.addSubview(countLabel)
    view.addSubview(divideLine)
    view.addSubview(scrollView)
    
    scrollView.addSubview(resultCollectionView)
    
    recentButton.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom)
      make.leading.equalTo(searchBar.snp.leading).offset(10)
    }
    
    separateLine.backgroundColor = .bg50
    separateLine.snp.makeConstraints { make in
      make.top.equalTo(recentButton).offset(10)
      make.bottom.equalTo(recentButton.snp.bottom).offset(-10)
      make.leading.equalTo(recentButton.snp.trailing).offset(10)
      make.width.equalTo(1)
    }
    
    popularButton.snp.makeConstraints { make in
      make.top.equalTo(recentButton)
      make.leading.equalTo(separateLine.snp.trailing).offset(10)
    }
    
    countLabel.snp.makeConstraints { make in
      make.centerY.equalTo(recentButton)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    divideLine.backgroundColor = .bg30
    divideLine.snp.makeConstraints { make in
      make.top.equalTo(recentButton.snp.bottom).offset(10)
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
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    guard let postID = detailPostDataManager.getPostDetailData()?.postID else { return }
    let postedVC = PostedStudyViewController(postID: postID)
  
    self.navigationController?.pushViewController(postedVC, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath)

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

