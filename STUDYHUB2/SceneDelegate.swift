//
//  SceneDelegate.swift
//  STUDYHUB2
//
//  Created by HYERYEONG on 2023/08/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  let tokenManager = TokenManager.shared
  let loginManager = LoginManager.shared
  let infoManager = UserInfoManager.shared
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    
//    loginManager.refreshAccessToken { result in
//      switch result {
//      case true:
//        let tabBarController = TabBarController()
//        self.window?.rootViewController = tabBarController
//      case false:
//        let loginViewController = LoginViewController()
//        self.window?.rootViewController = loginViewController
//      }
//    }
    
    let forgotPasswordVC = DepartmentViewController()
    let navigationController = UINavigationController(rootViewController: forgotPasswordVC)
   
    
    self.window?.rootViewController = navigationController
    
//    if accessToken == "a" {
//      // 로그인 성공한 경우 HomeViewController 표시
//      let tabBarController = TabBarController()
//      window?.rootViewController = tabBarController
//    } else {
//      // 로그인하지 않은 경우 LoginViewController 표시
//      if #available(iOS 16.0, *) {
//        let loginViewController = LoginViewController()
//        let navigationController = UINavigationController(rootViewController: loginViewController)
//        window?.rootViewController = navigationController
//
//      } else {
//        let loginViewController = PostedStudyViewController(postID: 0)
//        let navigationController = UINavigationController(rootViewController: loginViewController)
//        window?.rootViewController = navigationController
//      }
//
//    }
    window?.makeKeyAndVisible()

  }
  
  
  
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}

