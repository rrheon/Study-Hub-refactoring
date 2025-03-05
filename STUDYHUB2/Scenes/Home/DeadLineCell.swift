
import UIKit

import SnapKit
import Then


/// 마감이 임박한 스터디의 셀
final class DeadLineCell: UICollectionViewCell {
  var model: PostData? { didSet { bind() } }
  
  var delegate: LoginPopupIsRequired?
  var checkBookmarked: Bool = false
  var loginStatus: Bool = false

  
  /// 작성자의 프로필 ImageView
  private lazy var profileImageView: UIImageView = UIImageView().then{
    $0.image = UIImage(named: "ProfileAvatar_change")
    $0.clipsToBounds = true
  }
  
  /// 스터디의 제목 라벨
  private lazy var titleLabel: UILabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 북마크 버튼
  private lazy var bookMarkButton: UIButton = UIButton().then{
    $0.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    $0.addAction(UIAction { _ in
      self.bookmarkTapped()
    }, for: .touchUpInside)
  }
  
  /// 인원 수 이미지뷰
  private lazy var countImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "PersonImg")
  }
  
  /// 인원 수 카운트 라벨
  private lazy var countLabel: UILabel = UILabel().then {
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 남아있는 자리 라벨
  private lazy var remainLabel: UILabel = UILabel().then {
    $0.textColor = .o50
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white

    makeUI()
    setViewShadow(backView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }


  /// UI 설정
  func makeUI() {
    addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
      make.height.width.equalTo(48)
    }
   
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(18)
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    addSubview(countImageView)
    countImageView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
    }
    
    addSubview(countLabel)
    countLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.centerY.equalTo(countImageView)
      make.leading.equalTo(countImageView.snp.trailing)
    }
    
    addSubview(bookMarkButton)
    bookMarkButton.snp.makeConstraints { make in
      make.top.equalTo(titleLabel)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    addSubview(remainLabel)
    remainLabel.snp.makeConstraints { make in
      make.top.equalTo(bookMarkButton.snp.bottom).offset(10)
      make.leading.equalTo(countLabel.snp.trailing).offset(50)
    }
  }
  
  // MARK: - 셀 재사용 관련
  
  /// 셀 재사용 관련
  override func prepareForReuse() {
    super.prepareForReuse()
    
    bookMarkButton.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    checkBookmarked = false
  }
  
  
  /// 북마크 터치 시
  private func bookmarkTapped(){
    guard let postID = self.model?.postId else { return }
  
    BookmarkManager.shared.bookmarkTapped(with: postID) { result in
      if result == 500 {
        self.delegate?.presentLoginPopup()
      } else {
        DispatchQueue.main.async {
          self.checkBookmarked.toggle()
         
          let bookmarkImage =  self.checkBookmarked  ? "BookMarkChecked": "BookMarkLightImg"
          self.bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
        }
      }
    }
  }
  
  /// 데이터 바인딩
  private func bind() {
    guard let data = model else { return }
  
    /// 북마크
    checkBookmarked = data.bookmarked

    let bookmarkImage = data.bookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
    
    bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    
    /// 스터디 제목
    titleLabel.text = data.title
    
    /// 인원수
    var studyPersonCount = data.studyPerson - data.remainingSeat
    countLabel.text = "\(studyPersonCount) /\(data.studyPerson)명"
    countLabel.changeColor(wantToChange: "\(studyPersonCount)", color: .o50)
    
    remainLabel.text = "\(data.remainingSeat)자리 남았어요!"
        
    /// 작성자 프로필 이미지
    if let imageURL = URL(string: data.userData.imageURL ?? "") {
      getUserProfileImage(imageURL: imageURL) { result in
        DispatchQueue.main.async {
          switch result {
          case .success(let image):
            self.profileImageView.layer.cornerRadius = 25
            self.profileImageView.image = image
          case .failure(_):
            self.profileImageView.image = UIImage(named: "ProfileAvatar_change")
          }
        }
      }
    }
  }
}

extension DeadLineCell: ManagementImage {}


