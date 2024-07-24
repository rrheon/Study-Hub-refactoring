
import UIKit

import SnapKit

final class NotificationCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  var model: [NoticeContent]? {
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
  
  private lazy var describeLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 20))
    label.text = "설명설명"
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
  
  static let cellId = "CellId"
  
  var buttonAction: (() -> Void) = {}

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
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(30)
    }
    
    createdDateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel.snp.leading)
    }
    
    describeLabel.isHidden = true
    describeLabel.snp.makeConstraints {
      $0.top.equalTo(createdDateLabel.snp.bottom).offset(5)
      $0.leading.trailing.equalToSuperview()
    }
    
    underlineView.snp.makeConstraints {
      $0.top.equalTo(createdDateLabel.snp.bottom).offset(5)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
    }
  }

  func bind(){
    model?.filter({ notice in
      titleLabel.text = notice.title
      let createDate = notice.createdDate
      createdDateLabel.text = "\(createDate[0]). \(createDate[1]). \(createDate[2])"
      return true
    })
  }
  
  // 상세 정보를 설정하는 메서드
  func configureWithDetail(_ text: String?, isExpanded: Bool) {
    describeLabel.text = text
    describeLabel.isHidden = !isExpanded
    
    layoutIfNeeded()
  }
  
  static func calculateContentHeight(for text: String, width: CGFloat) -> CGFloat {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 17.0) // 실제 라벨의 폰트 크기를 사용하세요.
    label.text = "    \(text)"
    let size = label.sizeThatFits(CGSize(width: width,
                                         height: CGFloat.greatestFiniteMagnitude))
    return size.height
  }
}


