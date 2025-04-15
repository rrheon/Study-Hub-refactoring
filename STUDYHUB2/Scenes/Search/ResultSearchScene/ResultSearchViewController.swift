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
  private lazy var searchBar = StudyHubUI.createSearchBar(placeholder: "관심있는 스터디를 검색해 보세요")
  
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
    
    view.addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
      make.height.equalTo(58)
    }
    
    view.addSubview(titleButton)
    titleButton.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(10)
      $0.leading.equalTo(searchBar.snp.leading).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    view.addSubview(popularButton)
    popularButton.snp.makeConstraints {
      $0.top.equalTo(titleButton)
      $0.leading.equalTo(titleButton.snp.trailing).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    view.addSubview(majorButton)
    majorButton.snp.makeConstraints {
      $0.top.equalTo(titleButton)
      $0.leading.equalTo(popularButton.snp.trailing).offset(10)
      $0.height.equalTo(34)
      $0.width.equalTo(57)
    }
    
    scrollView.addSubview(resultCollectionView)
    resultCollectionView.reloadData()
    resultCollectionView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(scrollView.snp.height)
    }
    
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(titleButton.snp.bottom).offset(20)
      make.leading.trailing.equalTo(view)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    leftButtonSetting()
    settingNavigationTitle(title: "검색결과")
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
//    viewModel.steps.accept(HomeStep.popScreenIsRequired)
    if let _ = self.navigationController?.viewControllers.first as? HomeViewController  {
      viewModel.steps.accept(HomeStep.popScreenIsRequired)
    }else{
      viewModel.steps.accept(StudyStep.popScreenIsRequired)
    }
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
          cell.cellData = content
        }
        .disposed(by: disposeBag)
  }
  
  
  /// Actions 설정
  func setupActions(){
    
    // 검색결과 collectionView 탭 -> 스터디 상세 화면으로 이동
    resultCollectionView.rx.modelSelected(PostData.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        let postID = item.postId
        NotificationCenter.default.post(name: .navToStudyDetailScrenn,
                                        object: nil,
                                        userInfo: ["postID" : postID])
      })
      .disposed(by: disposeBag)
    
    // 검색결과 제목이 일치하는 스터디로 정렬
    titleButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.allButtonTapped()
      })
      .disposed(by: disposeBag)
    
    // 검색결과 인기순 스터디로 정렬
    popularButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.popularButtonTapped()
      })
      .disposed(by: disposeBag)
    
    // 검색결과 학과가 일치하는 스터디로 정렬
    majorButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.majorButtonTapped()
      })
      .disposed(by: disposeBag)
  }
  
  func buttonTapped(hot: String, titleAndMajor: String){
    resultCollectionView.setContentOffset(CGPoint.zero, animated: false)
    viewModel.fetchPostData(with: titleAndMajor)
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

  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    viewModel.steps.accept(HomeStep.popScreenIsRequired)
    return false
  }
  
//  /// 검색버튼 터치 시 pop
//  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    guard let content = searchBar.text else { return }
//    
//    viewModel.steps.accept(HomeStep.popScreenIsRequired)
//  }
//  
//  func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//    viewModel.searchContent = searchBar.text ?? ""
//    return true
//  }
}

// MARK: - 스크롤


extension ResultSearchViewController {
  
  /// 스크롤할 때 네트워킹 요청
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let scrollViewHeight = scrollView.frame.size.height
    let contentHeight = scrollView.contentSize.height
    let offsetY = scrollView.contentOffset.y
    
    // 바닥에서 50포인트 위에 도달했는지 체크
    if offsetY + scrollViewHeight >= contentHeight - 50 && viewModel.isInfiniteScroll == false {
      print("바닥에서 50포인트 위에 도달! ")
       
      viewModel.fetchPostData(with: viewModel.searchContent)
    
    
    }
  }
}
