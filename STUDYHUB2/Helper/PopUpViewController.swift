import UIKit

import SnapKit

final class PopupViewController: UIViewController {
  let popupView: PopupView
  var check: Bool?
  let myPostInfoManager = MyPostInfoManager.shared
  
  init(title: String, desc: String, postID: Int = 0,
       bottomeSheet: BottomSheet? = nil,
       leftButtonTitle: String = "취소",
       rightButtonTilte: String = "삭제",
       checkEndButton: Bool = false) {
    self.popupView = PopupView(title: title,
                               desc: desc,
                               leftButtonTitle: leftButtonTitle,
                               rightButtonTitle: rightButtonTilte,
                               checkEndButton: checkEndButton)
    super.init(nibName: nil, bundle: nil)
      
    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)
    
    self.view.addSubview(self.popupView)
    self.setupConstraints()
    
    self.popupView.leftButtonAction = { [weak self] in
      guard let self = self else { return }
      
      self.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.rightButtonAction = { [weak self] in
      self?.myPostInfoManager.fetchDeletePostInfo(postID: postID) { result in
        guard let self = self else { return }
        switch result {
        case .success:
          DispatchQueue.main.async {
            self.dismiss(animated: false) {
              bottomeSheet?.dismiss(animated: false)
            }
          }
          
          DispatchQueue.main.async {
            self.showToast(message: "글이 삭제되었어요.", alertCheck: true)
          }
          
        case .failure(let error):
          // 삭제 실패 시의 처리
          print("게시글 삭제 실패: \(error)")
        }
      }
    }
    
    self.popupView.endButtonAction = {
      self.dismiss(animated: true)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
}
