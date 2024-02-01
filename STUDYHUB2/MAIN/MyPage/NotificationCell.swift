
import UIKit

import SnapKit

final class NotificationCell: UITableViewCell {

  var model: RecommendList? {
    didSet {
      bind()
    }
  }

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "제목제목"
    label.textColor = .black
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var createdDateLabel: UILabel = {
    let label = UILabel()
    label.text = "2023.8.24"
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  private lazy var describeLabel: UILabel = {
    let label = UILabel()
    label.text = "설명설명"
    label.textColor = .bg90
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.backgroundColor = .bg20
    return label
  }()
  
  
  static let cellId = "CellId"
  
  var buttonAction: (() -> Void) = {}
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  func setupLayout() {
    [
      titleLabel,
      createdDateLabel,
      describeLabel
    ].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  func makeUI() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(30)
    }
    
    createdDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    describeLabel.isHidden = true
    describeLabel.snp.makeConstraints {
      $0.top.equalTo(createdDateLabel.snp.bottom)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
  }

  func bind(){
//    name.text = model?.recommend
  }
}


