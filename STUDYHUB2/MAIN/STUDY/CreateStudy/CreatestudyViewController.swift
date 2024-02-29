import UIKit

import SnapKit

protocol AfterCreatePost: AnyObject {
  func afterCreatePost(postId: Int)
}

// 캘린더 커스텀하기, 캘린더 선택 버튼 수정
final class CreateStudyViewController: NaviHelper {
  let tokenManager = TokenManager.shared
  let postInfoManager = PostDetailInfoManager.shared
  let postManager = PostManager.shared
  
  var genderType: String? {
    didSet {
      checkButtonActivation()
    }
  }
  var contactMethod: String?{
    didSet {
      checkButtonActivation()
    }
  }
  
  var selectedMajor: String? {
    didSet {
      checkButtonActivation()
    }
  }
  
  var modifyPostID: Int?
  
  weak var delegate: AfterCreatePost?
  
  var fineCheck: Bool? {
    didSet {
      checkButtonActivation()
    }
  }
  var genderCheck: Bool? = false {
    didSet {
      checkButtonActivation()
    }
  }
  
  var startDateCheck: String = "선택하기" {
    didSet {
      checkButtonActivation()
    }
  }
  
  var endDateCheck: String = "선택하기" {
    didSet {
      checkButtonActivation()
    }
  }
  
  
  // MARK: - UI설정
  // 채팅방 링크
  private lazy var chatLinkStackView = createStackView(axis: .vertical,
                                                       spacing: 5)
  
  private lazy var chatLinkLabel = createLabel(title: "채팅방 링크",
                                               textColor: .black,
                                               fontType: "Pretendard-SemiBold",
                                               fontSize: 16)
  
  private lazy var chatLinkdescriptionLabel = createLabel(title: "참여코드가 없는 카카오톡 오픈 채팅방 링크로 첨부",
                                                          textColor: .bg70,
                                                          fontType: "Pretendard-Medium",
                                                          fontSize: 12)
  
  private lazy var chatLinkTextField = createTextField(title: "채팅방 링크를 첨부해 주세요")
  
  private lazy var chatLinkDividerLine = createDividerLine(height: 10)
  
  // MARK: - 스터디 제목
  private lazy var studytitleStackView = createStackView(axis: .vertical,
                                                         spacing: 10)
  
  private lazy var studytitleLabel = createLabel(title: "스터디 제목",
                                                 textColor: .black,
                                                 fontType: "Pretendard-SemiBold",
                                                 fontSize: 16)
  
  private lazy var studytitleTextField = createTextField(title: "제목을 적어주세요")
  
  // MARK: - 스터디 소개
  private lazy var studyProduceLabel = createLabel(title: "스터디 소개",
                                                   textColor: .black,
                                                   fontType: "Pretendard-SemiBold",
                                                   fontSize: 16)
  
  let textViewContent = "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
  private lazy var studyProduceTextView: UITextView = {
    let tv = UITextView()
    tv.text = textViewContent
    tv.textColor = UIColor.lightGray
    tv.font = UIFont.systemFont(ofSize: 15)
    tv.layer.borderWidth = 0.5
    tv.layer.borderColor = UIColor.lightGray.cgColor
    tv.layer.cornerRadius = 5.0
    tv.adjustUITextViewHeight()
    tv.delegate = self
    return tv
  }()
  
  
  // MARK: - 관련학과 선택
  private lazy var studyProduceDividerLine = createDividerLine(height: 10)
  
  private lazy var totalSelectMajorStackView = createStackView(axis: .vertical,
                                                               spacing: 10)
  
  private lazy var selectMajorStackView = createStackView(axis: .horizontal,
                                                          spacing: 10)
  
  private lazy var selectMajorLabel = createLabel(title: "관련 학과 선택",
                                                  textColor: .black,
                                                  fontType: "Pretendard-SemiBold",
                                                  fontSize: 16)
  
  private lazy var selectedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    let img = UIImage(named: "DeleteImg")
    button.setImage(img, for: .normal)
    button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var selectMajorButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    button.tintColor = .black
    button.addTarget(self, action: #selector(departmentArrowButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var selectMajorDividerLine = createDividerLine(height: 10)
  
  // MARK: - 스터디 팀원
  private lazy var studymemberLabelStackView = createStackView(axis: .horizontal, spacing: 10)
  
  private lazy var studyMemberStackView = createStackView(axis: .vertical,
                                                          spacing: 5)
  
  private lazy var studymemberLabel = createLabel(title: "스터디 팀원",
                                                  textColor: .black,
                                                  fontType: "Pretendard-SemiBold",
                                                  fontSize: 16)
  
  private lazy var studymemberDividerLine = createDividerLine(height: 1)
  
  // MARK: - 인원
  private lazy var studymemberTitleLabel = createLabel(title: "인원",
                                                       textColor: .black,
                                                       fontType: "Pretendard-SemiBold",
                                                       fontSize: 16)
  
  private lazy var studyMemberDescibeLabel = createLabel(title: "본인 제외 최대 50명",
                                                         textColor: .bg70,
                                                         fontType: "Pretendard-Medium",
                                                         fontSize: 12)
  
  private lazy var studyMemberCountStackView = createStackView(axis: .horizontal,
                                                               spacing: 5)
  
  private lazy var studymemberTextField = createTextField(title: "스터디 인원을 알려주세요")
  
  private lazy var countLabel = createLabel(title: "명",
                                            textColor: .bg80,
                                            fontType: "Pretendard-SemiBold",
                                            fontSize: 14)
  
  private lazy var countAlert = createLabel(title: "1명부터 가능해요(본인 제외)",
                                            textColor: .r50,
                                            fontType: "Pretendard",
                                            fontSize: 12)
  
  // MARK: - 성별
  private lazy var genderLabel = createLabel(title: "성별",
                                             textColor: .black,
                                             fontType: "Pretendard-SemiBold",
                                             fontSize: 16)
  
  private lazy var genderDescribeLabel = createLabel(title: "참여자의 성별 선택",
                                                     textColor: .bg70,
                                                     fontType: "Pretendard-Medium",
                                                     fontSize: 12)
  
  private lazy var genderButtonStackView = createStackView(axis: .horizontal,
                                                           spacing: 5)
  
  private lazy var allGenderButton = createContactButton(title: "무관",
                                                         selector: #selector(genderButtonTapped(_:)))
  
  private lazy var maleOnlyButton = createContactButton(title: "남자만",
                                                        selector:#selector(genderButtonTapped(_:)))
  
  private lazy var femaleOnlyButton = createContactButton(title: "여자만",
                                                          selector: #selector(genderButtonTapped(_:)))
  
  private lazy var genderButtonDividerLine = createDividerLine(height: 10)
  
  // MARK: - 스터디 방식
  private lazy var studyMethodStackView = createStackView(axis: .vertical,
                                                          spacing: 5)
  
  private lazy var studyMethodLabelStackView = createStackView(axis: .vertical, spacing: 5)
  
  private lazy var studymethodLabel = createLabel(title: "스터디 방식",
                                                  textColor: .black,
                                                  fontType: "Pretendard-SemiBold",
                                                  fontSize: 16)
  
  private lazy var studyMethodDivierLine = createDividerLine(height: 1)
  
  // MARK: - 대면 여부
  private lazy var meetLabel = createLabel(title: "대면 여부",
                                           textColor: .black,
                                           fontType: "Pretendard-SemiBold",
                                           fontSize: 16)
  
  private lazy var meetDescribeLabel = createLabel(
    title: "대면이나 혼합일 경우, 관련 내용에 대한 계획을 소개에 적어주세요",
    textColor: .bg70,
    fontType: "Pretendard-Medium",
    fontSize: 12)
  
  private lazy var studyMethodButtonStackView = createStackView(axis: .horizontal,
                                                                spacing: 10)
  
  private lazy var contactButton = createContactButton(title: "대면",
                                                       selector: #selector(meetButtonTapped(_:)))
  
  private lazy var untactButton = createContactButton(title: "비대면",
                                                      selector: #selector(meetButtonTapped(_:)))
  
  private lazy var mixmeetButton = createContactButton(title: "혼합",
                                                       selector: #selector(meetButtonTapped(_:)))
  
  // MARK: - 벌금
  private lazy var fineLabel = createLabel(title: "벌금",
                                           textColor: .black,
                                           fontType: "Pretendard-SemiBold",
                                           fontSize: 16)
  
  
  private lazy var fineStackView = createStackView(axis: .horizontal,
                                                   spacing: 10)
  
  private lazy var haveFineLabel = createLabel(title: "있어요",
                                               textColor: .bg70,
                                               fontType: "Pretendard-Medium",
                                               fontSize: 14)
  
  private lazy var haveFineButton = createFineButton(selector: #selector(haveFineButtonTapped(_:)))
  
  private lazy var noFineLabel = createLabel(title: "없어요",
                                             textColor: .bg70,
                                             fontType: "Pretendard-Medium",
                                             fontSize: 14)
  
  private lazy var noFineButton = createFineButton(selector: #selector(noFineButtonTapped(_:)))
  
  private lazy var fineDividerLine = createDividerLine(height: 10)
  
  // MARK: - 벌금 있을 때
  private lazy var isFineStackView = createStackView(axis: .vertical, spacing: 5)
  
  private lazy var fineTypeLabel = createLabel(title: "어떤 벌금인가요?",
                                               textColor: .bg90,
                                               fontType: "Pretendard-Medium",
                                               fontSize: 14)
  
  private lazy var fineTypesTextField = createTextField(title: "지각비, 결석비 등")
  
  
  private lazy var fineAmountLabel = createLabel(title: "얼마인가요?",
                                                 textColor: .bg90,
                                                 fontType: "Pretendard-Medium",
                                                 fontSize: 14)
  
  private lazy var fineAmountTextField = createTextField(title: "금액을 알려주세요")
  
  private lazy var fineAmountCountLabel = createLabel(title: "원",
                                                      textColor: .bg80,
                                                      fontType: "Pretendard-SemiBold",
                                                      fontSize: 14)
  
  private lazy var maxFineLabel = createLabel(title: "최대 99,999원",
                                              textColor: .bg70,
                                              fontType: "Pretendard-Medium",
                                              fontSize: 12)
  
  
  
  // MARK: - 기간
  private lazy var periodStackView = createStackView(axis: .vertical,
                                                     spacing: 10)
  
  private lazy var periodLabelStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var periodLabel = createLabel(title: "기간",
                                             textColor: .black,
                                             fontType: "Pretendard-SemiBold",
                                             fontSize: 16)
  
  private lazy var periodDividerLine = createDividerLine(height: 1)
  
  private lazy var startLabel = createLabel(title: "시작하는 날",
                                            textColor: .black,
                                            fontType: "Pretendard-SemiBold",
                                            fontSize: 16)
  
  private lazy var startDateButton = createDateButton(selector: #selector(calendarButtonTapped))

  
  private lazy var endLabel = createLabel(title: "종료하는 날",
                                          textColor: .black,
                                          fontType: "Pretendard-SemiBold",
                                          fontSize: 16)
  
  private lazy var endDateButton = createDateButton(selector: #selector(calendarButtonTapped))
  
  
  // MARK: - 완료하기
  private lazy var completeButton: UIButton = {
    let completeButton = UIButton()
    completeButton.setTitle("완료하기", for: .normal)
    completeButton.setTitleColor(.white, for: .normal)
    completeButton.backgroundColor = .o30
    completeButton.layer.cornerRadius = 5
    completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    completeButton.isEnabled = false
    return completeButton
  }()
  
  private lazy var pageStackView = createStackView(axis: .vertical,
                                                   spacing: 10)
  
  let scrollView = UIScrollView()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
    
    postModify()
    compleButtonCheck()
    
    setScrollViewSingTap()
 
  }
  
  func setScrollViewSingTap(){
    let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTapMethod))
    singleTapGestureRecognizer.numberOfTapsRequired = 1
    singleTapGestureRecognizer.isEnabled = true
    singleTapGestureRecognizer.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(singleTapGestureRecognizer)
  }
  
  @objc func myTapMethod(sender: UITapGestureRecognizer) {self.view.endEditing(true)}
  
  // MARK: - setUpLayout
  func setUpLayout(){
    let chatSpacerUnderDescription = UIView()
    chatSpacerUnderDescription.snp.makeConstraints {
      $0.height.equalTo(10)
    }
    
    let chatSpacerUnderTextField = UIView()
    chatSpacerUnderTextField.snp.makeConstraints {
      $0.height.equalTo(10)
    }
    
    // chatlink
    [
      chatLinkLabel,
      chatLinkdescriptionLabel,
      chatSpacerUnderDescription,
      chatLinkTextField,
      chatSpacerUnderTextField,
    ].forEach {
      chatLinkStackView.addArrangedSubview($0)
    }
    
    let studyTitleSpacerUnderTextField = UIView()
    studyTitleSpacerUnderTextField.snp.makeConstraints {
      $0.height.equalTo(10)
    }
    
    let studyProuceSpacerUnderTextView = UIView()
    studyProuceSpacerUnderTextView.snp.makeConstraints {
      $0.height.equalTo(10)
    }
    
    // 스터디 제목, 스터디 소개
    [
      studytitleLabel,
      studytitleTextField,
      studyTitleSpacerUnderTextField,
      studyProduceLabel,
      studyProduceTextView,
      studyProuceSpacerUnderTextView
    ].forEach {
      studytitleStackView.addArrangedSubview($0)
    }
    
    // 관련학과 선택
    [
      selectMajorLabel,
      selectMajorButton
    ].forEach {
      selectMajorStackView.addArrangedSubview($0)
    }
    
    selectedMajorLabel.isHidden = true
    cancelButton.isHidden = true
    [
      selectMajorStackView
    ].forEach {
      totalSelectMajorStackView.addArrangedSubview($0)
    }
    
    // 스터디 팀원
    
    // 스터디 팀원 입력
    [
      studymemberTextField
    ].forEach {
      studyMemberCountStackView.addArrangedSubview($0)
    }
    
    let genderSpacerUnderDescription = UIView()
    genderSpacerUnderDescription.snp.makeConstraints {
      $0.height.equalTo(5)
    }
    
    // 성별 버튼
    let genderButtonRightSpacer = UIView()
    
    [
      allGenderButton,
      maleOnlyButton,
      femaleOnlyButton,
      genderButtonRightSpacer
    ].forEach {
      genderButtonStackView.addArrangedSubview($0)
    }
    
    [
      studymemberTitleLabel,
      studyMemberDescibeLabel,
      studyMemberCountStackView,
      genderLabel,
      genderDescribeLabel,
      genderSpacerUnderDescription,
      genderButtonStackView,
    ].forEach {
      studyMemberStackView.addArrangedSubview($0)
    }
    
    // 스터디 방식
    // 스터디 버튼
    let studyMethodRightSpacer = UIView()
    
    studyMethodButtonStackView.distribution = .fillEqually
    [
      mixmeetButton,
      contactButton,
      untactButton,
      studyMethodRightSpacer
    ].forEach {
      studyMethodButtonStackView.addArrangedSubview($0)
    }
    
    studymemberLabelStackView.addArrangedSubview(studymemberLabel)
    
    studyMethodLabelStackView.addArrangedSubview(studymethodLabel)
    
    let meetSpacerUnderDescription = UIView()
    meetSpacerUnderDescription.snp.makeConstraints {
      $0.height.equalTo(5)
    }
    
    // 벌금 유무
    let fineButtonRightSpacer = UIView()
    
    fineStackView.distribution = .fill
    fineStackView.alignment = .leading
    [
      haveFineButton,
      haveFineLabel,
      noFineButton,
      noFineLabel,
      fineButtonRightSpacer
    ].forEach {
      fineStackView.addArrangedSubview($0)
    }
    
    let meetSpacerUnderButton = UIView()
    meetSpacerUnderButton.snp.makeConstraints {
      $0.height.equalTo(10)
    }
    
    [
      meetLabel,
      meetDescribeLabel,
      meetSpacerUnderDescription,
      studyMethodButtonStackView,
      meetSpacerUnderButton,
      fineLabel
    ].forEach {
      studyMethodStackView.addArrangedSubview($0)
    }
    
    // 기간
    periodLabelStackView.addArrangedSubview(periodLabel)
    
    let spacerUnderEndButton = UIView()
    spacerUnderEndButton.snp.makeConstraints {
      $0.height.equalTo(40)
    }
    
    let spacerUnderStartButton = UIView()
    spacerUnderStartButton.snp.makeConstraints {
      $0.height.equalTo(10)
    }
    
    [
      startLabel,
      startDateButton,
      spacerUnderStartButton,
      endLabel,
      endDateButton,
      spacerUnderEndButton,
      completeButton
    ].forEach {
      periodStackView.addArrangedSubview($0)
    }
    
    [
      chatLinkStackView,
      chatLinkDividerLine,
      studytitleStackView,
      studyProduceDividerLine,
      totalSelectMajorStackView,
      selectMajorDividerLine,
      studymemberLabelStackView,
      studymemberDividerLine,
      studyMemberStackView,
      genderButtonDividerLine,
      studyMethodLabelStackView,
      studyMethodDivierLine,
      studyMethodStackView,
      fineStackView,
      fineDividerLine,
      periodLabelStackView,
      periodDividerLine,
      periodStackView
    ].forEach {
      pageStackView.addArrangedSubview($0)
    }
    
    [
      pageStackView,
      countLabel
    ].forEach {
      scrollView.addSubview($0)
    }
    
    view.addSubview(scrollView)
  }
  
  // MARK: - makeUI
  func makeUI(){
    chatLinkTextField.clearButtonMode = .whileEditing
    chatLinkTextField.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    chatLinkDividerLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    studytitleTextField.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    studyProduceTextView.delegate = self
    studyProduceTextView.snp.makeConstraints {
      $0.height.equalTo(170)
    }
    
    studyProduceDividerLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    selectMajorDividerLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    totalSelectMajorStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    totalSelectMajorStackView.isLayoutMarginsRelativeArrangement = true
    
    studyMemberStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    studyMemberStackView.isLayoutMarginsRelativeArrangement = true
    
    studymemberLabelStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    studymemberLabelStackView.isLayoutMarginsRelativeArrangement = true
    
    studymemberDividerLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    studymemberTextField.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    countLabel.snp.makeConstraints {
      $0.centerY.equalTo(studymemberTextField)
      $0.trailing.equalTo(studymemberTextField).offset(-20)
    }
    
    studyMemberCountStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    studyMemberCountStackView.isLayoutMarginsRelativeArrangement = true
    
    genderButtonStackView.distribution = .fillEqually
    
    genderButtonDividerLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    studyMethodLabelStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    studyMethodLabelStackView.isLayoutMarginsRelativeArrangement = true
    
    studyMethodDivierLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    studyMethodStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    studyMethodStackView.isLayoutMarginsRelativeArrangement = true
    
    
    fineStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    fineStackView.isLayoutMarginsRelativeArrangement = true
    
    haveFineLabel.snp.makeConstraints {
      $0.centerY.equalTo(haveFineButton)
    }
    
    noFineLabel.snp.makeConstraints {
      $0.centerY.equalTo(haveFineButton)
    }
    
    fineDividerLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    periodLabelStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    periodLabelStackView.isLayoutMarginsRelativeArrangement = true
    
    periodDividerLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    startDateButton.tag = 1
    startDateButton.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    endDateButton.tag = 2
    endDateButton.snp.makeConstraints {
      $0.height.equalTo(50)
    }
    
    completeButton.snp.makeConstraints {
      $0.height.equalTo(55)
    }
    
    [
      chatLinkStackView,
      studytitleStackView,
      periodStackView
    ].forEach {
      $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
      $0.isLayoutMarginsRelativeArrangement = true
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
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItems = .none
    self.navigationItem.title = "게시글 작성하기"
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  }
  
  // MARK: - 수정 시 뒤로가기 눌렀을 때
  @objc override func leftButtonTapped(_ sender: UIBarButtonItem) {
//    textViewContent.text = nil
    studyProduceTextView.resignFirstResponder()
    
    guard let postID = modifyPostID else {
      navigationController?.popViewController(animated: true)
      return
    }
    
    let popupVC = PopupViewController(title: "수정을 취소할까요?",
                                      desc: "취소할 시 내용이 저장되지 않아요",
                                      leftButtonTitle: "아니요",
                                      rightButtonTilte: "네")
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: false) {
        self.navigationController?.popViewController(animated: true)
      }
    }
    self.present(popupVC, animated: true)
  }
  
  // MARK: -  선택한 학과에 대한 버튼을 생성
  func addDepartmentButton(_ department: String) {
    totalSelectMajorStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 70, right: 20)
    
    selectedMajor = department
    print(selectedMajor)
    guard let labelText = selectedMajor else { return }
    
    selectedMajorLabel.text = "  \(labelText)"
    selectedMajorLabel.clipsToBounds = true
    selectedMajorLabel.layer.cornerRadius = 15
    selectedMajorLabel.backgroundColor = .bg30
    selectedMajorLabel.textAlignment = .left
    selectedMajorLabel.adjustsFontSizeToFitWidth = true
    
    scrollView.addSubview(selectedMajorLabel)
    scrollView.addSubview(cancelButton)
    
    selectedMajorLabel.isHidden = false
    selectedMajorLabel.snp.makeConstraints { make in
      make.top.equalTo(selectMajorLabel.snp.bottom).offset(10)
      make.leading.equalTo(selectMajorLabel)
      make.height.equalTo(30)
    }
    
    cancelButton.isHidden = false
    cancelButton.snp.makeConstraints { make in
      make.centerY.equalTo(selectedMajorLabel.snp.centerY)
      make.leading.equalTo(selectedMajorLabel.snp.trailing).offset(-30)
    }
    
    view.layoutIfNeeded()
  }
  
  @objc func cancelButtonTapped(){
    selectedMajorLabel.isHidden = true
    cancelButton.isHidden = true
    
    selectedMajor = nil
    
    totalSelectMajorStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
  }
  
  // MARK: - 벌금이 있을 때
  @objc func haveFineButtonTapped(_ sender: UIButton) {
    fineCheck = true
    
    sender.isSelected = !sender.isSelected
    noFineButton.isSelected = !sender.isSelected
    
    if sender.isSelected {
      fineStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 250, right: 20)
      [
        fineTypeLabel,
        fineTypesTextField,
        fineAmountLabel,
        fineAmountTextField,
        fineAmountCountLabel,
        maxFineLabel
      ].forEach {
        $0.isHidden = false
      }
      
      [
        fineTypeLabel,
        fineTypesTextField,
        fineAmountLabel,
        fineAmountTextField,
        fineAmountCountLabel,
        maxFineLabel
      ].forEach {
        scrollView.addSubview($0)
      }
      
      fineTypeLabel.snp.makeConstraints {
        $0.top.equalTo(haveFineButton.snp.bottom).offset(30)
        $0.leading.equalTo(haveFineButton)
      }
      
      fineTypesTextField.snp.makeConstraints {
        $0.top.equalTo(fineTypeLabel.snp.bottom).offset(10)
        $0.leading.equalTo(haveFineButton)
        $0.trailing.equalToSuperview().offset(-20)
        $0.height.equalTo(50)
      }
      
      fineAmountLabel.snp.makeConstraints {
        $0.top.equalTo(fineTypesTextField.snp.bottom).offset(10)
        $0.leading.equalTo(haveFineButton)
      }
      
      fineAmountTextField.snp.makeConstraints {
        $0.top.equalTo(fineAmountLabel.snp.bottom).offset(20)
        $0.leading.equalTo(haveFineButton)
        $0.trailing.equalToSuperview().offset(-20)
        $0.height.equalTo(50)
      }
      
      fineAmountCountLabel.snp.makeConstraints {
        $0.centerY.equalTo(fineAmountTextField)
        $0.trailing.equalTo(fineAmountTextField.snp.trailing).offset(-10)
      }
      
      maxFineLabel.snp.makeConstraints {
        $0.top.equalTo(fineAmountTextField.snp.bottom).offset(10)
        $0.leading.equalTo(haveFineButton)
      }
      
      view.layoutIfNeeded()
    }
  }
  
  // MARK: - 벌금 없을 때 함수
  @objc func noFineButtonTapped(_ sender: UIButton) {
    fineCheck = false
    
    sender.isSelected = !sender.isSelected
    haveFineButton.isSelected = !sender.isSelected
    fineStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    
    
    [
      fineTypeLabel,
      fineTypesTextField,
      fineAmountLabel,
      fineAmountTextField,
      fineAmountCountLabel,
      maxFineLabel
    ].forEach {
      $0.isHidden = true
    }
  }
  
  // MARK: - 완료버튼 누를 때 함수
  @objc func completeButtonTapped() {
    // 수정하려면 postid도 넣어야함
    let test = (modifyPostID == nil) ? "POST" : "PUT"
    print(test)
    if test == "PUT" {
      let chatUrl = chatLinkTextField.text ?? ""
      let content = studyProduceTextView.text ?? ""
      let gender = genderType ?? "null"
      let major = convertMajor(selectedMajor ?? "", isEnglish: true)
      let penalty = Int(fineAmountTextField.text ?? "0") ?? 0
      let penaltyWay = fineTypesTextField.text ?? ""
      
      let endDate = endDateButton.currentTitle ?? ""
      let studyEndDate = endDate.replacingOccurrences(of: ". ", with: "-")
      
      let studyPerson = Int(studymemberTextField.text ?? "") ?? 0
      
      let stratDate = startDateButton.currentTitle ?? ""
      let studyStartDate = stratDate.replacingOccurrences(of: ". ", with: "-")
      let studyWay = contactMethod ?? "CONTACT"
      let title = studytitleTextField.text ?? ""
      
      // 날짜 형식땨문인듯 2024-02-34 이여야함 지금은 2024-2-32 이런식
      let updatePostData = UpdateStudyRequest(chatUrl: chatUrl,
                                              close: false,
                                              content: content,
                                              gender: gender,
                                              major: major,
                                              penalty: penalty,
                                              penaltyWay: penaltyWay,
                                              postId: modifyPostID ?? 0,
                                              studyEndDate: studyEndDate,
                                              studyPerson: studyPerson,
                                              studyStartDate: studyStartDate,
                                              studyWay: studyWay,
                                              title: title)
      loginManager.refreshAccessToken { result in
        switch result {
        case true:
          self.postManager.modifyPost(data: updatePostData) {
            self.navigationController?.popViewController(animated: true)
            self.showToast(message: "글이 수정됐어요.", alertCheck: true)
          }
        case false:
          return
        }
      }
    } else {
      let studyData = CreateStudyRequest(
        chatUrl: chatLinkTextField.text ?? "",
        close: false,
        content: studyProduceTextView.text ?? "",
        // 무관일때 안됨 null이 아닌가
        gender: genderType ?? "null",
        major: convertMajor(selectedMajor ?? "", isEnglish: true) ,
        penalty: Int(fineAmountTextField.text ?? "0") ?? 0 ,
        penaltyWay: fineTypesTextField.text ?? "",
        studyEndDate: endDateButton.currentTitle ?? "",
        studyPerson: Int(studymemberTextField.text ?? "") ?? 0,
        studyStartDate: startDateButton.currentTitle ?? "",
        studyWay: contactMethod ?? "CONTACT",
        title: studytitleTextField.text ?? "")
      
      loginManager.refreshAccessToken { result in
        switch result {
        case true:
          print(studyData)
          self.postManager.createPost(createPostDatas: studyData) { postId in
            self.navigationController?.popViewController(animated: false)
            
            self.delegate?.afterCreatePost(postId: Int(postId) ?? 0)
          }
        case false:
          return
        }
      }
    }
  }
  
  @objc func departmentArrowButtonTapped() {
    let departmentselectVC = DepartmentselectViewController()
    departmentselectVC.previousVC = self
    
    if let navigationController = self.navigationController {
      navigationController.pushViewController(departmentselectVC, animated: true)
    } else {
      let navigationController = UINavigationController(rootViewController: departmentselectVC)
      navigationController.modalPresentationStyle = .fullScreen
      present(navigationController, animated: true, completion: nil)
    }
  }
  
  
  // MARK: - 성별 눌렸을 때 함수
  @objc func genderButtonTapped(_ sender: UIButton) {
    genderCheck = true
    // Reset colors of all buttons
    allGenderButton.layer.borderColor = UIColor.bg50.cgColor
    allGenderButton.setTitleColor(.gray, for: .normal)
    
    maleOnlyButton.layer.borderColor = UIColor.bg50.cgColor
    maleOnlyButton.setTitleColor(.gray, for: .normal)
    
    femaleOnlyButton.layer.borderColor = UIColor.bg50.cgColor
    femaleOnlyButton.setTitleColor(.gray, for: .normal)
    
    // Set the tapped button to orange background
    sender.layer.borderColor = UIColor(hexCode: "#FF5530").cgColor
    sender.setTitleColor(UIColor(hexCode: "#FF5530"), for: .normal)
    
    guard let gender = sender.titleLabel?.text else { return }
    genderType = gender
    // MALE FEMALE null
    if genderType == "남자만" {
      genderType = "MALE"
    }
    else if genderType == "여자만" {
      genderType = "FEMALE"
    }
    else {
      genderType = "NULL"
    }
  }
  
  // MARK: - 스터디 방식 눌렸을 때 함수
  @objc func meetButtonTapped(_ sender: UIButton) {
    // Reset colors of all buttons
    contactButton.layer.borderColor = UIColor.bg50.cgColor
    contactButton.setTitleColor(.gray, for: .normal)
    
    untactButton.layer.borderColor = UIColor.bg50.cgColor
    untactButton.setTitleColor(.gray, for: .normal)
    
    mixmeetButton.layer.borderColor = UIColor.bg50.cgColor
    mixmeetButton.setTitleColor(.gray, for: .normal)
    
    // Set the tapped button to orange background
    sender.layer.borderColor = UIColor(hexCode: "#FF5530").cgColor
    sender.setTitleColor(UIColor(hexCode: "#FF5530"), for: .normal)
    // CONTACT UNCONTACT MIX
    guard let contact = sender.titleLabel?.text else{ return }
    contactMethod = contact
    if contactMethod == "대면" {
      contactMethod = "CONTACT"
    }
    else if contactMethod == "비대면" {
      contactMethod = "UNTACT"
    }
    else {
      contactMethod = "MIX"
    }
  }
  
  // MARK: - calenderTapped함수
  @objc func calendarButtonTapped(_ sender: Any) {
    let calendarVC = CalendarViewController()
    calendarVC.delegate = self
    calendarVC.selectedStatDate = startDateButton.titleLabel?.text ?? ""
    
    if (sender as AnyObject).tag == 1 {
      calendarVC.buttonSelect = true
    } else {
      calendarVC.buttonSelect = false
    }
    if #available(iOS 15.0, *) {
      if let sheet = calendarVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return 400.0
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
    self.present(calendarVC, animated: true, completion: nil)
  }
  
  // MARK: - 수정하기눌렀을 때 데이터 가져옴
  func postModify(){
    guard let postID = modifyPostID else { return }
    
    self.navigationItem.title = "수정하기"
    self.navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    postInfoManager.searchSinglePostData(postId: postID, loginStatus: false) {
      
      let modifyData = self.postInfoManager.getPostDetailData()
      
      DispatchQueue.main.async {
        modifyData.map {
          self.chatLinkTextField.text = $0.chatURL
          self.studyProduceTextView.text = $0.content
          self.studyProduceTextView.textColor = .black

          self.studytitleTextField.text = $0.title
          
          self.selectedMajor = self.convertMajor($0.major, isEnglish: false)
          self.addDepartmentButton(self.convertMajor($0.major, isEnglish: false))
          
          self.studymemberTextField.text = String($0.studyPerson)
          
          self.genderType = $0.filteredGender
          if self.genderType == "FEMALE" {
            self.femaleOnlyButton.isSelected = true
            self.genderButtonTapped(self.femaleOnlyButton)
          } else if self.genderType == "MALE" {
            self.maleOnlyButton.isSelected = true
            self.genderButtonTapped(self.maleOnlyButton)
          } else {
            self.allGenderButton.isSelected = true
            self.genderButtonTapped(self.allGenderButton)
          }
          
          self.contactMethod = $0.studyWay
          if self.contactMethod == "CONTACT" {
            self.contactButton.isSelected = true
            self.meetButtonTapped(self.contactButton)
          } else if self.contactMethod == "MIX" {
            self.mixmeetButton.isSelected = true
            self.meetButtonTapped(self.mixmeetButton)
          } else {
            self.untactButton.isSelected = true
            self.meetButtonTapped(self.untactButton)
          }
          
          if $0.penalty == 0 {
            self.noFineButtonTapped(self.noFineButton)
          } else {
            self.haveFineButtonTapped(self.haveFineButton)
            self.fineTypesTextField.text = $0.penaltyWay
            self.fineAmountTextField.text = String($0.penalty)
          }
          
          // 날짜 형식을 변경할것 - 2023.1.19 -> 2023.01.19이런식으로
          
          let startDate = "\($0.studyStartDate[0])-\($0.studyStartDate[1])-\($0.studyStartDate[2])"
          //          let startDate = ""
          let changedStartDate = startDate.convertDateString(from: .format3, to: "yyyy-MM-dd")
          self.startDateButton.setTitle(changedStartDate, for: .normal)
          
          let endDate = "\($0.studyEndDate[0])-\($0.studyEndDate[1])-\($0.studyEndDate[2])"
          //          let endDate = ""
          let changedEndDate = endDate.convertDateString(from: .format3, to: "yyyy-MM-dd")
          self.endDateButton.setTitle(changedEndDate, for: .normal)
        }
      }
      
    }
  }
  
  func compleButtonCheck(){
    chatLinkTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
  }
  
}

// MARK: - textField 0 입력 시
extension CreateStudyViewController {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    if textView == studyProduceTextView {
      checkButtonActivation()
      updateTextViewHeight()
    }
  }
  
  private func updateTextViewHeight() {
    let fixedWidth = studyProduceTextView.frame.size.width
    let newSize = studyProduceTextView.sizeThatFits(CGSize(width: fixedWidth,
                                                           height: CGFloat.greatestFiniteMagnitude))
    let newHeight = max(newSize.height, 170)
    studyProduceTextView.delegate = self
    studyProduceTextView.constraints.forEach { constraint in
      if constraint.firstAttribute == .height {
        constraint.constant = newHeight
      }
    }
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    let monitoredTextFields: [UITextField] = [chatLinkTextField, studymemberTextField,
                                              studytitleTextField, fineAmountTextField,
                                              fineTypesTextField]
    
    if monitoredTextFields.contains(textField) {
      checkButtonActivation()
    }
  }


  func checkButtonActivation() {
    if chatLinkTextField.text?.isEmpty == false &&
        studytitleTextField.text?.isEmpty == false &&
        studymemberTextField.text?.isEmpty == false &&
        studyProduceTextView.text != textViewContent &&
        selectedMajor != nil &&
        genderCheck == true &&
        contactMethod != nil &&
        startDateButton.currentTitle != "선택하기" &&
        endDateButton.currentTitle != "선택하기" {
      if fineCheck == true && fineAmountTextField.text?.isEmpty != false &&
          fineTypesTextField.text?.isEmpty != false {
        completeButton.isEnabled = false
        completeButton.backgroundColor = .o30
      } else {
        completeButton.isEnabled = true
        completeButton.backgroundColor = .o50
      }
    } else {
      completeButton.isEnabled = false
      completeButton.backgroundColor = .o30
    }
  }
  

  override func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == fineAmountTextField {
      if let text = fineAmountTextField.text,
         let number = Int(text),
         number >= 99999 {
        fineAmountTextField.text = "99999"
      }
    }
    
    if textField == studymemberTextField,
       let text = textField.text,
       let number = Int(text),
       !(2...50).contains(number){
      countAlert.isHidden = false
      studymemberTextField.layer.borderColor = UIColor.r50.cgColor
      
      scrollView.addSubview(countAlert)
      
      countAlert.snp.makeConstraints { make in
        make.top.equalTo(studymemberTextField.snp.bottom)
        make.leading.equalTo(studymemberTextField)
      }
      studymemberTextField.text = ""
    }
    else {
      studymemberTextField.layer.borderColor = UIColor.bg50.cgColor
      
      countAlert.isHidden = true
    }
  }
}

// MARK: - 캘린더에서 선택한 날짜로 바꿈
extension CreateStudyViewController: ChangeDateProtocol {
  func dataSend(data: String, buttonTag: Int) {
    if buttonTag == 1 {
      startDateButton.setTitle(data, for: .normal)
      self.startDateCheck = data
    } else if buttonTag == 2 {
      endDateButton.setTitle(data, for: .normal)
      self.endDateCheck = data
    }
  }
}
