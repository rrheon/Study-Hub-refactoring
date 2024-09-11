import UIKit

import SnapKit

final class PostedStudyDetailInfoComponent: UIView, CreateUIprotocol, Convert {
  let postedValues: PostDetailData
  
  private lazy var introduceStudyLabel = createLabel(
    title: "소개",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  lazy var introduceStudyDeatilLabel = createLabel(
    title: "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var divideLineUnderIntroduceStudy = createDividerLine(height: 1.0)
  
  private lazy var periodTitleLabel = createLabel(
    title: "기간",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var periodLabel = createLabel(
    title: periodText,
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var fineTitleLabel = createLabel(
    title: "벌금",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var fineAmountLabel = createLabel(
    title: "결석비 \(postedValues.penalty)원",
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var meetTitleLabel = createLabel(
    title: "대면여부",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var meetLabel = createLabel(
    title: convertStudyWay(wayToStudy: postedValues.studyWay),
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var majorTitleLabel = createLabel(
    title: "관련학과",
    textColor: .bg90,
    fontType: "Pretendard-SemiBold",
    fontSize: 14
  )
  
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.text = convertMajor(postedValues.major, toEnglish: false)
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.backgroundColor = .bg30
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    return label
  }()
  
  private lazy var detailInfoStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        introduceStudyLabel,
        introduceStudyDeatilLabel,
        divideLineUnderIntroduceStudy,
        createInfoRow(
          titleLabel: periodTitleLabel,
          contentLabel: periodLabel,
          imageName: "CalenderImage"
        ),
        createInfoRow(
          titleLabel: fineTitleLabel,
          contentLabel: fineAmountLabel,
          imageName: "MoneyImage"
        ),
        createInfoRow(
          titleLabel: meetTitleLabel,
          contentLabel: meetLabel,
          imageName: "MixMeetImage"
        ),
        createMajorStackView(),
        UIView()
      ]
    )
    stackView.axis = .vertical
    stackView.spacing = 30
    return stackView
  }()
  
  private var periodText: String {
    let startDate = postedValues.studyStartDate
    let endDate = postedValues.studyEndDate
    return "\(startDate[0]). \(startDate[1]). \(startDate[2]) ~ \(endDate[0]). \(endDate[1]). \(endDate[2])"
  }
  
  init(_ postedValues: PostDetailData) {
    self.postedValues = postedValues
    super.init(frame: .zero)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    self.addSubview(detailInfoStackView)
    
    detailInfoStackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
  }
  
  private func createInfoRow(
    titleLabel: UILabel,
    contentLabel: UILabel,
    imageName: String
  ) -> UIStackView {
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .left
    
    let stackView = createStackView(axis: .horizontal, spacing: 10)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(contentLabel)
    stackView.addArrangedSubview(UIView())
    
    let containerStack = UIStackView(arrangedSubviews: [titleLabel, stackView])
    containerStack.axis = .vertical
    containerStack.spacing = 10
    return containerStack
  }
  
  private func createMajorStackView() -> UIStackView {
    let stackView = createStackView(axis: .vertical, spacing: 10)
    stackView.addArrangedSubview(majorTitleLabel)
    stackView.addArrangedSubview(majorLabel)
    stackView.addArrangedSubview(UIView())
    stackView.alignment = .leading
    return stackView
  }
}
