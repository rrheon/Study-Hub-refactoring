import UIKit

import SnapKit
import RxCocoa

final class PostedStudyWriterComponent: UIView {
  let viewModel: PostedStudyViewModel

  private lazy var divideLineTopWriterLabel = createDividerLine(height: 8.0)
  private lazy var writerLabel = createLabel(
    title: "작성자",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 16
  )
  
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ProfileAvatar_change")
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 20
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var writerMajorLabel = createLabel(
    textColor: .bg80,
    fontType: "Pretendard-Medium",
    fontSize: 14
  )
  
  private lazy var nickNameLabel = createLabel(
    textColor: .black,
    fontType: "Pretendard-Medium",
    fontSize: 16
  )
  
  private lazy var divideLineUnderWriterLabel = createDividerLine(height: 8.0)

  private lazy var writerInfoStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [writerMajorLabel, nickNameLabel])
    stackView.axis = .vertical
    stackView.spacing = 5
    return stackView
  }()
  
  private lazy var writerInfoWithImageStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [profileImageView, writerInfoStackView])
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.alignment = .center
    return stackView
  }()
  
  private lazy var totalWriterInfoStackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        divideLineTopWriterLabel,
        writerLabel,
        writerInfoWithImageStackView,
        divideLineUnderWriterLabel
      ])
    stackView.axis = .vertical
    stackView.spacing = 20
    return stackView
  }()
  
  init(_ viewModel: PostedStudyViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    self.setupLayout()
    self.setupBinding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayout() {
    self.addSubview(totalWriterInfoStackView)
    
    writerLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
    }
    
    profileImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.height.width.equalTo(50)
    }
    
    divideLineTopWriterLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    divideLineUnderWriterLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    totalWriterInfoStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func setupBinding(){
    viewModel.postDatas
      .asDriver()
      .drive(onNext: {[weak self] in
        guard let data = $0 else { return }
        self?.setupUIData(data)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupUIData(_ data: PostDetailData){
    writerMajorLabel.text = convertMajor(data.major, toEnglish: false)
    nickNameLabel.text = data.postedUser.nickname
  }
}
extension PostedStudyWriterComponent: CreateUIprotocol {}
extension PostedStudyWriterComponent: Convert {}
