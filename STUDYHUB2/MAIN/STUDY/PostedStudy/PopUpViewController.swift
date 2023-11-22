import UIKit

import SnapKit

final class PopupViewController: UIViewController {
  private let popupView: PopupView
  var check: Bool?
  let myPostInfoManager = MyPostInfoManager.shared
  
  init(title: String, desc: String, postID: Int, bottomeSheet: BottomSheet?) {
    self.popupView = PopupView(title: title, desc: desc)
    super.init(nibName: nil, bundle: nil)
      
    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)
    
    self.view.addSubview(self.popupView)
    self.setupConstraints()
    
    self.popupView.leftButtonAction = { [weak self] in
      guard let self = self else { return }
      
      self.dismiss(animated: true, completion: nil)
    }
    
    // 삭제되었을 때 알람필요
    self.popupView.rightButtonAction = { [weak self] in
//      self?.myPostInfoManager.fetchDeletePostInfo(postID: postID) { result in
//        guard let self = self else { return }
//        switch result {
//          case .success:
//              // 성공적으로 삭제되었을 때의 처리
//              print("게시글이 성공적으로 삭제되었습니다.")
//          DispatchQueue.main.async {
//            self.dismiss(animated: true, completion: nil)
//          }
//          case .failure(let error):
//              // 삭제 실패 시의 처리
//              print("게시글 삭제 실패: \(error)")
//          }
//      }
      DispatchQueue.main.async {
        self?.dismiss(animated: false) {
          bottomeSheet?.dismiss(animated: false)
        }
      }
      
      DispatchQueue.main.async {
        self?.showToast(message: "삭제되었습니다.", alertCheck: true)
        print("1")
  
      }

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
