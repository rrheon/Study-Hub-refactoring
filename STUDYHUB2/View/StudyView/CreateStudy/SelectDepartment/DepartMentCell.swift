
import UIKit

import SnapKit

final class CustomCell: UITableViewCell {

  var model: RecommendList? {
    didSet {
      bind()
    }
  }

  var textColor: UIColor? {
    didSet {
      name.textColor = textColor
    }
  }
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
  
  lazy var name: UILabel = {
    let label = UILabel()
    label.text = "정보통신학과"
    label.textColor = textColor
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  
  func setupLayout() {
    [
      name
    ].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  func makeUI() {
    name.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(30)
      make.centerY.equalTo(self.snp.centerY)
    }
  }

  func bind(){
//    name.text = model?.recommend
  }
}


