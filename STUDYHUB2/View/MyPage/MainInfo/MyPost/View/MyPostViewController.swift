
import UIKit

import SnapKit
import RxCocoa

final class MyPostViewController: CommonNavi {
  let viewModel: MyPostViewModel
  
  private lazy var totalPostCountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    return label
  }()
  
  private lazy var deleteAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체삭제", for: .normal)
    button.setTitleColor(UIColor.bg70, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    button.addAction(UIAction { _ in
      self.confirmDeleteAll()
    },for: .touchUpInside)
    return button
  }()
  
  // MARK: - 작성한 글 없을 때
  
  private lazy var emptyImage: UIImageView = UIImageView(image: UIImage(named: "EmptyPostImg"))
  
  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "작성한 글이 없어요\n새로운 스터디 활동을 시작해 보세요!"
    label.numberOfLines = 0
    label.textColor = .bg70
    return label
  }()
  
  private lazy var writePostButton = StudyHubButton(title: "글 작성하기")
  
  // MARK: - 작성한 글 있을 때
  
  
  private lazy var myPostCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .bg30
    return scrollView
  }()
  
  init(_ userData: BehaviorRelay<UserDetailData?>) {
    self.viewModel = MyPostViewModel(userData: userData)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .bg30
    
    setupNavigationbar()
    
    registerCell()
    
    makeUI()
    
    setupBinding()
    setupActions()
  }
  
  
  // MARK: - makeUI
  
  
  func makeUI(){
    view.addSubview(totalPostCountLabel)
    let postCount = viewModel.userData.value?.postCount
    totalPostCountLabel.text = "전체 \(postCount ?? 0)"
    totalPostCountLabel.changeColor(wantToChange: "전체", color: .bg80)
    totalPostCountLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    view.addSubview(deleteAllButton)
    deleteAllButton.snp.makeConstraints { make in
      make.top.equalTo(totalPostCountLabel)
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalTo(totalPostCountLabel)
    }
  }
  
  func makeUIWithPostCount(_ postCount: Int){
    if postCount > 0 {
      scrollView.addSubview(myPostCollectionView)
      myPostCollectionView.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(scrollView.snp.height)
      }
      
      view.addSubview(scrollView)
      scrollView.snp.makeConstraints { make in
        make.top.equalTo(totalPostCountLabel.snp.bottom).offset(20)
        make.leading.trailing.bottom.equalTo(view)
      }
    } else {
      view.addSubview(emptyImage)
      emptyImage.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-20)
        make.height.equalTo(210)
        make.width.equalTo(180)
      }
      
      view.addSubview(emptyLabel)
      emptyLabel.setLineSpacing(spacing: 15)
      emptyLabel.textAlignment = .center
      emptyLabel.changeColor(wantToChange: "새로운 스터디 활동을 시작해 보세요!", color: .bg60)
      emptyLabel.snp.makeConstraints { make in
        make.centerX.equalTo(emptyImage)
        make.top.equalTo(emptyImage.snp.bottom).offset(20)
      }
      
      view.addSubview(writePostButton)
      writePostButton.snp.makeConstraints { make in
        make.centerX.equalTo(emptyImage)
        make.top.equalTo(emptyLabel).offset(70)
        make.width.equalTo(195)
        make.height.equalTo(47)
      }
    }
  }
  
  func setupBinding(){
    viewModel.myPostData
      .asDriver(onErrorJustReturn: [])
      .drive(myPostCollectionView.rx.items(
        cellIdentifier: MyPostCell.id,
        cellType: MyPostCell.self)) { index, content, cell in
          cell.model = content
          cell.delegate = self
        }
        .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    viewModel.myPostData
      .asDriver(onErrorJustReturn: [])
      .drive(onNext: { [ weak self] data in
        let postCount = data.count
        self?.makeUIWithPostCount(postCount)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  private func registerCell() {
    myPostCollectionView.register(MyPostCell.self, forCellWithReuseIdentifier: MyPostCell.id)
    myPostCollectionView.rx.setDelegate(self)
      .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - setupNavigationbar
  
  func setupNavigationbar(){
    settingNavigationTitle(title: "작성한 글")
    leftButtonSetting()
  }
  
  // MARK: - 전체삭제
  
  
  func confirmDeleteAll() {
    let popupVC = PopupViewController(
      title: "글을 모두 삭제할까요?",
      desc: "삭제한 글과 참여자는 다시 볼 수 없어요"
    )
    
    popupVC.popupView.rightButtonAction = { [weak self] in
      guard let self = self else { return }
      popupVC.dismiss(animated: true)
      viewModel.deleteMyAllPost()
      showToast(message: "글이 삭제됐어요")
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
}


extension MyPostViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: 350, height: 181)
  }
}

// MARK: - MyPostcell 함수


extension MyPostViewController: MyPostCellDelegate {
  func acceptButtonTapped(in cell: MyPostCell, studyID: Int) {
    moveToOtherVCWithSameNavi(vc: CheckParticipantsVC(), hideTabbar: true)
  }
  
  func menuButtonTapped(in cell: MyPostCell, postID: Int) {
    let bottomSheetVC = BottomSheet(postID: postID)
    bottomSheetVC.delegate = self
    showBottomSheet(bottomSheetVC: bottomSheetVC, size: 228.0)
    present(bottomSheetVC, animated: true, completion: nil)
  }
  
  func closeButtonTapped(in cell: MyPostCell, postID: Int){
    let popupVC = PopupViewController(
      title: "이 글의 모집을 마감할까요?",
      desc: "마감하면 다시 모집할 수 없어요",
      rightButtonTilte: "마감"
    )
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = {
      
    }
  }
  
  // MARK: - 스크롤해서 데이터 가져오기
  //  func fetchMoreData(){
  //    guard let countData = myPostDatas?.count else { return }
  //    getMyPostData(size: countData + 5) {
  //      self.myPostCollectionView.reloadData()
  //    }
  //  }
  //
  // MARK: - 스터디 생성 VC로 이동
  func moveToCreateVC(){
    moveToOtherVCWithSameNavi(vc: CreateStudyViewController(), hideTabbar: true)
  }
}

extension MyPostViewController: BottomSheetDelegate {
  func firstButtonTapped(postID: Int, checkPost: Bool) {
    let popupVC = PopupViewController(
      title: "이 글을 삭제할까요?",
      desc: "삭제한 글과 참여자는 다시 볼 수 없어요"
    )
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
  
  func secondButtonTapped(postID: Int, checkPost: Bool) {
    self.dismiss(animated: true) {
      let createVC = CreateStudyViewController()
      //      createVC.modifyPostID = postID
      self.navigationController?.pushViewController(createVC, animated: true)
    }
  }
}

//// MARK: - 스크롤할 때 네트워킹 요청
//extension MyPostViewController {
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let tableView = myPostCollectionView
//    if (tableView.contentOffset.y > (tableView.contentSize.height - tableView.bounds.size.height)){
//      let myPostTotalData = myPostDataManager.getMyTotalPostData()
//
//      guard let last = myPostTotalData?.posts.last else { return }
//
//      if !last {
//        fetchMoreData()
//      }
//    }
//  }
//}

//extension MyPostViewController: PopupViewDelegate {
//  func afterDeletePost(completion: @escaping () -> Void) {
//    getMyPostData(size: 5) {
//      self.myPostCollectionView.reloadData()
//    }
////  }
//}

extension MyPostViewController: ShowBottomSheet {}
