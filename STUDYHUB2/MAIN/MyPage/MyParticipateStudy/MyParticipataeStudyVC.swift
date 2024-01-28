//
//  MyParticipataeStudyVC.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/30.
//

import UIKit

import SnapKit

final class MyParticipateStudyVC: NaviHelper {
  let participateManager = ParticipateManager.shared
  
  var countPostNumber = 2 {
    didSet {
      totalPostCountLabel.text = "전체 \(countPostNumber)"
    }
  }
  
  private lazy var totalPostCountLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 14)
    label.text = "전체 0"
    return label
  }()
  
  private lazy var deleteAllButton: UIButton = {
    let button = UIButton()
    button.setTitle("전체삭제", for: .normal)
    button.setTitleColor(UIColor.bg70, for: .normal)
    button.titleLabel?.font = UIFont(name: "Pretendard", size: 14)
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
    
    setupLayout()
    makeUI()
    
    participateManager.getMyParticipateList(0, 5) {
      print("조회완료")
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
    totalPostCountLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    
    deleteAllButton.snp.makeConstraints { make in
      make.top.equalTo(totalPostCountLabel)
      make.trailing.equalToSuperview().offset(-10)
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
    self.navigationItem.title = "참여한 스터디"
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  }
  
  func confirmDeleteAll(){
      let popupVC = PopupViewController(title: "스터디를 모두 삭제할까요?",
                                        desc: "삭제하면 채팅방을 찾을 수 없으며, 미수락된 스터디는 신청이 취소돼요")
     
      popupVC.modalPresentationStyle = .overFullScreen
      self.present(popupVC, animated: false)
  }
//  func getMyPostData(completion: @escaping () -> Void) {
//    DispatchQueue.global().async {
//      self.myPostDataManager.getMyPostDataFromApi {
//        DispatchQueue.main.async {
//          self.myPostDatas = self.myPostDataManager.getMyPostData()
//          self.countPostNumber = self.myPostDatas.count
//          self.myPostCollectionView.reloadData()
//          completion()
//        }
//      }
//    }
//  }
  
  // MARK: - 전체삭제
  // 전체삭제 알람표시
//  func confirmDeleteAll() {
//    let popupVC = PopupViewController(title: "글을 모두 삭제할까요?",
//                                      desc: "삭제한 글과 참여자는 다시 볼 수 없어요")
//
//    popupVC.popupView.rightButtonAction = { [weak self] in
//      guard let self = self else { return }
//      popupVC.dismiss(animated: true)
//      self.deleteAllPost()
//    }
//
//    popupVC.modalPresentationStyle = .overFullScreen
//    self.present(popupVC, animated: false)
//  }
  
  // 전체 삭제를 수행하는 메서드
//  func deleteAllPost() {
//    let dispatchGroup = DispatchGroup()
//
//    myPostDatas.forEach { post in
//      dispatchGroup.enter() // 진입
//
//      myPostDataManager.fetchDeletePostInfo(postID: post.postId) { [weak self] result in
//        guard let self = self else { return }
//        defer {
//          dispatchGroup.leave() // 완료되면 나가기
//        }
//
//        switch result {
//        case .success:
//          print("모든 게시글 삭제")
//        case .failure(let error):
//          // 삭제 실패 시의 처리
//          print("게시글 삭제 실패: \(error)")
//        }
//      }
//    }
//
//    dispatchGroup.notify(queue: .main) {
//      // 모든 비동기 작업이 완료된 후 실행될 코드
//      self.showToast(message: "모든 글이 삭제되었어요", alertCheck: true)
//      self.myPostCollectionView.reloadData()
//    }
//  }
  
}

// MARK: - collectionView
extension MyParticipateStudyVC: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyParticipateCell.id,
                                                  for: indexPath) as! MyParticipateCell
    cell.delegate = self
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
  func deleteButtonTapped(in cell: MyParticipateCell, postID: Int) {
    let popupVC = PopupViewController(title: "이 스터디를 삭제할까요?",
                                      desc: "삭제하면 신청이 취소돼요")

    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
}
