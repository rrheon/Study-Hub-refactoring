import UIKit

import SnapKit

// 캘린더 커스텀하기, 캘린더 선택 버튼 수정
final class CreateStudyViewController: NaviHelper, ChangeDateProtocol {
  let tokenManager = TokenManager.shared
  let postInfoManager = PostDetailInfoManager.shared
  let postManager = PostManager.shared
  
  var genderType: String?
  var contactMethod: String?
  var selectedMajor: String?
  var modifyPostID: Int?
  
  // 선택한 학과를 저장할 프로퍼티
  var selectedDepartment: String? {
    didSet {
      // selectedDepartment가 설정되면 버튼을 생성
      if let department = selectedDepartment {
        addDepartmentButton(department)
      }
    }
  }
  
  var selectDate: String? = ""
  
  // MARK: - UI설정
  private lazy var completeButton: UIButton = {
    let completeButton = UIButton()
    completeButton.setTitle("완료하기", for: .normal)
    completeButton.setTitleColor(.white, for: .normal)
    completeButton.backgroundColor = UIColor(hexCode: "#FF5530")
    completeButton.layer.cornerRadius = 5
    completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    return completeButton
  }()
  
  private lazy var categoryStackView = createStackView(axis: .vertical,
                                                       spacing: 16)
  private lazy var departmentButtonStackView = createStackView(axis: .vertical,
                                                               spacing: 16)
  // 성별버튼
  private lazy var allGenderButton = createContactButton(title: "무관",
                                                         selector: #selector(genderButtonTapped(_:)))
  
  private lazy var maleOnlyButton = createContactButton(title: "남자만",
                                                        selector:#selector(genderButtonTapped(_:)))
  private lazy var femaleOnlyButton = createContactButton(title: "여자만",
                                                          selector: #selector(genderButtonTapped(_:)))
  // 대면 비대면 버튼
  private lazy var contactButton = createContactButton(title: "대면",
                                                       selector: #selector(meetButtonTapped(_:)))
  
  private lazy var untactButton = createContactButton(title: "비대면",
                                                      selector: #selector(meetButtonTapped(_:)))
  
  private lazy var mixmeetButton = createContactButton(title: "혼합",
                                                       selector: #selector(meetButtonTapped(_:)))
  
  // 벌금버튼
  private lazy var haveFineButton = createFineButton(selector: #selector(haveFineButtonTapped(_:)))
  
  private lazy var noFineButton = createFineButton(selector: #selector(noFineButtonTapped(_:)))
  
  private lazy var fineButtonsStackView = createStackView(axis: .horizontal,
                                                          spacing: 10)
  private lazy var finefixStackView = createStackView(axis: .vertical,
                                                      spacing: 10)
  
  private lazy var periodStackView = createStackView(axis: .vertical,
                                                     spacing: 16)
  
  private lazy var startDateButton = createDateButton(selector: #selector(calendarButtonTapped))
  private lazy var endDateButton = createDateButton(selector: #selector(calendarButtonTapped))
  
  private lazy var chatLinkTextField = createTextField(title: "채팅방 링크를 첨부해 주세요")
  
  
  private lazy var studyproduceTextView: UITextView = {
    let tv = UITextView()
    tv.text = "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
    tv.textColor = UIColor.lightGray
    tv.font = UIFont.systemFont(ofSize: 15)
    tv.layer.borderWidth = 0.5
    tv.layer.borderColor = UIColor.lightGray.cgColor
    tv.layer.cornerRadius = 5.0
    tv.delegate = self
    tv.textViewDidChange(tv)
    return tv
  }()
  
  private lazy var fineAmountTextField = createTextField(title: "금액을 알려주세요")
  
  private lazy var studymemberTextField = createTextField(title: "스터디 인원을 알려주세요")
  private lazy var studytitleTextField = createTextField(title: "제목을 적어주세요")
  
  let startDatePicker = UIDatePicker()
  let startDateTextField = UITextField()
  var selectedStartDate: Date?
  
  let endDatePicker = UIDatePicker()
  let endDateTextField = UITextField()
  var selectedEndDate: Date?
  
  private lazy var headerContentStackView = createStackView(axis: .vertical,
                                                            spacing: 40)
  
  private lazy var chatLinkStackView = createStackView(axis: .vertical,
                                                       spacing: 16)
  
  private lazy var chatLinkLabel = createLabel(title: "채팅방 링크",
                                               textColor: .black,
                                               fontType: "Pretendard",
                                               fontSize: 18)
  
  
  private lazy var descriptionLabel = createLabel(title: "참여코드가 없는 카카오톡 오픈 채팅방 링크로 첨부",
                                                  textColor: .gray,
                                                  fontType: "Pretendard",
                                                  fontSize: 14)
  
  private let chatLinkDividerLine: UIView = {
    let chatLinkDividerLine = UIView()
    chatLinkDividerLine.backgroundColor = UIColor(hexCode: "#F3F5F6")
    return chatLinkDividerLine
  }()
  
  private lazy var studyinfoStackView = createStackView(axis: .vertical,
                                                        spacing: 16)
  
  private lazy var studytitleLabel = createLabel(title: "스터디 제목",
                                                 textColor: .black,
                                                 fontType: "Pretendard",
                                                 fontSize: 18)
  
  private lazy var studyproduceLabel = createLabel(title: "내용",
                                                   textColor: .black,
                                                   fontType: "Pretendard",
                                                   fontSize: 18)
  
  private let studyinfoStackViewDividerLine: UIView = {
    let studyinfoStackViewDividerLine = UIView()
    studyinfoStackViewDividerLine.backgroundColor = UIColor(hexCode: "#F3F5F6")
    return studyinfoStackViewDividerLine
  }()
  
  private lazy var associatedepartLabel = createLabel(title: "관련 학과 선택",
                                                      textColor: .black,
                                                      fontType: "Pretendard",
                                                      fontSize: 18)
  private lazy var selectMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    label.textColor = .bg80
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    let img = UIImage(named: "DeleteImg")
    button.setImage(img, for: .normal)
    button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var periodLabel = createLabel(title: "기간",
                                             textColor: .black,
                                             fontType: "Pretendard",
                                             fontSize: 18)
  
  private lazy var startLabel = createLabel(title: "시작하는 날",
                                            textColor: .black,
                                            fontType: "Pretendard",
                                            fontSize: 18)
  
  
  private lazy var endLabel = createLabel(title: "종료하는 날",
                                          textColor: .black,
                                          fontType: "Pretendard",
                                          fontSize: 18)
  
  
  private lazy var genderLabel = createLabel(title: "성별",
                                             textColor: .black,
                                             fontType: "Pretendard",
                                             fontSize: 18)
  
  private lazy var studymembercountLabel = createLabel(title: "인원",
                                                       textColor: .black,
                                                       fontType: "Pretendard",
                                                       fontSize: 18)
  
  private lazy var studymemberLabel = createLabel(title: "스터디 팀원",
                                                  textColor: .black,
                                                  fontType: "Pretendard",
                                                  fontSize: 18)
  
  private lazy var studymethodLabel = createLabel(title: "스터디 방식",
                                                  textColor: .black,
                                                  fontType: "Pretendard",
                                                  fontSize: 18)
  
  private lazy var meetLabel = createLabel(title: "대면 여부",
                                           textColor: .black,
                                           fontType: "Pretendard",
                                           fontSize: 18)
 private lazy var fineTypesTextField = createTextField(title: "지각비, 결석비 등")

  private lazy var fineLabel = createLabel(title: "벌금",
                                           textColor: .black,
                                           fontType: "Pretendard",
                                           fontSize: 18)
  
  private lazy var haveFineLabel = createLabel(title: "있어요",
                                               textColor: .black,
                                               fontType: "Pretendard",
                                               fontSize: 16)
  
  private lazy var noFineLabel = createLabel(title: "없어요",
                                             textColor: .black,
                                             fontType: "Pretendard",
                                             fontSize: 16)
  
  private lazy var associatedepartStackView = createStackView(axis: .horizontal,
                                                              spacing: 16)
  
  private lazy var studymemberStackView = createStackView(axis: .vertical,
                                                          spacing: 16)
  
  private lazy var genderButtonsStackView = createStackView(axis: .horizontal,
                                                            spacing: 16)
  
  private lazy var meetButtonsStackView = createStackView(axis: .horizontal,
                                                          spacing: 16)
  
  private lazy var description4Label = createLabel(title: "최대 50명 참여 가능",
                                                   textColor: UIColor(hexCode: "#A1AAB0"),
                                                   fontType: "Pretendard",
                                                   fontSize: 12)
  
  private lazy var countLabel = createLabel(title: "명",
                                            textColor: UIColor(hexCode: "#68737D"),
                                            fontType: "Pretendard",
                                            fontSize: 15)
  
  private lazy var description5Label = createLabel(title: "참여자의 성별 선택",
                                                   textColor: UIColor(hexCode: "#A1AAB0"),
                                                   fontType: "Pretendard",
                                                   fontSize: 12)
  
  
  private lazy var studymethodStackView = createStackView(axis: .vertical,
                                                          spacing: 16)
  
  
  private lazy var description6Label = createLabel(title: "대면이나 혼합일 경우, 관련 내용에 대한 계획을 소개에 적어주세요",
                                                   textColor: UIColor(hexCode: "#A1AAB0"),
                                                   fontType: "Pretendard",
                                                   fontSize: 12)
  
  private lazy var categoryStackViewDividerLine = createDividerLine(height: 10)
  private lazy var grayDividerLine = createDividerLine(height: 2)
  private lazy var studymemberStackViewDividerLine = createDividerLine(height: 10)
  private lazy var grayDividerLine2 = createDividerLine(height: 2)
  private lazy var studymethodStackViewDividerLine = createDividerLine(height: 10)
  private lazy var grayDividerLine3 = createDividerLine(height: 2)
  
  private lazy var associatedepartButton: UIButton = {
    let associatedepartButton = UIButton(type: .system)
    associatedepartButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    associatedepartButton.tintColor = .black
    associatedepartButton.addTarget(self, action: #selector(departmentArrowButtonTapped), for: .touchUpInside)
    return associatedepartButton
  }()
  
  private lazy var countAlert = createLabel(title: "1명부터 가능해요(본인 제외)",
                                            textColor: .r50,
                                            fontType: "Pretendard",
                                            fontSize: 12)
  
  let scrollView = UIScrollView()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
    postModify()

  }
  
  // MARK: - setUpLayout
  func setUpLayout(){

    headerContentStackView.addArrangedSubview(chatLinkStackView)
    headerContentStackView.addArrangedSubview(chatLinkDividerLine)
    headerContentStackView.addArrangedSubview(studyinfoStackView)
    
    // 키보드 내리기를 위한 탭 제스처 추가
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    view.addGestureRecognizer(tapGesture)
    
    chatLinkDividerLine.heightAnchor.constraint(equalToConstant: 10).isActive = true
    
    chatLinkTextField.clearButtonMode = .always
    chatLinkStackView.addArrangedSubview(chatLinkLabel)
    chatLinkStackView.addArrangedSubview(descriptionLabel)
    chatLinkStackView.addArrangedSubview(chatLinkTextField)
    
    studyproduceTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    studyinfoStackViewDividerLine.heightAnchor.constraint(equalToConstant: 10).isActive = true
    
    studyinfoStackView.addArrangedSubview(studytitleLabel)
    studyinfoStackView.addArrangedSubview(studytitleTextField)
    studyinfoStackView.addArrangedSubview(studyproduceLabel)
    studyinfoStackView.addArrangedSubview(studyproduceTextView)
    
    headerContentStackView.addArrangedSubview(studyinfoStackViewDividerLine)
    headerContentStackView.addArrangedSubview(categoryStackView)
    headerContentStackView.addArrangedSubview(categoryStackViewDividerLine)
    headerContentStackView.addArrangedSubview(studymemberStackView)
    headerContentStackView.addArrangedSubview(studymethodStackViewDividerLine)
    headerContentStackView.addArrangedSubview(studymethodStackView)
    headerContentStackView.addArrangedSubview(studymemberStackViewDividerLine)
    headerContentStackView.addArrangedSubview(periodStackView)
    
    categoryStackView.addArrangedSubview(associatedepartStackView)
    categoryStackView.addArrangedSubview(departmentButtonStackView)
    
    associatedepartStackView.addArrangedSubview(associatedepartLabel)
    associatedepartStackView.addArrangedSubview(associatedepartButton)
    
    studymemberTextField.addSubview(countLabel)
    
    genderButtonsStackView.distribution = .fillEqually
    genderButtonsStackView.addArrangedSubview(allGenderButton)
    genderButtonsStackView.addArrangedSubview(maleOnlyButton)
    genderButtonsStackView.addArrangedSubview(femaleOnlyButton)
    
    studymemberStackView.addArrangedSubview(studymemberLabel)
    studymemberStackView.addArrangedSubview(grayDividerLine)
    studymemberStackView.addArrangedSubview(studymembercountLabel)
    studymemberStackView.addArrangedSubview(description4Label)
    studymemberStackView.addArrangedSubview(studymemberTextField)
    studymemberStackView.addArrangedSubview(genderLabel)
    studymemberStackView.addArrangedSubview(description5Label)
    studymemberStackView.addArrangedSubview(genderButtonsStackView)
    
    meetButtonsStackView.distribution = .fillEqually
    meetButtonsStackView.addArrangedSubview(mixmeetButton)
    meetButtonsStackView.addArrangedSubview(contactButton)
    meetButtonsStackView.addArrangedSubview(untactButton)
    
    fineButtonsStackView.addArrangedSubview(haveFineButton)
    fineButtonsStackView.addArrangedSubview(haveFineLabel)
    fineButtonsStackView.addArrangedSubview(noFineButton)
    fineButtonsStackView.addArrangedSubview(noFineLabel)
    
    studymethodStackView.addArrangedSubview(studymethodLabel)
    studymethodStackView.addArrangedSubview(grayDividerLine2)
    studymethodStackView.addArrangedSubview(meetLabel)
    studymethodStackView.addArrangedSubview(description6Label)
    studymethodStackView.addArrangedSubview(meetButtonsStackView)
    studymethodStackView.addArrangedSubview(fineLabel)
    studymethodStackView.addArrangedSubview(fineButtonsStackView)
    studymethodStackView.addArrangedSubview(finefixStackView)
    
    // Add UI elements to the headerContentStackView
    startDateButton.tag = 1
    endDateButton.tag = 2
    periodStackView.addArrangedSubview(periodLabel)
    periodStackView.addArrangedSubview(grayDividerLine3)
    periodStackView.addArrangedSubview(startLabel)
    periodStackView.addArrangedSubview(startDateButton)
    periodStackView.addArrangedSubview(endLabel)
    periodStackView.addArrangedSubview(endDateButton)
    // Add the completeButton to the periodStackView
    periodStackView.addArrangedSubview(completeButton)
    
    // Constraints for the "완료하기" button
    completeButton.leadingAnchor.constraint(equalTo: periodStackView.leadingAnchor,
                                            constant: 16).isActive = true
    completeButton.trailingAnchor.constraint(equalTo: periodStackView.trailingAnchor,
                                             constant: -16).isActive = true
    completeButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
    
    // Create a scroll view to make the content scrollable
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(headerContentStackView)
    view.addSubview(scrollView)
    
    scrollView.backgroundColor = .white
    
    headerContentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
  }
  // MARK: - makeUI
  func makeUI(){
//    headerStackView.snp.makeConstraints { make in
//      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//      make.leading.equalTo(view.snp.leading).offset(-60)
//      make.trailing.equalTo(view.snp.trailing).offset(-16)
//    }
//
//    createStudyLabel.snp.makeConstraints { make in
//      make.centerX.equalTo(headerStackView.snp.centerX).offset(100)
//    }
    headerContentStackView.snp.makeConstraints { make in
      make.top.equalTo(scrollView.snp.top).offset(30)
      make.leading.trailing.bottom.equalTo(scrollView)
      make.width.equalTo(scrollView)
    }
    
    chatLinkLabel.snp.makeConstraints { make in
      make.leading.equalTo(chatLinkStackView).offset(16)
      make.trailing.equalTo(chatLinkStackView).offset(10)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(chatLinkLabel.snp.bottom).offset(10)
      make.leading.equalTo(chatLinkStackView).offset(16)
      make.trailing.equalTo(chatLinkStackView).offset(100)
    }
    
    chatLinkTextField.snp.makeConstraints { make in
      make.leading.equalTo(chatLinkStackView).offset(16)
      make.trailing.equalTo(chatLinkStackView)
      make.width.equalTo(chatLinkStackView).offset(-50)
      make.height.equalTo(50)
    }
    
    studytitleLabel.snp.makeConstraints { make in
      make.top.equalTo(studyinfoStackView.snp.top).offset(-20)
      make.leading.equalTo(studyinfoStackView).offset(16)
      make.trailing.equalTo(studyinfoStackView).offset(5)
    }
    
    studytitleTextField.snp.makeConstraints { make in
      make.leading.equalTo(studyinfoStackView).offset(16)
      make.trailing.equalTo(chatLinkTextField)
      make.height.equalTo(50)
    }
    
    studyproduceLabel.snp.makeConstraints { make in
      make.top.equalTo(studytitleTextField.snp.bottom).offset(20)
      make.leading.equalTo(studyinfoStackView).offset(16)
      make.trailing.equalTo(studyinfoStackView).offset(10)
    }
    
    studyproduceTextView.snp.makeConstraints { make in
      make.leading.equalTo(studyinfoStackView).offset(16)
      make.trailing.equalTo(studyinfoStackView)
      make.width.equalTo(studyinfoStackView).offset(-50)
    }
    // (3) 카테고리 뷰
    associatedepartStackView.snp.makeConstraints { make in
      make.leading.equalTo(categoryStackView).offset(16)
      make.trailing.equalTo(categoryStackView)
    }
    
    associatedepartButton.snp.makeConstraints { make in
      make.leading.equalTo(studyproduceTextView.snp.trailing).offset(-20)
      make.trailing.equalTo(studyproduceTextView.snp.trailing)
    }
    
    // (4) 스터디멤버 뷰
    studymemberLabel.snp.makeConstraints { make in
      make.top.equalTo(studymemberStackView).offset(-20)
      make.leading.equalTo(studymemberStackView).offset(16)
      make.trailing.equalTo(studymemberStackView).offset(5)
    }
    
    grayDividerLine.snp.makeConstraints { make in
      make.leading.equalTo(studymemberStackView).offset(0)
      make.trailing.equalTo(studymemberStackView).offset(10)
    }
    
    studymembercountLabel.snp.makeConstraints { make in
      make.leading.equalTo(studymemberStackView).offset(16)
      make.trailing.equalTo(studymemberStackView).offset(5)
    }
    
    description4Label.snp.makeConstraints { make in
      make.top.equalTo(studymembercountLabel.snp.bottom).offset(10)
      make.leading.equalTo(studymemberStackView).offset(16)
      make.trailing.equalTo(studymemberStackView).offset(100)
    }
    
    studymemberTextField.snp.makeConstraints { make in
      make.leading.equalTo(studymemberStackView).offset(16)
      make.trailing.equalTo(studymemberStackView)
      make.width.equalTo(studymemberStackView).offset(-50)
      make.height.equalTo(50)
    }
    
    countLabel.snp.makeConstraints { make in
      make.centerY.equalTo(studymemberTextField)
      make.trailing.equalTo(studymemberTextField).offset(-8)
      make.width.equalTo(20)
      make.height.equalTo(20)
    }
    
    genderLabel.snp.makeConstraints { make in
      make.leading.equalTo(studymemberStackView.snp.leading).offset(16)
      make.trailing.equalTo(studymemberStackView.snp.trailing).offset(10)
    }
    
    description5Label.snp.makeConstraints { make in
      make.top.equalTo(genderLabel.snp.bottom).offset(10)
      make.leading.equalTo(studymemberStackView.snp.leading).offset(16)
      make.trailing.equalTo(studymemberStackView.snp.trailing).offset(10)
    }
    
    genderButtonsStackView.snp.makeConstraints { make in
      make.trailing.equalTo(studymemberStackView.snp.trailing).offset(-100)
      make.top.equalTo(description5Label.snp.bottom).offset(8)
      make.height.equalTo(30)
    }
    
    studymethodLabel.snp.makeConstraints { make in
      make.top.equalTo(studymethodStackView.snp.top).offset(-20)
      make.leading.equalTo(studymethodStackView).offset(16)
      make.trailing.equalTo(studymethodStackView).offset(5)
    }
    meetLabel.snp.makeConstraints { make in
      make.leading.equalTo(studymethodStackView).offset(16)
      make.trailing.equalTo(studymethodStackView).offset(5)
    }
    
    description6Label.snp.makeConstraints { make in
      make.top.equalTo(meetLabel.snp.bottom).offset(10)
      make.leading.equalTo(studymethodStackView).offset(16)
      make.trailing.equalTo(studymethodStackView).offset(100)
    }
    
    meetButtonsStackView.snp.makeConstraints { make in
      make.trailing.equalTo(studymethodStackView).offset(-150)
    }
    
    fineLabel.snp.makeConstraints { make in
      make.leading.equalTo(studymethodStackView).offset(16)
      make.trailing.equalTo(studymethodStackView).offset(100)
    }
    
    fineButtonsStackView.snp.makeConstraints { make in
      make.leading.equalTo(studymethodStackView).offset(16)
      make.trailing.equalTo(studymethodStackView).offset(50)
    }
    
    grayDividerLine2.snp.makeConstraints { make in
      make.leading.equalTo(studymethodStackView)
      make.trailing.equalTo(studymethodStackView).offset(10)
    }
    // 스터디기간 뷰
    periodLabel.snp.makeConstraints { make in
      make.top.equalTo(periodStackView.snp.top).offset(-20)
      make.leading.equalTo(periodStackView).offset(16)
      make.trailing.equalTo(periodStackView).offset(5)
    }
    
    grayDividerLine3.snp.makeConstraints { make in
      make.leading.equalTo(periodStackView)
      make.trailing.equalTo(periodStackView).offset(10)
    }
    
    startLabel.snp.makeConstraints { make in
      make.leading.equalTo(periodStackView).offset(16)
      make.trailing.equalTo(periodStackView).offset(10)
    }
    startDateButton.snp.makeConstraints { make in
      make.leading.equalTo(periodStackView).offset(16)
      make.trailing.equalTo(periodStackView).offset(-16)
      make.height.equalTo(50)
    }
    
    endLabel.snp.makeConstraints { make in
      make.leading.equalTo(periodStackView).offset(16)
      make.trailing.equalTo(periodStackView).offset(10)
    }
    
    endDateButton.snp.makeConstraints { make in
      make.leading.equalTo(periodStackView).offset(16)
      make.trailing.equalTo(periodStackView).offset(-16)
      make.height.equalTo(50)
    }
    
    endDateButton.snp.makeConstraints { make in
      make.bottom.equalTo(completeButton.snp.top).offset(-40)
    }
    
    scrollView.snp.makeConstraints { make in
//      make.top.equalTo(headerStackView.snp.bottom).offset(16)
//      make.leading.equalTo(view)
//      make.trailing.equalTo(view)
//      make.bottom.equalTo(view)
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
    
    guard let postID = modifyPostID else {
      navigationController?.popViewController(animated: true)
      return
    }
    
    let popupVC = PopupViewController(title: "수정을 취소할까요?",
                                      desc: "취소할 시 내용이 저장되지 않아요",
                                      leftButtonTitle: "아니요",
                                      rightButtonTilte: "네")
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)
    }
    self.present(popupVC, animated: true)
  }
  
  // MARK: -  선택한 학과에 대한 버튼을 생성
  func addDepartmentButton(_ department: String) {
    selectedMajor = department
    
    let labelText = selectedMajor
    let labelSize = (labelText as? NSString)?.size(withAttributes: [NSAttributedString.Key.font: selectMajorLabel.font!])
    
    selectMajorLabel.text = labelText
    selectMajorLabel.clipsToBounds = true
    selectMajorLabel.layer.cornerRadius = 15
    selectMajorLabel.backgroundColor = .bg30
    selectMajorLabel.textAlignment = .left
    selectMajorLabel.adjustsFontSizeToFitWidth = true
    
    selectedMajor = selectMajorLabel.text ?? ""
    
    scrollView.addSubview(selectMajorLabel)
    scrollView.addSubview(cancelButton)
    
    selectMajorLabel.snp.makeConstraints { make in
      make.top.equalTo(associatedepartLabel.snp.bottom).offset(10)
      make.leading.equalTo(associatedepartLabel)
      make.width.equalTo((labelSize?.width ?? 30) + 35)
      make.height.equalTo(30)
    }
    
    cancelButton.snp.makeConstraints { make in
      make.centerY.equalTo(selectMajorLabel.snp.centerY)
      make.leading.equalTo(selectMajorLabel.snp.trailing).offset(-35)
    }
    view.layoutIfNeeded()
  }
  
  @objc func cancelButtonTapped(){
    selectMajorLabel.isHidden = true
    cancelButton.isHidden = true
    
    selectedMajor = nil
  }
  
  // 키보드 내리기 위한 탭 제스처 핸들러
  @objc func handleTap() {
    // 키보드를 내립니다.
    view.endEditing(true)
  }
  
  // MARK: - 벌금 있을 때 함수
  @objc func haveFineButtonTapped(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    noFineButton.isSelected = !sender.isSelected
    
    if sender.isSelected {
      // Create a label for "어떤 벌금인가요?"
      let fineTypeLabel = createLabel(title:"어떤 벌금인가요?",
                                      textColor: UIColor(hexCode: "#49545C"),
                                      fontType: "Pretendard",
                                      fontSize: 14)
      
      
      // Create a text field for "얼마인가요?"
      let fineAmountLabel = createLabel(title: "얼마인가요?",
                                        textColor: UIColor(hexCode: "#49545C"),
                                        fontType: "Pretendard",
                                        fontSize: 14)
      // Create a label for
      let countLabel2 = createLabel(title: "원",
                                    textColor: UIColor(hexCode: "#68737D"),
                                    fontType: "Pretendard",
                                    fontSize: 15)
      
      lazy var maxFineLabel = createLabel(title: "최대 99,999원",
                                          textColor: UIColor(hexCode: "#A1AAB0"),
                                          fontType: "Pretendard",
                                          fontSize: 12)
      
      fineAmountTextField.addSubview(countLabel2)
      
      finefixStackView.addArrangedSubview(fineTypeLabel)
      finefixStackView.addArrangedSubview(fineTypesTextField)
      finefixStackView.addArrangedSubview(fineAmountLabel)
      finefixStackView.addArrangedSubview(fineAmountTextField)
      finefixStackView.addArrangedSubview(maxFineLabel)
      
      // Constraints for chatLinkTextField
      fineTypesTextField.snp.makeConstraints { make in
        make.leading.equalTo(fineButtonsStackView)
        make.trailing.equalTo(fineButtonsStackView)
        make.width.equalTo(fineButtonsStackView).offset(-30)
      }
      
      fineAmountTextField.snp.makeConstraints { make in
        make.leading.equalTo(fineButtonsStackView)
        make.trailing.equalTo(fineButtonsStackView)
        make.width.equalTo(fineButtonsStackView).offset(-30)
      }
      
      countLabel2.snp.makeConstraints { make in
        make.centerY.equalTo(fineAmountTextField)
        make.trailing.equalTo(fineAmountTextField).offset(-8)
        make.width.equalTo(20)
        make.height.equalTo(20)
      }
      
      maxFineLabel.snp.makeConstraints { make in
        make.top.equalTo(fineAmountTextField.snp.bottom).offset(10)
      }
    }
  }
  
  // MARK: - 완료버튼 누를 때 함수
  @objc func completeButtonTapped() {
    // 수정하려면 postid도 넣어야함
    let test = (modifyPostID == nil) ? "POST" : "PUT"
    
    if test == "PUT" {
      let chatUrl = chatLinkTextField.text ?? ""
      let content = studyproduceTextView.text ?? ""
      let gender = genderType ?? "null"
      let major = convertMajor(selectedMajor ?? "", isEnglish: true)
      let penalty = Int(fineAmountTextField.text ?? "0") ?? 0
      let penaltyWay = fineTypesTextField.text ?? ""

      let endDate = endDateButton.currentTitle ?? ""
      let studyEndDate = endDate.replacingOccurrences(of: ". ", with: "-")

      let studyPerson = Int(studymemberTextField.text ?? "") ?? 0

      let stratDate = endDateButton.currentTitle ?? ""
      let studyStartDate = stratDate.replacingOccurrences(of: ". ", with: "-")
      let studyWay = contactMethod ?? "CONTACT"
      let title = studytitleTextField.text ?? ""

        // 시작하는 날 종료하는 날의 버튼형식이 이상함, postedData에서 가져오는거라 처음에 .으로 가져와짐 -> - 으로 바꿔야함
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
      postManager.modifyPost(data: updatePostData) {
        self.navigationController?.popViewController(animated: true)
        self.showToast(message: "글이 수정됐어요.", alertCheck: true)
      }
    } else {
      let studyData = CreateStudyRequest(
        chatUrl: chatLinkTextField.text ?? "",
        close: false,
        content: studyproduceTextView.text ?? "",
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
      print(studyData)
      postManager.createPost(createPostDatas: studyData) {
        print("생성시작")
      }
    }
  }
  
  // MARK: - 벌금 없을 때 함수
  @objc func noFineButtonTapped(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    haveFineButton.isSelected = !sender.isSelected
    
    // Remove the labels and text fields from the finefixStackView
    finefixStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
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
      genderType = "null"
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
      contactMethod = "UNCONTACT"
    }
    else {
      contactMethod = "MIX"
    }
  }
  
  // MARK: - calenderTapped함수
  @objc func calendarButtonTapped(_ sender: Any) {
    let viewControllerToPresent = CalendarViewController()
    viewControllerToPresent.delegate = self
    
    if (sender as AnyObject).tag == 1 {
      viewControllerToPresent.buttonSelect = true
    } else {
      viewControllerToPresent.buttonSelect = false
    }
    if #available(iOS 15.0, *) {
      if let sheet = viewControllerToPresent.sheetPresentationController {
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
    self.present(viewControllerToPresent, animated: true, completion: nil)
  }
  
  // 캘린더에서 선택한 날짜로 바꿈
  func dataSend(data: String, buttonTag: Int) {
    if buttonTag == 1 {
      startDateButton.setTitle(data, for: .normal)
    } else if buttonTag == 2 {
      endDateButton.setTitle(data, for: .normal)
    }
  }
  
  // MARK: - 수정하기눌렀을 때 데이터 가져옴
  func postModify(){
    guard let postID = modifyPostID else { return }
    
    self.navigationItem.title = "수정하기"
    self.navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    postInfoManager.getPostDetailData(postID: postID) {
      let modifyData = self.postInfoManager.getPostDetailData()
      
      DispatchQueue.main.async {
        modifyData.map {
          self.chatLinkTextField.text = $0.chatURL
          self.studyproduceTextView.text = $0.content
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
          
          if $0.penaltyWay == nil {
            self.noFineButtonTapped(self.noFineButton)
          } else {
            self.haveFineButtonTapped(self.haveFineButton)
          }
          
          self.fineAmountTextField.text = String($0.penalty)
          
          // 날짜 형식을 변경할것 - 2023.1.19 -> 2023.01.19이런식으로
          let startDate = "\($0.studyStartDate[0])-\($0.studyStartDate[1])-\($0.studyStartDate[2])"

          let changedStartDate = startDate.convertDateString(from: .format3, to: "yyyy-MM-dd")
          self.startDateButton.setTitle(changedStartDate, for: .normal)
          
          let endDate = "\($0.studyEndDate[0])-\($0.studyEndDate[1])-\($0.studyEndDate[2])"
          let changedEndDate = endDate.convertDateString(from: .format3, to: "yyyy-MM-dd")
        
          self.endDateButton.setTitle(changedEndDate, for: .normal)
        }
      }

    }
  }
  
}

// MARK: - textField 0 입력 시
extension CreateStudyViewController {
  override func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == studymemberTextField, let text = textField.text, text == "0" {
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



