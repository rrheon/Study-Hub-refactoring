
import UIKit

import SnapKit
import Kingfisher

final class ParticipateCell: UICollectionViewCell {
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }

  var model: ApplyUserContent? {
    didSet {
      bind()
    }
  }
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ProfileAvatar_change")
    return imageView
  }()
  
  private lazy var majorLabel: UILabel = {
    let label = UILabel()
    label.text = "경영학부"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard", size: 12)
    return label
  }()
  
  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "경영이"
    label.textColor = .black
    label.font = UIFont(name: "Pretendard", size: 14)
    return label
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "2023. 9 . 8 참여 "
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard", size: 12)
    return label
  }()
  
 
  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setViewShadow(backView: self)
    
    self.backgroundColor = .white
    
    setupLayout()
    makeUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      profileImageView,
      majorLabel,
      nickNameLabel,
      dateLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    profileImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(10)
      $0.height.width.equalTo(50)
    }
    
    majorLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(majorLabel.snp.bottom)
      $0.leading.equalTo(majorLabel)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom)
      $0.leading.equalTo(majorLabel)
    }
  }
  
  func bind(){
    guard let data = model else { return }
      majorLabel.text = convertMajor(data.major, toEnglish: false)
      nickNameLabel.text = data.nickname
      dateLabel.text = "\(data.createdDate[0]). \(data.createdDate[1]). \(data.createdDate[2])"
      
    if let imageURL = URL(string: data.imageURL) {
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50))
        
        self.profileImageView.kf.setImage(with: imageURL,
                                          options: [.processor(processor)]) { result in
          switch result {
          case .success(let value):
            DispatchQueue.main.async {
              self.profileImageView.image = value.image
              self.profileImageView.layer.cornerRadius = 20
              self.profileImageView.clipsToBounds = true
            }
          case .failure(let error):
            print("Image download failed: \(error)")
            self.profileImageView.image = UIImage(named: "ProfileAvatar_change")
          }
        }
      }
    }
}

extension ParticipateCell: ConvertMajor {}
