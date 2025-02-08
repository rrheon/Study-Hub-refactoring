import UIKit

protocol Logout {
  func logout()
}

extension Logout {
  func logout() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else { return }
////
////    let loginVC = LoginViewController()
////    loginVC.modalPresentationStyle = .overFullScreen
//
//    window.rootViewController = loginVC
//    window.makeKeyAndVisible() 
  }
}
