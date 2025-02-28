
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Then

/// 유저의 활동정보 View - 작성한 글, 참여한 스터디, 신청내역
final class UserActivityView: UIView {
  let disposeBag: DisposeBag = DisposeBag()
  
  let viewModel: MyPageViewModel
  
  /// 작성한 글 라벨
  private lazy var writtenLabel = UILabel().then {
    $0.text = "작성한 글"
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 14)
  }

  /// 작성한 글 갯수 라벨
  private lazy var writtenCountLabel = UILabel().then {
    $0.text = "0"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 18)
  }
  
  /// 작성한 글 버튼
  private lazy var writtenButton = UIButton()
  
  /// 참여한 스터디 라벨
  private lazy var joinstudyLabel = UILabel().then {
    $0.text = "참여한 스터디"
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 14)
  }
  
  /// 참여한 스터디 갯수 라벨
  private lazy var joinstudyCountLabel = UILabel().then {
    $0.text = "0"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 18)
  }
  
  /// 참여한 스터디 버튼
  private lazy var joinstudyButton = UIButton()
  
  /// 신청내역 라벨
  private lazy var requestLabel = UILabel().then {
    $0.text = "신청내역"
    $0.textColor = .bg80
    $0.font = UIFont(name: "Pretendard", size: 14)
  }
  
  /// 신청 내역 갯수 라벨
  private lazy var requestCountLabel = UILabel().then {
    $0.text = "0"
    $0.textColor = .black
    $0.font = UIFont(name: "Pretendard-Bold", size: 18)
  }
  
  /// 신청내역 버튼
  private lazy var requestListButton = UIButton()

  /// 구분선
  private lazy var didiveLine = StudyHubUI.createDividerLine(height: 10)
  
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
  
  /// layout 설정
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
  
  /// UI 설정
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
      $0.top.equalToSuperview()
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
  
  /// 바인딩
  func setupBinding(){
    /// 유저 데이터
    viewModel.userData
      .asDriver()
      .drive(onNext: {[weak self] in
        guard let data = $0 else { return }
        self?.setupUIData(data)
      })
      .disposed(by: disposeBag)
  }
  
  /// actions 설정
  func setupActions() {
    let userData = self.viewModel.userData
    
    // 내가 작성한 글 버튼 탭
    writtenButton.rx
      .tap
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: .navToMyStudyPostScreen,
                                        object: nil,
                                        userInfo: ["userData": userData])
      })
      .disposed(by: disposeBag)
    
    // 내가 참여한 글 버튼 탭
    joinstudyButton.rx
      .tap
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: .navToMyParticipatePostScreen,
                                      object: nil,
                                      userInfo: ["userData": userData])
    })
    .disposed(by: disposeBag)
    
    // 내가 신청한 글 버튼 탭
    requestListButton.rx
      .tap
      .subscribe(onNext: { _ in
        NotificationCenter.default.post(name: .navToMyRequestPostScreen,
                                        object: nil,
                                        userInfo: ["userData": userData])
      })
      .disposed(by: disposeBag)
  }


  // MARK: - updateVC
  
  /// UI 데이터 설정
  func setupUIData(_ data: UserDetailData){
    self.writtenCountLabel.text = "\(data.postCount ?? 0)"
    self.joinstudyCountLabel.text = "\(data.participateCount ?? 0)"
    self.requestCountLabel.text = "\((data.applyCount ?? 0) - (data.participateCount ?? 0))"
  }
}
