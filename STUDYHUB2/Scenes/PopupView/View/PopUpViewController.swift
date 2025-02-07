import UIKit

import SnapKit
import RxRelay

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
  
  func buttonActions(){
    self.popupView.leftButtonAction = { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.rightButtonAction = { [weak self] in
      guard let self = self else { return }
      if let selectedAction = selectedAction {
        viewModel.dataSubject.accept(selectedAction)
      }
      
      self.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.endButtonAction = {
      self.dismiss(animated: true)
    }
  }
}
