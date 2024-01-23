
import UIKit

import SnapKit

protocol MyPostCellDelegate: AnyObject {
  func menuButtonTapped(in cell: MyPostCell, postID: Int)
  func closeButtonTapped(in cell: MyPostCell, postID: Int)
  func acceptButtonTapped(in cell: MyPostCell, postID: Int)
}


final class MyPostCell: UICollectionViewCell {
  weak var delegate: MyPostCellDelegate?

  var postID: Int?
  var studyId: Int?
  
  var model: MyPostcontent? {
    didSet {
      bind()
    }
  }
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  private lazy var majorLabel: UILabel = {
    let label = UILabel()
    label.text = " 세무회계학과 "
    label.textColor = .o50
    label.layer.cornerRadius = 5
    return label
  }()
  
  private lazy var menuButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "ThreeDotImage"), for: .normal)
    button.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "단기 스터디원 구해요!"
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }()
  
  lazy var infoLabel: UILabel = {
    let label = UILabel()
    label.text = "내용내용내용"
    label.textColor = .bg80
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  var remainCount: Int = 0 {
    didSet {
      remainLabel.text = "잔여 \(remainCount)자리"
    }
  }
  
  private lazy var remainLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg70
    label.font = UIFont.boldSystemFont(ofSize: 12)
    return label
  }()

  private lazy var seperateLine = UIView()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    return stackView
  }()
    
  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.setTitle("마감", for: .normal)
    button.setTitleColor(UIColor.o50, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var seperateLineinStackView = UIView()

  private lazy var checkPersonButton: UIButton = {
    let button = UIButton()
    button.setTitle("참여자", for: .normal)
    button.setTitleColor(UIColor.bg80, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.addAction(UIAction { _ in
      self.acceptButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViewShadow(backView: self)
    addSubviews()
    
    configure()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addSubviews() {
    
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
    
    let data = [closeButton, seperateLineinStackView, checkPersonButton]
    for data in data{
      buttonStackView.addArrangedSubview(data)
    }
  }
  
  private func configure() {
    majorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(10)
    }
    
    menuButton.snp.makeConstraints { make in
      make.centerY.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(20)
      make.leading.equalTo(majorLabel.snp.leading).offset(5)
    }
    
    infoLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading).offset(5)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    remainLabel.snp.makeConstraints { make in
      make.top.equalTo(infoLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading).offset(5)
    }
    
    seperateLine.backgroundColor = .bg30
    seperateLine.snp.makeConstraints { make in
      make.top.equalTo(remainLabel.snp.bottom).offset(10)
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
      make.top.equalTo(seperateLine.snp.bottom)
      make.leading.equalTo(remainLabel.snp.trailing)
      make.trailing.equalTo(menuButton.snp.leading).offset(-30)
    }
  
    backgroundColor = .white
    
    self.layer.borderWidth = 0.1
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.cornerRadius = 10
  }
  
  private func bind() {
    majorLabel.text = model?.major.convertMajor(model?.major ?? "" , isEnglish: false)
    titleLabel.text = model?.title
    infoLabel.text = model?.content
    remainCount = model?.remainingSeat ?? 0
    postID = model?.postID
    studyId = model?.studyId
  }
  
  
  @objc func menuButtonTapped(){
    delegate?.menuButtonTapped(in: self, postID: postID ?? 0)
  }
  
  @objc func closeButtonTapped(){
    delegate?.closeButtonTapped(in: self, postID: postID ?? 0)
  }
  
  func acceptButtonTapped(){
    delegate?.acceptButtonTapped(in: self, postID: postID ?? 0)
  }
}

