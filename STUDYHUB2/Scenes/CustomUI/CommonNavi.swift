
import UIKit

extension UIViewController {
  
  /// 왼쪽 아이템 버튼 설정
  /// - Parameters:
  ///   - imgName: 이미지 - 기본값 = 왼쪽 화살표
  ///   - activate: 버튼 액션 활성화 여부
  func leftButtonSetting(imgName: String = "LeftArrow", activate: Bool = true) {
    let homeImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(
      image: homeImg,
      style: .plain,
      target: self,
      action: #selector(leftBarBtnTapped))
    leftButton.isEnabled = activate
    self.navigationItem.leftBarButtonItem = leftButton
  }

  @objc func leftBarBtnTapped(_ sender: UIBarButtonItem){}
  
  /// 오른쪽 아이템 버튼 설정
  /// - Parameters:
  ///   - imgName: 이미지 이름
  ///   - activate: 오른쪽 버튼 활성화 여부
  func rightButtonSetting(imgName: String, activate: Bool = true) {
    let rightButtonImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
    lazy var rightButton = UIBarButtonItem(
      image: rightButtonImg,
      style: .plain,
      target: self,
      action: #selector(rightBarBtnTapped))
    rightButton.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    rightButton.isEnabled = activate
    self.navigationItem.rightBarButtonItem = rightButton
  }
  
  @objc func rightBarBtnTapped(_ sender: UIBarButtonItem){}
  
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
    navigationBar.scrollEdgeAppearance = appearance
    
  }
  
  
  /// 네비게이션 바 타이틀 설정
  /// - Parameters:
  ///   - title: 제목
  ///   - font: 폰트
  ///   - size: 사이즈
  func settingNavigationTitle(title: String, font: String = "Pretendard-Bold", size: CGFloat = 18) {
    self.navigationItem.title = title
    
    if let appearance = self.navigationController?.navigationBar.standardAppearance {
      appearance.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: font, size: size)!
      ]
      
      self.navigationController?.navigationBar.standardAppearance = appearance
      self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
  }
  
  /// 스크롤 시 네비게이션 바 색상 변경 방지
  func configurationNavigationBar(){
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithTransparentBackground()
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
  }
}

class CommonNavi: UIViewController {
  
  init(_ scroll: Bool = false) {
    super.init(nibName: nil, bundle: .none)
    settingNavigationbar(scroll)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
//  func leftButtonSetting(imgName: String = "LeftArrow", activate: Bool = true) {
//    let homeImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
//    let leftButton = UIBarButtonItem(
//      image: homeImg,
//      style: .plain,
//      target: self,
//      action: #selector(leftButtonTapped(_:)))
//    leftButton.isEnabled = activate
//    self.navigationItem.leftBarButtonItem = leftButton
//  }
//  
//  @objc func leftButtonTapped(_ sender: UIBarButtonItem) {
//    self.navigationController?.popViewController(animated: true)
//  }
//  
//  func rightButtonSetting(imgName: String, activate: Bool = true) {
//    let rightButtonImg = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
//    lazy var rightButton = UIBarButtonItem(
//      image: rightButtonImg,
//      style: .plain,
//      target: self,
//      action: #selector(rightButtonTapped(_:)))
//    rightButton.imageInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
//    rightButton.isEnabled = activate
//    self.navigationItem.rightBarButtonItem = rightButton
//  }
  
  @objc func rightButtonTapped(_ sender: UIBarButtonItem) {}
  
  // MARK: - 네비게이션 바 제목설정
  
//  func settingNavigationTitle(
//    title: String,
//    font: String = "Pretendard-Bold",
//    size: CGFloat = 18
//  ) {
//    self.navigationItem.title = title
//    
//    if let appearance = self.navigationController?.navigationBar.standardAppearance {
//      appearance.titleTextAttributes = [
//        NSAttributedString.Key.foregroundColor: UIColor.white,
//        NSAttributedString.Key.font: UIFont(name: font, size: size)!
//      ]
//      
//      self.navigationController?.navigationBar.standardAppearance = appearance
////      self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//    }
//  }
  
//  func settingNavigationbar(_ scroll: Bool) {
//    let appearance = UINavigationBarAppearance()
//    appearance.configureWithOpaqueBackground()
//    appearance.shadowColor = .black
//    appearance.backgroundColor = .black
//    
//    appearance.titleTextAttributes = [
//      NSAttributedString.Key.foregroundColor: UIColor.white,
//      NSAttributedString.Key.font: UIFont(name: "Pretendard-Bold", size: 18)!
//    ]
//    
//    let navigationBar = UINavigationBar.appearance()
//    navigationBar.standardAppearance = appearance
//    
//    if scroll {
//      navigationBar.scrollEdgeAppearance = appearance
//    }
//  }

}
