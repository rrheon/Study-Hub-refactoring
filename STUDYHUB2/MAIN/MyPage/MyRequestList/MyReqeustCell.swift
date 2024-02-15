
import UIKit

import SnapKit

protocol MyRequestCellDelegate: AnyObject {
  func deleteButtonTapped(in cell: MyRequestCell, postID: Int)
}

final class MyRequestCell: UICollectionViewCell {
  
  weak var delegate: MyRequestCellDelegate?
  
  var model: RequestStudyContent? {
    didSet {
      bind()
    }
  }

  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
  
  lazy var requestLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8))
    label.text = " 수락 대기 중 "
    label.textColor = .white
    label.backgroundColor = .black
    label.layer.cornerRadius = 10
    label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
    return label
  }()
  
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "DeleteButtonImage"), for: .normal)
    button.addAction(UIAction { _ in
      self.deleteButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "단기 스터디원 구해요!"
    label.textColor = .black
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    return label
  }()
  
  lazy var infoLabel: BasePaddingLabel = {
    let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16))
    label.text = "내용내용내용"
    label.textColor = .bg80
    label.backgroundColor = .bg20
    label.font = UIFont(name: "Pretendard-Medium", size: 14)
    return label
  }()

  private lazy var checkRejectReasonButton: UIButton = {
    let button = UIButton()
    button.setTitle("거절 이유 확인하기", for: .normal)
    button.setTitleColor(UIColor.bg80, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    button.titleLabel?.textAlignment = .center
    button.addAction(UIAction { _ in
      self.moveToChatButtonTapped()
    }, for: .touchUpInside)
    return button
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
  
  private func addSubviews() {
    
    [
      requestLabel,
      deleteButton,
      titleLabel,
      infoLabel,
      checkRejectReasonButton
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    requestLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    deleteButton.snp.makeConstraints {
      $0.centerY.equalTo(requestLabel)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(requestLabel.snp.bottom).offset(10)
      $0.leading.equalTo(requestLabel.snp.leading)
    }
    
    infoLabel.numberOfLines = 0
    infoLabel.changeColor(label: infoLabel,
                          wantToChange: "신청 내용",
                          color: .bg60,
                          font: UIFont(name: "Pretendard-SemiBold",
                                                    size: 12))
    infoLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.leading.equalTo(requestLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    if requestLabel.text == "거절" {
      checkRejectReasonButton.snp.makeConstraints {
        $0.top.equalTo(infoLabel.snp.bottom)
        $0.height.equalTo(42)
      }
    }

    backgroundColor = .white
    
    self.layer.borderWidth = 0.1
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.cornerRadius = 10
  }
  
  func deleteButtonTapped(){
    self.delegate?.deleteButtonTapped(in: self, postID: 0)
    print("1")
  }
  
  func moveToChatButtonTapped(){
    print("@")
  }
  
  func bind(){
    guard let model = model else { return }
    
    requestLabel.text = model.inspection == "STANDBY" ? "수락 대기 중" : "거절"
    titleLabel.text = model.studyTitle
    infoLabel.text = "신청내용\n\(model.introduce)"
  }
}

