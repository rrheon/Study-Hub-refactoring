
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: CommonNavi {
  var viewModel: SearchViewModel
    
  // MARK: - 서치바
  private let searchBar = UISearchBar.createSearchBar(placeholder: "스터디와 관련된 학과를 입력해주세요")
  
  private lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    tableView.separatorInset.left = 0
    tableView.layer.cornerRadius = 10
    return tableView
  }()
  
  // MARK: - 서치바에서 검색할 때
  private lazy var allButton = createSearchViewButton(
    title: "제목",
    titleColor: .white,
    backgorundColor: .black
  )

  private lazy var popularButton = createSearchViewButton(title: "인기")
  private lazy var majorButton = createSearchViewButton(title: "학과")

  private lazy var emptyImage = UIImage(named: "EmptyStudy")
  private lazy var emptyImageView = UIImageView(image: emptyImage)
  
  private lazy var emptyLabel = createLabel(
    title: "관련 스터디가 없어요\n지금 스터디를 만들어보세요!",
    textColor: .bg60,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
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
  
  init(_ data: SearchViewData) {
    self.viewModel = SearchViewModel(data)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    viewModel.isNeedFetchToHomeVC?.accept(true)
  }
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupDelegate()
    setupNavigationbar()
  
    redesignSearchBar()
    
    self.setUpLayout()
    self.makeUI()
    
    setupBinding()
    setupActions()
  }
  
  func makeUI() {
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
  
  func setupDelegate(){
    searchBar.delegate = self
    
    resultCollectionView.delegate = self
    resultCollectionView.register(
      SearchResultCell.self,
      forCellWithReuseIdentifier: SearchResultCell.id
    )
    
    resultTableView.delegate = self
    resultTableView.register(
      CustomCell.self,
      forCellReuseIdentifier: CustomCell.cellId
    )
  }
  
  func createSearchViewButton(
    title: String,
    titleColor: UIColor = .bg90,
    backgorundColor: UIColor = .bg30
  ) -> UIButton{
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    button.backgroundColor = backgorundColor
    button.layer.cornerRadius = 20
    
    return button
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
  func setupNavigationbar(){
    leftButtonSetting()
    rightButtonSetting(imgName: "BookMarkImg")
    
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    let data = BookMarkData(
      loginStatus: viewModel.isUserLogin,
      isNeedFetch: viewModel.isNeedFetchToSearchVC
    )
    moveToBookmarkView(sender, data: data)
  }
  
  // MARK: - setupBinding
  
  func setupBinding(){
    viewModel.isNeedFetchToSearchVC
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: { [weak self] _ in
        guard let keyword = self?.viewModel.searchKeyword else { return }
        self?.keyWordTapped(keyword: keyword)
      })
      .disposed(by: viewModel.disposeBag)
   
    viewModel.recommendList
      .asDriver(onErrorJustReturn: [])
      .drive(resultTableView.rx.items(
        cellIdentifier: CustomCell.cellId,
        cellType: CustomCell.self)) { index, content, cell in
          cell.model = content
          cell.setupImage()
        }
        .disposed(by: viewModel.disposeBag)
    
    viewModel.recommendList
      .subscribe(onNext: { [weak self] in
        self?.noSearchDataUI(count: $0.count)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.postDatas
      .asDriver(onErrorJustReturn: [])
      .drive(resultCollectionView.rx.items(
        cellIdentifier: SearchResultCell.id,
        cellType: SearchResultCell.self)) { index, content, cell in
          cell.delegate = self
          cell.model = content
          cell.loginStatus = self.viewModel.isUserLogin
        }
        .disposed(by: viewModel.disposeBag)
    
    viewModel.postDatas
      .subscribe(onNext: { [ weak self]  _ in
        self?.updateUI()
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - setupActions
  
  func setupActions(){
    resultTableView.rx.modelSelected(String.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        self?.keyWordTapped(keyword: item)
      })
      .disposed(by: viewModel.disposeBag)
    
    resultCollectionView.rx.modelSelected(Content.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        self?.viewModel.fetchSinglePostDatas(item.postID) { result in
          let postData = PostedStudyData(
            isUserLogin: self?.viewModel.isUserLogin ?? false,
            postDetailData: result,
            isNeedFechData: self?.viewModel.isNeedFetchToSearchVC
          )
          
          let postedVC = PostedStudyViewController(postData)
          postedVC.hidesBottomBarWhenPushed = true
          self?.navigationController?.pushViewController(postedVC, animated: true)
        }
      })
      .disposed(by: viewModel.disposeBag)
    
    allButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.allButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
    
    popularButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.popularButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
    
    majorButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.majorButtonTapped()
      })
      .disposed(by: viewModel.disposeBag)
  }

  func buttonTapped(hot: String, titleAndMajor: String){
    resultCollectionView.setContentOffset(CGPoint.zero, animated: false)
    
    let data = RequestPostData(
      hot: hot,
      text: self.viewModel.searchKeyword ?? "",
      page: 0,
      size: 5,
      titleAndMajor: titleAndMajor
    )
    viewModel.getPostData(data: data)
    
    self.resultCollectionView.isHidden = false
    
    noSearchDataUI(count: viewModel.numberOfCells)
  }
  
  
  // MARK: - 전체버튼 눌렸을 때
  func allButtonTapped() {
    updateButtonColors(
      selectedButton: allButton,
      deselectedButtons: [popularButton, majorButton]
    )
    
    buttonTapped(hot: "false", titleAndMajor: "true")
  }
  
  // MARK: - 인기버튼 눌렸을 때
  func popularButtonTapped() {
    updateButtonColors(
      selectedButton: popularButton,
      deselectedButtons: [allButton, majorButton]
    )
    
    buttonTapped(hot: "true", titleAndMajor: "true")
  }
  
  // MARK: - 학과버튼 눌렸을 때
  func majorButtonTapped() {
    updateButtonColors(
      selectedButton: majorButton,
      deselectedButtons: [allButton, popularButton]
    )
    
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
  
  
  // MARK: - 검색결과가 없을 때
  func noSearchDataUI(count: Int){
    if count == 0 {
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
  
  func keyWordTapped(keyword: String){
    viewModel.searchKeyword = keyword
    
    let data = RequestPostData(
      hot: "false",
      text: keyword,
      page: 0,
      size: 5,
      titleAndMajor: "true"
    )
    viewModel.getPostData(data: data)
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
    
    viewModel.searchRecommend(keyword: keyword)
  }
}

// MARK: - tableView cell 함수
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
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
extension SearchViewController: BookMarkDelegate {}
extension SearchViewController: CheckLoginDelegate {}

extension SearchViewController {
  // MARK: - 네트워킹 기다릴 때
   func waitingNetworking(){
     view.addSubview(activityIndicator)
     
     activityIndicator.snp.makeConstraints {
       $0.centerX.centerY.equalToSuperview()
     }
     
     activityIndicator.startAnimating()
   }

   // MARK: - 스크롤해서 네트워킹
  func fetchMoreData(hotType: String, titleAndMajor: String){
//    addPageCount { pageCount in
//      self.waitingNetworking()
//      
//      self.postDataManager.getPostData(hot: "false",
//                                       text: self.searchKeyword,
//                                       page: pageCount,
//                                       size: 5,
//                                       titleAndMajor: titleAndMajor,
//                                       loginStatus: false) { PostDataContent in
//        
//        self.totalDatas?.append(contentsOf: PostDataContent.postDataByInquiries.content)
//        
//        DispatchQueue.main.async {
//          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.removeFromSuperview()
//            
//            self.updateCollectionViewHeight()
//            self.resultCollectionView.reloadData()
//            self.isInfiniteScroll = true
//          }
//        }
//      }
//    }
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
    let numberOfCells = viewModel.numberOfCells
    let newHeight = CGFloat(numberOfCells) * cellHeight + CGFloat(numberOfCells - 1) * spacing
    
    return newHeight
  }
}

extension SearchViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height)){
      
      if viewModel.isInfiniteScroll {
        viewModel.isInfiniteScroll = false
        
        fetchMoreData(hotType: "false", titleAndMajor: "true")
      }
    }
  }
}

extension SearchViewController: MoveToBookmarkView {}
