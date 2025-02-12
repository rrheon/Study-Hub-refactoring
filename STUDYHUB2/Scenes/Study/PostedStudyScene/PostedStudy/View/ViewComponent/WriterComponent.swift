
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 작성자 정보 component
final class PostedStudyWriterComponent: UIView {
  
  let disposeBag: DisposeBag = DisposeBag()
  
  var postedData: PostDetailData

  /// 구분선
  private lazy var divideLineUnderIntroduceStudy = UIView().then {
    $0.backgroundColor = UIColor(hexCode: "#F3F5F6")
    $0.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
  }

  /// 작성자 이름 제목
  private lazy var writerLabel = UILabel().then {
    $0.text = "작성자"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 프로필 이미지
  private lazy var profileImageView: UIImageView = UIImageView().then {
    $0.image = UIImage(named: "ProfileAvatar_change")
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 20
    $0.clipsToBounds = true
  }
  
  /// 작성자 전공 라벨
  private lazy var writerMajorLabel = UILabel().then {
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 작성자 닉네임 라벨
  private lazy var nickNameLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Medium", size: 16)
  }
 
  /// 구분선
  private lazy var divideLineUnderWriterLabel = UIView().then {
    $0.backgroundColor = UIColor(hexCode: "#F3F5F6")
    $0.heightAnchor.constraint(equalToConstant: 8.0).isActive = true
  }

  /// 작성자 정보 스택뷰 - 학과, 이름
  private lazy var writerInfoStackView: UIStackView = UIStackView().then {
   $0.axis = .vertical
   $0.spacing = 5
  }
  
  /// 작성자 정보 스택뷰 - 학과, 이름, 이미지
  private lazy var writerInfoWithImageStackView: UIStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
    $0.alignment = .center
  }
  
  /// 전체 작성자정보 스택뷰
  private lazy var totalWriterInfoStackView: UIStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
  }
  
  init(with data: PostDetailData) {
    self.postedData = data
    
    super.init(frame: .zero)
    
    self.setupLayout()
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    /// 작성자 정보 스택뷰 - 학과, 이름
    [writerMajorLabel, nickNameLabel]
      .forEach { writerInfoStackView.addArrangedSubview($0) }
    
    /// 작성자 정보 스택뷰 - 학과, 이름, 이미지
    [profileImageView, writerInfoStackView]
      .forEach {  writerInfoWithImageStackView.addArrangedSubview($0) }

    /// 전체 작성자 정보 스택뷰
    [
      divideLineUnderIntroduceStudy,
      writerLabel,
      writerInfoWithImageStackView,
      divideLineUnderWriterLabel
    ].forEach {
      totalWriterInfoStackView.addArrangedSubview($0)
    }

    self.addSubview(totalWriterInfoStackView)
    
    writerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
    }
    
    profileImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.height.width.equalTo(50)
    }
    
    divideLineUnderIntroduceStudy.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    divideLineUnderWriterLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    totalWriterInfoStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  /// 바인딩
  func setupBinding(){
//    viewModel.postDatas
//      .asDriver()
//      .drive(onNext: {[weak self] in
//        guard let data = $0 else { return }
//        self?.setupUIData(data)
//      })
//      .disposed(by: disposeBag)
  }
  
  /// UI에 데이터 세팅
  func setupUIData(_ data: PostDetailData){
    writerMajorLabel.text = Utils.convertMajor(data.major, toEnglish: false)
    nickNameLabel.text = data.postedUser.nickname
  }
}
