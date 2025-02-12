//
//  ResultSearchViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 검색결과 VC
class ResultSearchViewController: UIViewController {
  
  var viewModel: SearchViewModel
  let disposeBag: DisposeBag = DisposeBag()

  /// 서치바
  private lazy var searchBar = UISearchBar.createSearchBar(placeholder: "관심있는 스터디를 검색해 보세요")
  
  /// 검색결과 필터링 버튼 - 제목일치(기본값)
  private lazy var titleButton = createSearchViewButton(
    title: "제목",
    titleColor: .white,
    backgorundColor: .black
  )
  
  /// 검색결과 필터링 버튼 - 인기순
  private lazy var popularButton = createSearchViewButton(title: "인기")
  
  /// 검색결과 필터링 버튼 - 동일한 학과
  private lazy var majorButton = createSearchViewButton(title: "학과")

  /// 검색결과가 없을 때 이미지
  private lazy var emptyImageView = UIImageView(image: UIImage(named: "EmptyStudy"))
  
  /// 검색결과가 없을 때 라벨
  private lazy var emptyLabel = UILabel().then {
    $0.text = "관련 스터디가 없어요\n지금 스터디를 만들어보세요!"
    $0.textColor = .bg60
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 검색결과 collectionView
  private lazy var resultCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 20
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  /// 스크롤뷰
  private let scrollView: UIScrollView = UIScrollView().then({
    $0.backgroundColor = .white
  })
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  init(with viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    setupNavigationbar()
    setupSearchBar()
    
    setupDelegate()
    
    setupBinding()
    setupActions()
    
    makeUI()
  } // viewDidLoad
  

  // MARK: - UI설정
  func makeUI(){
    [
      searchBar,
      titleButton,
      popularButton,
      majorButton,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(resultCollectionView)
    
    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
      make.height.equalTo(58)
    }
    
    titleButton.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(10)
      $0.leading.equalTo(searchBar.snp.leading).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    popularButton.snp.makeConstraints {
      $0.top.equalTo(titleButton)
      $0.leading.equalTo(titleButton.snp.trailing).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    majorButton.snp.makeConstraints {
      $0.top.equalTo(titleButton)
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
      make.top.equalTo(titleButton.snp.bottom).offset(20)
      make.leading.trailing.equalTo(view)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    leftButtonSetting()
    settingNavigationTitle(title: "검색결과") // 타이틀 색상이 안보임
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  /// 서치바 설정
  func setupSearchBar(){
    if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.backgroundColor = .bg30
      searchBarTextField.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
  /// 네비게이션 바 왼쪽버튼 탭
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(HomeStep.popScreenIsRequired)
  }
  
  /// delegate 설정
  func setupDelegate(){
    searchBar.delegate = self
    
    resultCollectionView.delegate = self
    resultCollectionView.register(
      SearchResultCell.self,
      forCellWithReuseIdentifier: SearchResultCell.cellID
    )
  }
  
  
  /// 스터디 검색결과 필터링 버튼
  /// - Parameters:
  ///   - title: 제목
  ///   - titleColor: 제목 색상 (기본값 bg90)
  ///   - backgorundColor: 버튼 색상
  /// - Returns: 생성된 버튼
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
    button.layer.cornerRadius = 16
    return button
  }
  
  
  /// 바인딩 설정
  func setupBinding(){
    viewModel.postDatas
      .asDriver(onErrorJustReturn: [])
      .drive(resultCollectionView.rx.items(
        cellIdentifier: SearchResultCell.cellID,
        cellType: SearchResultCell.self)) { index, content, cell in
          cell.model = content
//          cell.loginStatus = self.viewModel.isUserLogin
        }
        .disposed(by: disposeBag)
    
//    viewModel.postDatas
//      .subscribe(onNext: { [ weak self]  _ in
//        self?.updateUI()
//      })
//      .disposed(by: disposeBag)
  }
  
  
  /// Actions 설정
  func setupActions(){
    resultCollectionView.rx.modelSelected(Content.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
//        self?.viewModel.fetchSinglePostDatas(item.postID) { result in
//          let postData = PostedStudyData(
//            isUserLogin: self?.viewModel.isUserLogin ?? false,
//            postDetailData: result,
//            isNeedFechData: self?.viewModel.isNeedFetchToSearchVC
//          )
//
//          let postedVC = PostedStudyViewController(postData)
//          postedVC.hidesBottomBarWhenPushed = true
//          self?.navigationController?.pushViewController(postedVC, animated: true)
//        }
      })
      .disposed(by: disposeBag)
    
    titleButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.allButtonTapped()
      })
      .disposed(by: disposeBag)
    
    popularButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.popularButtonTapped()
      })
      .disposed(by: disposeBag)
    
    majorButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.majorButtonTapped()
      })
      .disposed(by: disposeBag)
  }
  
  func buttonTapped(hot: String, titleAndMajor: String){
    resultCollectionView.setContentOffset(CGPoint.zero, animated: false)
//
//    let data = RequestPostData(
//      hot: hot,
//      text: self.viewModel.searchKeyword ?? "",
//      page: 0,
//      size: 5,
//      titleAndMajor: titleAndMajor
//    )
//    viewModel.getPostData(data: data)
//
//    self.resultCollectionView.isHidden = false
//
//    noSearchDataUI(count: viewModel.numberOfCells)
  }
  
  // MARK: - 전체버튼 눌렸을 때
  func allButtonTapped() {
    updateButtonColors(selectedButton: titleButton, deselectedButtons: [popularButton, majorButton])
    
    buttonTapped(hot: "false", titleAndMajor: "true")
  }
  
  // MARK: - 인기버튼 눌렸을 때
  func popularButtonTapped() {
    updateButtonColors(selectedButton: popularButton, deselectedButtons: [titleButton, majorButton])
  
    buttonTapped(hot: "true", titleAndMajor: "true")
  }
  
  // MARK: - 학과버튼 눌렸을 때
  func majorButtonTapped() {
    updateButtonColors(selectedButton: majorButton, deselectedButtons: [titleButton, popularButton])
    
    buttonTapped(hot: "false", titleAndMajor: "false")
  }
  
  /// 버튼 색상 업데이트 함수
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
    
    // MARK: - 스크롤 제약 업데이트
    func updateCollectionViewHeight() {
      // 기존의 제약 조건을 찾아 업데이트
      let existingConstraint = resultCollectionView.constraints.first { constraint in
        return constraint.firstAttribute == .height && constraint.relation == .equal
      }
      
 //     if let existingConstraint = existingConstraint {
 //       // 기존의 제약 조건이 존재하는 경우, 해당 제약 조건을 업데이트
 //       existingConstraint.constant = calculateNewCollectionViewHeight()
 //     } else {
 //       // 기존의 제약 조건이 존재하지 않는 경우, 새로운 제약 조건 추가
 //       resultCollectionView.snp.makeConstraints { make in
 //         make.height.equalTo(calculateNewCollectionViewHeight())
 //       }
 //     }
      
      
      // 레이아웃 업데이트
      self.view.layoutIfNeeded()
    }
    
    // MARK: - 스크롤 시 셀 높이 계산
   func calculateNewCollectionViewHeight()
 //  -> CGFloat {
   {
     // resultCollectionView의 셀 개수에 따라 새로운 높이 계산
     let cellHeight: CGFloat = 247
     let spacing: CGFloat = 10
 //    let numberOfCells = viewModel.numberOfCells
 //    let newHeight = CGFloat(numberOfCells) * cellHeight + CGFloat(numberOfCells - 1) * spacing
     
 //    return newHeight
   }
  }
  
}

// 셀의 각각의 크기
extension ResultSearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 247)
  }
}

// MARK: - 서치바 함수

extension ResultSearchViewController: UISearchBarDelegate {
  /// 검색버튼 터치 시 pop
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.steps.accept(HomeStep.popScreenIsRequired)
  }
}
