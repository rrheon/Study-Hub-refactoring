
import UIKit

class CommonNavi: UIViewController {
  
  init(_ scroll: Bool = false) {
    super.init(nibName: nil, bundle: .none)
    settingNavigationbar(scroll)
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
  
  func rightButtonSetting(imgName: String, activate: Bool = true) {
    let rightButtonImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    lazy var rightButton = UIBarButtonItem(
      image: rightButtonImg,
      style: .plain,
      target: self,
      action: #selector(rightButtonTapped(_:)))
    rightButton.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    rightButton.isEnabled = activate
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  @objc func rightButtonTapped(_ sender: UIBarButtonItem) {}
  
  // MARK: - 네비게이션 바 제목설정
  
  func settingNavigationTitle(
    title: String,
    font: String = "Pretendard-Bold",
    size: CGFloat = 18
  ) {
    self.navigationItem.title = title
    
    if let appearance = self.navigationController?.navigationBar.standardAppearance {
      appearance.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: font, size: size)!
      ]
      
      self.navigationController?.navigationBar.standardAppearance = appearance
//      self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
  }
  
  func settingNavigationbar(_ scroll: Bool) {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.shadowColor = .black
    appearance.backgroundColor = .black
    
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 18)!
    ]
    
    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = appearance
    
    if scroll {
      navigationBar.scrollEdgeAppearance = appearance
    }
  }

}
