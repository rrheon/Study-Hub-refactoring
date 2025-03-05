//
//  SearchResultCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//


import UIKit

import SnapKit
import Kingfisher
import Then

/// 스터디 검색결과 Cell
final class SearchResultCell: UICollectionViewCell {
  var delegate: LoginPopupIsRequired?
  
  var cellData: PostData? { didSet { bind() } }
  
  var checkBookmarked: Bool = false
  
  var loginStatus: Bool = false
  
  /// 학과 라벨
  private lazy var majorLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    label.text = "세무회계학과"
    label.textColor = .o50
    label.backgroundColor = .o10
    label.layer.cornerRadius = 5
    label.clipsToBounds = true
    return label
  }()
  
  /// 북마크 버튼
  private lazy var bookMarkButton: UIButton = UIButton().then({
    $0.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    $0.addAction(UIAction { _ in
      self.bookmarkTapped()
    }, for: .touchUpInside)
  })
  
  /// 스터디 제목 라벨
  private lazy var titleLabel: UILabel = UILabel().then({
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  })
  
  /// 스터디 기간 라벨
  private lazy var periodLabel: UILabel = UILabel().then({
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  })
 
  /// 스터디에 남아있는 자리 라벨
  private lazy var remainLabel: UILabel = UILabel().then({
    $0.textColor = .o50
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 14)
  })
  
  /// 맴버 카운트 이미지
  private lazy var memberCountImage: UIImageView = UIImageView().then({
    $0.image = UIImage(named: "MemberNumberImage")
  })

  /// 맴버 관련 스택뷰
  private lazy var memberStackView: UIStackView = UIStackView().then({
    $0.axis = .vertical
    $0.spacing = 5
  })
  
  /// 벌금 이미지
  private lazy var fineImage: UIImageView = UIImageView().then({
    $0.image = UIImage(named: "MoneyImage")
  })
  
  /// 벌금 라벨
  private lazy var fineLabel: UILabel = UILabel().then({
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    $0.textColor = .bg90
  })
  
  /// 벌금 관련 스택뷰
  private lazy var fineStackView: UIStackView = UIStackView().then({
    $0.axis = .vertical
    $0.spacing = 5
  })
  
  /// 성별 이미지
  private lazy var genderImage: UIImageView = UIImageView().then({
    $0.image = UIImage(named: "GenderMixImg")
  })
  
  /// 성별 라벨
  private lazy var genderLabel: UILabel = UILabel().then({
   $0.font = UIFont(name: "Pretendard-Medium", size: 14)
   $0.textColor = .bg90
  })
  
  /// 성별 관련 스택뷰
  private lazy var genderStackView: UIStackView = UIStackView().then({
    $0.axis = .vertical
    $0.spacing = 5
  })
  
  /// 인원, 벌금, 성별 스택뷰
  private lazy var infoStackView: UIStackView = UIStackView().then({
    $0.axis = .horizontal
    $0.spacing = 10
  })
  
  /// 작성자의 프로필 이미지뷰
  private lazy var profileImageView: UIImageView = UIImageView().then({
    $0.layer.cornerRadius = 48
    $0.image = UIImage(named: "ProfileAvatar_change")
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  })
  
  /// 작성자의 프로필 라벨
  private lazy var nickNameLabel: UILabel = UILabel().then({
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
    $0.textColor = .bg90
  })
  
  /// 게시된 날짜 라벨
  private lazy var postedDate: UILabel = UILabel().then({
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  })
  
  /// 맴버 수 라벨
  private lazy var countMemeberLabel: UILabel = UILabel().then({
    $0.textColor = .bg90
    $0.changeColor(wantToChange: "0", color: .changeInfo)
  })
  
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
  
  /// 셀 재사용
  override func prepareForReuse() {
    super.prepareForReuse()
    
    bookMarkButton.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    checkBookmarked = false
  }
  
  private func addSubviews() {
    // 스터디의 맴버 정보
    memberStackView.alignment = .center
    memberStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    memberStackView.isLayoutMarginsRelativeArrangement = true
    
    [memberCountImage, countMemeberLabel]
      .forEach { memberStackView.addArrangedSubview($0) }
    
    // 스터디의 벌금 정보
    fineStackView.alignment = .center
    fineStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    fineStackView.isLayoutMarginsRelativeArrangement = true
    
    [fineImage, fineLabel]
      .forEach { fineStackView.addArrangedSubview($0) }
    
    // 스터디의 성별 정보
    genderStackView.alignment = .center
    genderStackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 11, right: 0)
    genderStackView.isLayoutMarginsRelativeArrangement = true
    
    [UIView(), genderImage, genderLabel]
      .forEach { genderStackView.addArrangedSubview($0) }
    
    // 스터디의 맴버, 벌금, 성별 정보
    infoStackView.backgroundColor = .bg20
    infoStackView.distribution = .fillEqually
    infoStackView.layer.cornerRadius = 10
    
    [memberStackView, fineStackView, genderStackView]
      .forEach { infoStackView.addArrangedSubview($0) }
    
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
  }
  
  
  /// 북마크 터치 시
  private func bookmarkTapped(){
    let postID = cellData?.postId ?? 0
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
  
  /// UI 데이터 설정
  private func bind() {
    guard let data = cellData,
          let createdDate = data.createdDate,
          let studyStartDate = data.studyStartDate else { return }
    
    checkBookmarked = data.bookmarked
    let bookmarkImage = checkBookmarked ? "BookMarkChecked": "BookMarkLightImg"
    bookMarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
    
    var countMember = data.studyPerson - data.remainingSeat

    majorLabel.text = " \(Utils.convertMajor(data.major, toEnglish: false) ?? "없음") "
    titleLabel.text = data.title
    periodLabel.text = "\(studyStartDate[1])월 \(studyStartDate[2])일 ~\(studyStartDate[1])월 \(studyStartDate[2])일 "
    
    remainLabel.text = "\(data.remainingSeat)자리 남았어요"
    countMemeberLabel.text = "\(countMember) /\(data.studyPerson)명"
    countMemeberLabel.changeColor(wantToChange: "\(countMember)", color: .o50)
    let fineText = data.penalty == 0 ? "없어요" : "\(data.penalty)원"
    fineLabel.text = "\(fineText)"
    
    genderLabel.text = Utils.convertGender(gender: data.filteredGender ?? "")
    
    if genderLabel.text == "남자" {
      genderImage.image = UIImage(named: "MenGenderImage")
    } else if genderLabel.text == "여자" {
      genderImage.image = UIImage(named: "GenderImage")
    } else {
      genderImage.image = UIImage(named: "GenderMixImg")
    }
    
    nickNameLabel.text = data.userData.nickname
    postedDate.text = "\(createdDate[0]).\(createdDate[1]).\(createdDate[2])"
    
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
  
  /// 마감인 포스트 UI
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

extension SearchResultCell: ManagementImage {}
