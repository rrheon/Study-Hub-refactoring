//
//  BookMarkCell.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/09.
//
import UIKit

import SnapKit
import Then

/// 북마크 셀에서 참여하기 action을 위한 프로토콜
protocol BookmarkCellDelegate: AnyObject {
  
  /// 참여하기 버튼 터치 시
  /// - Parameters:
  ///   - studyId: 스터디의 StudyId
  ///   - postId: 스터디의 PostId
  func participateBtnTapped(studyId: Int, postId: Int)
  
  func bookmarkBtnTapped(postId: Int)
}

/// 북마크 셀
final class BookMarkCell: UICollectionViewCell {
  weak var delegate: BookmarkCellDelegate?
  
  var model: BookmarkContent? { didSet { bind()} }
  
  /// 학과 라벨
  private lazy var majorLabel: UILabel = UILabel().then {
    $0.textColor = .o50
    $0.layer.cornerRadius = 5
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 12)
  }
  
  /// 북마크 버튼
  private lazy var bookMarkButton: UIButton = UIButton().then {
    $0.setImage(UIImage(named: "BookMarkChecked"), for: .normal)
    $0.addAction(UIAction { _ in
      BookmarkManager.shared.bookmarkTapped(with: self.model?.postID ?? 0) { _ in 
        self.delegate?.bookmarkBtnTapped(postId: self.model?.postID ?? 0)
      }
    }, for: .touchUpInside)
  } 
  
  /// 스터디의 제목 라벨
  private lazy var titleLabel: UILabel = UILabel().then{
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
  }
  
  /// 스터디의 내용 라벨
  private lazy var infoLabel: UILabel = UILabel().then{
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard-Medium", size: 14)
  }
  
  /// 잔여 자리 라벨
  private lazy var remainLabel: UILabel = UILabel().then{
    $0.textColor = .bg70
    $0.font = UIFont(name: "Pretendard-Medium", size: 12)
  }
  
  /// 스터디 참여하기 버튼
  private lazy var enterButton: UIButton = UIButton().then{
   $0.setTitle("신청하기", for: .normal)
   $0.setTitleColor(UIColor.o50, for: .normal)
   $0.layer.cornerRadius = 5
   $0.layer.borderWidth = 1
   $0.layer.borderColor = UIColor.o40.cgColor
   $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
   $0.addAction(UIAction { _ in
     self.delegate?.participateBtnTapped(studyId: self.model?.studyID ?? 0,
                                         postId: self.model?.postID ?? 0)
    }, for: .touchUpInside)
  }
  
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
  
  
  /// Layout 설정
  private func addSubviews() {
    
    [
      majorLabel,
      bookMarkButton,
      titleLabel,
      infoLabel,
      remainLabel,
      enterButton
    ].forEach {
      addSubview($0)
    }
  }
  
  
  /// UI설정
  private func configure() {
    majorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(20)
    }
    
    bookMarkButton.snp.makeConstraints { make in
      make.centerY.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    infoLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    remainLabel.snp.makeConstraints { make in
      make.top.equalTo(infoLabel.snp.bottom).offset(10)
      make.leading.equalTo(majorLabel.snp.leading)
    }
    
    enterButton.snp.makeConstraints { make in
      make.top.equalTo(remainLabel.snp.bottom).offset(30)
      make.leading.equalTo(majorLabel.snp.leading)
      make.trailing.equalTo(bookMarkButton.snp.trailing)
      make.height.equalTo(47)
    }
    
    backgroundColor = .white
  }
  
  
  /// 데이터 바인딩
  private func bind() {
    majorLabel.text = Utils.convertMajor(model?.major ?? "없음", toEnglish: false)
    titleLabel.text =  model?.title
    infoLabel.text = model?.content
    remainLabel.text = "잔여 \(model?.remainingSeat ?? 0)자리"
   
    if model?.close == true {
      enterButton.setTitle("마감되었어요", for: .normal)
      enterButton.layer.borderColor = UIColor.bg40.cgColor
      enterButton.titleLabel?.textColor = .bg60
      enterButton.setTitleColor(.bg60, for: .normal)
      enterButton.isEnabled = false
    }
  }
}
