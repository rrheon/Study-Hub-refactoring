
import UIKit

import SnapKit
import Then

/// 내가 작성한 스터디 Cell의 delegate
protocol MyPostCellDelegate: AnyObject {
  func menuButtonTapped(in cell: MyPostCell, postID: Int)
  func closeButtonTapped(in cell: MyPostCell, postID: Int)
  func acceptButtonTapped(in cell: MyPostCell, studyID: Int)
}

/// 내가 작성한 스터디 Cell
final class MyPostCell: UICollectionViewCell {
  weak var delegate: MyPostCellDelegate?
  
  /// 작성한 스터디 데이터
  var model: MyPostcontent? {
    didSet { bind() }
  }
  
  /// 관련 학과 라벨
  private lazy var majorLabel: UILabel = UILabel().then {
    $0.textColor = .o50
    $0.layer.cornerRadius = 5
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
  }
  
  /// 메뉴 버튼 - 수정, 삭제
  private lazy var menuButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "ThreeDotImage"), for: .normal)
    $0.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
  }
  
  /// 스터디 제목 라벨
  lazy var titleLabel: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 정보 라벨
  lazy var infoLabel: UILabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }

  /// 잔여 좌석 라벨
  private lazy var remainLabel: UILabel = UILabel().then {
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
  /// 스터디 내용과 버튼 구분선
  private lazy var seperateLine = UIView()

  /// 버튼 스택뷰
  private lazy var buttonStackView = StudyHubUI.createStackView(axis: .horizontal, spacing: 10)
    
  /// 스터디 마감 버튼
  private lazy var closeButton: UIButton = UIButton().then {
    $0.setTitle("마감", for: .normal)
    $0.titleLabel?.textAlignment = .center
    $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    $0.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
  }
  
  /// 버튼 사이 구분 선
  private lazy var seperateLineinStackView = UIView()

  /// 참여자 확인 버튼
  private lazy var checkPersonButton: UIButton = UIButton().then {
    $0.setTitle("참여자", for: .normal)
    $0.setTitleColor(.bg80, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    $0.titleLabel?.textAlignment = .center
    $0.addTarget(self, action: #selector(checkPersonButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubviews()
    
    configure()
    setViewShadow(backView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - addsubviews
  
  /// layout 설정
  private func addSubviews() {
    [ closeButton, seperateLineinStackView, checkPersonButton]
      .forEach { buttonStackView.addArrangedSubview($0) }
    
    [
      majorLabel,
      menuButton,
      titleLabel,
      infoLabel,
      remainLabel,
      seperateLine,
      buttonStackView
    ].forEach {
      addSubview($0)
    }
  }
  
  // MARK: - configure
  
  /// UI 설정
  private func configure() {
    majorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(22)
      make.leading.equalToSuperview().offset(20)
    }
    
    menuButton.snp.makeConstraints { make in
      make.centerY.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    infoLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    remainLabel.snp.makeConstraints { make in
      make.top.equalTo(infoLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    seperateLine.backgroundColor = .bg30
    seperateLine.snp.makeConstraints { make in
      make.top.equalTo(remainLabel.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    seperateLineinStackView.backgroundColor = .bg30
    seperateLineinStackView.snp.makeConstraints { make in
      make.height.equalTo(20)
      make.width.equalTo(1)
    }
    
    buttonStackView.alignment = .center
    buttonStackView.distribution = .equalCentering
    buttonStackView.snp.makeConstraints { make in
      make.top.equalTo(seperateLine.snp.bottom).offset(5)
      make.leading.equalToSuperview().offset(70)
      make.trailing.equalTo(menuButton.snp.leading).offset(-30)
    }
  
    backgroundColor = .white
  }
  
  // MARK: - bind
  
  /// 데이터 바인딩
  private func bind() {
    if model?.close == true {
      remainLabel.text = "마감됐어요"
      closeButton.setTitleColor(.bg60, for: .normal)
      closeButton.isEnabled = false
    } else {
      remainLabel.text = "잔여 \(model?.remainingSeat ?? 0)자리"
      closeButton.setTitleColor(.o50, for: .normal)
    }
  
    majorLabel.text = Utils.convertMajor(model?.major ?? "", toEnglish: false)
    titleLabel.text = model?.title
    infoLabel.text = model?.content
  }
  
  // MARK: - 버튼함수
  
  /// 메뉴버튼 탭 - 수정 삭제
  @objc func menuButtonTapped(){
    guard let postID = model?.postID else { return }
    delegate?.menuButtonTapped(in: self, postID: postID)
  }
  
  /// 마감버튼 탭 - 스터디 마감
  @objc func closeButtonTapped(){
    guard let postID = model?.postID else { return }
    delegate?.closeButtonTapped(in: self, postID: postID)
  }
  
  /// 참여자 확인버튼 탭 - 참여자 확인 페이지로 이동
  @objc func checkPersonButtonTapped(){
    guard let studyID = model?.studyId else { return }
    delegate?.acceptButtonTapped(in: self, studyID: studyID)
  }
}

