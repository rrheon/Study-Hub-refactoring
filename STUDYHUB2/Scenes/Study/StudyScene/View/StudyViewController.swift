
import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class StudyViewController: UIViewController {
  
  let disposeBag: DisposeBag = DisposeBag()
  let viewModel: StudyViewModel = StudyViewModel.shared
  
  private lazy var recentButton = createButton(
    title: "   전체   ",
    titleColor: .white,
    backgroundColor: .black
  )
  
  private lazy var popularButton = createButton(
    title: "   인기   ",
    titleColor: .bg90,
    backgroundColor: .bg30
  )
    
  private lazy var emptyImage = UIImage(named: "EmptyStudy")
  private lazy var emptyImageView = UIImageView(image: emptyImage)
  
  private lazy var describeLabel = createLabel(
    title: "관련 스터디가 없어요\n지금 스터디를 만들어\n  팀원을 구해보세요!",
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 12
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
    scrollView.backgroundColor = .bg30
    return scrollView
  }()
  
  private lazy var addButton: UIButton = {
    let addButton = UIButton(type: .system)
    addButton.setTitle("+", for: .normal)
    addButton.setTitleColor(.white, for: .normal)
    addButton.backgroundColor = UIColor(hexCode: "FF5935")
    addButton.layer.cornerRadius = 30
    addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    return addButton
  }()
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    
//    setupNavigationbar()
    setupCollectionView()
    
    setupBinding()
    setupActions()
  }

  // MARK: - setupLayout
  
  func setupLayout(_ count: Int){
    if count > 0 {
      scrollView.addSubview(resultCollectionView)
      
      [
        recentButton,
        popularButton,
        scrollView,
        addButton
      ].forEach {
        view.addSubview($0)
      }
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
  
  // MARK: - makeUI
  
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
        make.bottom.equalTo(view.snp.bottom).offset(-100)
        make.trailing.equalTo(view.snp.trailing).offset(-30)
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
  
  func setupCollectionView(){
    resultCollectionView.delegate = self
    resultCollectionView.register(
      SearchResultCell.self,
      forCellWithReuseIdentifier: SearchResultCell.cellID
    )
  }
  
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
//  
//  func setupNavigationbar(){
//    leftButtonSetting(imgName: "StudyImg", activate: false)
//    rightButtonSetting(imgName: "SearchImg_White")
//    
//    self.navigationController?.navigationBar.isTranslucent = false
//  }
//  
//  override func rightButtonTapped(_ sender: UIBarButtonItem) {
//    let data = SearchViewData(
//      isUserLogin: viewModel.checkLoginStatus.value,
//      isNeedFechData: viewModel.isNeedFetch
//    )
//    let searchVC = SearchViewController(data)
//    searchVC.hidesBottomBarWhenPushed = true
//    navigationController?.pushViewController(searchVC, animated: true)
//  }
  
  // MARK: -  setupBinding
  
  func setupBinding(){
    viewModel.postCount
      .asDriver(onErrorJustReturn: 0)
      .drive(onNext: { [weak self] in
        self?.setupLayout($0)
        self?.makeUI($0)
      })
      .disposed(by: disposeBag)
    
    viewModel.postDatas
      .asDriver(onErrorJustReturn: [])
      .drive(resultCollectionView.rx.items(
        cellIdentifier: SearchResultCell.cellID,
        cellType: SearchResultCell.self)) { index, content, cell in
          cell.model = content
          cell.loginStatus = self.viewModel.checkLoginStatus.value
        }
        .disposed(by: disposeBag)
    
    viewModel.isNeedFetch
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] _ in
        guard let count = self?.viewModel.postCounts,
        let type = self?.viewModel.searchType else { return }
        self?.viewModel.fetchPostData(hotType: type, page: 0, size: count, dataUpdate: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.postData
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: { [weak self] postData in
        self?.recentButtonTapped()
        guard let data = postData else { return }
        let postedData = PostedStudyData(isUserLogin: true, postDetailData: data)
        self?.moveToOtherVCWithSameNavi(vc: PostedStudyViewController(postedData), hideTabbar: true)
        
        self?.showToast(message: "글 작성이 완료됐어요", imageCheck: true, alertCheck: true)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: -  setupActions
  
  func setupActions(){
    resultCollectionView.rx.modelSelected(Content.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        guard let loginStauts = self?.viewModel.checkLoginStatus.value else { return }
//        self?.viewModel.detailPostDataManager.searchSinglePostData(
//          postId: item.postID,
//          loginStatus: loginStauts,
//          completion: { result  in
//            let postData = PostedStudyData(
//              isUserLogin: loginStauts,
//              postDetailData: result,
//              isNeedFechData: self?.viewModel.isNeedFetch
//            )
//            
//            let postedVC = PostedStudyViewController(postData)
//            postedVC.hidesBottomBarWhenPushed = true
//            self?.navigationController?.pushViewController(postedVC, animated: true)
//          })
      })
      .disposed(by: disposeBag)
    
    recentButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.recentButtonTapped()
      })
      .disposed(by: disposeBag)
    
    popularButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.popularButtonTapped()
      })
      .disposed(by: disposeBag)
    
    addButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
    
        let loginStatus = viewModel.checkLoginStatus.value
        switch loginStatus {
        case true:
          moveToOtherVCWithSameNavi(
            vc: CreateStudyViewController(postedData: viewModel.postData, mode: .POST),
            hideTabbar: true
          )
        case false: break
//          checkLoginPopup(checkUser: viewModel.checkLoginStatus.value)
        }
      })
      .disposed(by: disposeBag)
  }
  
  func studyTapBarTapped(){
    viewModel.isNeedFetch.accept(true)
  }
  
  // MARK: - recent / popular button tap
  
  func updateButtonUI(selectedButton: UIButton, unselectedButton: UIButton) {
    selectedButton.setTitleColor(.white, for: .normal)
    selectedButton.backgroundColor = .black
    
    unselectedButton.setTitleColor(.bg90, for: .normal)
    unselectedButton.backgroundColor = .bg30
  }
  
  func resetViewModelAndFetchData(hotType: String) {
    viewModel.resetCounter()
    viewModel.isLastData = false
    viewModel.isInfiniteScroll = true
    
    resultCollectionView.setContentOffset(.zero, animated: false)
    viewModel.fetchPostData(hotType: hotType, dataUpdate: true)
  }
  
  @objc func recentButtonTapped() {
    resetViewModelAndFetchData(hotType: "false")
    updateButtonUI(selectedButton: recentButton, unselectedButton: popularButton)
  }
  
  @objc func popularButtonTapped() {
    resetViewModelAndFetchData(hotType: "true")
    updateButtonUI(selectedButton: popularButton, unselectedButton: recentButton)
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
    viewModel.fetchPostData(hotType: hotType, page: viewModel.counter, size: 5)
    activityIndicator.stopAnimating()
  }
}

// MARK: - collectionView

extension StudyViewController: UICollectionViewDelegate {
  // MARK: - 스크롤할 때 네트워킹 요청
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height) {
      if viewModel.isInfiniteScroll && viewModel.isLastData != true {
        viewModel.isInfiniteScroll = false
        fetchMoreData(hotType: viewModel.searchType)
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
    return CGSize(width: 350, height: 247)
  }
}

extension StudyViewController: CreateUIprotocol {}
