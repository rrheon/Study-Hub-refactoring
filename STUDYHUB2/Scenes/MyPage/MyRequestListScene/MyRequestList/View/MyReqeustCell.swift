
import UIKit

import SnapKit
import Then

protocol MyRequestCellDelegate: AnyObject {
  func deleteButtonTapped(postID: Int)
  func moveToCheckRejectReason(studyId: Int)
}

/// 내가 신청한 스터디 셀
final class MyRequestCell: UICollectionViewCell {
  
  weak var delegate: MyRequestCellDelegate?
  
  /// 신청한 스터디 데이ㅓㅌ
  var model: RequestStudyContent? {
    didSet { bind() }
  }

  /// 스터디 신청 상태 라벨
  lazy var requestLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
    label.text = " 수락 대기 중 "
    label.textColor = .white
    label.backgroundColor = .black
    label.layer.cornerRadius = 10
    label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    return label
  }()
  
  /// 신청 삭제하기
  private lazy var deleteButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "DeleteButtonImage"), for: .normal)
    $0.addAction(UIAction { _ in
      self.deleteButtonTapped()
    }, for: .touchUpInside)
  }
  
  /// 스터디 제목 라벨
  lazy var titleLabel: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디 신청 내용
  lazy var infoLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16))
    label.textColor = .bg80
    label.backgroundColor = .bg20
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.setLineSpacing(spacing: 10)
    return label
  }()

  /// 스터디 신청 거절 사유 확인버튼
  private lazy var checkRejectReasonButton: UIButton = UIButton().then{
    $0.setTitle("거절 이유 확인하기", for: .normal)
    $0.setTitleColor(UIColor.bg80, for: .normal)
    $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    $0.titleLabel?.textAlignment = .center
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 5
    $0.layer.borderColor = UIColor.bg50.cgColor
    $0.addAction(UIAction { _ in
      self.checkRejectReason()
    }, for: .touchUpInside)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    configure()
    setViewShadow(backView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
  private func configure() {
    addSubview(requestLabel)
    requestLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    addSubview(deleteButton)
    deleteButton.snp.makeConstraints {
      $0.centerY.equalTo(requestLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(requestLabel.snp.bottom).offset(10)
      $0.leading.equalTo(requestLabel.snp.leading)
    }
    
    addSubview(infoLabel)
    infoLabel.numberOfLines = 0
    infoLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.leading.equalTo(requestLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    addSubview(checkRejectReasonButton)
    checkRejectReasonButton.isHidden = true
    checkRejectReasonButton.snp.makeConstraints {
      $0.top.equalTo(infoLabel.snp.bottom).offset(20)
      $0.height.equalTo(42)
      $0.leading.equalTo(requestLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    backgroundColor = .white
  }
  
  /// 신청한 내역 삭제하기
  func deleteButtonTapped(){
    self.delegate?.deleteButtonTapped(postID: self.model?.studyID ?? 0)
  }
  
  /// 거절사유 체크
  func checkRejectReason(){
    print(self.model?.studyID)
    self.delegate?.moveToCheckRejectReason(studyId: self.model?.studyID ?? 0)
  }
  
  /// 데이터 바인딩
  func bind(){
    guard let model = model else { return }
    
    requestLabel.text = model.inspection == "STANDBY" ? "수락 대기 중" : "거절"
    
    if requestLabel.text == "거절" {
      checkRejectReasonButton.isHidden = false
      requestLabel.backgroundColor = .bg30
      requestLabel.textColor = .bg80
    }
  
    titleLabel.text = model.studyTitle
    infoLabel.text = "신청 내용\n\(model.introduce)"
    infoLabel.changeColor(
      wantToChange: "신청 내용",
      color: .bg60,
      font: UIFont(name: "Pretendard-SemiBold", size: 12)
    )
  }
}

