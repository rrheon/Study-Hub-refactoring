//
//  MyPostViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/17.
//

import UIKit

import SnapKit

final class MyPostViewController: NaviHelper {
  let myPostDataManager = MyPostInfoManager.shared
  let detailPostDataManager = PostDetailInfoManager.shared
  let commonNetworking = CommonNetworking.shared
  
  var myPostDatas: [MyPostcontent]?
  var previousMyPage: MyPageViewController?
  
  var countPostNumber = 0 {
    didSet {
      totalPostCountLabel.text = "전체 \(countPostNumber)"
    }
  }
  
  private lazy var totalPostCountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 14)
    return label
  }()
  
  private lazy var deleteAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체삭제", for: .normal)
    button.setTitleColor(UIColor.bg70, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
    button.addAction(UIAction { _ in
      print("tap button")
      self.confirmDeleteAll()
    },for: .touchUpInside)
    return button
  }()
  
  // MARK: - 작성한 글 없을 때
  private lazy var emptyImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "EmptyPostImg")
    return imageView
  }()
  
  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "작성한 글이 없어요\n새로운 스터디 활동을 시작해 보세요!"
    label.numberOfLines = 0
    label.textColor = .bg70
    return label
  }()
  
  private lazy var writePostButton: UIButton = {
    let button = UIButton()
    button.setTitle("글 작성하기", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o50
    button.layer.cornerRadius = 5
    button.addAction(UIAction{ _ in
      self.moveToCreateVC()
    }, for: .touchUpInside)
    return button
  }()
  
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
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  // MARK: - 이전페이지로 넘어갈 때
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent {
      previousMyPage?.fetchUserData()
    }
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .bg30
    
    
    navigationItemSetting()
    redesignNavigationbar()
    
    registerCell()
    
    getMyPostData(size: 100) {
      self.setupLayout()
      self.makeUI()
    }
//    setupLayout()
//    makeUI()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      totalPostCountLabel,
      deleteAllButton
    ].forEach {
      view.addSubview($0)
    }
    
    if countPostNumber > 0 {
      view.addSubview(scrollView)
      scrollView.addSubview(myPostCollectionView)
    } else {
      [
        emptyImage,
        emptyLabel,
        writePostButton
      ].forEach {
        view.addSubview($0)
      }
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    totalPostCountLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    deleteAllButton.snp.makeConstraints { make in
      make.top.equalTo(totalPostCountLabel)
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalTo(totalPostCountLabel)
    }
    
    if countPostNumber > 0 {
      myPostCollectionView.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(scrollView.snp.height)
      }
      
      scrollView.snp.makeConstraints { make in
        make.top.equalTo(totalPostCountLabel.snp.bottom).offset(20)
        make.leading.trailing.bottom.equalTo(view)
      }
    } else {
      emptyImage.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-20)
        make.height.equalTo(210)
        make.width.equalTo(180)
      }
      
      emptyLabel.setLineSpacing(spacing: 15)
      emptyLabel.textAlignment = .center
      emptyLabel.changeColor(label: emptyLabel,
                             wantToChange: "새로운 스터디 활동을 시작해 보세요!",
                             color: .bg60)
      emptyLabel.snp.makeConstraints { make in
        make.centerX.equalTo(emptyImage)
        make.top.equalTo(emptyImage.snp.bottom).offset(20)
      }
      
      writePostButton.snp.makeConstraints { make in
        make.centerX.equalTo(emptyImage)
        make.top.equalTo(emptyLabel).offset(70)
        make.width.equalTo(195)
        make.height.equalTo(47)
      }
    }
    
  }
  
  private func registerCell() {
    myPostCollectionView.delegate = self
    myPostCollectionView.dataSource = self
    
    myPostCollectionView.register(MyPostCell.self,
                                  forCellWithReuseIdentifier: MyPostCell.id)
  }
  
  // MARK: - navigationbar 재설정
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItems = .none
    settingNavigationTitle(title: "작성한 글",
                           font: "Pretendard-Bold",
                           size: 18)
  }
  
  // MARK: - 내가쓴 포스트 데이터 가져오기
  func getMyPostData(size: Int,
                     completion: @escaping () -> Void) {
    self.myPostDataManager.fetchMyPostInfo(page: 0, size: size) { [weak self] success in
      if success {
        DispatchQueue.main.async {
          self?.myPostDatas = self?.myPostDataManager.getMyPostData()
          self?.moveDataToBottom()

          guard let postCount = self?.myPostDataManager.getMyTotalPostData() else { return }
          self?.countPostNumber = postCount.totalCount
          self?.myPostCollectionView.reloadData()

          completion()
        }
      }
    }
  }
  
  // MARK: - 전체삭제
  // 전체삭제 알람표시
  func confirmDeleteAll() {
    let popupVC = PopupViewController(title: "글을 모두 삭제할까요?",
                                      desc: "삭제한 글과 참여자는 다시 볼 수 없어요")
    
    popupVC.popupView.rightButtonAction = { [weak self] in
      guard let self = self else { return }
      popupVC.dismiss(animated: true)
      self.deleteAllPost()
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }

  // MARK: -  전체 삭제를 수행하는 메서드
  func deleteAllPost() {
    let dispatchGroup = DispatchGroup()
    myPostDatas?.forEach({
      dispatchGroup.enter()
      myPostDataManager.deleteMyPost(postId: $0.postID) { result in
        defer {
          dispatchGroup.leave() // 완료되면 나가기
        }
        switch result{
        case .success(let response):
          print(response)
        case .failure(let response):
          print(response)
        }
      }
    })
    
    dispatchGroup.notify(queue: .main) {
      // 모든 비동기 작업이 완료된 후 실행될 코드
      self.showToast(message: "모든 글이 삭제되었어요", alertCheck: true)
      self.getMyPostData(size: 5) {
        print("전체삭제 완료")
      }
    }
  }
  
  // MARK: - 마감인 데이터 아래로 보내는 함수
  func moveDataToBottom(){
    guard let index = myPostDatas?.firstIndex(where:{ $0.close}) else { return }
      
    guard let data = myPostDatas?.remove(at: index) else { return }
    myPostDatas?.append(data)
    myPostCollectionView.reloadData()
  }
}

// MARK: - collectionView
extension MyPostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return myPostDatas?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
  
    guard let postID = myPostDatas?[indexPath.row].postID else { return }
    let postedVC = PostedStudyViewController(postID: postID)
    postedVC.previousMyPostVC = self
    // 단건조회 시 연관된 포스트도 같이 나옴
    
    var username: String? = nil
    
    loginManager.refreshAccessToken { loginStatus in
      self.detailPostDataManager.searchSinglePostData(postId: postID,
                                                 loginStatus: loginStatus) {
        let cellData = self.detailPostDataManager.getPostDetailData()
        postedVC.postedData = cellData
        
        
        username = cellData?.postedUser.nickname
        
        if username == nil {
          self.showToast(message: "해당 post에 접근할 수 없습니다", imageCheck: false)
          return
        }
        self.navigationController?.pushViewController(postedVC, animated: true)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPostCell.id,
                                                  for: indexPath) as! MyPostCell
    
    cell.delegate = self
    cell.buttonColor = myPostDatas?[indexPath.row].close == true ? .bg60 : .o50
    print(myPostDatas?[indexPath.row].close)
    cell.model = myPostDatas?[indexPath.row]
    return cell
  }
}

// 셀의 각각의 크기
extension MyPostViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 181)
  }
}

// MARK: - MyPostcell 함수
extension MyPostViewController: MyPostCellDelegate {
  // 참여자 버튼
  func acceptButtonTapped(in cell: MyPostCell, studyID: Int) {
    guard let navigationController = self.navigationController else { return}
    let checkParticipateVC = CheckParticipantsVC()
    checkParticipateVC.studyID = studyID
    print(studyID)
    navigationController.pushViewController(checkParticipateVC, animated: true)
  }

  // 메뉴버튼
  func menuButtonTapped(in cell: MyPostCell, postID: Int) {
    let bottomSheetVC = BottomSheet(postID: postID)
    bottomSheetVC.delegate = self
    
    if #available(iOS 15.0, *) {
      if let sheet = bottomSheetVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return 228.0
          })]
        } else {
          // Fallback on earlier versions
        }
        sheet.largestUndimmedDetentIdentifier = nil
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        sheet.preferredCornerRadius = 20
      }
    } else {
      // Fallback on earlier versions
    }
    present(bottomSheetVC, animated: true, completion: nil)
  }
  
  // MARK: - 게시글 모집 마감, 마감한 애를 어떻게 맨 밑으로 내릴까나 api는 동작함, close 가 true이면 맨밑으론 내리고 비활성화
  func closeButtonTapped(in cell: MyPostCell, postID: Int){
    // Postid수정필요
    let popupVC = PopupViewController(title: "이 글의 모집을 마감할까요?",
                                      desc: "마감하면 다시 모집할 수 없어요",
                                      rightButtonTilte: "마감")
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
    
    popupVC.popupView.rightButtonAction = {
      self.commonNetworking.moyaNetworking(networkingChoice: .closePost(postID)) { result in
        switch result {
        case .success(let response):
          print(response.response)
          if response.statusCode == 200 {
            self.getMyPostData(size: 5) {
              print("데이터리로드")
            }
            self.dismiss(animated: true)
          }
        case .failure(let response):
          print(response.response)
        }
      }
    }
  }
  
  // MARK: - 스크롤해서 데이터 가져오기
  func fetchMoreData(){
    guard let countData = myPostDatas?.count else { return }
    getMyPostData(size: countData + 5) {
      self.myPostCollectionView.reloadData()
    }
  }
  
  // MARK: - 스터디 생성 VC로 이동
  func moveToCreateVC(){
    let createPostVC = CreateStudyViewController()
    createPostVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(createPostVC, animated: true)
  }
}

// 삭제하고 뒤로가면 마이페이지인데 이거 데이터도 다시 잡아줘야함, 게시글 상세조회에서 할때도
extension MyPostViewController: BottomSheetDelegate {
  // 수정해야할수도
  func firstButtonTapped(postID: Int?) {
    let popupVC = PopupViewController(title: "이 글을 삭제할까요?",
                                      desc: "삭제한 글과 참여자는 다시 볼 수 없어요",
                                      postID: postID ?? 0)
    popupVC.delegate = self
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
  
  // BottomSheet에서 화면을 전환할 때
  func secondButtonTapped(postID: Int?) {
    self.dismiss(animated: true) {
      let createVC = CreateStudyViewController()
      createVC.modifyPostID = postID
      self.navigationController?.pushViewController(createVC, animated: true)
    }
  }
}

// MARK: - 스크롤할 때 네트워킹 요청
extension MyPostViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let tableView = myPostCollectionView
    if (tableView.contentOffset.y > (tableView.contentSize.height - tableView.bounds.size.height)){
      let myPostTotalData = myPostDataManager.getMyTotalPostData()
      
      guard let last = myPostTotalData?.posts.last else { return }
      
      if !last {
        fetchMoreData()
      }
    }
  }
}

extension MyPostViewController: PopupViewDelegate {
  func afterDeletePost(completion: @escaping () -> Void) {
    getMyPostData(size: 5) {
      self.myPostCollectionView.reloadData()
    }
  }
}

