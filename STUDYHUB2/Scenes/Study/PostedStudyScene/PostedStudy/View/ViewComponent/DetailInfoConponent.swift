
import UIKit

import SnapKit
import RxSwift
import Then

/// 포스트 상세 정보
final class PostedStudyDetailInfoComponent: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  /// 스터디 데이터
  var postedData: PostDetailData

  /// 소개 제목 라벨
  private lazy var introduceStudyLabel = UILabel().then {
    $0.text = "소개"
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }

  /// 소개 내용 라벨
  lazy var introduceStudyDeatilLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    $0.numberOfLines = 0
  }
  
  /// 구분선
  private lazy var divideLineUnderIntroduceStudy = UIView().then {
    $0.backgroundColor = UIColor(hexCode: "#F3F5F6")
    $0.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
  }
  
  /// 기간 제목 라벨
  private lazy var periodTitleLabel = UILabel().then {
    $0.text = "기간"
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }
  
  /// 기간 제목 라벨
  private lazy var periodLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }

  /// 벌금 제목 라벨
  private lazy var fineTitleLabel = UILabel().then {
    $0.text = "벌금"
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }
  
  /// 벌금 상세 라벨
  private lazy var fineAmountLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 대면 제목 라벨
  private lazy var meetTitleLabel = UILabel().then {
    $0.text = "대면여부"
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }
  
  /// 대면 상세 라벨
  private lazy var meetLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 관련학과 제목 라벨
  private lazy var majorTitleLabel = UILabel().then {
    $0.text = "관련학과"
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  }
  
  /// 관련학과 상세 라베
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.backgroundColor = .bg30
    label.layer.cornerRadius = 10
    label.clipsToBounds = true
    return label
  }()
  
  /// 전체 스택뷰
  private lazy var detailInfoStackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 30
  }
  
  init(with data: PostDetailData) {
    self.postedData = data
    
    super.init(frame: .zero)
    
    setupLayout()
    setupUIData(data)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// layout 설정
  private func setupLayout() {
    self.addSubview(detailInfoStackView)
    
    /// 기간 스택뷰
    let periodStackView = createInfoRow(titleLabel: periodTitleLabel,
                                        contentLabel: periodLabel,
                                        imageName: "CalenderImage")
    
    /// 벌금 스택뷰
    let fineStackView =  createInfoRow(titleLabel: fineTitleLabel,
                                        contentLabel: fineAmountLabel,
                                        imageName: "MoneyImage")
    
    /// 성별 스택뷰
    let genderStackView = createInfoRow(titleLabel: meetTitleLabel,
                                         contentLabel: meetLabel,
                                         imageName: "MixMeetImage")
    
    [
      introduceStudyLabel,
      introduceStudyDeatilLabel,
      divideLineUnderIntroduceStudy,
      periodStackView,
      fineStackView,
      genderStackView,
      createMajorStackView(),
      UIView()
    ].forEach {
      detailInfoStackView.addArrangedSubview($0)
    }
    
    detailInfoStackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
  }
  
  /// 이미지, 라벨 스택뷰 생성
  private func createInfoRow(
    titleLabel: UILabel,
    contentLabel: UILabel,
    imageName: String
  ) -> UIStackView {
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .left
    
    let stackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(contentLabel)
    stackView.addArrangedSubview(UIView())
    
    let containerStack = UIStackView(arrangedSubviews: [titleLabel, stackView])
    containerStack.axis = .vertical
    containerStack.spacing = 10
    return containerStack
  }
  
  /// 학과 스택뷰 생성
  private func createMajorStackView() -> UIStackView {
    let stackView = StudyHubUI.createStackView(axis: .vertical, spacing: 10)
    stackView.addArrangedSubview(majorTitleLabel)
    stackView.addArrangedSubview(majorLabel)
    stackView.addArrangedSubview(UIView())
    stackView.alignment = .leading
    return stackView
  }
  
  /// 기간 가져오기
  func getPeriodText(_ data: PostDetailData) -> String {
    let startDate = data.studyStartDate
    let endDate = data.studyEndDate
    return "\(startDate[0]). \(startDate[1]). \(startDate[2]) ~ \(endDate[0]). \(endDate[1]). \(endDate[2])"
  }
  
  /// UI에 데이터 세팅
  func setupUIData(_ data: PostDetailData){
    introduceStudyDeatilLabel.text = data.content
    periodLabel.text = getPeriodText(data)
    
    if let penaltyWay = data.penaltyWay, data.penalty != 0 {
      fineAmountLabel.text = "\(penaltyWay) \(data.penalty)원"
    } else {
      fineAmountLabel.text = "없어요"
    }
    
    
    meetLabel.text = Utils.convertStudyWay(wayToStudy: data.studyWay ?? "")
    majorLabel.text = Utils.convertMajor(data.major, toEnglish: false)
  }
}
