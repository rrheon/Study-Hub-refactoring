
import UIKit

import SnapKit

final class SeletMajorCell: UITableViewCell {
  
  var model: String? {
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
    name.text = model
  }
    
  func setupImage(){
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ScearchImgGray")
    
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalTo(contentView)
    }
    
    backgroundColor = .white
  }
}


