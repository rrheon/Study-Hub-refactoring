
import UIKit

import SnapKit
import Then

/// 새로 모집중인 스터디 셀
final class RecruitPostCell: UICollectionViewCell {
  
  var model: PostData? { didSet { bind() } }
  
  var delegate: LoginPopupIsRequired?
  var checkBookmarked: Bool = false
  var loginStatus: Bool? = false
  
  /// 학과 라벨
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
    label.text = " 세무회계학과 "
    label.textColor = .o50
    label.backgroundColor = .o10
    label.layer.cornerRadius = 5
    label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    label.clipsToBounds = true
    return label
  }()
  
  /// 북마크 버튼
  private lazy var bookMarkButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    $0.addAction(UIAction { _ in
      self.bookmarkTapped()
    }, for: .touchUpInside)
  }
  
  /// 스터디 제목 라벨
  private lazy var titleLabel: UILabel = UILabel().then {
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    $0.textColor = .black
  }
  
  /// 작성자의 프로필 이미지 뷰
  private lazy var profileImageView: UIImageView = UIImageView().then {
    $0.layer.cornerRadius = 15
    $0.image = UIImage(named: "PersonImg")
    $0.contentMode = .left
    $0.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
  }
  
  /// 인원 수 라벨
  private lazy var countMemeberLabel: UILabel = UILabel().then {
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 벌금 이미지 라벨
  private lazy var fineImageView = UIImageView(image:  UIImage(named: "MoneyImage"))
  
  /// 벌금 라벨
  private lazy var fineCountLabel: UILabel = UILabel().then {
    $0.textColor = .bg90
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 잔여 좌석 라벨
  private lazy var remainMemeber: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2))
    label.textColor = .bg80
    label.layer.borderColor = UIColor.bg60.cgColor
    label.layer.borderWidth = 1
    label.layer.cornerRadius = 5
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white

    configure()
    
    setViewShadow(backView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  /// UI 설정
  private func configure() {
    addSubview(majorLabel)
    majorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    addSubview(bookMarkButton)
    bookMarkButton.snp.makeConstraints { make in
      make.centerY.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(30)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    addSubview(countMemeberLabel)
    countMemeberLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(5)
      make.centerY.equalTo(profileImageView)
    }
    
    addSubview(fineImageView)
    fineImageView.snp.makeConstraints { make in
      make.leading.equalTo(countMemeberLabel.snp.trailing).offset(50)
      make.centerY.equalTo(countMemeberLabel)
    }
    
    addSubview(fineCountLabel)
    fineCountLabel.snp.makeConstraints { make in
      make.leading.equalTo(fineImageView.snp.trailing).offset(5)
      make.centerY.equalTo(fineImageView)
    }
    
    addSubview(remainMemeber)
    remainMemeber.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.bottom).offset(15)
      make.leading.equalTo(majorLabel.snp.leading)
    }
  }
  
  // MARK: - 셀 재사용 관련
  
  /// 셀 재사용 관련
  override func prepareForReuse() {
    super.prepareForReuse()
    
    bookMarkButton.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    checkBookmarked = false
  }

  
  /// 북마크 버튼 탭
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
   
    /// 스터디 참여 인원
    let studyPersonCount = data.studyPerson - data.remainingSeat
    remainMemeber.text = "  잔여 \(data.remainingSeat)자리  "
    countMemeberLabel.text = "\(studyPersonCount) /\(data.studyPerson)명"
    countMemeberLabel.changeColor(wantToChange: "\(studyPersonCount)", color: .o50)
    
    /// 북마크 여부
    checkBookmarked = data.bookmarked
    let bookmarkImage = checkBookmarked ? "BookMarkChecked": "BookMarkLightImg"
    bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    
    /// 학과
    majorLabel.text = Utils.convertMajor(data.major, toEnglish: false) ?? "없음"
   
    /// 스터디 제목
    titleLabel.text = data.title
  
    /// 벌금
    let fineText = data.penalty == 0 ? "없어요" : "\(data.penalty) 원"
    fineCountLabel.text = "\(fineText)"
    fineCountLabel.changeColor(wantToChange: "\(data.penalty)", color: .o50)
  }
}
