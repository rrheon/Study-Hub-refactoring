import UIKit

import SnapKit
import Kingfisher

final class MyPageViewController: NaviHelper {
  
  let userInfoManager = UserInfoManager.shared
  
  var loginStatus: Bool = false
  
  var myPageUserData: UserDetailData? {
    didSet {
      DispatchQueue.main.async {
        self.nickNameLabel.text = self.myPageUserData?.nickname
        self.majorLabel.text = self.convertMajor(self.myPageUserData?.major ?? "", isEnglish: false)
        
        if let imageURL = URL(string: self.myPageUserData?.imageURL ?? "") {
          let processor = ResizingImageProcessor(referenceSize: CGSize(width: 56, height: 56))
          
          KingfisherManager.shared.cache.removeImage(forKey: imageURL.absoluteString)
          
          self.profileImageView.kf.setImage(with: imageURL, options: [.processor(processor)]) { result in
            switch result {
            case .success(let value):
              DispatchQueue.main.async {
                self.profileImageView.image = value.image
                self.profileImageView.layer.cornerRadius = 20
                self.profileImageView.clipsToBounds = true
              }
            case .failure(let error):
              print("Image download failed: \(error)")
            }
          }
        }
      }
    }
  }
  
  var changedUserNickname: String? {
    didSet {
      nickNameLabel.text = changedUserNickname
    }
  }
  
  var changedUserMajor: String? {
    didSet {
      majorLabel.text = convertMajor(changedUserMajor ?? "", isEnglish: false)
    }
  }
  
  // MARK: - UI설정
  // 로그인 하면 보이는 라벨
  private lazy var loginSuccessStackView = createStackView(axis: .vertical,
                                                           spacing: 5)
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "ProfileAvatar_change")
 
    return imageView
  }()
  
  private lazy var majorLabel = createLabel(title: convertMajor(myPageUserData?.major! ?? "",
                                                                isEnglish: false),
                                            textColor: .bg80,
                                            fontType: "Pretendard",
                                            fontSize: 14)
  
  private lazy var nickNameLabel = createLabel(title: myPageUserData?.nickname ?? "비어있음",
                                               textColor: .black,
                                               fontType: "Pretendard-Bold",
                                               fontSize: 18)
  
  // 로그인 안하면 보이는 라벨
  private lazy var loginFailStackView = createStackView(axis: .vertical,
                                                        spacing: 8)
  
  private lazy var loginFailLabel = createLabel(title: "나의 스터디 팀원을 만나보세요",
                                               textColor: .bg80,
                                               fontType: "Pretendard",
                                               fontSize: 14)
  
  private lazy var loginFailTitleLabel = createLabel(title: "로그인 / 회원가입",
                                                     textColor: .black,
                                                     fontType: "Pretendard-Bold",
                                                     fontSize: 18)
  
  // 로그인 시 -> 정보수정, 비로그인 시 -> 로그인화면으로 이동
  private lazy var chevronButton: UIButton = {
    let chevronButton = UIButton(type: .system)
    chevronButton.setImage(UIImage(systemName: "chevron.right"),
                           for: .normal)
    chevronButton.tintColor = .black
    chevronButton.addTarget(self,
                            action: #selector(chevronButtonTapped),
                            for: .touchUpInside)
    chevronButton.contentHorizontalAlignment = .trailing
    
    return chevronButton
  }()
  
  // 사용자 프로필, 로그인 화면으로 가는 버튼을 담은 스택뷰
  private lazy var gotologinStackView = createStackView(axis: .horizontal,
                                                        spacing: 10)
  
  // 북마크, 글 횟수 등의 버튼을 담은 스택뷰
  private lazy var mainInfoStackView = createStackView(axis: .horizontal,
                                                       spacing: 8)
  
  // 작성한 글
  private lazy var writtenLabel = createLabel(title: "작성한 글",
                                              textColor: .bg80,
                                              fontType: "Pretendard",
                                              fontSize: 14)
  
  private lazy var writtenCountLabel = createLabel(title: "\(myPageUserData?.postCount ?? 0)" ,
                                                   textColor: .black,
                                                   fontType: "Pretendard-Bold",
                                                   fontSize: 18)
  private lazy var writtenButton: UIButton = {
    let writtenButton = UIButton()
    writtenButton.addAction(UIAction { _ in
      self.writtenButtonTapped()
    }, for: .touchUpInside)

    return writtenButton
  }()
  
  // 참여한 스터디
  private lazy var joinstudyLabel = createLabel(title: "참여한 스터디",
                                                textColor: .bg80,
                                                fontType: "Pretendard",
                                                fontSize: 14)
  
  private lazy var joinstudyCountLabel = createLabel(title: "\(myPageUserData?.participateCount ?? 0)",
                                                     textColor: .black,
                                                     fontType: "Pretendard-Bold",
                                                     fontSize: 18)

  private lazy var joinstudyButton: UIButton = {
    // Create a button for "참여한 스터디"
    let joinstudyButton = UIButton()
    joinstudyButton.addAction(UIAction { _ in
      self.joinstudyButtonTapped()
    }, for: .touchUpInside)
    return joinstudyButton
  }()
  
  // 북마크
  private lazy var bookmarkCountLabel = createLabel(title: "\(myPageUserData?.bookmarkCount ?? 0)",
                                                    textColor: .black,
                                                    fontType: "Pretendard-Bold",
                                                    fontSize: 18)
  
  private lazy var bookmarkLabel = createLabel(title: "북마크",
                                               textColor: .bg80,
                                               fontType: "Pretendard",
                                               fontSize: 14)

  private lazy var bookmarkButton: UIButton = {
    // Create a button for "북마크"
    let bookmarkButton = UIButton()
    bookmarkButton.addAction(UIAction { _ in
      self.bookmarkpageButtonTapped()
    }, for: .touchUpInside)
    
    return bookmarkButton
  }()
  
  private let boxesDividerLine: UIView = {
    let boxesDividerLine = UIView()
    boxesDividerLine.backgroundColor = .bg30
    boxesDividerLine.heightAnchor.constraint(equalToConstant: 10).isActive = true
    return boxesDividerLine
  }()
  
  
  private lazy var bottomButtonStackView = createStackView(axis: .vertical,
                                                           spacing: 16)
  
  private lazy var informButton = createMypageButton(title: "공지사항")
  private lazy var askButton = createMypageButton(title: "문의하기")
  private lazy var howToUseButton = createMypageButton(title: "이용방법")
  private lazy var serviceButton = createMypageButton(title: "서비스 이용약관")
  private lazy var informhandleButton = createMypageButton(title: "개인정보 처리 방침")
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
     
    navigationItemSetting()
    redesignNavigationbar()
    
    fetchUserData()
    
    print(loginStatus)
  }
  
  // MARK: - setUpLayout
  func setUpLayout(){
    
    if loginStatus == false {
      [
        loginFailLabel,
        loginFailTitleLabel
      ].forEach {
        view.addSubview($0)
      }
    } else {
      [
        profileImageView,
        majorLabel,
        nickNameLabel
      ].forEach {
        view.addSubview($0)
      }
    }
   
    [
      chevronButton,
      writtenButton,
      writtenCountLabel,
      writtenLabel,
      joinstudyButton,
      joinstudyCountLabel,
      joinstudyLabel,
      bookmarkButton,
      bookmarkCountLabel,
      bookmarkLabel,
      boxesDividerLine,
      informButton,
      askButton,
      howToUseButton,
      serviceButton,
      informhandleButton
    ].forEach {
      view.addSubview($0)
    }
    
  }
  
  // MARK: - makeUI
  func makeUI(){
    if loginStatus == false {
      loginFailLabel.snp.makeConstraints {
        $0.top.equalToSuperview().offset(30)
        $0.leading.equalToSuperview().offset(20)
      }

      loginFailTitleLabel.snp.makeConstraints {
        $0.top.equalTo(loginFailLabel.snp.bottom).offset(10)
        $0.leading.equalToSuperview().offset(20)
      }
    }else {
      profileImageView.snp.makeConstraints {
        $0.top.equalToSuperview().offset(30)
        $0.leading.equalToSuperview().offset(20)
      }
      
      majorLabel.snp.makeConstraints {
        $0.top.equalTo(profileImageView)
        $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
      }
      
      nickNameLabel.snp.makeConstraints {
        $0.top.equalTo(majorLabel.snp.bottom).offset(10)
        $0.leading.equalTo(majorLabel)
      }
    }
 
    chevronButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.trailing.equalToSuperview().offset(-25)
    }
    
    // 작성한 글 , 참여한 스터디, 북마크
    let buttons = [writtenButton, joinstudyButton, bookmarkButton]
    for button in buttons {
      button.backgroundColor = .bg20
      button.layer.cornerRadius = 5
      button.layer.borderColor = UIColor.bg40.cgColor
      button.layer.borderWidth = 1
    }
    
    // 작성한 글
    writtenButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(100)
      $0.width.equalTo(105)
      $0.height.equalTo(87)
    }
    
    writtenCountLabel.snp.makeConstraints {
      $0.top.equalTo(writtenButton.snp.top).offset(20)
      $0.centerX.equalTo(writtenButton)
    }
    
    writtenLabel.snp.makeConstraints {
      $0.top.equalTo(writtenCountLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(writtenButton)
    }
    
    // 참여한 스터디
    joinstudyButton.snp.makeConstraints {
      $0.leading.equalTo(writtenButton.snp.trailing).offset(15)
      $0.top.equalTo(writtenButton)
      $0.width.equalTo(105)
      $0.height.equalTo(87)
    }
    
    joinstudyCountLabel.snp.makeConstraints {
      $0.top.equalTo(joinstudyButton.snp.top).offset(20)
      $0.centerX.equalTo(joinstudyButton)
    }
    
    joinstudyLabel.snp.makeConstraints {
      $0.top.equalTo(joinstudyCountLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(joinstudyButton)
    }
    
    // 북마크
    bookmarkButton.snp.makeConstraints {
      $0.leading.equalTo(joinstudyButton.snp.trailing).offset(15)
      $0.top.equalTo(writtenButton)
      $0.width.equalTo(105)
      $0.height.equalTo(87)
    }
    
    bookmarkCountLabel.snp.makeConstraints {
      $0.top.equalTo(bookmarkButton.snp.top).offset(20)
      $0.centerX.equalTo(bookmarkButton)
    }
    
    bookmarkLabel.snp.makeConstraints {
      $0.top.equalTo(bookmarkCountLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(bookmarkButton)
    }
    
    boxesDividerLine.snp.makeConstraints {
      $0.top.equalTo(writtenButton.snp.bottom).offset(40)
      $0.leading.trailing.equalToSuperview()
    }
    
    // 공지사항 , 문의하기, 이용방법, 서비스 이용약관, 개인정보처리방침
    informButton.snp.makeConstraints {
      $0.top.equalTo(boxesDividerLine.snp.bottom).offset(20)
      $0.leading.equalTo(writtenButton)
    }
    
    askButton.snp.makeConstraints {
      $0.top.equalTo(informButton.snp.bottom).offset(20)
      $0.leading.equalTo(writtenButton)
    }
    
    howToUseButton.snp.makeConstraints {
      $0.top.equalTo(askButton.snp.bottom).offset(20)
      $0.leading.equalTo(writtenButton)
    }
    
    serviceButton.snp.makeConstraints {
      $0.top.equalTo(howToUseButton.snp.bottom).offset(20)
      $0.leading.equalTo(writtenButton)
    }
    
    informhandleButton.snp.makeConstraints {
      $0.top.equalTo(serviceButton.snp.bottom).offset(20)
      $0.leading.equalTo(writtenButton)
    }
  }
  
  // MARK: - 네비게이션바 재설정
  func redesignNavigationbar(){
    let myPageImg = UIImage(named: "MyPageImg")?.withRenderingMode(.alwaysOriginal)
    let myPage = UIBarButtonItem(image: myPageImg, style: .done, target: nil, action: nil)
    myPage.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    myPage.isEnabled = false
    
    let alertBellImg = UIImage(named: "BellImgWithWhite")?.withRenderingMode(.alwaysOriginal)
    lazy var alertBell = UIBarButtonItem(
      image: alertBellImg,
      style: .plain,
      target: self,
      action: nil)
    alertBell.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    navigationItem.leftBarButtonItem = myPage
    navigationItem.rightBarButtonItem = alertBell
  }
  
  // MARK: - 유저 정보 가저오는 함수
  func fetchUserData() {
    userInfoManager.fetchUserInfo {
      self.myPageUserData = self.userInfoManager.getUserInfo()
      
      let status = self.myPageUserData == nil ? false : true
      self.loginStatus = status
      
      DispatchQueue.main.async {
        self.setUpLayout()
        self.makeUI()
      }
    }
  }
  
  @objc func writtenButtonTapped(){
    let myPostVC = MyPostViewController()
    myPostVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(myPostVC, animated: true)
  }
  
  func joinstudyButtonTapped(){
    let myParticipateVC = MyParticipateStudyVC()
  
    self.navigationController?.pushViewController(myParticipateVC, animated: true)
  }
  
  @objc func bookmarkpageButtonTapped() {
    let bookmarkVC = BookmarkViewController()
  
    self.navigationController?.pushViewController(bookmarkVC, animated: true)
  }
  
  @objc func chevronButtonTapped() {

    let myinformViewController = MyInformViewController()
    
    myinformViewController.previousVC = self
    
    // Pass major information to MyinformViewController
    myinformViewController.major = convertMajor(myPageUserData?.major! ?? "", isEnglish: false)
    myinformViewController.nickname = myPageUserData?.nickname
    myinformViewController.email = myPageUserData?.email
    myinformViewController.gender = convertGender(gender: myPageUserData?.gender ?? "없음")

    myinformViewController.profileImage = myPageUserData?.imageURL
    
    
    self.navigationController?.pushViewController(myinformViewController, animated: true)
  }
}
