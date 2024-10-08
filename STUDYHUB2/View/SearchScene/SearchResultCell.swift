
import UIKit

import SnapKit
import Kingfisher

final class SearchResultCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  var delegate: BookMarkDelegate?
  
  var model: Content? { didSet { bind() } }
  
  var checkBookmarked: Bool?
  var loginStatus: Bool = false
  
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    label.text = "세무회계학과"
    label.textColor = .o50
    label.backgroundColor = .o10
    label.layer.cornerRadius = 5
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
    label.text = "단기 스터디원 구해요!"
    label.textColor = .black
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return label
  }()
  
  private lazy var periodLabel: UILabel = {
    let label = UILabel()
    label.text = "9월 10일 ~ 10월 10일"
    label.textColor = .bg80
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()
  
  private lazy var remainLabel: UILabel = {
    let label = UILabel()
    label.text = "1자리 남았어요"
    label.textColor = .o50
    label.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    return label
  }()
  
  private lazy var memberCountImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MemberNumberImage")
    return imageView
  }()

  private lazy var memberStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  private lazy var fineImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MoneyImage")
    return imageView
  }()
  
  private lazy var fineLabel: UILabel = {
    let label = UILabel()
    label.text = "400원"
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.textColor = .bg90
    return label
  }()
  
  private lazy var fineStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  private lazy var genderImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "GenderMixImg")
    return imageView
  }()
  
  private lazy var genderLabel: UILabel = {
    let label = UILabel()
    label.text = "무관"
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.textColor = .bg90
    return label
  }()
  
  private lazy var genderStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  private lazy var infoStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    return stackView
  }()
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 48
    imageView.image = UIImage(named: "ProfileAvatar_change")
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var nickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "학생"
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    label.textColor = .bg90
    return label
  }()
  
  private lazy var postedDate: UILabel = {
    let label = UILabel()
    label.text = "2023.9.1"
    label.textColor = .bg70
    label.font = UIFont(name: "Pretendard-Medium", size: 12)
    return label
  }()
  
  private lazy var countMemeberLabel: UILabel = {
    let label = UILabel()
    label.textColor = .bg90
    label.text = "0/14"
    label.changeColor(wantToChange: "0", color: .changeInfo)
    return label
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
  
  // MARK: - 셀 재사용 관련
  override func prepareForReuse() {
    super.prepareForReuse()
    
    bookMarkButton.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    checkBookmarked = false
  }
  
  private func addSubviews() {
    memberStackView.alignment = .center
    memberStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    memberStackView.isLayoutMarginsRelativeArrangement = true
    
    [
      memberCountImage,
      countMemeberLabel
    ].forEach {
      memberStackView.addArrangedSubview($0)
    }
    
    fineStackView.alignment = .center
    fineStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    fineStackView.isLayoutMarginsRelativeArrangement = true
    
    [
      fineImage,
      fineLabel
    ].forEach {
      fineStackView.addArrangedSubview($0)
    }
    
    genderStackView.alignment = .center
    genderStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 11, right: 0)
    genderStackView.isLayoutMarginsRelativeArrangement = true
    
    let genderSpace = UIView()
    [
      genderSpace,
      genderImage,
      genderLabel
    ].forEach {
      genderStackView.addArrangedSubview($0)
    }
    
    infoStackView.backgroundColor = .bg20
    infoStackView.distribution = .fillEqually
    infoStackView.layer.cornerRadius = 10
    
    [
      memberStackView,
      fineStackView,
      genderStackView
    ].forEach {
      infoStackView.addArrangedSubview($0)
    }
    
    [
      majorLabel,
      bookMarkButton,
      titleLabel,
      periodLabel,
      remainLabel,
      infoStackView,
      profileImageView,
      nickNameLabel,
      postedDate,
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    majorLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(10)
    }
    
    bookMarkButton.snp.makeConstraints { make in
      make.top.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-10)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel)
    }
    
    periodLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel)
    }
    
    remainLabel.snp.makeConstraints { make in
      make.top.equalTo(periodLabel)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    infoStackView.snp.makeConstraints { make in
      make.top.equalTo(periodLabel.snp.bottom).offset(10)
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(infoStackView.snp.bottom).offset(20)
      make.leading.equalTo(majorLabel)
      make.height.width.equalTo(34)
    }
    
    nickNameLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
      make.top.equalTo(profileImageView.snp.top)
    }
    
    postedDate.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
      make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
    }
    
    backgroundColor = .white
    
    self.layer.borderWidth = 0.1
    self.layer.borderColor = UIColor.cellShadow.cgColor
    self.layer.cornerRadius = 10
  }
  
  private func bookmarkTapped(){
    self.delegate?.bookmarkTapped(postId: self.model?.postID ?? 0)
    
    if loginStatus {
      checkBookmarked = !(checkBookmarked ?? false)
      let bookmarkImage =  checkBookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
      bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    }
  }
  
  private func bind() {
    guard let data = model else { return }
    
    checkBookmarked = data.bookmarked
    let bookmarkImage =  checkBookmarked ?? false ? "BookMarkChecked": "BookMarkLightImg"
    bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    
    var countMember = data.studyPerson - data.remainingSeat

    majorLabel.text = " \(convertMajor(data.major, toEnglish: false) ?? "없음") "
    titleLabel.text = data.title
    periodLabel.text = "\(data.studyStartDate[1])월 \(data.studyStartDate[2])일 ~\(data.studyEndDate[1])월 \(data.studyEndDate[2])일 "
    
    remainLabel.text = "\(data.remainingSeat)자리 남았어요"
    countMemeberLabel.text = "\(countMember) /\(data.studyPerson)명"
    countMemeberLabel.changeColor(wantToChange: "\(countMember)", color: .o50)
    let fineText = data.penalty == 0 ? "없어요" : "\(data.penalty)원"
    fineLabel.text = "\(fineText)"
    
    genderLabel.text = convertGender(gender: data.filteredGender)
    
    if genderLabel.text == "남자" {
      genderImage.image = UIImage(named: "MenGenderImage")
    } else if genderLabel.text == "여자" {
      genderImage.image = UIImage(named: "GenderImage")
    } else {
      genderImage.image = UIImage(named: "GenderMixImg")
    }
    
    nickNameLabel.text = data.userData.nickname
    postedDate.text = "\(data.createdDate[0]).\(data.createdDate[1]).\(data.createdDate[2])"
    
    if let imageURL = URL(string: data.userData.imageURL ?? "") {
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: 50, height: 50))
            
      self.profileImageView.kf.setImage(
        with: imageURL,
        options: [.processor(processor)]) { result in
        switch result {
        case .success(let value):
          DispatchQueue.main.async {
            self.profileImageView.image = value.image
            self.profileImageView.layer.cornerRadius = 15
            self.profileImageView.clipsToBounds = true
          }
        case .failure(let error):
          print("Image download failed: \(error)")
          self.profileImageView.image = UIImage(named: "ProfileAvatar_change")
          self.profileImageView.layer.cornerRadius = 15
        }
      }
    }
    
    closePostUI(data.close, countMember: countMember, remainingSeat: data.remainingSeat)
  }
  
  func closePostUI(_ postClose: Bool, countMember: Int, remainingSeat: Int){
    majorLabel.textColor = postClose ? .bg70 : .o50
    majorLabel.backgroundColor = postClose ? .bg30 : .o10
    
    titleLabel.textColor = postClose ? .bg70 : .black
    periodLabel.textColor = postClose ? .bg60 : .bg80
    
    remainLabel.text = postClose ? "마감됐어요" : "\(remainingSeat)자리 남았어요"
    remainLabel.textColor = postClose ? .bg70 : .o50
    
    countMemeberLabel.textColor = postClose ? .bg70 : .bg90
    
    if postClose == false {
      countMemeberLabel.changeColor(wantToChange: "\(countMember)", color: .o50)
    }
    
    fineLabel.textColor = postClose ? .bg70 : .bg90
    genderLabel.textColor = postClose ? .bg70 : .bg90
    
    nickNameLabel.textColor = postClose ? .bg70 : .bg90
    bookMarkButton.isHidden = postClose
  }
}

extension SearchResultCell: Convert{}
extension SearchResultCell: ManagementImage {}
