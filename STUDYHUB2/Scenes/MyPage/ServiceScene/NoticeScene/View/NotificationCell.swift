
import UIKit

import SnapKit
import Then

/// 공지사항 Cell;
final class NotificationCell: UICollectionViewCell {
  
  /// 공지사항 데이터
  var model: ExpandedNoticeContent? {
    didSet { bind() }
  }

  /// 공지사항 제목 라벨
  lazy var titleLabel: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 공지날짜 라벨
  private lazy var createdDateLabel: UILabel = UILabel().then {
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
  /// 공지사항 설명 라벨
  private lazy var describeLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 20))
    label.textColor = .bg90
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.backgroundColor = .bg20
    label.numberOfLines = 0
    return label
  }()

  /// 밑줄 뷰
  private let underlineView: UIView = UIView().then {
    $0.backgroundColor = .bg30
  }
    
  override init(frame: CGRect) {
    super.init(frame: frame)
       
    makeUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }

  /// UI 설정
  func makeUI() {
    self.contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(30)
    }
    
    self.contentView.addSubview(createdDateLabel)
    createdDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    self.contentView.addSubview(underlineView)
    underlineView.snp.makeConstraints {
      $0.top.equalTo(createdDateLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    self.contentView.addSubview(describeLabel)
    describeLabel.isHidden = true
    describeLabel.snp.makeConstraints {
      $0.top.equalTo(underlineView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
  }

  /// 데이터 바인딩
  func bind(){
    guard let data = model?.noticeContent else { return }
    titleLabel.text = data.title
    let createDate = data.createdDate
    createdDateLabel.text = "\(createDate[0]). \(createDate[1]). \(createDate[2])"
    
    describeLabel.text = model?.noticeContent.content
    describeLabel.isHidden = !(model?.isExpanded ?? false)
    layoutIfNeeded()
  }
}


