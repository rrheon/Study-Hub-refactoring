
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 전체 스터디 VC
final class StudyViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: StudyViewModel = StudyViewModel.shared
  
  /// 스터디 게시글 전체 버튼 - 최신 순
  private lazy var recentButton = createButton(
    title: "   전체   ",
    titleColor: .white,
    backgroundColor: .black
  )
  
  /// 스터디 게시글 인기 버튼 - 인기 순
  private lazy var popularButton = createButton(
    title: "   인기   ",
    titleColor: .bg90,
    backgroundColor: .bg30
  )
    
  
  /// 스터디가 없을 때 이미지
  private lazy var emptyImageView = UIImageView(image: UIImage(named: "EmptyStudy"))
  
  /// 스터디가 없을 때 라벨
  private lazy var describeLabel = UILabel().then {
    $0.text = "관련 스터디가 없어요\n지금 스터디를 만들어\n  팀원을 구해보세요!"
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 12)
  }
  
  /// 스터디 collectionView
  private lazy var resultCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 20
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    
    return view
  }()
  
  private let scrollView: UIScrollView =  UIScrollView().then {
    $0.backgroundColor = .bg30
  }
  
  /// 스터디 생성버튼
  private lazy var addButton: UIButton = UIButton().then {
    $0.setTitle("+", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = UIColor(hexCode: "FF5935")
    $0.layer.cornerRadius = 30
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
  }
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  /// view가 나타날 때 데이터 다시 가져오기
  override func viewWillAppear(_ animated: Bool) {
//    Task {
//      do {
//        print(#fileID, #function, #line," - 호출")
//
//        await viewModel.fetchPostData(hotType: "false")
//      }
//    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setupNavigationbar()
    setupCollectionView()
    
    setupBinding()
    setupActions()
  } // viewDidLoad

  // MARK: - setupLayout
  
  /// layout  설정
  func setupLayout(_ count: Int){
    if count > 0 {
      scrollView.addSubview(resultCollectionView)
      [ recentButton, popularButton, scrollView, addButton]
        .forEach { view.addSubview($0) }
    }else {
      [ recentButton, popularButton, emptyImageView, describeLabel, addButton]
        .forEach { view.addSubview($0) }
    }
  }
  
  // MARK: - makeUI
  
  /// UI 설정
  func makeUI(_ count: Int){
    recentButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
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
    
    if count > 0 {
      resultCollectionView.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(scrollView.snp.height)
      }
      
      scrollView.snp.makeConstraints { make in
        make.top.equalTo(recentButton.snp.bottom).offset(20)
        make.leading.trailing.bottom.equalTo(view)
      }
      
      addButton.snp.makeConstraints { make in
        make.width.height.equalTo(60)
        make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        make.trailing.equalTo(view).offset(-16)
      }
    } else {
      emptyImageView.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-50)
      }
      
      describeLabel.numberOfLines = 3
      describeLabel.changeColor(
        wantToChange: "지금 스터디를 만들어\n  팀원을 구해보세요!",
        color: .changeInfo
      )
      
      describeLabel.snp.makeConstraints { make in
        make.top.equalTo(emptyImageView.snp.bottom).offset(10)
        make.centerX.equalTo(emptyImageView)
      }
      
      addButton.snp.makeConstraints { make in
        make.width.height.equalTo(60)
        make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        make.trailing.equalTo(view).offset(-16)
      }
    }
  }
  
  /// collectinoView 설정
  func setupCollectionView(){    
    resultCollectionView.delegate = self
    resultCollectionView.register(
      SearchResultCell.self,
      forCellWithReuseIdentifier: SearchResultCell.cellID
    )
  }
  
  /// 버튼 생성하기 - 최신순, 인기순
  /// - Parameters:
  ///   - title: 버튼 제목
  ///   - titleColor: 버튼 제목색상
  ///   - backgroundColor: 버튼 배경색
  func createButton(title: String, titleColor: UIColor, backgroundColor: UIColor) -> UIButton{
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    button.backgroundColor = backgroundColor
    button.layer.cornerRadius = 15
    
    return button
  }
  
  // MARK: -  setupNavigationbar

  /// 네비게이션 바 세팅
  func setupNavigationbar(){
    leftButtonSetting(imgName: "StudyImg", activate: false)
    rightButtonSetting(imgName: "SearchImg_White")
    
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  /// 네비게이션 바 오른쪽 아이템 터치 - 검색화면으로 이동
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(StudyStep.enterSearchIsRequired)
  }

  
  // MARK: -  setupBinding
  
  /// 바인딩
  func setupBinding(){
    /// 포스트 갯수
    viewModel.postCount
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self,0))
      .drive(onNext: { (vc, count) in
        vc.setupLayout(count)
        vc.makeUI(count)
      }).disposed(by: disposeBag)
    
    /// 스터디 데이터 - 셀에 바인딩
    viewModel.postDatas
      .asDriver(onErrorJustReturn: [])
      .drive(resultCollectionView.rx.items(
        cellIdentifier: SearchResultCell.cellID,
        cellType: SearchResultCell.self)) { index, content, cell in
          cell.cellData = content
        }
        .disposed(by: disposeBag)
  }
  
  // MARK: -  setupActions
  
  /// Actinos 설정
  func setupActions(){
    /// 스터디 셀 터치 시 - 스터디 상세 화면으로 이동
    resultCollectionView.rx.modelSelected(PostData.self)
      .withUnretained(self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { (_, item) in
        let postID = item.postID
        
        NotificationCenter.default.post(name: .navToStudyDetailScrenn,
                                        object: nil,
                                        userInfo: ["postID" : postID])
        
      })
      .disposed(by: disposeBag)
    
    /// 최신버튼 탭
    recentButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (vc, _) in
        vc.viewModel.recentOrPopularBtnTapped(btnType: "false")
        vc.updateButtonUI(selectedButton: vc.recentButton, unselectedButton: vc.popularButton)
        vc.resultCollectionView.setContentOffset(.zero, animated: false)
      })
      .disposed(by: disposeBag)
    
    /// 인기버튼 탭
    popularButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: {  (vc, _) in
        vc.viewModel.recentOrPopularBtnTapped(btnType: "true")
        vc.updateButtonUI(selectedButton: vc.popularButton, unselectedButton: vc.recentButton)
        vc.resultCollectionView.setContentOffset(.zero, animated: false)
      })
      .disposed(by: disposeBag)
    
    /// 게시글 생성 버튼 탭
    addButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { (_, _) in
        NotificationCenter.default.post(name: .navToCreateOrModifyScreen,
                                        object: nil,
                                        userInfo: ["postID" : nil])
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - recent / popular button tap
  
  /// 최신 / 인기 버튼 터치 시
  /// - Parameters:
  ///   - selectedButton: 선택된 버튼
  ///   - unselectedButton: 다른 버튼
  func updateButtonUI(selectedButton: UIButton, unselectedButton: UIButton) {
    selectedButton.setTitleColor(.white, for: .normal)
    selectedButton.backgroundColor = .black
    
    unselectedButton.setTitleColor(.bg90, for: .normal)
    unselectedButton.backgroundColor = .bg30
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
  
  func fetchMoreData(hotType: String) {
    self.waitingNetworking()
//    viewModel.fetchPostData(hotType: hotType, page: viewModel.counter, size: 5)
    activityIndicator.stopAnimating()
  }
}

// MARK: - collectionView

extension StudyViewController: UICollectionViewDelegate {
  // MARK: - 스크롤할 때 네트워킹 요청
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let scrollViewHeight = scrollView.frame.size.height
    let contentHeight = scrollView.contentSize.height
    let offsetY = scrollView.contentOffset.y
    
    // 바닥에서 50포인트 위에 도달했는지 체크
    if offsetY + scrollViewHeight >= contentHeight - 50 && viewModel.isInfiniteScroll == false {
      print("바닥에서 50포인트 위에 도달! \(recentButton.isSelected)")
      
      Task {
        await viewModel.fetchPostData(hotType: "false")
      }
    }
  }
}

// 셀의 각각의 크기
extension StudyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 350, height: 240)
  }
}
