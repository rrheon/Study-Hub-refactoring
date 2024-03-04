
//
//  AppDelegate.swift
//  STUDYHUB2
//
//  Created by HYERYEONG on 2023/08/05.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      window = UIWindow()
      window?.rootViewController = LoginViewController()
      window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
    }


}
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Check if a Refresh Token is saved in UserDefaults
//        if let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken") {
//            // Create a dictionary for the refresh token request
//            let refreshTokenData: [String: String] = [
//                "refreshToken": refreshToken
//            ]
//
//            // Convert refreshTokenData to JSON data
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: refreshTokenData, options: [])
//
//                // Create a URLRequest for the token refresh
//                if let refreshTokenURL = URL(string: "https://study-hub.site:443/api/jwt/accessToken") {
//                    var request = URLRequest(url: refreshTokenURL)
//                    request.httpMethod = "POST"
//                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                    request.httpBody = jsonData
//
//                    // Create a URLSessionDataTask to perform the token refresh request
//                    let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//                        if let data = data,
//                           let response = response as? HTTPURLResponse,
//                           response.statusCode == 200 {
//                            // Token refresh successful
//                            do {
//                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                                   let accessToken = json["access_token"] as? String {
//                                    // Update the saved Access Token
//                                    UserDefaults.standard.set(accessToken, forKey: "AccessToken")
//
//                                    // Switch to the HomeViewController
//                                    DispatchQueue.main.async {
//                                        let homeViewController = HomeViewController()
//                                        let navigationController = UINavigationController(rootViewController: homeViewController)
//                                        navigationController.modalPresentationStyle = .fullScreen
//                                        self?.window?.rootViewController = navigationController
//                                    }
//                                }
//                            } catch {
//                                // Handle JSON parsing error
//                                print("JSON Parsing Error: \(error)")
//                            }
//                        } else {
//                            // Token refresh failed, switch to the ViewController
//                            DispatchQueue.main.async {
//                                let viewController = ViewController()
//                                self?.window?.rootViewController = viewController
//                            }
//                        }
//                    }
//
//                    // Start the URLSessionDataTask for token refresh
//                    task.resume()
//                }
//            } catch {
//                // Handle JSON serialization error
//                print("JSON Serialization Error: \(error)")
//            }
//        } else {
//            // No Refresh Token found, switch to the ViewController
//            let viewController = ViewController()
//            window?.rootViewController = viewController
//        }
//
//        // Make sure the window is visible
//        window?.makeKeyAndVisible()
//
//        return true
//    }
//
//    // This method is called when the app is about to terminate
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Save the Refresh Token and Access Token to UserDefaults
//        let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken")
//        let accessToken = UserDefaults.standard.string(forKey: "AccessToken")
//
//        if let refreshToken = refreshToken, let accessToken = accessToken {
//            UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
//            UserDefaults.standard.set(accessToken, forKey: "AccessToken")
//        }
//    }
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//
//    }
//    // ...
//}

