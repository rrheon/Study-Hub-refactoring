//
//  PostedStudyViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/30.
//

import UIKit

import SnapKit
import Kingfisher
import Moya

final class PostedStudyViewController: NaviHelper {

  let detailPostDataManager = PostDetailInfoManager.shared
  let myPostDataManager = MyPostInfoManager.shared
  let createPostManager = PostManager.shared
  let userDataManager = UserInfoManager.shared
  let commentManager = CommentManager.shared
  
  var commentId: Int?
  var bookmarked: Bool?
  var participateCheck: Bool?
  
  // 이전페이지의 종류가 스터디VC , 검색결과 VC도 있음
  var previousHomeVC: HomeViewController?
  var previousMyPostVC: MyPostViewController?
  var previousStudyVC: StudyViewController?
  var previousSearchVC: SearchViewController?
  var previousBookMarkVC: BookmarkViewController?
  
  var myPostIDList: [Int] = []
  var userData: UserDetailData?
  var similarPostCount: Int?
  
  // 여기에 데이터가 들어오면 관련 UI에 데이터 넣어줌
  var postedData: PostDetailData? {
    didSet {
      self.getCommentList {
        DispatchQueue.main.async {
          print(self.postedData)
          self.redrawUI()

          self.setUpLayout()
          self.makeUI()
        }
      }
    }
  }
  
  var commentData: [CommentConetent]? {
    didSet {
      DispatchQueue.main.async {
        self.commentTableView.reloadData()
      }
    }
  }
  
  var memberNumberCount: Int = 0 {
    didSet {
      var possibleNum = memberNumberCount - (postedData?.remainingSeat ?? 0)
      memeberNumberCountLabel.text = "\(possibleNum) /\(memberNumberCount)명"
      memeberNumberCountLabel.changeColor(label: memeberNumberCountLabel,
                                          wantToChange: "\(possibleNum)",
                                          color: .changeInfo)
    }
  }
  
  var fineCount: Int = 0 {
    didSet{
      if fineCount == 0 {
        fineAmountLabel.text = "없어요"
        fineCountLabel.text = "없어요"
      }else {
        fineCountLabel.text = "\(fineCount)원"
        fineCountLabel.changeColor(label: fineCountLabel,
                                   wantToChange: "\(fineCount)",
                                   color: .changeInfo)
        
        fineAmountLabel.text = "\(postedData?.penaltyWay ?? "") \(fineCount)원"
      }
    }
  }
  
  var gender: String = "무관" {
    didSet {
      fixedGenderLabel.text = "\(gender)"
    }
  }
  
  // 작성일, 관련학과, 제목
  private lazy var postedDateLabel = createLabel(title: "2023-10-31",
                                                 textColor: .g70,
                                                 fontType: "Pretendard-Medium",
                                                 fontSize: 12)
  
  private lazy var postedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = "세무회계학과"
    label.textColor = .o30
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    label.backgroundColor = .o60
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var postedMajorStackView = createStackView(axis: .horizontal,
                                                          spacing: 10)
  
  private lazy var postedTitleLabel = createLabel(title: "전산세무 같이 준비해요",
                                                  textColor: .white,
                                                  fontType: "Pretendard-Bold",
                                                  fontSize: 20)
  
  private lazy var postedInfoStackView = createStackView(axis: .vertical, spacing: 10)
  
  // 팀원수 관련
  private lazy var memeberNumberLabel = createLabel(title: "팀원수",
                                                    textColor: .g60,
                                                    fontType: "Pretendard-SemiBold",
                                                    fontSize: 12)
  private lazy var memberImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MemberNumberImage")
    return imageView
  }()
  
  private lazy var memeberNumberCountLabel = createLabel(title: "1" + "/30명",
                                                         textColor: .white,
                                                         fontType: "Pretendard-SemiBold",
                                                         fontSize: 16)
  
  private lazy var memberNumberStackView = createStackView(axis: .vertical,
                                                           spacing: 8)
  // 벌금 관련
  private lazy var fineLabel = createLabel(title: "벌금",
                                           textColor: .g60,
                                           fontType: "Pretendard-SemiBold",
                                           fontSize: 12)
  
  private lazy var fineImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MoneyImage")
    
    return imageView
  }()
  
  private lazy var fineCountLabel = createLabel(title: "1000"+"원",
                                                textColor: .white,
                                                fontType: "Pretendard-SemiBold",
                                                fontSize: 16)
  
  private lazy var fineStackView = createStackView(axis: .vertical,
                                                   spacing: 8)
  // 성별 관련
  private lazy var genderLabel = createLabel(title: "성별",
                                             textColor: .g60,
                                             fontType: "Pretendard-SemiBold",
                                             fontSize: 12)
  
  private lazy var genderImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "GenderImage")
    
    return imageView
  }()
  
  private lazy var fixedGenderLabel = createLabel(title: "여자",
                                                  textColor: .white,
                                                  fontType: "Pretendard-SemiBold",
                                                  fontSize: 16)
  
  private lazy var genderStackView = createStackView(axis: .vertical,
                                                     spacing: 8)
  
  private lazy var spaceView4 = UIView()
  private lazy var spaceView5 = UIView()
  
  private lazy var redesignCoreInfoStackView = createStackView(axis: .horizontal,
                                                               spacing: 10)
  // 팀원수, 벌금, 성별 들어감
  private lazy var coreInfoStackView = createStackView(axis: .horizontal,
                                                       spacing: 10)
  // 페이지 위에 정보 들어감
  private lazy var topInfoStackView = createStackView(axis: .vertical,
                                                      spacing: 12)
  private lazy var spaceView = UIView()
  
  // 소개, 소개내용 , 회색구분선
  private lazy var aboutStudyLabel = createLabel(title: "소개",
                                                 textColor: .bg90,
                                                 fontType: "Pretendard-SemiBold",
                                                 fontSize: 14)
  
  private lazy var aboutStudyDeatilLabel = createLabel(
    title: "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14)
  
  private lazy var aboutStudyStackView = createStackView(axis: .vertical,
                                                         spacing: 10)
  
  // 기간,벌금,대면여부, 관련학과
  private lazy var periodTitleLabel = createLabel(title: "기간",
                                                  textColor: .bg90,
                                                  fontType: "Pretendard-SemiBold",
                                                  fontSize: 14)
  
  private lazy var periodLabel = createLabel(title: "2023.9.12 ~ 2023.12.30",
                                             textColor: .bg80,
                                             fontType: "Pretendard-Medium",
                                             fontSize: 14)
  
  private lazy var fineTitleLabel = createLabel(title: "벌금",
                                                textColor: .bg90,
                                                fontType: "Pretendard-SemiBold",
                                                fontSize: 14)
  
  private lazy var fineAmountLabel = createLabel(title: "결석비  " + "1000원",
                                                 textColor: .bg80,
                                                 fontType: "Pretendard-Medium",
                                                 fontSize: 14)
  
  private lazy var meetTitleLabel = createLabel(title: "대면여부",
                                                textColor: .bg90,
                                                fontType: "Pretendard-SemiBold",
                                                fontSize: 14)
  
  private lazy var meetLabel = createLabel(title: "혼합",
                                           textColor: .bg80,
                                           fontType: "Pretendard-Medium",
                                           fontSize: 14)
  
  private lazy var majorTitleLabel = createLabel(title: "관련학과",
                                                 textColor: .bg90,
                                                 fontType: "Pretendard-SemiBold",
                                                 fontSize: 14)
  
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = "세무회계학과"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.backgroundColor = .bg30
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var majorStackView = createStackView(axis: .horizontal,
                                                    spacing: 10)
  
  private lazy var detailInfoStackView = createStackView(axis: .vertical,
                                                         spacing: 10)
  private lazy var spaceView6 = UIView()
  private lazy var spaceView7 = UIView()
  private lazy var spaceView8 = UIView()
  
  private lazy var periodStackView = createStackView(axis: .horizontal,
                                                     spacing: 10)
  private lazy var fineInfoStackView = createStackView(axis: .horizontal,
                                                       spacing: 10)
  private lazy var meetStackView = createStackView(axis: .horizontal,
                                                   spacing: 10)
  
  private lazy var periodImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "CalenderImage")
    imageView.contentMode = .left
    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return imageView
  }()
  
  private lazy var meetImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MixMeetImage")
    imageView.contentMode = .left
    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return imageView
  }()
  
  private lazy var smallFineImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MoneyImage")
    imageView.contentMode = .left
    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return imageView
  }()
  
  private lazy var grayDividerLine2 = createGrayDividerLine(8.0)
  
  // 작성자 정보
  private lazy var writerLabel = createLabel(title: "작성자",
                                             textColor: .black,
                                             fontType: "Pretendard-SemiBold",
                                             fontSize: 16)
  
  private lazy var profileImageStackView = createStackView(axis: .vertical,
                                                           spacing: 10)
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ProfileAvatar")
    imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    return imageView
  }()
  
  private lazy var writerMajorLabel = createLabel(title: "세무회계학과",
                                                  textColor: .bg80,
                                                  fontType: "Pretendard-Medium",
                                                  fontSize: 14)
  
  private lazy var nickNameLabel = createLabel(title: "비어있음",
                                               textColor: .black,
                                               fontType: "Pretendard-Medium",
                                               fontSize: 16)
  // 학과, 닉네임 스택
  
  private lazy var writerInfoStackView = createStackView(axis: .vertical,
                                                         spacing: 5)
  // 학과 닉네임 이미지 스택
  private lazy var writerInfoWithImageStackView = createStackView(axis: .horizontal,
                                                                  spacing: 10)
  // 학과 닉네임 이미지 작성자 스택
  private lazy var totalWriterInfoStackView = createStackView(axis: .vertical,
                                                              spacing: 20)
  private lazy var spaceView1 = UIView()
  
  private lazy var grayDividerLine3 = createGrayDividerLine(8.0)
  

  // 댓글
  private lazy var countComment: Int = 0 {
    didSet {
      commentLabel.text = "댓글 \(countComment)"
      
      let buttonStatus = countComment > 0 ? false : true
      moveToCommentViewButton.isHidden = buttonStatus
    }
  }
  
  private lazy var commentLabel = createLabel(title: "댓글 0",
                                              textColor: .black,
                                              fontType: "Pretendard-SemiBold",
                                              fontSize: 16)
  
  private lazy var moveToCommentViewButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "RightArrow"), for: .normal)
    button.tintColor = .black
    button.addAction(UIAction { _ in
      self.moveToCommentViewButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var commentLabelStackView = createStackView(axis: .horizontal, spacing: 10)
  
  
  private lazy var grayDividerLine4 = createGrayDividerLine(1.0)
  
  private lazy var commentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommentCell.self,
                       forCellReuseIdentifier: CommentCell.cellId)
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    
    return tableView
  }()
  
  
  private lazy var commentStackView = createStackView(axis: .vertical, spacing: 10)
  
  private lazy var commentTextField = createTextField(title: "댓글을 입력해주세요")
  
  private lazy var commentButton: UIButton = {
    let button = UIButton()
    button.setTitle("등록", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o30
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      if self.commentId != nil {
        self.modifyComment {
          self.afterCommentButtonTapped()
        }
      } else {
        self.commentButtonTapped {
          self.afterCommentButtonTapped()
        }
      }
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var commentButtonStackView = createStackView(axis: .horizontal, spacing: 8)
  
  private lazy var grayDividerLine5 = createGrayDividerLine(8.0)
  
  // 비슷한 게시글
  private lazy var similarPostLabel = createLabel(title: "이 글과 비슷한 스터디예요",
                                                  textColor: .black,
                                                  fontType: "Pretendard-SemiBold",
                                                  fontSize: 18)
  
  private lazy var similarCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50 // cell사이의 간격 설정
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    
    return view
  }()
  
  private lazy var similarPostStackView = createStackView(axis: .vertical,
                                                          spacing: 20)
  
  // 회색 라인 생성
  private lazy var createGrayDividerLine: (CGFloat) -> UIView = { size in
    let dividerLine = UIView()
    dividerLine.backgroundColor = .bg30
    dividerLine.heightAnchor.constraint(equalToConstant: size).isActive = true
    dividerLine.translatesAutoresizingMaskIntoConstraints = false
    return dividerLine
  }
  
  // 참여하기, 북마크버튼
  private var buttonImage: Bool = false {
    didSet{
      let buttonImage = buttonImage ? "BookMarkChecked" : "BookMarkLightImg"
      self.bookmarkButton.setImage(UIImage(named: buttonImage), for: .normal)
    }
  }
  
  private lazy var bookmarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    button.addAction(UIAction { _ in
      self.bookmarkButtonTappedAtPostedVC()
    } , for: .touchUpInside)
    return button
  }()
  
  private lazy var participateButton: UIButton = {
    let button = UIButton()
    button.setTitle("참여하기", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = .o50
    button.layer.cornerRadius = 10
    button.addAction(UIAction { _ in
      self.participateButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var bottomButtonStackView = createStackView(axis: .horizontal, spacing: 10)
  
  
  // 전체 요소를 담는 스택
  private lazy var pageStackView = createStackView(axis: .vertical,
                                                   spacing: 10)
  
  private lazy var scrollView: UIScrollView = UIScrollView()
  
  // MARK: - 뒤로 이동
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent {
      
      if let homeVC = previousHomeVC {
        homeVC.reloadHomeVCCells()
      }
      
      if let studyVC = previousStudyVC {
        studyVC.recentButtonTapped()
      }
      
      if let searchVC = previousSearchVC {
        searchVC.allButtonTapped()
      }
      
      if let bookmarkVC = previousBookMarkVC {
        bookmarkVC.reloadBookmarkList()
      }
      
    }
  }

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItemSetting()
    
    let test = CommonNetworking.shared
    test.delegate = self
    
    DispatchQueue.main.async {
      self.getMyPostID {
        self.navigationItemSetting()
      }
    }
    
    view.backgroundColor = .white
    
    setupDelegate()
    registerCell()
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    // 게시일, 관련학과, 제목
    let spaceView9 = UIView()
    let postedMajorData = [postedMajorLabel, spaceView9]
    for view in postedMajorData {
      postedMajorStackView.addArrangedSubview(view)
    }
    
    var spaceViewUnderTitle = UIView()
    let postedInfoData = [postedDateLabel, postedMajorStackView, postedTitleLabel,spaceViewUnderTitle]
    for view in postedInfoData {
      postedInfoStackView.addArrangedSubview(view)
    }
    // 인원수
    memberNumberStackView.alignment = .center
    let memberNumberData = [memeberNumberLabel, memberImageView, memeberNumberCountLabel]
    for view in memberNumberData {
      memberNumberStackView.addArrangedSubview(view)
    }
    // 벌금
    fineStackView.alignment = .center
    let fineData = [fineLabel,fineImageView,fineCountLabel]
    for view in fineData {
      fineStackView.addArrangedSubview(view)
    }
    // 성별
    genderStackView.alignment = .center
    let genderData = [genderLabel, genderImageView, fixedGenderLabel]
    for view in genderData {
      genderStackView.addArrangedSubview(view)
    }
    
    let spaceView12 = UIView()
    let coreInfoData = [memberNumberStackView, fineStackView, genderStackView, spaceView12]
    for view in coreInfoData {
      coreInfoStackView.addArrangedSubview(view)
    }
    
    let redesignData = [spaceView4,coreInfoStackView,spaceView5]
    for view in redesignData {
      redesignCoreInfoStackView.addArrangedSubview(view)
    }
    
    let topInfoData = [postedInfoStackView, redesignCoreInfoStackView, spaceView]
    for view in topInfoData{
      topInfoStackView.addArrangedSubview(view)
    }
    
    // 소개
    let grayDividerLine1 = createGrayDividerLine(1.0)
    let aboutStudyData = [aboutStudyLabel, aboutStudyDeatilLabel, grayDividerLine1]
    for view in aboutStudyData {
      aboutStudyStackView.addArrangedSubview(view)
    }
    
    // 기간, 벌금, 대면여부, 관련학과
    let periodData = [periodImageView, periodLabel, spaceView6]
    for view in periodData {
      periodStackView.addArrangedSubview(view)
    }
    
    let fineInfoData = [smallFineImageView, fineAmountLabel, spaceView7]
    for view in fineInfoData {
      fineInfoStackView.addArrangedSubview(view)
    }
    
    let meetData = [meetImageView, meetLabel, spaceView8]
    for view in meetData {
      meetStackView.addArrangedSubview(view)
    }
    
    majorLabel.backgroundColor = .bg30
    
    let spaceView10 = UIView()
    let majorData = [majorLabel, spaceView10]
    for view in majorData {
      majorStackView.addArrangedSubview(view)
    }
    
    let detailInfo = [periodTitleLabel, periodStackView,
                      fineTitleLabel, fineInfoStackView,
                      meetTitleLabel, meetStackView,
                      majorTitleLabel, majorStackView]
    
    for view in detailInfo {
      detailInfoStackView.addArrangedSubview(view)
    }
    
    // 작성자 정보
    
    let spaceViewTopUsermajorLabel = UIView()
    let spaceViewUnderNicknameLabel = UIView()
    let writerData = [spaceViewTopUsermajorLabel, writerMajorLabel,
                      nickNameLabel, spaceViewUnderNicknameLabel]
    for view in writerData {
      writerInfoStackView.addArrangedSubview(view)
    }
    
    
    let writerDataWithImage = [profileImageView, writerInfoStackView, spaceView1]
    for view in writerDataWithImage {
      writerInfoWithImageStackView.addArrangedSubview(view)
    }
    
    // 댓글 라벨
    [
      commentLabel,
      moveToCommentViewButton
    ].forEach {
      commentLabelStackView.addArrangedSubview($0)
    }
    
    if countComment == 0 {
      moveToCommentViewButton.isHidden = true
    }
    
    commentStackView.addArrangedSubview(commentTableView)
    
    let commentInfo = [commentTextField, commentButton]
    for view in commentInfo {
      commentButtonStackView.addArrangedSubview(view)
    }
    
    let spaceView8 = UIView()
    let totalWriterData = [writerLabel, writerInfoWithImageStackView,
                           spaceView8]
    for view in totalWriterData {
      totalWriterInfoStackView.addArrangedSubview(view)
    }
        
    // 유사 스터디 추천
    let spaceView11 = UIView()
    let collectionView = [similarPostLabel,similarCollectionView, spaceView11]
    for view in collectionView {
      similarPostStackView.addArrangedSubview(view)
    }
    
    // 북마크, 참여하기버튼
    [
      bookmarkButton,
      participateButton
    ].forEach {
      bottomButtonStackView.addArrangedSubview($0)
    }
    
    
    // 전체 페이지
    [
      topInfoStackView,
      aboutStudyStackView,
      detailInfoStackView,
      grayDividerLine2,
      totalWriterInfoStackView,
      grayDividerLine3,
      commentLabelStackView,
      commentStackView,
      grayDividerLine4,
      commentButtonStackView,
      grayDividerLine5,
      similarPostStackView,
      bottomButtonStackView
    ].forEach {
      pageStackView.addArrangedSubview($0)
    }
    
    scrollView.addSubview(pageStackView)
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    coreInfoStackView.distribution = .fillProportionally
    coreInfoStackView.backgroundColor = .deepGray
    
    topInfoStackView.backgroundColor = .black
    
    postedMajorLabel.backgroundColor = .postedMajorBackGorund
    
    // 스터디 제목
    postedInfoStackView.layoutMargins = UIEdgeInsets(top: 50, left: 10, bottom: 0, right: 0)
    postedInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    // 인원수 벌금 성별여부
    [
      periodStackView,
      fineInfoStackView,
      meetStackView,
      majorStackView
    ].forEach {
      $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
      $0.isLayoutMarginsRelativeArrangement = true
    }
 
    coreInfoStackView.spacing = 10  // 수평 여백 설정
    coreInfoStackView.layer.cornerRadius = 10
    coreInfoStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
    coreInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    redesignCoreInfoStackView.distribution = .fillProportionally
    
    spaceView.snp.makeConstraints { make in
      make.height.equalTo(20)
    }
    
    // 스터디 소개
    aboutStudyStackView.backgroundColor = .white
    aboutStudyDeatilLabel.numberOfLines = 0
    aboutStudyStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10)
    aboutStudyStackView.isLayoutMarginsRelativeArrangement = true
    
    // 기간 벌금 대면여부 관련학과
    detailInfoStackView.backgroundColor = .white
    detailInfoStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 10)
    detailInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    // 작성자 정보
    writerInfoWithImageStackView.distribution = .fillProportionally
    
    totalWriterInfoStackView.backgroundColor = .white
    totalWriterInfoStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 10)
    totalWriterInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    spaceView1.snp.makeConstraints { make in
      make.width.equalTo(180)
    }
    
    moveToCommentViewButton.snp.makeConstraints {
      $0.height.width.equalTo(32)
    }
    
    commentLabelStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    commentLabelStackView.isLayoutMarginsRelativeArrangement = true
    
    // 양옆 여백 필요
    let tableViewHeight = 86 * countComment
    
    commentTableView.snp.makeConstraints {
      $0.height.equalTo(tableViewHeight)
    }
    
    commentStackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 20)
    commentStackView.isLayoutMarginsRelativeArrangement = true
    
    commentButton.isEnabled = false
    
    commentButtonStackView.distribution = .fillProportionally
    commentButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    commentButtonStackView.isLayoutMarginsRelativeArrangement = true
    
    commentTextField.snp.makeConstraints {
      $0.height.equalTo(42)
    }
    
    commentTextField.addTarget(self,
                               action: #selector(textFieldDidChange(_:)),
                               for: .editingChanged)
    
    // 비슷한 게시글
    similarPostStackView.backgroundColor = .white
    similarPostStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 30, right: 10)
    similarPostStackView.isLayoutMarginsRelativeArrangement = true
    
    similarCollectionView.snp.makeConstraints { make in
      make.height.equalTo(171)
    }
    
    // 북마크 참여하기버튼
    bottomButtonStackView.distribution = .fillProportionally
    bottomButtonStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    bottomButtonStackView.isLayoutMarginsRelativeArrangement = true
    
    participateButton.snp.makeConstraints {
      $0.height.equalTo(55)
      $0.width.equalTo(283)
    }
    
    // pageStackView의 설정
    pageStackView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.contentLayoutGuide)
      make.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
      make.width.equalTo(view.safeAreaLayoutGuide)
    }
    
    // scrollView의 설정
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
  }

  // MARK: - collectionview 관련
  private func setupDelegate() {
    similarCollectionView.delegate = self
    similarCollectionView.dataSource = self
    similarCollectionView.tag = 1
    
    commentTableView.delegate = self
    commentTableView.dataSource = self
  }
  
  private func registerCell() {
    similarCollectionView.register(SimilarPostCell.self,
                            forCellWithReuseIdentifier: SimilarPostCell.id)
  }
  
  // MARK: - 데이터 받아오고 ui다시 그리는 함수
  func redrawUI(){
    if let postDate = self.postedData?.createdDate {
      self.postedDateLabel.text = "\(postDate[0]). \(postDate[1]). \(postDate[2])"
    }
    
    bookmarked = postedData?.bookmarked
    let bookmarkImage = bookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
    bookmarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    
    let major = self.convertMajor(self.postedData?.major ?? "", isEnglish: false)
    self.postedMajorLabel.text = "\(major)"
    self.postedTitleLabel.text = self.postedData?.title
    self.memberNumberCount = self.postedData?.remainingSeat ?? 0
    self.fineCount = self.postedData?.penalty ?? 0
    
    self.gender = self.convertGender(gender: self.postedData?.filteredGender ?? "무관")
    
    if gender == "남자" {
      genderImageView.image = UIImage(named: "MenGenderImage")
    } else if gender == "여자" {
      genderImageView.image = UIImage(named: "GenderImage")
    } else {
      genderImageView.image = UIImage(named: "GenderMixImg")
    }
    
    
    self.aboutStudyDeatilLabel.text = self.postedData?.content
    
    guard let startDate = self.postedData?.studyStartDate,
          let endDate = self.postedData?.studyEndDate else { return }
    
    self.periodLabel.text = "\(startDate[0]). \(startDate[1]). \(startDate[2]) ~ \(endDate[0]). \(endDate[1]). \(endDate[2])"
    self.meetLabel.text = self.convertStudyWay(wayToStudy: self.postedData?.studyWay ?? "혼합")
    
    let convertedMajor = self.convertMajor(self.postedData?.major ?? "",
                                           isEnglish: false)
    self.majorLabel.text = "\(convertedMajor)"
    
    self.writerMajorLabel.text = self.convertMajor(self.postedData?.postedUser.major ?? "",
                                                   isEnglish: false)
    self.nickNameLabel.text = self.postedData?.postedUser.nickname
    
    if let imageURL = URL(string: postedData?.postedUser.imageURL ?? "") {
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50))
            
      self.profileImageView.kf.setImage(with: imageURL,
                                        options: [.processor(processor)]) { result in
        switch result {
        case .success(let value):
          DispatchQueue.main.async {
            self.profileImageView.image = value.image
            self.profileImageView.layer.cornerRadius = 25
            self.profileImageView.clipsToBounds = true
          }
        case .failure(let error):
          print("Image download failed: \(error)")
        }
      }
    }
    
    if postedData?.apply == true || participateCheck == true {
      participateButton.setTitle("수락 대기 중", for: .normal)
      participateButton.backgroundColor = .o30
      participateButton.isEnabled = false
    }
    
    if postedData?.close == true {
      participateButton.setTitle("마감 됐어요.", for: .normal)
      participateButton.backgroundColor = .o30
      participateButton.isEnabled = false
    }
    
    similarPostCount = postedData?.relatedPost.count
    if similarPostCount == 0 {
      similarPostStackView.isHidden = true
    }
    
    similarCollectionView.reloadData()
  }
  
  // MARK: - 댓글 작성하기
  func commentButtonTapped(completion: @escaping () -> Void){
    guard let postId = postedData?.postID,
          let content = commentTextField.text else { return }
    commentManager.createComment(content: content,
                                 postId: postId) {
      completion()
    }
  }
  
  // MARK: - 댓글 수정하기
  func modifyComment(completion: @escaping () -> Void){
    guard let content = commentTextField.text,
          let commentId = commentId else { return }
    
    commentButton.setTitle("수정", for: .normal)
    commentButton.addAction(UIAction { _ in
      self.commentManager.modifyComment(commentId: commentId ,
                                        content: content) {
        completion()
      }
    }, for: .touchUpInside)
  }

  func afterCommentButtonTapped(){
    self.getCommentList {
      self.commentTableView.reloadData()
      
      self.tableViewResizing()
      
      let message = self.commentId == nil ? "댓글이 작성됐어요" : "댓글이 수정됐어요"
      self.showToast(message: message,imageCheck: false)
      
      self.commentButton.setTitle("등록", for: .normal)
      self.commentTextField.text = nil
      self.commentTextField.resignFirstResponder()
      self.commentId = nil
    }
  }
  
  // MARK: - 댓글 리스트 가져오기
  func getCommentList(completion: @escaping () -> Void){
    guard let postId = postedData?.postID else { return }
    detailPostDataManager.getCommentPreview(postId: postId) { commentListResult in
      self.commentData = commentListResult
      self.countComment = commentListResult.count
      
      completion()
    }

  }
  
  // MARK: - 댓글페이지로 이동
  func moveToCommentViewButtonTapped(){
    let commentVC = CommentViewController()
    
    guard let postId = postedData?.postID else { return }
    commentVC.postId = postId
    commentVC.previousVC = self
    navigationController?.pushViewController(commentVC, animated: true)
  }
  
  // MARK: - 테이블뷰 사이즈 동적으로 조정
  func tableViewResizing(){
    let tableViewHeight = 86 * (self.commentData?.count ?? 0)
    self.commentTableView.snp.updateConstraints {
      $0.height.equalTo(tableViewHeight)
    }
  }
  
  // MARK: - 댓글삭제
  func deleteComment(commentId: Int, completion: @escaping () -> Void){
    commentManager.deleteComment(commentId: commentId) {
      completion()
    }
  }
  
  // MARK: - 댓글 리로드
  func tableViewReload(){
    self.getCommentList {
      self.commentTableView.reloadData()
      
      self.tableViewResizing()
    }
  }
  
  // MARK: - 네비게이션바의 deletePost 재정의
  override func deletePost() {
    guard let postID = postedData?.postID else { return }
    let popupVC = PopupViewController(title: "글을 삭제할까요?",
                                      desc: "",
                                      postID: postID)
    popupVC.delegate = self
    popupVC.modalPresentationStyle = .overFullScreen

    self.present(popupVC, animated: true)
  }
  
  // MARK: - 네비게이션바의 modifyPost재정의
  override func modifyPost() {
    guard let postID = postedData?.postID else { return }
    let popupVC = PopupViewController(title: "글을 수정할까요?",
                                      desc: "",
                                      postID: postID,
                                      leftButtonTitle: "아니요",
                                      rightButtonTilte: "네")
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)
      
      let modifyVC = CreateStudyViewController()
      modifyVC.modifyPostID = postID
      
      self.navigationController?.pushViewController(modifyVC, animated: true)
    }
    
    popupVC.delegate = self
    popupVC.modalPresentationStyle = .overFullScreen

    self.present(popupVC, animated: true)
  }
  
  // MARK: - 내가 쓴 post의 postid가져오기, 지금 화면이넘어갈때 처음 초기세팅이 잠깐 보였다가 바뀜
  func getMyPostID(page: Int = 0,
                   size: Int = 5,
                   completion: @escaping () -> Void) {
    myPostDataManager.fetchMyPostInfo(page: page, size: size) { _ in
      let data = self.myPostDataManager.getMyTotalPostData()
      guard let last = data?.posts.last else { return }
      
      if last {
        let finalData = self.myPostDataManager.getMyTotalPostData()
        
        if let posts = finalData?.posts.myPostcontent {
          for i in posts {
            self.myPostIDList.append(i.postID)
          }
        }
        completion()
      } else {
        self.getMyPostID(page: page,
                         size: size + 5,
                         completion: completion)
      }
    }
  }

  // MARK: - 네비게이션바 세팅
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    if !myPostIDList.contains(postedData?.postID ?? 0) {
      self.navigationItem.rightBarButtonItem = nil
    } else {
      bottomButtonStackView.isHidden = true
    }
  }

  // MARK: - 참여하기 버튼
  func participateButtonTapped(){
    guard let studyId = postedData?.studyID else { return }
    
    // close 정보 얻어와야함, 세부내용에 들어가 있을 때 마감이 되면 못하도록..?
    userDataManager.getUserInfo { fetchedUserData in
      self.userData = fetchedUserData
      DispatchQueue.main.async {
        if self.userData?.nickname == nil {
          self.goToLoginVC()
          return
        }
        
        if self.postedData?.filteredGender != self.userData?.gender &&
            self.postedData?.filteredGender != "NULL" {
          self.showToast(message: "이 스터디는 성별 제한이 있는 스터디예요",
                         alertCheck: false)
          return
        }
        
        if self.postedData?.close == true {
          self.showToast(message: "이 스터디는 마감된 스터디예요",
                         alertCheck: false)
          return
        }
        
        let participateVC = ParticipateVC()
        participateVC.studyId = studyId
        participateVC.beforeVC = self
        self.navigationController?.pushViewController(participateVC, animated: true)
      }
    }
  }
  
  // MARK: - 참여하기를 눌렀는데 로그인이 안되어 있을 경우
  func goToLoginVC(){
    DispatchQueue.main.async {
      let popupVC = PopupViewController(title: "로그인이 필요해요",
                                        desc: "계속하려면 로그인을 해주세요!",
                                        rightButtonTilte: "로그인")
      self.present(popupVC, animated: true)
     
      popupVC.popupView.rightButtonAction = {
        self.dismiss(animated: true) {
          if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: false)
            
            let loginVC = LoginViewController()
            
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController.present(loginVC, animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  // MARK: - 북마크 버튼 탭
  func bookmarkButtonTappedAtPostedVC(){
    guard let postId = postedData?.postID else { return }
    bookmarkButtonTapped(postId, 1) {
      // 북마크 버튼 누르고 상태 업데이트 필요 -> searchsinglepost로 데이터 받아서 리로드 해야할듯
      self.bookmarkStatus()
    }
  }
  
  // MARK: - 북마크 이미지 확인
  func bookmarkStatus(){
    bookmarked?.toggle()
    let bookmarkImage =  bookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
    bookmarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
  }
}

// MARK: - collectionView
extension PostedStudyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if similarPostCount ?? 0 > 3 { similarPostCount = 3}
    return similarPostCount ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarPostCell.id,
                                                    for: indexPath)
      if let cell = cell as? SimilarPostCell {
        if indexPath.item < postedData?.relatedPost.count ?? 0 {
          let data = postedData?.relatedPost[indexPath.item]
          cell.model = data
        }
      }
      return cell
  }


  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? SimilarPostCell {
      let postedVC = PostedStudyViewController()
      
      loginManager.refreshAccessToken { loginStatus in
        self.detailPostDataManager.searchSinglePostData(postId: cell.postID ?? 0, loginStatus: loginStatus) {
          let cellData = self.detailPostDataManager.getPostDetailData()
          postedVC.postedData = cellData
        }
      }
   
      self.navigationController?.pushViewController(postedVC, animated: true)
    }
  }
  
}

extension PostedStudyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 250, height: collectionView.frame.height)
  }
}


// MARK: - tableview
extension PostedStudyViewController: UITableViewDelegate, UITableViewDataSource  {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return commentData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = commentTableView.dequeueReusableCell(withIdentifier: CommentCell.cellId,
                                                    for: indexPath) as! CommentCell
    
    cell.delegate = self
    cell.model = commentData?[indexPath.row]
    cell.selectionStyle = .none
    cell.contentView.isUserInteractionEnabled = false
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 86
  }
}

// MARK: - 댓글 입력 시 버튼 활성화
extension PostedStudyViewController {
  @objc func textFieldDidChange(_ textField: UITextField) {
    if textField.text?.isEmpty != true && textField.text != "댓글을 입력해주세요" {
      commentButton.backgroundColor = .o50
      commentButton.isEnabled = true
    }
  }
}

// MARK: - cell에 메뉴버튼 눌렀을 때
extension PostedStudyViewController: CommentCellDelegate {
  func menuButtonTapped(in cell: CommentCell, commentId: Int) {
    let bottomSheetVC = BottomSheet(postID: commentId)
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

}

extension PostedStudyViewController: BottomSheetDelegate {
  func firstButtonTapped(postID: Int?) {
    self.commentTextField.text = nil
    self.commentTextField.resignFirstResponder()
    
    let popupVC = PopupViewController(title: "댓글을 삭제할까요?",
                                      desc: "")
    popupVC.modalPresentationStyle = .overFullScreen

    self.present(popupVC, animated: true)
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true) {
        DispatchQueue.main.async {
          self.deleteComment(commentId: postID ?? 0) {
            self.getCommentList {
              self.showToast(message: "댓글이 삭제됐어요.",
                             imageCheck: false)
              self.tableViewResizing()
            }
          }
        }
      }
    }
  }
  
  func secondButtonTapped(postID: Int?) {
    commentButton.setTitle("수정", for: .normal)
    commentId = postID
  }
}

// MARK: - 네비게이션바 아이템으로 삭제 후 작업, 서치뷰도 있음..
extension PostedStudyViewController: PopupViewDelegate {
  func afterDeletePost(completion: @escaping () -> Void) {
    navigationController?.popViewController(animated: true)
    if (previousHomeVC != nil) {
      previousHomeVC?.fetchData(loginStatus: true) {
        print("삭제 후 리로드")
      }
    }else {
      previousMyPostVC?.afterDeletePost {
        print("삭제 후 마이페이")
      }
    }
  }
}

extension PostedStudyViewController: CheckLoginDelegate {
  func checkLoginPopup(checkUser: Bool) {
    self.commentTextField.text = nil
    self.commentTextField.resignFirstResponder()
    
    checkLoginStatus(checkUser: checkUser)
  }
}
