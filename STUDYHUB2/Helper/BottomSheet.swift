//
//  BottomSheet.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/11/01.
//

import UIKit

import SnapKit

// 이걸 다 바꿔야하나, 버튼 2개 다 delegate로 받고 쓸 때 함수 선언, 초기화 할 때 버튼 이름 받기
protocol BottomSheetDelegate: AnyObject {
  func firstButtonTapped(postID: Int?)
  func secondButtonTapped(postID: Int?)
}

final class BottomSheet: UIViewController {
  weak var delegate: BottomSheetDelegate?
  
  private let postID: Int
  private let firstButtonTitle: String
  private let secondButtonTitle: String
  private let checkMyPost: Bool
  
  let detailPostDataManager = PostDetailInfoManager.shared
  var deletePostButtonAction: (() -> Void)?
  var modifyPostButtonAction: (() -> Void)?

  init(postID: Int,
       checkMyPost: Bool = false,
       firstButtonTitle: String = "삭제하기",
       secondButtonTitle: String = "수정하기") {
    self.postID = postID
    self.firstButtonTitle = firstButtonTitle
    self.secondButtonTitle = secondButtonTitle
    self.checkMyPost = checkMyPost
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle(firstButtonTitle, for: .normal)
    
    let buttonColor = firstButtonTitle == "삭제하기" ? UIColor.o50 : UIColor.bg80
    button.setTitleColor(buttonColor, for: .normal)
    button.addAction(UIAction { _ in
      if self.checkMyPost {
        self.deletePostButtonTapped()
      }else{
        self.firstButtonTapped()
      }
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var modifyButton: UIButton = {
    let button = UIButton()
    button.setTitle(secondButtonTitle, for: .normal)
    button.setTitleColor(.bg80, for: .normal)
    button.addAction(UIAction { _ in
      if self.checkMyPost {
        self.modifyPostButtonTapped()
      }else{
        self.secondButtonTapped()
      }
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.setTitle("닫기", for: .normal)
    button.setTitleColor(.bg80, for: .normal)
    button.backgroundColor = .bg30
    button.addTarget(self, action: #selector(dissMissButtonTapped), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setUpLayout()
    makeUI()
    
  }
  
  func setUpLayout(){
    [
      deleteButton,
      modifyButton,
      dismissButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    deleteButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview()
      make.height.equalTo(50)
    }
    
    modifyButton.snp.makeConstraints { make in
      make.top.equalTo(deleteButton.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.height.equalTo(50)
      
    }
    
    dismissButton.snp.makeConstraints { make in
      make.top.equalTo(modifyButton.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
      make.height.equalTo(50)
      make.width.equalTo(335)
    }
  }
  
  func firstButtonTapped(){
    dismiss(animated: true) {
      self.delegate?.firstButtonTapped(postID: self.postID)
    }
  }
  
  @objc func dissMissButtonTapped(){
    dismiss(animated: true, completion: nil)
  }
  
  func secondButtonTapped(){
    dismiss(animated: true) {
      self.delegate?.secondButtonTapped(postID: self.postID)
    }
  }
  
  func deletePostButtonTapped(){
    deletePostButtonAction?()
    print("Hhh")
  }
  
  func modifyPostButtonTapped(){
    modifyPostButtonAction?()
    print("게시글 수정하기")
  }
}
