//
//  EmptyResultView.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//

import UIKit

import SnapKit
import Then

/// 결과값 없을 때 사용하는 View
final class EmptyResultView: UIView {
  
  /// 비어있을 때의 이미지
  private let emptyImageView: UIImageView = UIImageView().then{
    $0.image = UIImage(named: "EmptyStudy")
  }
  
  
  /// 비어있을 때의 라벨
  private let emptyLabel: UILabel = UILabel().then{
   $0.text = "관련 스터디가 없어요\n지금 스터디를 만들어보세요!"
   $0.textColor = .bg60
   $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
   $0.textAlignment = .center
   $0.numberOfLines = 2
  }
  
  /// 결과가 없을 때의 View 생성
  /// - Parameters:
  ///   - imageName: 이미지 이름
  ///   - title: 내용
  convenience init(imageName: String, title: String) {
    self.init(frame: .zero)
    
    emptyImageView.image = UIImage(named: imageName)
    emptyLabel.text = title
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupView()
  }
  
  /// reulstEmpty View 설정
  private func setupView() {
    addSubview(emptyImageView)
    emptyImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview()
      make.size.equalTo(CGSize(width: 150, height: 200))
    }
    
    addSubview(emptyLabel)
    emptyLabel.snp.makeConstraints { make in
      make.top.equalTo(emptyImageView.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
    }
  }
}
