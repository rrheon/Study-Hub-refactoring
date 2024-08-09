
import UIKit

import SnapKit

final class DeadLineCell: UICollectionViewCell {
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  weak var delegate: BookMarkDelegate?
  
  var model: Content? { didSet { bind() } }
  var buttonAction: (() -> Void) = {}
  
  var checkBookmarked: Bool?
  var loginStatus: Bool = false

  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ProfileAvatar_change")
    imageView.clipsToBounds = true
    
    return imageView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "컴활 1급 같이하실 분"
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return label
  }()
  
  private lazy var bookMarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    button.addAction(UIAction { _ in
      self.delegate?.bookmarkTapped(postId: self.model?.postID ?? 0,
                                    userId: self.model?.userData.userID ?? 0)
      self.bookmarkTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var countImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "PersonImg")
    return imageView
  }()
  
  private lazy var countLabel: UILabel = {
    let label = UILabel()
    label.text = "29/30명"
    label.textColor = .bg90
    label.changeColor(label: label, wantToChange: "29", color: .changeInfo)
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var remainLabel: UILabel = {
    let label = UILabel()
    label.text = "1자리 남았어요!"
    label.textColor = .o50
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViewShadow(backView: self)
    setupLayout()
    makeUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }

  func setupLayout() {
    [
      profileImageView,
      titleLabel,
      bookMarkButton,
      countImageView,
      countLabel,
      remainLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  func makeUI() {
    profileImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
      make.height.width.equalTo(48)
    }
   
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(18)
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    countImageView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    countLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.centerY.equalTo(countImageView)
      make.leading.equalTo(countImageView.snp.trailing)
    }
    
    bookMarkButton.snp.makeConstraints { make in
      make.top.equalTo(titleLabel)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    remainLabel.snp.makeConstraints { make in
      make.top.equalTo(bookMarkButton.snp.bottom).offset(10)
      make.leading.equalTo(countLabel.snp.trailing).offset(50)
    }
    
    backgroundColor = .white
    
    self.layer.borderWidth = 0.1
    self.layer.borderColor = UIColor.cellShadow.cgColor
    self.layer.cornerRadius = 10
  }
  
  // MARK: - 셀 재사용 관련
  override func prepareForReuse() {
    super.prepareForReuse()
    
    bookMarkButton.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    checkBookmarked = false
  }
  
  private func bookmarkTapped(){
    self.delegate?.bookmarkTapped(postId: self.model?.postID ?? 0,
                                  userId: self.model?.userData.userID ?? 0)
    
    if loginStatus {
      checkBookmarked = !(checkBookmarked ?? false)
      let bookmarkImage =  checkBookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
      bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    }
  }
  
  private func bind() {
    guard let data = model else { return }
  
    var studyPersonCount = data.studyPerson - data.remainingSeat
    checkBookmarked = data.bookmarked
    let bookmarkImage =  checkBookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"

    bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    
    titleLabel.text = data.title
    
    countLabel.text = "\(studyPersonCount) /\(data.studyPerson)명"
    countLabel.changeColor(label: countLabel,
                           wantToChange: "\(studyPersonCount)",
                           color: .o50)
    
    remainLabel.text = "\(data.remainingSeat)자리 남았어요!"
    
    if let url = URL(string: data.userData.imageURL ?? "") {
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
          print("Error: \(error)")
        } else if let data = data {
          let image = UIImage(data: data)
          DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = 15
            self.profileImageView.image = image
          }
        }
      }
      task.resume()
    }
    
  }
}


