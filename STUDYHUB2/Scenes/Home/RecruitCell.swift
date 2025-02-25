
import UIKit

import SnapKit


/// 새로 모집중인 스터디 셀
final class RecruitPostCell: UICollectionViewCell {
  
  var model: PostData? { didSet { bind() } }
  var checkBookmarked: Bool?
  var loginStatus: Bool? = false
  
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
  
  private lazy var bookMarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    button.addAction(UIAction { _ in
      self.bookmarkTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    label.textColor = .black
    return label
  }()
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 15
    imageView.image = UIImage(named: "PersonImg")
    imageView.contentMode = .left
    imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return imageView
  }()
  
  private lazy var countMemeberLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg90
    label.text = "/14"
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var fineImageView = UIImageView(image:  UIImage(named: "MoneyImage"))
  
  private lazy var fineCountLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg90
    label.text = "900원"
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var remainMemeber: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2))
    label.textColor = .bg80
    label.text = " 잔여 14자리 "
    label.layer.borderColor = UIColor.bg60.cgColor
    label.layer.borderWidth = 1
    label.layer.cornerRadius = 5
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubviews()
    
    configure()
    
    setViewShadow(backView: self)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addSubviews() {
    [
      majorLabel,
      bookMarkButton,
      titleLabel,
      profileImageView,
      countMemeberLabel,
      fineImageView,
      fineCountLabel,
      remainMemeber,
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    majorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    bookMarkButton.snp.makeConstraints { make in
      make.centerY.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(30)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    countMemeberLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(5)
      make.centerY.equalTo(profileImageView)
    }
    
    fineImageView.snp.makeConstraints { make in
      make.leading.equalTo(countMemeberLabel.snp.trailing).offset(50)
      make.centerY.equalTo(countMemeberLabel)
    }
    
    fineCountLabel.snp.makeConstraints { make in
      make.leading.equalTo(fineImageView.snp.trailing).offset(5)
      make.centerY.equalTo(fineImageView)
    }
    
    remainMemeber.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.bottom).offset(15)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    backgroundColor = .white
//    
//    self.layer.borderWidth = 0.1
//    self.layer.borderColor = UIColor.cellShadow.cgColor
//    self.layer.cornerRadius = 20
  }
  
  // MARK: - 셀 재사용 관련
  override func prepareForReuse() {
    super.prepareForReuse()
    
    bookMarkButton.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    checkBookmarked = false
  }

  
  /// 북마크 버튼 탭
  private func bookmarkTapped(){
    guard let postID = self.model?.postID else { return }
    
    
    BookmarkManager.shared.bookmarkTapped(with: postID) {
      
    }
    if loginStatus ?? false {
      checkBookmarked = !(checkBookmarked ?? false)
      let bookmarkImage =  checkBookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
      bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
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
    let bookmarkImage =  data.bookmarked ? "BookMarkChecked": "BookMarkLightImg"
    bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    
    /// 학과
    majorLabel.text = Utils.convertMajor(data.major, toEnglish: false)
   
    /// 스터디 제목
    titleLabel.text = data.title
  
    /// 벌금
    let fineText = data.penalty == 0 ? "없어요" : "\(data.penalty) 원"
    fineCountLabel.text = "\(fineText)"
    fineCountLabel.changeColor(wantToChange: "\(data.penalty)", color: .o50)
  }
}
