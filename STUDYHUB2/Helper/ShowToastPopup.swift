////
////  ShowToastPopup.swift
////  STUDYHUB2
////
////  Created by 최용헌 on 8/21/24.
////
//
//import UIKit
//
//protocol ShowToastPopup {
//  func showToastPopup(message: String, imageCheck: Bool, alertCheck: Bool, large: Bool)
//}
//
//extension ShowToastPopup {
//  func showToastPopup(message: String,
//                 imageCheck: Bool = true,
//                 alertCheck: Bool = true,
//                 large: Bool = false) {
//    let toastContainer = UIView()
//    toastContainer.backgroundColor = .g100
//    toastContainer.layer.cornerRadius = 10
//    
//    let toastLabel = UILabel()
//    toastLabel.textColor = .g10
//    toastLabel.font = UIFont(name: "Pretendard", size: 14)
//    toastLabel.text = message
//    toastLabel.numberOfLines = 0
//    
//    let alertImage = alertCheck ? "SuccessImage" : "WarningImg"
//    let imageView = UIImageView(image: UIImage(named: alertImage))
//    
//    if imageCheck {
//      toastContainer.addSubview(imageView)
//    }
//    toastContainer.addSubview(toastLabel)
//
//    guard let keyWindow = UIApplication.shared.keyWindow else { return }
//    
//    keyWindow.addSubview(toastContainer)
//    
//    toastContainer.snp.makeConstraints { make in
//      make.centerX.equalToSuperview()
//      make.bottom.equalTo(keyWindow.safeAreaLayoutGuide.snp.bottom).offset(-50)
//      make.width.equalTo(335)
//      
//      let size = large ? 74 : 56
//      make.height.equalTo(size)
//    }
//    
//    if imageCheck {
//      imageView.snp.makeConstraints { make in
//        make.centerY.equalTo(toastContainer)
//        make.leading.equalTo(toastContainer).offset(15)
//      }
//    }
//    
//    toastLabel.snp.makeConstraints { make in
//      make.centerY.equalTo(toastContainer)
//      if imageCheck {
//        make.leading.equalTo(imageView.snp.trailing).offset(8)
//      } else {
//        make.leading.equalTo(toastContainer).offset(30)
//      }
//      make.trailing.equalTo(toastContainer).offset(-16)
//    }
//    
//    UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
//      toastContainer.alpha = 0.0
//    }, completion: { _ in
//      toastContainer.removeFromSuperview()
//    })
//  }
//
//}
