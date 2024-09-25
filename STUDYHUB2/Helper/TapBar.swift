//
//  TapBar.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import UIKit

class TabBarController: UITabBarController {
  var checkLoginStatus: Bool
  
  init(_ loginStatus: Bool) {
    checkLoginStatus = loginStatus
    
    super.init(nibName: nil, bundle: .none)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
     
    let homeVC = addViewController(vc: HomeViewController(checkLoginStatus))
    let studyVC = addViewController(vc: StudyViewController(checkLoginStatus))
    let mypageVC = addViewController(vc: MyPageViewController(checkLoginStatus))

    self.viewControllers = [homeVC, studyVC, mypageVC]
    
    homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
    studyVC.tabBarItem = UITabBarItem(title: "스터디", image: UIImage(systemName: "book"), tag: 1)
    mypageVC.tabBarItem = UITabBarItem(title: "마이페이지",image: UIImage(systemName:"person"), tag: 2)
    
    self.tabBar.tintColor = .o50
    self.tabBar.layer.borderColor = UIColor.white.cgColor
    self.tabBar.layer.borderWidth = 0.5
    self.tabBar.backgroundColor = .white
  }
  
  func addViewController(vc: UIViewController) -> UINavigationController {
    return UINavigationController(rootViewController: vc)
  }
}

extension TabBarController: UITabBarControllerDelegate {
  func tabBarController(
    _ tabBarController: UITabBarController,
    didSelect viewController: UIViewController
  ) {
    if let selectedViewController = viewController as? UINavigationController {
      if let homeViewController = selectedViewController.viewControllers.first as? HomeViewController {
        homeViewController.homeTapBarTapped()
      } else if let studyViewController = selectedViewController.viewControllers.first as? StudyViewController {
        studyViewController.studyTapBarTapped()
      }
    }
  }
}
