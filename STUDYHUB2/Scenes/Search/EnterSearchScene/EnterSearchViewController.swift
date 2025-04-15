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
  private lazy var searchBar = StudyHubUI.createSearchBar(placeholder: "관심있는 스터디를 검색해 보세요")
  
  /// 검색어 결과 테이블뷰
  private lazy var resultTableView: UITableView = UITableView().then({
    $0.backgroundColor = .white
    $0.separatorInset.left = 0
    $0.layer.cornerRadius = 10
  })
  
  /// 결과값이 없을 때의 view
  private lazy var emptyResultView = EmptyResultView()
  
  
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
    // 서치바
    view.addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    // 검색어 테이블뷰
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
  
  
  // MARK: - 서치바 설정
  
  /// 서치바 설정
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
  
  /// 네비게이션 왼쪽버튼 탭 - pop
  override func leftBarBtnTapped(_ sender: UIBarButtonItem) {
    if let _ = self.navigationController?.viewControllers.first as? HomeViewController  {
      viewModel.steps.accept(HomeStep.popScreenIsRequired)
    }else{
      viewModel.steps.accept(StudyStep.popScreenIsRequired)
    }
  }
  
  /// 네비게이션 바 오른쪽 버튼 탭 - 북마크 화면으로 이동
  override func rightBarBtnTapped(_ sender: UIBarButtonItem) {
    NotificationCenter.default.post(name: .navToBookmarkScreen, object: nil)
  }
  
  // MARK: - setupBinding
  
  /// 바인딩 설정
  func setupBinding(){
    
    // 검색어
    viewModel.recommendList
      .asDriver(onErrorJustReturn: [])
      .drive(resultTableView.rx.items(
        cellIdentifier: SeletMajorCell.cellId,
        cellType: SeletMajorCell.self)) { index, content, cell in
          cell.model = content
          cell.setupImage()
          cell.selectionStyle = .none
        }
        .disposed(by: disposeBag)
    
    viewModel.recommendList
      .withUnretained(self)
      .asDriver(onErrorJustReturn: (self, []))
      .drive(onNext: { (vc, list) in
                
        vc.view.addSubview(vc.emptyResultView)
        vc.emptyResultView.isHidden = list.count != 0
        vc.resultTableView.isHidden = list.count == 0
        vc.emptyResultView.snp.makeConstraints {
          $0.top.equalTo(vc.searchBar.snp.bottom).offset(80)
          $0.centerX.equalToSuperview()
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  // MARK: - setupActions
  
  /// Actions 설정
  func setupActions(){
    // 검색어 셀 터치 시 해당 검색어 관련 스터디 불러오기
    resultTableView.rx.modelSelected(String.self)
      .withUnretained(self)
      .throttle(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { (vc, keyword) in
        print(#fileID, #function, #line," - \(keyword)")
        
        vc.viewModel.fetchPostData(with: keyword)
        
        if let _ = self.navigationController?.viewControllers.first as? HomeViewController  {
          vc.viewModel.steps.accept(HomeStep.resultSearchIsRequired)
        }else{
          vc.viewModel.steps.accept(StudyStep.resultSearchIsRequired)
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  func noSearchDataUI(count: Int){
    view.addSubview(emptyResultView)
    emptyResultView.isHidden = false
    emptyResultView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
  }
  
}

// MARK: - 서치바 함수
extension EnterSearchViewController: UISearchBarDelegate {
  
  // 검색 시 실시간으로 호출 - 비어있지 않는 경우만
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
    if !searchText.isEmpty {
      viewModel.searchRecommend(keyword: searchText)
    }
  }
}

// MARK: - tableView cell 함수
extension EnterSearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

