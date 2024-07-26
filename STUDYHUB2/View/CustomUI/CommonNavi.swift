
import UIKit

class CommonNavi: UIViewController {
  // MARK: - navi 설정
  func leftButtonSetting() {
    let homeImg = UIImage(named: "LeftArrow")?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(image: homeImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(leftButtonTapped(_:)))
    
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  func rightButtonSetting() {
    let rightButtonImg = UIImage(named: "RightButtonImg")?.withRenderingMode(.alwaysOriginal)
    let rightButton = UIBarButtonItem(image: rightButtonImg,
                                      style: .plain,
                                      target: self,
                                      action: #selector(rightButtonTapped))
  
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  @objc func leftButtonTapped(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func rightButtonTapped() {
    
  }
  
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
