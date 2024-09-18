
import UIKit

import SnapKit
import RxCocoa

final class UserActivityView: UIView {
  let viewModel: MyPageViewModel
  
  // 작성한 글
  private lazy var writtenLabel = createLabel(
    title: "작성한 글",
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 14
  )
  
  private lazy var writtenCountLabel = createLabel(
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 18
  )
  
  private lazy var writtenButton = UIButton()
  
  // 참여한 스터디
  private lazy var joinstudyLabel = createLabel(
    title: "참여한 스터디",
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 14
  )
  
  private lazy var joinstudyCountLabel = createLabel(
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 18
  )
  
  private lazy var joinstudyButton = UIButton()
  
  // 신청 내역
  private lazy var requestCountLabel = createLabel(
    textColor: .black,
    fontType: "Pretendard-Bold",
    fontSize: 18
  )
  
  private lazy var requestLabel = createLabel(
    title: "신청내역",
    textColor: .bg80,
    fontType: "Pretendard",
    fontSize: 14
  )
  
  private lazy var requestListButton = UIButton()

  private lazy var didiveLine = createDividerLine(height: 10)
  
  init(_ viewModel: MyPageViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero)
    
    setupLayout()
    makeUI()
    setupBinding()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - setupLayout
  
  
  func setupLayout(){
    [
      writtenButton,
      writtenCountLabel,
      writtenLabel,
      joinstudyButton,
      joinstudyCountLabel,
      joinstudyLabel,
      requestListButton,
      requestCountLabel,
      requestLabel,
      didiveLine
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI(){
    [
      writtenButton,
      joinstudyButton,
      requestListButton
    ].forEach {
      $0.backgroundColor = .bg20
      $0.layer.cornerRadius = 5
      $0.layer.borderColor = UIColor.bg40.cgColor
      $0.layer.borderWidth = 1
    }
    
    // 작성한 글
    writtenButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(100)
      $0.width.equalTo(105)
      $0.height.equalTo(87)
    }
    
    writtenCountLabel.snp.makeConstraints {
      $0.top.equalTo(writtenButton.snp.top).offset(20)
      $0.centerX.equalTo(writtenButton)
    }
    
    writtenLabel.snp.makeConstraints {
      $0.top.equalTo(writtenCountLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(writtenButton)
    }
    
    // 참여한 스터디
    joinstudyButton.snp.makeConstraints {
      $0.leading.equalTo(writtenButton.snp.trailing).offset(15)
      $0.top.equalTo(writtenButton)
      $0.width.equalTo(105)
      $0.height.equalTo(87)
    }
    
    joinstudyCountLabel.snp.makeConstraints {
      $0.top.equalTo(joinstudyButton.snp.top).offset(20)
      $0.centerX.equalTo(joinstudyButton)
    }
    
    joinstudyLabel.snp.makeConstraints {
      $0.top.equalTo(joinstudyCountLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(joinstudyButton)
    }
    
    // 북마크
    requestListButton.snp.makeConstraints {
      $0.leading.equalTo(joinstudyButton.snp.trailing).offset(15)
      $0.top.equalTo(writtenButton)
      $0.width.equalTo(105)
      $0.height.equalTo(87)
    }
    
    requestCountLabel.snp.makeConstraints {
      $0.top.equalTo(requestListButton.snp.top).offset(20)
      $0.centerX.equalTo(requestListButton)
    }
    
    requestLabel.snp.makeConstraints {
      $0.top.equalTo(requestCountLabel.snp.bottom).offset(10)
      $0.centerX.equalTo(requestListButton)
    }
    
    didiveLine.snp.makeConstraints {
      $0.top.equalTo(writtenButton.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func setupBinding(){
    viewModel.userData
      .asDriver()
      .drive(onNext: {[weak self] in
        guard let data = $0 else { return }
        self?.setupUIData(data)
      })
      .disposed(by: viewModel.disposeBag)
  }
  
  func setupActions(){
    
  }
  
  // MARK: - 작성한 글 버튼 탭
//  
//  @objc func writtenButtonTapped(){
//    let myPostVC = MyPostViewController()
//    myPostVC.previousMyPage = self
//    myPostVC.hidesBottomBarWhenPushed = true
//    self.navigationController?.pushViewController(myPostVC, animated: true)
//  }
//  
//  // MARK: - 참여한 스터디 버튼 탭
//  
//  func joinstudyButtonTapped(){
//    let myParticipateVC = MyParticipateStudyVC()
//    myParticipateVC.previousMyPage = self
//    myParticipateVC.hidesBottomBarWhenPushed = true
//    self.navigationController?.pushViewController(myParticipateVC, animated: true)
//  }
//  
//  @objc func myRequestPageButtonTapped() {
//    let myRequestVC = MyRequestListViewController()
//    myRequestVC.previousMyPage = self
//    myRequestVC.hidesBottomBarWhenPushed = true
//    self.navigationController?.pushViewController(myRequestVC, animated: true)
//  }
  

  // MARK: - updateVC
  func setupUIData(_ data: UserDetailData){
    self.writtenCountLabel.text = "\(data.postCount ?? 0)"
    self.joinstudyCountLabel.text = "\(data.participateCount ?? 0)"
    self.requestCountLabel.text = "\((data.applyCount ?? 0) - (data.participateCount ?? 0))"
  }
}

extension UserActivityView: CreateUIprotocol {}
