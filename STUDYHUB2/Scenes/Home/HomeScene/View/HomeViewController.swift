
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/*
 셀 터치 시 상세 스터디 페이지로 이동
 북마크 가능하게 수정
 무한스크롤 구현 - 북마크, 검색
 */
/// 홈 VC - 메인
final class HomeViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  var viewModel: HomeViewModel = HomeViewModel.shared
  
  // MARK: - 화면구성

  /// 메인 이미지 - 알아보기 버튼의 배경 이미지
  private let mainImageView: UIImageView =  UIImageView().then{
    $0.image = UIImage(named: "MainImg")
    $0.clipsToBounds = true
  }
  
  
  /// 알아보기 버튼
  let detailsButton = StudyHubButton(title: "알아보기", radious: 5)

  /// 검색서치바
  private lazy var searchBar = UISearchBar.createSearchBar(placeholder: "스터디와 관련된 학과를 입력해주세요")
  
  
  /// 새로 모집중인 스터디 라벨
  private lazy var newStudyLabel = createHomeLabel(title: "NEW! 모집 중인 스터디예요", changeLength: 4)

  /// 전체 스터디 버튼
  private lazy var allButton: UIButton = UIButton().then {
    $0.semanticContentAttribute = .forceLeftToRight
    $0.contentHorizontalAlignment = .left
    $0.setTitle("전체", for: .normal)
    $0.setTitleColor(UIColor.g60, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    $0.setImage(UIImage(named: "RightArrow"), for: .normal)
    
    let spacing: CGFloat = 8
    
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing, bottom: 0, right: 0)
  }

  
  // MARK: - collectionview
  
  /// 모집중인 스터디 collectionview
  private lazy var recrutingCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var newStudyTopStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  private lazy var newStudyTotalStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
  
  // MARK: - 마감이 입박한 스터디
  
  /// 마감이 임박한 스터디 이미지
  private let deadLineImg: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "FireImg")
    $0.contentMode = .scaleAspectFit
    $0.tintColor = UIColor(hexCode: "FF5935")
  }
  
  /// 마감이 임박한 스터디 라벨
  private lazy var deadLineLabel = createHomeLabel(title: "마감이 임박한 스터디예요", changeLength: 2)

  /// 마감이 임박한 스터디 컬렉션 뷰
  private lazy var deadLineCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var deadLineStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  private lazy var totalStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  
  /// 뷰가 나타날 때 데이터 불러오기
  override func viewWillAppear(_ animated: Bool) {
//    viewModel.isNeedFetchDatas.accept(true)
  }
  
  // MARK: -  viewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .backgroundBlack

//    Task {
//      do {
//        async let newPostData: () = viewModel.fetchNewPostDatas()
//        async let deadLinePostData: () = viewModel.fetchDeadLinePostDatas()
//      
//        await newPostData
//        await deadLinePostData
//      }
//    }
    
    setupBindings()
    setupCollectionView()
    setupActions()
   
    setUpLayout()
    makeUI()
    
    setupNavigationbar()
    redesignSearchBar()

  } // viewDidLoad
  
  
  // MARK: - setuplayout
  
  /// layout 설정
  func setUpLayout(){
    scrollView.addSubview(mainImageView)
    scrollView.addSubview(detailsButton)

    /// 새로운 스터디
    [ newStudyLabel, allButton ]
      .forEach { newStudyTopStackView.addArrangedSubview($0) }
    
    [ newStudyTopStackView, UIView(), recrutingCollectionView ]
      .forEach { newStudyTotalStackView.addArrangedSubview($0) }
    
    /// 마감이 임박한 스터디의 라벨
    [deadLineImg,deadLineLabel, UIView()]
      .forEach { deadLineStackView.addArrangedSubview($0) }
    
    /// vc전체 UI
    [ UIView(), searchBar, newStudyTotalStackView, deadLineStackView, deadLineCollectionView]
      .forEach { totalStackView.addArrangedSubview($0) }
    
    scrollView.addSubview(totalStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  
  /// UI설정
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
  
  
  /// 라벨 생성 - 모집중인 스터디, 마감 직전 스터디
  /// - Parameters:
  ///   - title: 타이틀
  ///   - changeLength: 색 변경할 범위
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
  
  // MARK: - 네비게이션바 설정
  
  /// 네비게이션 바 세팅
  func setupNavigationbar(){
    leftButtonSetting(imgName: "LogoImage", activate: false)
    rightButtonSetting(imgName: "BookMarkImg")
    settingNavigationbar()
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  
  // MARK: -  북마크 버튼 탭
  
  /// 네비게이션 바 오른쪽 버튼 탭 - 북마크 화면으로 이동
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    NotificationCenter.default.post(name: .navToBookmarkScreen, object: nil)
  }
  
  /// collectionView 설정
  private func setupCollectionView() {
    recrutingCollectionView.tag = 1
    deadLineCollectionView.tag = 2
    
    recrutingCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    deadLineCollectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    recrutingCollectionView.register(
      RecruitPostCell.self,
      forCellWithReuseIdentifier: RecruitPostCell.cellID
    )
    
    deadLineCollectionView.register(
      DeadLineCell.self,
      forCellWithReuseIdentifier: DeadLineCell.cellID
    )
    
    recrutingCollectionView.showsHorizontalScrollIndicator = false
    
  }
  
  /// 바인딩
  func setupBindings(){
    /// 새로운 포스트 -> 새로 모집중인 collectionview
    viewModel.newPostDatas
      .asDriver(onErrorJustReturn: [])
      .drive(recrutingCollectionView.rx.items(
        cellIdentifier: RecruitPostCell.cellID,
        cellType: RecruitPostCell.self)) { index, content, cell in
          cell.model = content
          cell.loginStatus = self.viewModel.checkLoginStatus.value
        }
        .disposed(by: disposeBag)
    
    /// 마감이 임박한 스터디 -> 마감이 임박한 collectionview
    viewModel.deadlinePostDatas
      .asDriver(onErrorJustReturn: [])
      .map { Array($0.prefix(4)) }
      .drive(deadLineCollectionView.rx.items(
        cellIdentifier: DeadLineCell.cellID,
        cellType: DeadLineCell.self)) { index, content, cell in
          cell.model = content
          cell.loginStatus = self.viewModel.checkLoginStatus.value
        }
        .disposed(by: disposeBag)
    
    // 새로운 데이터가 필요한 경우
    viewModel.isNeedFetchDatas
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, false))
      .drive(onNext: { vc, isNeedFecthDatas in
        if isNeedFecthDatas {
          Task {
            await vc.viewModel.fetchNewPostDatas()
            await vc.viewModel.fetchDeadLinePostDatas()
          }
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// Actions 설정
  func setupActions(){
    /// 새로 모집중인 스터디 셀 터치 시
    recrutingCollectionView.rx.modelSelected(PostData.self)
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .withUnretained(self)
        .subscribe(onNext: { (vc, item) in
            let postID = item.postID
#warning("스터디 상세 화면으로 이동")
          NotificationCenter.default.post(name: .navToStudyDetailScrenn,
                                          object: nil,
                                          userInfo: ["postID" : postID]
          )

        })
        .disposed(by: disposeBag)

    /// 마감이 임박한 스터디 셀 터치 시

    deadLineCollectionView.rx.modelSelected(PostData.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { (vc, item) in
        let postID = item.postID
        NotificationCenter.default.post(name: .navToStudyDetailScrenn,
                                        object: nil,
                                        userInfo: ["postID" : postID]
        )
      })
      .disposed(by: disposeBag)
    
    /// 알아보기 버튼 터치 시
    detailsButton.rx.tap
      .withUnretained(self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { vc, _ in
#warning("알아보기 화면으로 이동")
        NotificationCenter.default.post(name: .navToHowToUseScreen, object: nil)

      })
      .disposed(by: disposeBag)
    
    /// 전체보기 버튼 터치시
    allButton.rx.tap
      .subscribe(onNext: { [weak self] in
        if let tabBarController = self?.tabBarController {
          tabBarController.selectedIndex = 1
        }
#warning("스터디 화면으로 이동")

      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - 서치바 재설정
  
  /// 서치바 설정
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
  /// 서치바 터치 시 검색 화면으로 이동
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    viewModel.steps.accept(HomeStep.enterSearchIsRequired)
    return false
  }
}

/// 스터디 셀 크기 - 최근 등록된 스터디, 마감이 임박한 스터디
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
