//
//  UIViewcontrollerExtention.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/12.
//

import UIKit

import SnapKit

extension UIViewController: UITextFieldDelegate, UITextViewDelegate {

  public func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 1.0
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.clear.cgColor
    textField.layer.borderWidth = 0.0
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
    textView.layer.borderColor = UIColor.black.cgColor
    textView.layer.borderWidth = 1.0
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "스터디에 대해 알려주세요\n (운영 방법, 대면 여부,벌금,공부 인증 방법 등)"
      textView.textColor = UIColor.lightGray
    }
    textView.layer.borderColor = UIColor.lightGray.cgColor
    textView.layer.borderWidth = 1.0 
  }
  
  // MARK: - toast message, 이미지가 뒤에 나오고 있음 앞으로 빼기, 이미지 없을 때도 있음
  
  
  /// Toast Popup 띄우기
  /// - Parameters:
  ///   - message: Toast Popup 메세지
  ///   - imageCheck: 이미지 사용 여부(기본값 true)
  ///   - alertCheck:경고 이미지 설정 ->  true = 성공 이미지 false = 경고 이미지(기본값 true)
  ///   - large:팝업 사이즈 -> true = 큰 팝업(74) false = 작은 팝업(56) (기본값 false)
  func showToast(
    message: String,
    imageCheck: Bool = true,
    alertCheck: Bool = true,
    large: Bool = false
  ) {
    let toastContainer = UIView()
    toastContainer.backgroundColor = .g100
    toastContainer.layer.cornerRadius = 10
    
    let toastLabel = UILabel()
    toastLabel.textColor = .g10
    toastLabel.font = UIFont(name: "Pretendard", size: 14)
    toastLabel.text = message
    toastLabel.numberOfLines = 0
    
    let alertImage = alertCheck ? "SuccessImage" : "WarningImg"
    let imageView = UIImageView(image: UIImage(named: alertImage))
    
    if imageCheck {
      toastContainer.addSubview(imageView)
    }
    toastContainer.addSubview(toastLabel)
  
    guard let keyWindow = UIApplication.shared.keyWindow else { return }
    
    keyWindow.addSubview(toastContainer)
    
    toastContainer.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(keyWindow.safeAreaLayoutGuide.snp.bottom).offset(-50)
      make.width.equalTo(335)
      
      let size = large ? 74 : 56
      make.height.equalTo(size)
    }
    
    // 이미지 여부에 따라 UI 설정
    if imageCheck {
      imageView.snp.makeConstraints { make in
        make.centerY.equalTo(toastContainer)
        make.leading.equalTo(toastContainer).offset(15)
      }
    }
    
    // 라벨 UI 설정
    toastLabel.snp.makeConstraints { make in
      make.centerY.equalTo(toastContainer)
      if imageCheck {
        make.leading.equalTo(imageView.snp.trailing).offset(8)
      } else {
        make.leading.equalTo(toastContainer).offset(30)
      }
      make.trailing.equalTo(toastContainer).offset(-16)
    }
    
    UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastContainer.alpha = 0.0
    }, completion: { _ in
      toastContainer.removeFromSuperview()
    })
  }
  
  func moveToOtherVC(vc: UIViewController, naviCheck: Bool){
    let destinationVC = vc
    let navigationVC = UINavigationController(rootViewController: destinationVC)
    
    if naviCheck {
      navigationVC.navigationBar.barTintColor = .black
      navigationVC.navigationBar.isTranslucent = false
      navigationVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    let movedVC = naviCheck ? navigationVC : destinationVC
    movedVC.modalPresentationStyle = .fullScreen
    self.present(movedVC, animated: true, completion: nil)
  }

  
  func moveToOtherVCWithSameNavi(vc: UIViewController, hideTabbar: Bool){
    vc.hidesBottomBarWhenPushed = hideTabbar
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
//  func moveToTabbar(_ loginStatus: Bool) {
//    let tapbarcontroller = TabBarController(loginStatus)
//    tapbarcontroller.modalPresentationStyle = .fullScreen
//    
//    self.present(tapbarcontroller, animated: true, completion: nil)
//  }
}
