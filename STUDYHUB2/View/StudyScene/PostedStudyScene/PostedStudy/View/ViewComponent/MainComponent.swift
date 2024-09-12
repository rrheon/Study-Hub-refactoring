import UIKit

import SnapKit

final class PostedStudyMainComponent: UIView {
  let postedValues: PostDetailData
  let viewModel: PostedStudyViewModel
  
  private lazy var createDate = postedValues.createdDate
  private lazy var postedDateLabel = createLabel(
    title: "\(createDate[0]). \(createDate[1]). \(createDate[2])",
    textColor: .g70,
    fontType: "Pretendard-Medium",
    fontSize: 12
  )
  
  private lazy var postedMajorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = convertMajor(postedValues.major, toEnglish: false)
    label.textColor = .o30
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    label.backgroundColor = .o60
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var postedTitleLabel = createLabel(
    title: postedValues.title,
    textColor: .white,
    fontType: "Pretendard-Bold",
    fontSize: 20
  )
  
  private lazy var availablePersonNum = postedValues.studyPerson - postedValues.remainingSeat
  
  private lazy var memberNumberStackView = createInfoStack(
    labelText: "팀원수",
    imageName: "MemberNumberImage",
    countText: "\(availablePersonNum) /\(postedValues.studyPerson)명",
    countColor: .o50
  )
  
  private lazy var fineStackView = createInfoStack(
    labelText: "벌금",
    imageName: "MoneyImage",
    countText: "\(postedValues.penalty)원",
    countColor: .o50
  )
  
  private lazy var genderStackView = createInfoStack(
    labelText: "성별",
    imageName: "GenderImage",
    countText: convertGender(gender: postedValues.filteredGender),
    countColor: .white
  )
  
  private lazy var postedMajorStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var postedInfoStackView = createStackView(axis: .vertical, spacing: 15)
  private lazy var coreInfoStackView = createStackView(axis: .horizontal, spacing: 10)
  private lazy var topInfoStackView = createStackView(axis: .vertical, spacing: 15)
  
  let bottomSpaceView = UIView()
  
  init(_ viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    self.postedValues = viewModel.postDatas.value!
    
    super.init(frame: .zero)
    setupLayout()
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    [
      postedMajorLabel,
      UIView()
    ].forEach {
      postedMajorStackView.addArrangedSubview($0)
    }
    
    [
      postedDateLabel,
      postedMajorStackView,
      postedTitleLabel
    ].forEach {
      postedInfoStackView.addArrangedSubview($0)
    }
    
    [
      memberNumberStackView,
      fineStackView,
      genderStackView
    ].forEach {
      coreInfoStackView.addArrangedSubview($0)
    }
    
    [
      postedInfoStackView,
      coreInfoStackView,
      bottomSpaceView
    ].forEach {
      topInfoStackView.addArrangedSubview($0)
    }
    
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

  private func createInfoStack(
    labelText: String,
    imageName: String,
    countText: String,
    countColor: UIColor
  ) -> UIStackView {
    let label = createLabel(
      title: labelText,
      textColor: .g60,
      fontType: "Pretendard-SemiBold",
      fontSize: 12
    )
    
    let imageView = UIImageView(image: UIImage(named: imageName))
    
    let countLabel = createLabel(
      title: countText,
      textColor: countColor,
      fontType: "Pretendard-SemiBold",
      fontSize: 16
    )
    
    changeLabelColor(countLabel)
    
    let stackView = createStackView(axis: .vertical, spacing: 8)
    
    stackView.alignment = .center
    [
      label,
      imageView,
      countLabel
    ].forEach {
      stackView.addArrangedSubview($0)
    }
    return stackView
  }
  
  func changeLabelColor(_ label: UILabel) {
    guard let title = label.text else { return }
    switch title {
    case _ where title.contains("명"):
      label.changeColor(wantToChange: "/\(postedValues.studyPerson)명", color: .white)
    case _ where title.contains("원"):
      label.changeColor(wantToChange: "원", color: .white)
    default:
      break
    }
  }
}

extension PostedStudyMainComponent: CreateUIprotocol {}
extension PostedStudyMainComponent: Convert {}
