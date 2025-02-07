
import UIKit

import SnapKit

final class NotificationCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  var model: ExpandedNoticeContent? {
    didSet {
      bind()
    }
  }

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var createdDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  private lazy var describeLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 20))
    label.textColor = .bg90
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.backgroundColor = .bg20
    label.numberOfLines = 0
    return label
  }()

  private let underlineView: UIView = {
    let view = UIView()
    view.backgroundColor = .bg30
    return view
  }()
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    
//    setViewShadow(backView: self)
   
    setupLayout()
    makeUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  func setupLayout() {
    [
      titleLabel,
      createdDateLabel,
      describeLabel,
      underlineView
    ].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  func makeUI() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(30)
    }
    
    createdDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
  
    underlineView.snp.makeConstraints {
      $0.top.equalTo(createdDateLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
    
    describeLabel.isHidden = true
    describeLabel.snp.makeConstraints {
      $0.top.equalTo(underlineView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
  }

  func bind(){
    guard let data = model?.noticeContent else { return }
    titleLabel.text = data.title
    let createDate = data.createdDate
    createdDateLabel.text = "\(createDate[0]). \(createDate[1]). \(createDate[2])"
    
    configureWithDetail()
  }
  
  func configureWithDetail() {
    describeLabel.text = model?.noticeContent.content
    describeLabel.isHidden = !(model?.isExpanded ?? false)
    layoutIfNeeded()
  }

}


