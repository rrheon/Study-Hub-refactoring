//
//  TapBar.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import UIKit

class TabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let homeViewController = HomeViewController()
    let homeVCwithNavi = UINavigationController(rootViewController: homeViewController) 

    let studyViewController = StudyViewController()
    let studyVCwithNavi = UINavigationController(rootViewController: studyViewController)

    let myPageViewController = MyPageViewController()
    let myPageVCwithNavi = UINavigationController(rootViewController: myPageViewController)


    self.viewControllers = [homeVCwithNavi, studyVCwithNavi, myPageVCwithNavi]
    
    homeViewController.tabBarItem = UITabBarItem(title: "홈",
                                                 image: UIImage(systemName: "house"), tag: 0)
    studyViewController.tabBarItem = UITabBarItem(title: "스터디",
                                                  image: UIImage(systemName: "book"), tag: 1)
    myPageViewController.tabBarItem = UITabBarItem(title: "마이페이지",
                                                   image: UIImage(systemName:"person"), tag: 2)
    
    self.tabBar.tintColor = .o50
    
    self.tabBar.layer.borderColor = UIColor.white.cgColor
    self.tabBar.layer.borderWidth = 0.5
    
    self.tabBar.backgroundColor = .white
  
  }
}

