
import UIKit

import SnapKit
import Kingfisher
import Then

/// 참여한 인원들 Cell
final class ParticipateCell: UICollectionViewCell {
  
  /// 참여한 인원들 데이터
  var model: ApplyUserContent? {
    didSet { bind() }
  }
  
  /// 참여한 인원의 프로필
  private lazy var profileImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "ProfileAvatar_change")
  }
  
  /// 참여한 인원의 학과 라벨
  private lazy var majorLabel: UILabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 12)
  }
  
  /// 참여한 인원의 닉네임 라벨
  private lazy var nickNameLabel: UILabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard", size: 14)
  }
  
  /// 신청한 날짜 라벨
  private lazy var dateLabel: UILabel = UILabel().then {
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard", size: 12)
  }
  
  
  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .white
    
    setupLayout()
    makeUI()
    setViewShadow(backView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - setupLayout
  
  /// layout 설정
  func setupLayout(){
    [ profileImageView, majorLabel, nickNameLabel, dateLabel]
      .forEach { addSubview($0) }
  }
  
  // MARK: - makeUI
  
  /// UI 설정
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
  
  /// 데이터 바인딩
  func bind(){
    guard let data = model else { return }
    majorLabel.text = Utils.convertMajor(data.major, toEnglish: false)
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
