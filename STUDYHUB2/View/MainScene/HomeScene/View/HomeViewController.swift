
import UIKit

import SnapKit
import RxSwift
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

  private lazy var searchBar = createSearchBar(placeholder: "스터디와 관련된 학과를 입력해주세요")
  
  private lazy var newStudyLabel = createHomeLabel(
    title: "NEW! 모집 중인 스터디예요",
    changeLength: 4
  )

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
  private lazy var totalStackView = createStackView(axis: .vertical, spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  override init(_ loginStatus: Bool) {
    self.viewModel = HomeViewModel(loginStatus: loginStatus)
    super.init(true)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: -  viewDidLoad
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    commonNetworking.delegate = self
    
    setupBindings()
    setupCollectionView()
    setupActions()
   
    setUpLayout()
    makeUI()
    
    redesignNavigationbar()
    redesignSearchBar()

  }
  
  func homeTapBarTapped(){
    viewModel.isNeedFetchDatas.accept(true)
  }
  
  // MARK: - setuplayout
  
  
  func setUpLayout(){
    scrollView.addSubview(mainImageView)
    scrollView.addSubview(detailsButton)

    [
      newStudyLabel,
      allButton
    ].forEach {
      newStudyTopStackView.addArrangedSubview($0)
    }
        
    [
      newStudyTopStackView,
      UIView(),
      recrutingCollectionView
    ].forEach {
      newStudyTotalStackView.addArrangedSubview($0)
    }
    
    
    [
      deadLineImg,
      deadLineLabel,
      UIView()
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
    searchBar.delegate = self
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
    attributedText.addAttribute(
      .foregroundColor,
      value: UIColor(hexCode: "FF5935"),
      range: NSRange(location: 0, length: changeLength)
    )
    newStudyLabel.attributedText = attributedText
    return newStudyLabel
  }
  
  // MARK: - 네비게이션바 재설정
  
  
  func redesignNavigationbar(){
    leftButtonSetting(imgName: "LogoImage", activate: false)
    rightButtonSetting(imgName: "BookMarkImg")
    
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  private func setupCollectionView() {
    recrutingCollectionView.tag = 1
    deadLineCollectionView.tag = 2
    
    recrutingCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    deadLineCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
    
    recrutingCollectionView.register(
      RecruitPostCell.self,
      forCellWithReuseIdentifier: RecruitPostCell.id
    )
    
    deadLineCollectionView.register(
      DeadLineCell.self,
      forCellWithReuseIdentifier: DeadLineCell.id
    )
  }
  
  func setupBindings(){
    viewModel.newPostDatas
      .asDriver(onErrorJustReturn: [])
      .map { Array($0.prefix(5)) }
      .drive(recrutingCollectionView.rx.items(
        cellIdentifier: RecruitPostCell.id,
        cellType: RecruitPostCell.self)) { index, content, cell in
          cell.model = content
          cell.delegate = self
          cell.loginStatus = self.viewModel.checkLoginStatus.value
        }
        .disposed(by: viewModel.disposeBag)
    
    viewModel.deadlinePostDatas
      .asDriver(onErrorJustReturn: [])
      .map { Array($0.prefix(4)) }
      .drive(deadLineCollectionView.rx.items(
        cellIdentifier: DeadLineCell.id,
        cellType: DeadLineCell.self)) { index, content, cell in
          cell.model = content
          cell.loginStatus = self.viewModel.checkLoginStatus.value
        }
        .disposed(by: viewModel.disposeBag)
    
    viewModel.singlePostData
      .subscribe(onNext: { [weak self] in
        self?.moveToPostedStudyVC(postData: $0)
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.isNeedFetchDatas
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: { [weak self] in
        if $0 == true{
          self?.viewModel.fetchNewPostDatas()
          self?.viewModel.fetchDeadLinePostDatas()
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    recrutingCollectionView.rx.modelSelected(Content.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        let postID = item.postID
        self?.viewModel.fectchSinglePostDatas(postID)
      })
      .disposed(by: viewModel.disposeBag)
    
    deadLineCollectionView.rx.modelSelected(Content.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        let postID = item.postID
        self?.viewModel.fectchSinglePostDatas(postID)
      })
      .disposed(by: viewModel.disposeBag)
    
    detailsButton.rx.tap
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: {[weak self] in
        guard let loginStatus = self?.viewModel.checkLoginStatus.value else { return }
        let detailsViewController = HowToUseViewController(loginStatus)
        detailsViewController.hidesBottomBarWhenPushed = true
        self?.navigationController?.pushViewController(detailsViewController, animated: true)
      })
      .disposed(by: viewModel.disposeBag)
    
    allButton.rx.tap
      .subscribe(onNext: { [weak self] in
        if let tabBarController = self?.tabBarController {
          tabBarController.selectedIndex = 1
        }
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func moveToPostedStudyVC(postData: PostDetailData){
    let postData = PostedStudyData(
      isUserLogin: viewModel.checkLoginStatus.value,
      postDetailData: postData,
      isNeedFechData: viewModel.isNeedFetchDatas
    )
    let postedStudyVC = PostedStudyViewController(postData)
    postedStudyVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(postedStudyVC, animated: true)
  }
  
  // MARK: -  북마크 버튼 탭
  
  override func rightButtonTapped(_ sender: UIBarButtonItem) {
    let data = BookMarkData(
      loginStatus: viewModel.checkLoginStatus.value,
      isNeedFetch: viewModel.isNeedFetchDatas
    )
    moveToBookmarkView(sender, data: data)
  }
  
  // MARK: - 서치바 재설정
  
  func redesignSearchBar(){
    searchBar.placeholder = "관심있는 스터디를 검색해 보세요"
    
    if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.backgroundColor = .bg30
      searchBarTextField.layer.borderColor = UIColor.clear.cgColor
    }
  }
}

// MARK: - 서치바 관련

extension HomeViewController: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    let searchViewdata = SearchViewData(
      isUserLogin: viewModel.checkLoginStatus.value,
      isNeedFechData: viewModel.isNeedFetchDatas
    )
    let searchViewController = SearchViewController(searchViewdata)
    searchViewController.hidesBottomBarWhenPushed = false
    self.navigationController?.pushViewController(searchViewController, animated: true)
    return false
  }
}

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

extension HomeViewController: MoveToBookmarkView {}
extension HomeViewController: CreateUIprotocol {}
extension HomeViewController: CheckLoginDelegate {}
extension HomeViewController: BookMarkDelegate {}
