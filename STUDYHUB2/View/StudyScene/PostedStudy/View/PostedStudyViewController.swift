//
//  PostedStudyViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/30.
//

import UIKit

import SnapKit
import RxCocoa

final class PostedStudyViewController: NaviHelper, CreateDividerLine {
  
  let viewModel: PostedStudyViewModel

  private var mainComponent: PostedStudyMainComponent
  
  private lazy var aboutStudyLabel = createLabel(
    title: "소개",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var aboutStudyDeatilLabel = createLabel(
    title: "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var aboutStudyStackView = createStackView(axis: .vertical, spacing: 10)
  private var detailInfoComponent: PostedStudyDetailInfoConponent
  
  private lazy var divideLineTopWriterInfo = createDividerLine(height: 8.0)
  private lazy var divideLineUnderWriterInfo = createDividerLine(height: 8.0)
  private var writerComponent: PostedStudyWriterComponent
  
  private lazy var commentComponent = PostedStudyCommentComponent()
  
  private lazy var similarPostLabel = createLabel(
    title: "이 글과 비슷한 스터디예요",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 18
  )
  
  private lazy var similarCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    return view
  }()
  
  private lazy var similarPostStackView = createStackView(axis: .vertical, spacing: 20)

  private lazy var bookmarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
//    button.addAction(UIAction { _ in
//      self.bookmarkButtonTappedAtPostedVC()
//    } , for: .touchUpInside)
    return button
  }()
  
  private lazy var participateButton = StudyHubButton(title: "참여하기")
  
  private lazy var bottomButtonStackView = createStackView(axis: .horizontal, spacing: 10)
  
  // 전체 요소를 담는 스택
  private lazy var pageStackView = createStackView(axis: .vertical, spacing: 10)
  
  private lazy var scrollView: UIScrollView = UIScrollView()
  private let activityIndicator = UIActivityIndicatorView(style: .large)

  init(_ postDatas: PostDetailData) {
    self.viewModel = PostedStudyViewModel(postDatas)
    
    self.mainComponent = PostedStudyMainComponent(postDatas)
    self.detailInfoComponent = PostedStudyDetailInfoConponent(postDatas)
    self.writerComponent = PostedStudyWriterComponent(postDatas)
    
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItemSetting()

    view.backgroundColor = .white
    
    setupBindings()

    setUpLayout()
    makeUI()
        
    setupDelegate()
    registerCell()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    let grayDividerLine = createDividerLine(height: 1.0)
    
    [
      aboutStudyLabel,
      aboutStudyDeatilLabel,
      grayDividerLine
    ].forEach {
      aboutStudyStackView.addArrangedSubview($0)
    }
  
    let spaceView = UIView()
    
    [
      similarPostLabel,
      similarCollectionView,
      spaceView
    ].forEach {
      similarPostStackView.addArrangedSubview($0)
    }

    [
      bookmarkButton,
      participateButton
    ].forEach {
      bottomButtonStackView.addArrangedSubview($0)
    }
    
    [
      mainComponent,
      aboutStudyStackView,
      detailInfoComponent,
      divideLineTopWriterInfo,
      writerComponent,
      divideLineUnderWriterInfo,
      commentComponent,
      similarPostStackView,
//      bottomButtonStackView
    ].forEach {
      pageStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(pageStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    mainComponent.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }
    
    aboutStudyStackView.backgroundColor = .white
    aboutStudyDeatilLabel.numberOfLines = 0
    aboutStudyStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10)
    aboutStudyStackView.isLayoutMarginsRelativeArrangement = true
    
    detailInfoComponent.snp.makeConstraints {
      $0.top.equalTo(aboutStudyStackView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    divideLineTopWriterInfo.snp.makeConstraints {
      $0.top.equalTo(detailInfoComponent.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
    }
    
    writerComponent.snp.makeConstraints {
      $0.top.equalTo(divideLineTopWriterInfo.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
    
    divideLineUnderWriterInfo.snp.makeConstraints {
      $0.top.equalTo(writerComponent.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
    
    commentComponent.snp.makeConstraints {
      $0.top.equalTo(divideLineUnderWriterInfo.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    similarPostStackView.snp.makeConstraints {
      $0.top.equalTo(commentComponent.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    similarCollectionView.snp.makeConstraints { make in
      make.height.equalTo(171)
    }
    
    bottomButtonStackView.distribution = .fillProportionally
    bottomButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    bottomButtonStackView.isLayoutMarginsRelativeArrangement = true
    
    participateButton.snp.makeConstraints {
      $0.height.equalTo(55)
      $0.width.equalTo(283)
    }
    
    pageStackView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.contentLayoutGuide)
      make.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }
  
  func setupBindings(){
    viewModel.postDatas
      .subscribe(onNext: {[weak self] in
        self?.aboutStudyDeatilLabel.text = $0?.content
      })
      .disposed(by: viewModel.disposeBag)
    
    viewModel.commentDatas
      .asDriver(onErrorJustReturn: [])
      .drive(commentComponent.commentTableView.rx.items(
        cellIdentifier: CommentCell.cellId,
        cellType: CommentCell.self)) { index, content, cell in
          cell.model = content
        }
        .disposed(by: viewModel.disposeBag)
  }
  
  // MARK: - collectionview 관련
  private func setupDelegate() {
    //    similarCollectionView.delegate = self
    //    similarCollectionView.dataSource = self
    //    similarCollectionView.tag = 1
    //
    //    commentTableView.delegate = self
    //    commentTableView.dataSource = self
  }
  
  private func registerCell() {
    similarCollectionView.register(
      SimilarPostCell.self,
      forCellWithReuseIdentifier: SimilarPostCell.id
    )
  }
  
  // MARK: - 데이터 받아오고 ui다시 그리는 함수
  func redrawUI(){
    //    if let postDate = self.postedData?.createdDate {
    //      self.postedDateLabel.text = "\(postDate[0]). \(postDate[1]). \(postDate[2])"
    //    }
    //
    //    bookmarked = postedData?.bookmarked
    //    let bookmarkImage = bookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
    //    bookmarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    //
    //    let major = self.convertMajor(self.postedData?.major ?? "", isEnglish: false)
    //    self.postedMajorLabel.text = "\(major)"
    //    self.postedTitleLabel.text = self.postedData?.title
    //    self.memberNumberCount = self.postedData?.remainingSeat ?? 0
    //    self.fineCount = self.postedData?.penalty ?? 0
    //
    //    self.gender = self.convertGender(gender: self.postedData?.filteredGender ?? "무관")
    //
    //    if gender == "남자" {
    //      genderImageView.image = UIImage(named: "MenGenderImage")
    //    } else if gender == "여자" {
    //      genderImageView.image = UIImage(named: "GenderImage")
    //    } else {
    //      genderImageView.image = UIImage(named: "GenderMixImg")
    //    }
    
    
    //    self.aboutStudyDeatilLabel.text = self.postedData?.content
    //
    //    guard let startDate = self.postedData?.studyStartDate,
    //          let endDate = self.postedData?.studyEndDate else { return }
    //
    //    self.periodLabel.text = "\(startDate[0]). \(startDate[1]). \(startDate[2]) ~ \(endDate[0]). \(endDate[1]). \(endDate[2])"
    //    self.meetLabel.text = self.convertStudyWay(wayToStudy: self.postedData?.studyWay ?? "혼합")
    //
    //    let convertedMajor = self.convertMajor(self.postedData?.major ?? "",
    //                                           isEnglish: false)
    //    self.majorLabel.text = "\(convertedMajor)"
    //
    //    self.writerMajorLabel.text = self.convertMajor(self.postedData?.postedUser.major ?? "",
    //                                                   isEnglish: false)
    //    self.nickNameLabel.text = self.postedData?.postedUser.nickname
    //
    //    if let imageURL = URL(string: postedData?.postedUser.imageURL ?? "") {
    //      let processor = ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50))
    //
    //      self.profileImageView.kf.setImage(with: imageURL,
    //                                        options: [.processor(processor)]) { result in
    //        switch result {
    //        case .success(let value):
    //          DispatchQueue.main.async {
    //            self.profileImageView.image = value.image
    //            self.profileImageView.layer.cornerRadius = 25
    //            self.profileImageView.clipsToBounds = true
    //          }
    //        case .failure(let error):
    //          print("Image download failed: \(error)")
    //        }
    //      }
    //    }
    //
    //    if postedData?.apply == true || participateCheck == true {
    //      participateButton.setTitle("수락 대기 중", for: .normal)
    //      participateButton.backgroundColor = .o30
    //      participateButton.isEnabled = false
    //    }
    //
    //    if postedData?.close == true {
    //      participateButton.setTitle("마감 됐어요.", for: .normal)
    //      participateButton.backgroundColor = .o30
    //      participateButton.isEnabled = false
    //    }
    //
    //    similarPostCount = postedData?.relatedPost.count
    //    if similarPostCount == 0 {
    //      similarPostStackView.isHidden = true
    //    }
    //
    //    similarCollectionView.reloadData()
  }
  //
  //  // MARK: - 댓글 작성하기
  //  func commentButtonTapped(completion: @escaping () -> Void){
  //    guard let postId = postedData?.postID,
  //          let content = commentTextField.text else { return }
  //    commentManager.createComment(content: content,
  //                                 postId: postId) {
  //      completion()
  //    }
  //  }
  //
  //  // MARK: - 댓글 수정하기
  //  func modifyComment(completion: @escaping () -> Void){
  //    guard let content = commentTextField.text,
  //          let commentId = commentId else { return }
  //
  //    commentButton.setTitle("수정", for: .normal)
  //    commentButton.addAction(UIAction { _ in
  //      self.commentManager.modifyComment(commentId: commentId ,
  //                                        content: content) {
  //        completion()
  //      }
  //    }, for: .touchUpInside)
  //  }
  //
  //  func afterCommentButtonTapped(){
  //    self.getCommentList {
  //      self.commentTableView.reloadData()
  //
  //      self.tableViewResizing()
  //
  //      let message = self.commentId == nil ? "댓글이 작성됐어요" : "댓글이 수정됐어요"
  //      self.showToast(message: message,imageCheck: false)
  //
  //      self.commentButton.setTitle("등록", for: .normal)
  //      self.commentTextField.text = nil
  //      self.commentTextField.resignFirstResponder()
  //      self.commentId = nil
  //    }
  //  }
  //
  //  // MARK: - 댓글 리스트 가져오기
  //  func getCommentList(completion: @escaping () -> Void){
  //    guard let postId = postedData?.postID else { return }
  //    detailPostDataManager.getCommentPreview(postId: postId) { commentListResult in
  //      self.commentData = commentListResult
  //      self.countComment = commentListResult.count
  //
  //      completion()
  //    }
  //
  //  }
  //
  //  // MARK: - 댓글페이지로 이동
  //  func moveToCommentViewButtonTapped(){
  //    let commentVC = CommentViewController()
  //
  //    guard let postId = postedData?.postID else { return }
  //    commentVC.postId = postId
  //    commentVC.previousVC = self
  //    navigationController?.pushViewController(commentVC, animated: true)
  //  }
  //
  //  // MARK: - 테이블뷰 사이즈 동적으로 조정
  //  func tableViewResizing(){
  //    let tableViewHeight = 86 * (self.commentData?.count ?? 0)
  //    self.commentTableView.snp.updateConstraints {
  //      $0.height.equalTo(tableViewHeight)
  //    }
  //  }
  //
  //  // MARK: - 댓글삭제
  //  func deleteComment(commentId: Int, completion: @escaping () -> Void){
  //    commentManager.deleteComment(commentId: commentId) {
  //      completion()
  //    }
  //  }
  //
  //  // MARK: - 댓글 리로드
  //  func tableViewReload(){
  //    self.getCommentList {
  //      self.commentTableView.reloadData()
  //
  //      self.tableViewResizing()
  //    }
  //  }
  //
  //  // MARK: - 네비게이션바의 deletePost 재정의
  //  override func deletePost() {
  //    guard let postID = postedData?.postID else { return }
  //    let popupVC = PopupViewController(title: "글을 삭제할까요?",
  //                                      desc: "",
  //                                      postID: postID)
  //    popupVC.delegate = self
  //    popupVC.modalPresentationStyle = .overFullScreen
  //
  //    self.present(popupVC, animated: true)
  //  }
  //
  //  // MARK: - 네비게이션바의 modifyPost재정의
  //  override func modifyPost() {
  //    guard let postID = postedData?.postID else { return }
  //    let popupVC = PopupViewController(title: "글을 수정할까요?",
  //                                      desc: "",
  //                                      postID: postID,
  //                                      leftButtonTitle: "아니요",
  //                                      rightButtonTilte: "네")
  //    popupVC.popupView.rightButtonAction = {
  //      self.dismiss(animated: true)
  //
  //      let modifyVC = CreateStudyViewController()
  //      modifyVC.modifyPostID = postID
  //
  //      self.navigationController?.pushViewController(modifyVC, animated: true)
  //    }
  //
  //    popupVC.delegate = self
  //    popupVC.modalPresentationStyle = .overFullScreen
  //
  //    self.present(popupVC, animated: true)
  //  }
  //
  //  // MARK: - 내가 쓴 post의 postid가져오기, 지금 화면이넘어갈때 처음 초기세팅이 잠깐 보였다가 바뀜
  //  func getMyPostID(page: Int = 0,
  //                   size: Int = 5,
  //                   completion: @escaping () -> Void) {
  //    myPostDataManager.fetchMyPostInfo(page: page, size: size) { _ in
  //      let data = self.myPostDataManager.getMyTotalPostData()
  //      guard let last = data?.posts.last else { return }
  //
  //      if last {
  //        let finalData = self.myPostDataManager.getMyTotalPostData()
  //
  //        if let posts = finalData?.posts.myPostcontent {
  //          for i in posts {
  //            self.myPostIDList.append(i.postID)
  //          }
  //        }
  //        completion()
  //      } else {
  //        self.getMyPostID(page: page,
  //                         size: size + 5,
  //                         completion: completion)
  //      }
  //    }
  //  }
  //
  //  // MARK: - 네비게이션바 세팅
  //  override func navigationItemSetting() {
  //    super.navigationItemSetting()
  //
  //    if !myPostIDList.contains(postedData?.postID ?? 0) {
  //      self.navigationItem.rightBarButtonItem = nil
  //    } else {
  //      bottomButtonStackView.isHidden = true
  //    }
  //  }
  //
  //  // MARK: - 참여하기 버튼
  //  func participateButtonTapped(){
  //    guard let studyId = postedData?.studyID else { return }
  //
  //    // close 정보 얻어와야함, 세부내용에 들어가 있을 때 마감이 되면 못하도록..?
  //    userDataManager.getUserInfo { fetchedUserData in
  //      self.userData = fetchedUserData
  //      DispatchQueue.main.async {
  //        if self.userData?.nickname == nil {
  //          self.goToLoginVC()
  //          return
  //        }
  //
  //        if self.postedData?.filteredGender != self.userData?.gender &&
  //            self.postedData?.filteredGender != "NULL" {
  //          self.showToast(message: "이 스터디는 성별 제한이 있는 스터디예요",
  //                         alertCheck: false)
  //          return
  //        }
  //
  //        if self.postedData?.close == true {
  //          self.showToast(message: "이 스터디는 마감된 스터디예요",
  //                         alertCheck: false)
  //          return
  //        }
  //
  //        let participateVC = ParticipateVC()
  //        participateVC.studyId = studyId
  //        participateVC.beforeVC = self
  //        self.navigationController?.pushViewController(participateVC, animated: true)
  //      }
  //    }
  //  }
  //
  //  // MARK: - 참여하기를 눌렀는데 로그인이 안되어 있을 경우
  //  func goToLoginVC(){
  //    DispatchQueue.main.async {
  //      let popupVC = PopupViewController(title: "로그인이 필요해요",
  //                                        desc: "계속하려면 로그인을 해주세요!",
  //                                        rightButtonTilte: "로그인")
  //      self.present(popupVC, animated: true)
  
  //      popupVC.popupView.rightButtonAction = {
  //        self.dismiss(animated: true) {
  //          if let navigationController = self.navigationController {
  //            navigationController.popToRootViewController(animated: false)
  //
  //            let loginVC = LoginViewController()
  //
  //            loginVC.modalPresentationStyle = .overFullScreen
  //            navigationController.present(loginVC, animated: true, completion: nil)
  //          }
  //        }
  //      }
  //    }
  //  }
  //
  //  // MARK: - 북마크 버튼 탭
  //  func bookmarkButtonTappedAtPostedVC(){
  //    guard let postId = postedData?.postID else { return }
  //    bookmarkButtonTapped(postId, 1) {
  //      // 북마크 버튼 누르고 상태 업데이트 필요 -> searchsinglepost로 데이터 받아서 리로드 해야할듯
  //      self.bookmarkStatus()
  //    }
  //  }
  //
  //  // MARK: - 북마크 이미지 확인
  //  func bookmarkStatus(){
  //    bookmarked?.toggle()
  //    let bookmarkImage =  bookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
  //    bookmarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
  //  }
  //}
  //
  //// MARK: - collectionView
//  extension PostedStudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        numberOfItemsInSection section: Int) -> Int {
//      if similarPostCount ?? 0 > 3 { similarPostCount = 3}
//      return similarPostCount ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      
//      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarPostCell.id,
//                                                    for: indexPath)
//      if let cell = cell as? SimilarPostCell {
//        if indexPath.item < postedData?.relatedPost.count ?? 0 {
//          let data = postedData?.relatedPost[indexPath.item]
//          cell.model = data
//        }
//      }
//      return cell
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        didSelectItemAt indexPath: IndexPath) {
//      if let cell = collectionView.cellForItem(at: indexPath) as? SimilarPostCell {
//        let postedVC = PostedStudyViewController()
//        
//        commonNetworking.refreshAccessToken { loginStatus in
//          self.detailPostDataManager.searchSinglePostData(postId: cell.postID ?? 0, loginStatus: loginStatus) {
//            let cellData = self.detailPostDataManager.getPostDetailData()
//            postedVC.postedData = cellData
//          }
//        }
//        
//        self.navigationController?.pushViewController(postedVC, animated: true)
//      }
//    }
//    
//  }
//  
//  extension PostedStudyViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//      return CGSize(width: 250, height: collectionView.frame.height)
//    }
//  }
  //
  //
  //// MARK: - tableview
  //extension PostedStudyViewController: UITableViewDelegate, UITableViewDataSource  {
  //  func tableView(_ tableView: UITableView,
  //                 numberOfRowsInSection section: Int) -> Int {
  //    return commentData?.count ?? 0
  //  }
  //
  //  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  //    let cell = commentTableView.dequeueReusableCell(withIdentifier: CommentCell.cellId,
  //                                                    for: indexPath) as! CommentCell
  //
  //    cell.delegate = self
  //    cell.model = commentData?[indexPath.row]
  //    cell.selectionStyle = .none
  //    cell.contentView.isUserInteractionEnabled = false
  //
  //    return cell
  //  }
  //
  //  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  //    return 86
  //  }
  //}
  //
  //// MARK: - 댓글 입력 시 버튼 활성화
  //extension PostedStudyViewController {
  ////  @objc func textFieldDidChange(_ textField: UITextField) {
  ////    commentManager.commonNetworking.checkingAccessToken { checkResult in
  ////      if checkResult && textField.text?.isEmpty != true && textField.text != "댓글을 입력해주세요" {
  ////        self.commentButton.backgroundColor = .o50
  ////        self.commentButton.isEnabled = true
  ////      }
  ////    }
  ////  }
  //}
  //
  //// MARK: - cell에 메뉴버튼 눌렀을 때
  //extension PostedStudyViewController: CommentCellDelegate {
  //  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
  //    let bottomSheetVC = BottomSheet(postID: commentId)
  //    bottomSheetVC.delegate = self
  //
  //    if #available(iOS 15.0, *) {
  //      if let sheet = bottomSheetVC.sheetPresentationController {
  //        if #available(iOS 16.0, *) {
  //          sheet.detents = [.custom(resolver: { context in
  //            return 228.0
  //          })]
  //        } else {
  //          // Fallback on earlier versions
  //        }
  //        sheet.largestUndimmedDetentIdentifier = nil
  //        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
  //        sheet.prefersEdgeAttachedInCompactHeight = true
  //        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
  //        sheet.preferredCornerRadius = 20
  //      }
  //    } else {
  //      // Fallback on earlier versions
  //    }
  //    present(bottomSheetVC, animated: true, completion: nil)
  //  }
  //
  //}
  //
  //extension PostedStudyViewController: BottomSheetDelegate {
  //  func firstButtonTapped(postID: Int?) {
  //    self.commentTextField.text = nil
  //    self.commentTextField.resignFirstResponder()
  //
  //    let popupVC = PopupViewController(title: "댓글을 삭제할까요?",
  //                                      desc: "")
  //    popupVC.modalPresentationStyle = .overFullScreen
  //
  //    self.present(popupVC, animated: true)
  //
  //    popupVC.popupView.rightButtonAction = {
  //      self.dismiss(animated: true) {
  //        DispatchQueue.main.async {
  //          self.deleteComment(commentId: postID ?? 0) {
  //            self.getCommentList {
  //              self.showToast(message: "댓글이 삭제됐어요.",
  //                             imageCheck: false)
  //              self.tableViewResizing()
  //            }
  //          }
  //        }
  //      }
  //    }
  //  }
  //
  //  func secondButtonTapped(postID: Int?) {
  //    commentButton.setTitle("수정", for: .normal)
  //    commentId = postID
  //  }
  //}
  //
  //// MARK: - 네비게이션바 아이템으로 삭제 후 작업, 서치뷰도 있음..
  //extension PostedStudyViewController: PopupViewDelegate {
  //  func afterDeletePost(completion: @escaping () -> Void) {
  //    navigationController?.popViewController(animated: true)
  //    if (previousHomeVC != nil) {
  //      //      previousHomeVC?.fetchData(loginStatus: true)
  //    }else {
  //      previousMyPostVC?.afterDeletePost {
  //        print("삭제 후 마이페이")
  //      }
  //    }
  //  }
  //}
  //
  //extension PostedStudyViewController: CheckLoginDelegate {
  //  func checkLoginPopup(checkUser: Bool) {
  //    self.commentTextField.text = nil
  //    self.commentTextField.resignFirstResponder()
  //
  //    checkLoginStatus(checkUser: checkUser)
  //  }
  //}
}
