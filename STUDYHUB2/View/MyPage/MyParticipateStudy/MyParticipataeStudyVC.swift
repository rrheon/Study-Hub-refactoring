//
//  MyParticipataeStudyVC.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/30.
//

import UIKit
import SafariServices

import SnapKit

final class MyParticipateStudyVC: NaviHelper {
  let participateManager = ParticipateManager.shared
  let myRequestListManger = MyRequestManager.shared
  var participateInfo: TotalParticipateStudyData?
  
  var previousMyPage: MyPageViewController?
  
  var countPostNumber = 0 {
    didSet {
      totalPostCountLabel.text = "전체 \(countPostNumber)"
    }
  }
  
  private lazy var totalPostCountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    label.text = "전체 0"
    label.textColor = .bg80
    return label
  }()
  
  private lazy var deleteAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체삭제", for: .normal)
    button.setTitleColor(UIColor.bg70, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
    button.addAction(UIAction { _ in
      print("tap button")
      self.confirmDeleteAll()
    },for: .touchUpInside
    )
    return button
  }()
  
  // MARK: - 작성한 글 없을 때
  private lazy var emptyImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "MyParticipateEmptyImage")
    return imageView
  }()
  
  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "참여한 스터디가 없어요\n나와 맞는 스터디를 찾아 보세요!"
    label.numberOfLines = 0
    label.textColor = .bg70
    return label
  }()
  
  // MARK: - 작성한 글 있을 때
  private lazy var myPostCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .bg30
    return scrollView
  }()
  
  // MARK: - 이전페이지로 넘어갈 때
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent {
      previousMyPage?.fetchUserData()
    }
  }
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .bg30
    
    
    navigationItemSetting()
    redesignNavigationbar()
    
    registerCell()
    
//    getMyPostData {
//      self.setupLayout()
//      self.makeUI()
//    }
    

    
    participateManager.getMyParticipateList(0, 5) { result in
      print(result)
      self.participateInfo = result
      self.countPostNumber = result.totalCount
      self.setupLayout()
      self.makeUI()
    }
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      totalPostCountLabel,
      deleteAllButton
    ].forEach {
      view.addSubview($0)
    }
    
    if countPostNumber > 0 {
      view.addSubview(scrollView)
      scrollView.addSubview(myPostCollectionView)
    } else {
      [
        emptyImage,
        emptyLabel
      ].forEach {
        view.addSubview($0)
      }
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    totalPostCountLabel.changeColor(label: totalPostCountLabel,
                                    wantToChange: "\(countPostNumber)",
                                    color: .black)
    totalPostCountLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    deleteAllButton.snp.makeConstraints { make in
      make.top.equalTo(totalPostCountLabel)
      make.trailing.equalToSuperview().offset(-20)
      make.centerY.equalTo(totalPostCountLabel)
    }
    
    if countPostNumber > 0 {
      myPostCollectionView.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(scrollView.snp.height)
      }
      
      scrollView.snp.makeConstraints { make in
        make.top.equalTo(totalPostCountLabel.snp.bottom).offset(20)
        make.leading.trailing.bottom.equalTo(view)
      }
    }else {
      emptyImage.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-20)
        make.height.equalTo(210)
        make.width.equalTo(180)
      }
      
      emptyLabel.setLineSpacing(spacing: 15)
      emptyLabel.textAlignment = .center
      emptyLabel.changeColor(label: emptyLabel,
                             wantToChange: "새로운 스터디 활동을 시작해 보세요!",
                             color: .bg60)
      emptyLabel.snp.makeConstraints { make in
        make.centerX.equalTo(emptyImage)
        make.top.equalTo(emptyImage.snp.bottom).offset(20)
      }
    }
  }
  
  private func registerCell() {
    myPostCollectionView.delegate = self
    myPostCollectionView.dataSource = self

    myPostCollectionView.register(MyParticipateCell.self,
                                  forCellWithReuseIdentifier: MyParticipateCell.id)
  }
  
  // MARK: - navigationbar 재설정
  func redesignNavigationbar(){
    navigationItem.rightBarButtonItems = .none

    settingNavigationTitle(title: "참여한 스터디",
                           font: "Pretendard-Bold",
                           size: 18)
  }
  
  func confirmDeleteAll(){
    let popupVC = PopupViewController(title: "스터디를 모두 삭제할까요?",
                                      desc: "삭제하면 채팅방을 다시 찾을 수 없어요")
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)
      self.participateInfo?.participateStudyData.content.map({ participateDatas in
        self.myRequestListManger.deleteRequestStudy(studyId: participateDatas.studyID) {
          print("전체삭제")
        }
      })
      self.getRequestList {
        self.myPostCollectionView.reloadData()
        
        if self.countPostNumber == 0 {
          self.myPostCollectionView.isHidden = true
          self.noDataUI()
        }
      }
      self.showToast(message: "삭제가 완료됐어요.",
                     imageCheck: true,
                     alertCheck: true)
      }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
  
  func noDataUI(){
    view.addSubview(emptyImage)
    emptyImage.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    view.addSubview(emptyLabel)
    emptyLabel.changeColor(label: emptyLabel,
                           wantToChange: "참여한 스터디가 없어요",
                           color: .bg60,
                           font: UIFont(name: "Pretendard-Medium",
                                        size: 16),
                           lineSpacing: 5)
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
  }
  
  func getRequestList(completion: @escaping () -> Void) {
      participateManager.getMyParticipateList(0, 5) { result in
        self.participateInfo = nil
        self.participateInfo = result
        self.countPostNumber = result.totalCount
       
        completion()
      }
    }
  
}

// MARK: - collectionView
extension MyParticipateStudyVC: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return countPostNumber
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyParticipateCell.id,
                                                  for: indexPath) as! MyParticipateCell
    cell.delegate = self
    cell.model = participateInfo?.participateStudyData.content[indexPath.row]
    cell.contentView.isUserInteractionEnabled = false
    return cell
  }
}

// 셀의 각각의 크기
extension MyParticipateStudyVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 181)
  }
}


extension MyParticipateStudyVC: MyParticipateCellDelegate {
  func moveToChatUrl(chatURL: NSURL) {
    guard UIApplication.shared.canOpenURL(chatURL as URL) else {
      showToast(message: "해당 주소를 사용할 수 없어요")
      return
    }
    
    let chatLinkSafariView = SFSafariViewController(url: chatURL as URL)
    self.present(chatLinkSafariView, animated: true)
  }

  
  func deleteButtonTapped(in cell: MyParticipateCell, postID: Int) {
    let popupVC = PopupViewController(title: "이 스터디를 삭제할까요?",
                                      desc: "삭제하면 채팅방을 다시 찾을 수 없어요")
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)

      self.myRequestListManger.deleteRequestStudy(studyId: postID) {

        self.getRequestList {
          self.myPostCollectionView.reloadData()

          if self.countPostNumber == 0 {
            self.myPostCollectionView.isHidden = true
            self.noDataUI()
          }
        }
        self.showToast(message: "삭제가 완료됐어요.",
                  imageCheck: true,
                  alertCheck: true)
      }
    }
    
    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
}
