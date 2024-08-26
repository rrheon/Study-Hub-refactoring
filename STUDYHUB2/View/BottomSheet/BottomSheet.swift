
import UIKit

import SnapKit

protocol BottomSheetDelegate {
  func firstButtonTapped(postID: Int, checkPost: Bool)
  func secondButtonTapped(postID: Int, checkPost: Bool)
}

final class BottomSheet: UIViewController {
  private let postID: Int
  private let firstButtonTitle: String
  private let secondButtonTitle: String
  private let checkMyPost: Bool
  private let checkPost: Bool
  
  var delegate: BottomSheetDelegate?
  
  init(postID: Int,
       checkMyPost: Bool = false,
       firstButtonTitle: String = "삭제하기",
       secondButtonTitle: String = "수정하기",
       checkPost: Bool = false) {
    self.postID = postID
    self.firstButtonTitle = firstButtonTitle
    self.secondButtonTitle = secondButtonTitle
    self.checkMyPost = checkMyPost
    self.checkPost = checkPost
    
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
      self.firstButtonTapped()
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var modifyButton: UIButton = {
    let button = UIButton()
    button.setTitle(secondButtonTitle, for: .normal)
    button.setTitleColor(.bg80, for: .normal)
    button.addAction(UIAction { _ in
      self.secondButtonTapped()
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
      self.delegate?.firstButtonTapped(postID: self.postID, checkPost: self.checkPost)
    }
  }
  
  @objc func dissMissButtonTapped(){
    dismiss(animated: true, completion: nil)
  }
  
  func secondButtonTapped(){
    dismiss(animated: true) {
      self.delegate?.secondButtonTapped(postID: self.postID, checkPost: self.checkPost)
    }
  }
}
