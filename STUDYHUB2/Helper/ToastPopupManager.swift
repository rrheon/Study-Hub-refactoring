
import UIKit

import SnapKit

/// ToastPopup 매니져
final class ToastPopupManager {
  static let shared = ToastPopupManager()
  
  private init() {}
  
  /// Toast Popup 띄우기
  /// - Parameters:
  ///   - message: Toast Popup 메세지
  ///   - imageCheck: 이미지 사용 여부(기본값 true)
  ///   - alertCheck: 경고 이미지 설정 -> true = 성공 이미지, false = 경고 이미지 (기본값 true)
  ///   - large: 팝업 사이즈 -> true = 큰 팝업(74), false = 작은 팝업(56) (기본값 false)
  func showToast(
    message: String,
    imageCheck: Bool = true,
    alertCheck: Bool = true,
    large: Bool = false
  ) {
    guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
    
    let toastContainer = UIView()
    toastContainer.backgroundColor = .g100
    toastContainer.layer.cornerRadius = 10
    toastContainer.clipsToBounds = true
    
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
    
    keyWindow.addSubview(toastContainer)
    
    toastContainer.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(keyWindow.safeAreaLayoutGuide.snp.bottom).offset(-50)
      make.width.equalTo(335)
      make.height.equalTo(large ? 74 : 56)
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
      make.leading.equalTo(imageCheck ? imageView.snp.trailing : toastContainer).offset(imageCheck ? 8 : 30)
      make.trailing.equalTo(toastContainer).offset(-16)
    }
    
    UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastContainer.alpha = 0.0
    }, completion: { _ in
      toastContainer.removeFromSuperview()
    })
  }
}
