
import UIKit

class CommonNavi: UIViewController {
  
  init() {
    super.init(nibName: nil, bundle: .none)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func leftButtonSetting(imgName: String = "LeftArrow", activate: Bool = true) {
    let homeImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(
      image: homeImg,
      style: .plain,
      target: self,
      action: #selector(leftButtonTapped(_:)))
    leftButton.isEnabled = activate
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  @objc func leftButtonTapped(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func rightButtonSetting(imgName: String){
    let bookMarkImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    lazy var bookMark = UIBarButtonItem(
      image: bookMarkImg,
      style: .plain,
      target: self,
      action: #selector(rightButtonTapped(_:)))
    bookMark.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    
    navigationItem.rightBarButtonItem = bookMark
  }
  
  @objc func rightButtonTapped(_ sender: UIBarButtonItem) {}
  
  // MARK: - 네비게이션 바 제목설정
  
  func settingNavigationTitle(title: String,
                              font: String = "Pretendard-Bold",
                              size: CGFloat = 18){
    self.navigationItem.title = title
    self.navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont(name: font, size: size)!
    ]
    
    self.navigationController?.navigationBar.barTintColor =  .black
    self.navigationController?.navigationBar.backgroundColor = .black
    self.navigationController?.navigationBar.isTranslucent = false
  }
}
