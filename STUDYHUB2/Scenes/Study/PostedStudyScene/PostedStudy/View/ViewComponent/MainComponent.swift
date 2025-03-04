
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 스터디 상세VC 메인 component 
final class PostedStudyMainComponent: UIView {

  let disposeBag: DisposeBag = DisposeBag()

  /// 스터디 데이터
  var postedData: PostDetailData

  /// 스터디  게시글 게시한 날짜
  private lazy var postedDateLabel = UILabel().then {
    $0.textColor = .g70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }

  /// 학과 라벨
  private lazy var postedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.textColor = .o30
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    label.backgroundColor = .o60
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  /// 게시글 제목 라벨
  private lazy var postedTitleLabel = UILabel().then {
    $0.textColor = .white
    $0.font = UIFont(name: "Pretendard-Bold", size: 20)
  }
  
  /// 가능한 인원 숫자
  private lazy var availablePersonNum = postedData.studyPerson - postedData.remainingSeat
  
  /// 팀원수 스택뷰
  private lazy var memberNumberStackView = createInfoStack(
    labelText: "팀원수",
    imageName: "MemberNumberImage",
    countText: "\(availablePersonNum) /\(postedData.studyPerson)명",
    countColor: .o50
  )
  
  /// 벌금 스택뷰
  private lazy var fineStackView = createInfoStack(
    labelText: "벌금",
    imageName: "MoneyImage",
    countText: "\(postedData.penalty)원",
    countColor: .o50
  )
  
  /// 성별 스택뷰
  private lazy var genderStackView = createInfoStack(
    labelText: "성별",
    imageName: postedData.filteredGender ?? "",
    countText: Utils.convertGender(gender: postedData.filteredGender ?? ""),
    countColor: .white
  )
  
  /// 학과 스택뷰
  private lazy var postedMajorStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
 
  /// 게시일, 학과, 스터디 제목 스택뷰
  private lazy var postedInfoStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 15)
  
  /// 팀원수, 벌금, 성별 스택뷰
  private lazy var coreInfoStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
  
  /// 전체 스택뷰
  private lazy var topInfoStackView = StudyHubUI.createStackView(axis: .vertical, spacing: 15)
 
  let bottomSpaceView = UIView()
  
  init(with data: PostDetailData) {
    self.postedData = data
    
    super.init(frame: .zero)
    
    setupLayout()
    configureUI()
    setupUIData(data)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - setupLayout
  
  /// layout 설정
  private func setupLayout() {
    /// 학과
    [ postedMajorLabel, UIView()]
      .forEach { postedMajorStackView.addArrangedSubview($0) }
    
    /// 게시일, 학과, 스터디 제목
    [ postedDateLabel, postedMajorStackView, postedTitleLabel]
      .forEach { postedInfoStackView.addArrangedSubview($0) }
    
    /// 팀원수, 벌금, 성별
    [ memberNumberStackView, fineStackView, genderStackView ]
      .forEach { coreInfoStackView.addArrangedSubview($0) }
    
    /// 전체
    [ postedInfoStackView, coreInfoStackView, bottomSpaceView ]
      .forEach { topInfoStackView.addArrangedSubview($0) }
    
    self.addSubview(topInfoStackView)
  }
  
  private func configureUI() {
    coreInfoStackView.distribution = .fillEqually
    coreInfoStackView.alignment = .center
    coreInfoStackView.backgroundColor = UIColor(hexCode: "#1A1A1A")
    coreInfoStackView.layer.cornerRadius = 10
    coreInfoStackView.isLayoutMarginsRelativeArrangement = true
    coreInfoStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
    
    topInfoStackView.backgroundColor = .black
    postedInfoStackView.layoutMargins = UIEdgeInsets(top: 50, left: 10, bottom: 0, right: 0)
    postedInfoStackView.isLayoutMarginsRelativeArrangement = true
    
    bottomSpaceView.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    
    postedInfoStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    coreInfoStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    topInfoStackView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-20)
    }
  }

  
  /// 스터디 정보 스택뷰 생성 (팀원수, 벌금, 성별)
  /// - Parameters:
  ///   - labelText: 정보 제목 라벨
  ///   - imageName: 정보 이미지
  ///   - countText: 정보 관련 값
  ///   - countColor: 변경할 색상
  private func createInfoStack(
    labelText: String,
    imageName: String,
    countText: String,
    countColor: UIColor
  ) -> UIStackView {
    /// 제목  라벨 생성
    let label = UILabel().then {
      $0.text = labelText
      $0.textColor = .g60
      $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    }
   
    /// 이미지 생성
    let imageView = UIImageView(image: UIImage(named: imageName))
    
    /// 값 라벨 생성
    let countLabel = UILabel().then {
      $0.text = countText
      $0.textColor = countColor
      $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
     
    /// 스택뷰 생성
    let stackView = UIStackView().then {
      $0.axis = .vertical
      $0.spacing = 0
    }
    
    stackView.alignment = .center
    [ label, imageView, countLabel]
      .forEach { stackView.addArrangedSubview($0) }
    return stackView
  }
  
  
  /// 라벨의 색상 변경
  func changeLabelColor(_ label: UILabel, studyPerson: Int = 0) {
    guard let title = label.text else { return }
    switch title {
    case _ where title.contains("명"):
      label.changeColor(wantToChange: "/\(studyPerson)명", color: .white)
    case _ where title.contains("원"):
      label.changeColor(wantToChange: "원", color: .white)
    default:
      break
    }
  }
  
  // MARK: - setupBinding
  
  /// UI 별 데이터 세팅
  func setupUIData(_ data: PostDetailData){
    let createdData = data.createdDate
    postedDateLabel.text =  "\(createdData[0]). \(createdData[1]). \(createdData[2])"
    postedMajorLabel.text = Utils.convertMajor(data.major, toEnglish: false)
    postedTitleLabel.text = data.title

    let availablePersonNum = data.studyPerson - data.remainingSeat
    let title = "\(availablePersonNum) /\(data.studyPerson)명"
    changeLabelTextInStackView(memberNumberStackView, title: title, studyPerson: data.studyPerson)
    changeLabelTextInStackView(fineStackView, title: "\(data.penalty)원")
    
    let convertedGender = Utils.convertGender(gender: data.filteredGender ?? "")
    changeLabelTextInStackView(genderStackView, title: convertedGender)
    changeImageInStackView(genderStackView, gender: data.filteredGender ?? "")
  }
  
  func changeLabelTextInStackView(_ stackView: UIStackView, title: String, studyPerson: Int = 0){
    if let titleLabel = stackView.arrangedSubviews.last as? UILabel {
      titleLabel.text = title
      if studyPerson != 0 {
        changeLabelColor(titleLabel, studyPerson: studyPerson)
      } else {
        changeLabelColor(titleLabel)
      }
    }
  }
  
  func changeImageInStackView(_ stackView: UIStackView, gender: String){
    for view in stackView.arrangedSubviews {
      if let imageView = view as? UIImageView {
        imageView.image = UIImage(named: Utils.convertGenderImage(gender))
        break
      }
    }
  }
}
