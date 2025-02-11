//
//  EnterSearchViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 검색어 입력 VC
final class EnterSearchViewController: UIViewController {
  let disposeBag: DisposeBag = DisposeBag()
  
  var viewModel: SearchViewModel
    
  /// 서치바
  private lazy var searchBar = UISearchBar.createSearchBar(placeholder: "관심있는 스터디를 검색해 보세요")
  
  /// 검색어 결과 테이블뷰
  private lazy var resultTableView: UITableView = UITableView().then({
    $0.backgroundColor = .white
    $0.separatorInset.left = 0
    $0.layer.cornerRadius = 10
  })
  
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    setupDelegate()
    setupNavigationbar()
  
    setupSearchBar()
    makeUI()
    
    setupBinding()
    setupActions()
  } // viewDidLoad
  
  /// UI설정
  func makeUI() {
    
    view.addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    view.addSubview(resultTableView)
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom).offset(10)
      make.leading.trailing.equalTo(searchBar).offset(10)
      make.bottom.equalTo(view).offset(-10)
    }
  }
  
  /// delegate설정
  func setupDelegate(){
    searchBar.delegate = self
  
    resultTableView.delegate = self
    resultTableView.register(SeletMajorCell.self, forCellReuseIdentifier: SeletMajorCell.cellId)
  }
  

  
  // MARK: - 서치바 재설정
  func setupSearchBar(){
    if let searchBarTextField = searchBar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.backgroundColor = .bg30
      searchBarTextField.layer.borderColor = UIColor.clear.cgColor
    }
  }
  
  /// 네비게이션 바 설정
  func setupNavigationbar(){
    leftButtonSetting()
    rightButtonSetting(imgName: "BookMarkImg")
    
    self.navigationController?.navigationBar.isTranslucent = false
  }
  
  /// 네비게이션 왼쪽버튼 탭
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    viewModel.steps.accept(HomeStep.popScreenIsRequired)
  }
  
  /// 네비게이션 바 오른쪽 버튼 탭 - 북마크 화면으로 이동
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    NotificationCenter.default.post(name: .navToBookmarkScreen, object: nil)
  }
  
  // MARK: - setupBinding
  
  /// 바인딩 설정
  func setupBinding(){
//    viewModel.isNeedFetchToSearchVC
//      .asDriver(onErrorJustReturn: true)
//      .drive(onNext: { [weak self] _ in
//        guard let keyword = self?.viewModel.searchKeyword else { return }
//        self?.keyWordTapped(keyword: keyword)
//      })
//      .disposed(by: disposeBag)
   
    viewModel.recommendList
      .asDriver(onErrorJustReturn: [])
      .drive(resultTableView.rx.items(
        cellIdentifier: SeletMajorCell.cellId,
        cellType: SeletMajorCell.self)) { index, content, cell in
          cell.model = content
          cell.setupImage()
        }
        .disposed(by: disposeBag)
    
//    viewModel.recommendList
//      .subscribe(onNext: { [weak self] in
//        self?.noSearchDataUI(count: $0.count)
//      })
//      .disposed(by: disposeBag)
    
  }
  
  // MARK: - setupActions
  
  /// Actions 설정
  func setupActions(){
    resultTableView.rx.modelSelected(String.self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        self?.keyWordTapped(keyword: item)
      })
      .disposed(by: disposeBag)
    

  }


  
  

  

  

  
  func keyWordTapped(keyword: String){
//    viewModel.searchKeyword = keyword
//    
//    let data = RequestPostData(
//      hot: "false",
//      text: keyword,
//      page: 0,
//      size: 5,
//      titleAndMajor: "true"
//    )
//    viewModel.getPostData(data: data)
  }
}

// MARK: - 서치바 함수
extension EnterSearchViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을 때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
    searchBar.resignFirstResponder()
  }
}

// MARK: - tableView cell 함수
extension EnterSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
}



// MARK: - 북마크 관련
//extension SearchViewController: CheckLoginDelegate {}

extension EnterSearchViewController {
  // MARK: - 네트워킹 기다릴 때
//   func waitingNetworking(){
//     view.addSubview(activityIndicator)
//     
//     activityIndicator.snp.makeConstraints {
//       $0.centerX.centerY.equalToSuperview()
//     }
//     
//     activityIndicator.startAnimating()
//   }
//
//
//   

}

extension EnterSearchViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.height)){
//      if viewModel.isInfiniteScroll {
//        viewModel.isInfiniteScroll = false
//        fetchMoreData(hotType: "false", titleAndMajor: "true")
//      }
//    }
  }
}

extension EnterSearchViewController: CreateUIprotocol {}
