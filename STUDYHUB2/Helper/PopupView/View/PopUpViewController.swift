import UIKit
import RxRelay

import SnapKit

enum PopupActionType {
  case editPost
  case deletePost
  case editComment
  case deleteComment
}

// 글을 삭제할까요? , 글을 수정할까요? , 댓글을 삭제할까요?, 댓글 수정-> 다른걸 받아야할듯
final class PopupViewController: UIViewController {
  let popupView: PopupView
  let viewModel: PopupViewModel
  
  let selectedAction: PopupActionType?
  
  init(title: String,
       desc: String = "",
       leftButtonTitle: String = "취소",
       rightButtonTilte: String = "삭제",
       checkEndButton: Bool = false,
       dataStream: PublishRelay<PopupActionType>? = nil,
       selectAction: PopupActionType? = nil
  ){
    self.selectedAction = selectAction
    
    self.viewModel = PopupViewModel(
      isActivateEndButton: checkEndButton,
      dataStrem: dataStream ?? PublishRelay<PopupActionType>()
    )
    
    self.popupView = PopupView(
      title: title,
      desc: desc,
      leftButtonTitle: leftButtonTitle,
      rightButtonTitle: rightButtonTilte,
      checkEndButton: checkEndButton
    )
    super.init(nibName: nil, bundle: nil)
    
    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)
    
    self.setupConstraints()
    buttonActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.view.addSubview(self.popupView)
    
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  func handlePopupAction(_ action: PopupActionType) -> PopupActionType {
    switch action {
    case .editPost:
      return .editPost
    case .deletePost:
      return .deletePost
    case .editComment:
      return .editComment
    case .deleteComment:
      return .deleteComment
    }
  }
  
  func buttonActions(){
    self.popupView.leftButtonAction = { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.rightButtonAction = { [weak self] in
      guard let self = self,
            let selectedAction = selectedAction else { return }
      viewModel.dataSubject.accept(selectedAction)
      self.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.endButtonAction = {
      self.dismiss(animated: true)
    }
  }
}
