//
//  MyRequestListViewController.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2024/02/15.
//

import UIKit

import SnapKit

final class MyRequestListViewController: NaviHelper {
  
  var myRequestListManger = MyRequestManager.shared
  var previousMyPage: MyPageViewController?
  
  var requestStudyList: [RequestStudyContent]? = []
  
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
  
  // MARK: - 작성한 글 없을 때
  private lazy var emptyImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "ApplyEmptyImg")
    return imageView
  }()
  
  private lazy var emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "참여한 스터디가 없어요\n나와 맞는 스터디를 찾아 보세요!"
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    label.textColor = .bg70
    return label
  }()
  
  // MARK: - 작성한 글 있을 때
  private lazy var myStudyRequestCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 24
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .bg30
    view.clipsToBounds = false
    return view
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
    
    getRequestList {      
      self.registerCell()
      self.setupLayout()
      self.makeUI()
    }
  }
  
  func getRequestList(completion: @escaping () -> Void) {
    myRequestListManger.getMyRequestStudyList { [weak self] result in
      self?.requestStudyList = []
      self?.requestStudyList?.append(contentsOf: result.requestStudyData.content)
      self?.countPostNumber = self?.requestStudyList?.count ?? 0
      
      completion()
    }
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    
    if countPostNumber > 0 {
      [
        totalPostCountLabel,
        myStudyRequestCollectionView
      ].forEach {
        view.addSubview($0)
      }
    } else {
      [
        totalPostCountLabel,
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
    totalPostCountLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    if countPostNumber > 0 {
      myStudyRequestCollectionView.snp.makeConstraints {
        $0.top.equalTo(totalPostCountLabel.snp.bottom).offset(20)
        $0.leading.equalTo(totalPostCountLabel)
        $0.trailing.equalToSuperview().offset(-20)
        $0.bottom.equalToSuperview()
      }
    } else {
      noDataUI()
    }
  }
  
  // MARK: - 네비게이션 설정
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    
    settingNavigationTitle(title: "신청 내역")
  }
  
  private func registerCell() {
    myStudyRequestCollectionView.delegate = self
    myStudyRequestCollectionView.dataSource = self
    
    myStudyRequestCollectionView.register(MyRequestCell.self,
                                          forCellWithReuseIdentifier: MyRequestCell.id)
  }
  
  func noDataUI(){
    view.addSubview(emptyImage)
    emptyImage.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    view.addSubview(emptyLabel)
    emptyLabel.changeColor(label: emptyLabel,
                           wantToChange: "지금 스터디에 참여해보세요!",
                           color: .bg60,
                           font: UIFont(name: "Pretendard-Medium",
                                        size: 16),
                           lineSpacing: 5)
    emptyLabel.snp.makeConstraints {
      $0.top.equalTo(emptyImage.snp.bottom).offset(10)
      $0.centerX.equalToSuperview()
    }
  }
}

// MARK: - collectionView
extension MyRequestListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return countPostNumber
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRequestCell.id,
                                                  for: indexPath) as! MyRequestCell
    cell.delegate = self
    cell.model = requestStudyList?[indexPath.row]
    cell.contentView.isUserInteractionEnabled = false
    
    myStudyRequestCollectionView.collectionViewLayout.invalidateLayout()

    return cell
  }
}

// 셀의 각각의 크기
extension MyRequestListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let model = requestStudyList?[indexPath.row]
    let cellHeight = model?.inspection == "REJECT" ? 239 : 197
    return CGSize(width: 350, height: cellHeight)
  }
}


extension MyRequestListViewController: MyRequestCellDelegate {
  func moveToCheckRejectReason(studyId: Int) {
    myRequestListManger.getMyRejectReason(studyId: studyId) { rejectReason in
      print(rejectReason)
      let checkRejectReasonVC = DetailRejectReasonViewController()
      checkRejectReasonVC.rejectData = rejectReason
      self.navigationController?.pushViewController(checkRejectReasonVC, animated: true)
    }
  }
  
  func deleteButtonTapped(in cell: MyRequestCell, postID: Int) {
    let popupVC = PopupViewController(title: "이 스터디를 삭제할까요?",
                                      desc: "")
    
    popupVC.modalPresentationStyle = .overFullScreen
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true)

      self.myRequestListManger.deleteRequestStudy(studyId: cell.model?.studyID ?? 0) {
        self.getRequestList {
          self.myStudyRequestCollectionView.reloadData()

          if self.countPostNumber == 0 {
            self.myStudyRequestCollectionView.isHidden = true
            self.noDataUI()
          }
        }
        self.showToast(message: "삭제가 완료됐어요.",
                  imageCheck: true,
                  alertCheck: true)
      }
    }
    
    self.present(popupVC, animated: false)
  }
}
