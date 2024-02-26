//
//  ParticipateVC.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/01/22.
//

import UIKit

import SnapKit

final class ParticipateVC: NaviHelper {
  
  let participateManager = ParticipateManager.shared
  let postDeatilManager = PostDetailInfoManager.shared
  let userDataManager = UserInfoManager.shared
  
  var beforeVC: PostedStudyViewController?
  var postData: PostDetailData? = nil
  
  var studyId: Int = 0
  var postId: Int = 0
  
  // MARK: - UI세팅
  private lazy var titleLabel = createLabel(
    title: "자기소개나 스터디에 대한 의지를 스터디 팀장에게 알려 주세요! 💬",
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 16)
  
  private lazy var reasonTextView: UITextView = {
    let textView = UITextView()
    textView.text =
    "ex) 안녕하세요, 저는 경영학부에 재학 중인 허브입니다! 지각이나 잠수 없이 열심히 참여하겠습니다. 잘 부탁드립니다 :)"
    textView.textColor = .bg70
    textView.layer.cornerRadius = 10
    textView.layer.borderWidth = 1
    textView.layer.borderColor = UIColor.bg50.cgColor
    textView.font = UIFont(name: "Pretendard", size: 14)
    textView.delegate = self
    return textView
  }()
  
  private lazy var countContentLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard", size: 12)
    label.text = "0/200"
    return label
  }()
  
  private lazy var bottomLabel = createLabel(
    title: "- 수락 여부는 알림으로 알려드려요\n- 채팅방 링크는 ‘마이페이지-참여한 스터디’에서 확인할 수 있어요",
    textColor: .bg60,
    fontType: "Pretendard",
    fontSize: 12)
  
  private lazy var completeButton: UIButton = {
    let button = UIButton()
    button.setTitle("완료", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .o30
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 16)
    button.addAction(UIAction { _ in
      self.completeButtonTapped()
    }, for: .touchUpInside)
    button.isEnabled = false
    button.layer.cornerRadius = 10
    return button
  }()
  
  override func viewWillDisappear(_ animated: Bool) {
    print("1")
    
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    navigationItemSetting()
  
    changeTitleLabelColor()
    
    postDeatilManager.searchSinglePostData(postId: postId,
                                           loginStatus: true) {
      self.postData = self.postDeatilManager.getPostDetailData()
      
      self.setupLayout()
      self.makeUI()
    }
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      reasonTextView,
      countContentLabel,
      bottomLabel,
      completeButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    titleLabel.numberOfLines = 0
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    reasonTextView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(titleLabel)
      $0.height.equalTo(170)
    }
    
    countContentLabel.snp.makeConstraints {
      $0.top.equalTo(reasonTextView.snp.bottom).offset(10)
      $0.trailing.equalTo(reasonTextView.snp.trailing)
    }
    
    bottomLabel.numberOfLines = 0
    bottomLabel.setLineSpacing(spacing: 5)
    bottomLabel.snp.makeConstraints {
      $0.bottom.equalTo(completeButton.snp.top).offset(-30)
      $0.leading.equalTo(completeButton)
    }
    
    completeButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-40)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(55)
    }
  }
  
  // MARK: - 네비게이션 세팅
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    settingNavigationTitle(title: "참여하기",
                           font: "Pretendard-Bold",
                           size: 18)
    navigationItem.rightBarButtonItem = .none
  }
  
  // MARK: - 메인라벨 텍스트 색상 변경
  func changeTitleLabelColor(){
    titleLabel.changeColor(label: titleLabel,
                           wantToChange: "자기소개",
                           color: .o50)
    titleLabel.changeColor(label: titleLabel,
                           wantToChange: "스터디에 대한 의지",
                           color: .o50)
  }
  
  // MARK: - 완료버튼 tapped
  func completeButtonTapped(){
    guard let text = reasonTextView.text else { return }

    if text.count < 10 {
      showToast(message: "팀장이 회원님에 대해 알 수 있도록 10자 이상 적어주세요.", alertCheck: false)
    } else {
      userDataManager.getUserInfo { userData in
        let postedGender = self.postData?.filteredGender
        if userData?.gender == postedGender || postedGender == "MIX" {
          self.participateManager.participateStudy(introduce: text,
                                                   studyId: self.studyId) {
            
            DispatchQueue.main.async {
              self.navigationController?.popViewController(animated: true)
              self.showToast(message: "참여 신청이 완료됐어요.", alertCheck: true)
              self.beforeVC?.participateCheck = true
              self.beforeVC?.redrawUI()
            }
          }
        } else {
          DispatchQueue.main.async {
            self.showToast(message: "이 스터디는 성별 제한이 있는 스터디예요.", alertCheck: false)
            return
          }
        }
      }
    }
  }
}

// MARK: - textview
extension ParticipateVC {
  override func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.bg70 {
      textView.text = nil
      textView.textColor = UIColor.black
      textView.layer.borderColor = UIColor.black.cgColor
      
      if self.postData?.apply == false {
        completeButton.isEnabled = true
        completeButton.backgroundColor = .o50
      }
    }
  }
  
  override func textViewDidEndEditing(_ textView: UITextView) {
    
    if textView.text.isEmpty {
      textView.text = "ex) 욕설 등의 부적절한 말을 사용했습니다, 저희 스터디와 맞지 않습니다"
      textView.textColor = UIColor.bg70
      textView.layer.borderColor = UIColor.bg50.cgColor
      
      completeButton.isEnabled = false
      completeButton.backgroundColor = .o30
    }
  }
  
  func textView(_ textView: UITextView,
                shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    let currentText = textView.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    
    let changedText = currentText.replacingCharacters(in: stringRange, with: text)
    
    countContentLabel.text = "\(changedText.count)/200"
    countContentLabel.changeColor(label: countContentLabel,
                                  wantToChange: "\(changedText.count)",
                                  color: .black)
    return changedText.count <= 199
  }
}


