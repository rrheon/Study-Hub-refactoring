//
//  CommonModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/12/24.
//

import UIKit

protocol CommonNetworkingProtocol: AnyObject {
  var commonNetworking: CommonNetworking { get }
}

extension CommonNetworkingProtocol {
  var commonNetworking: CommonNetworking {
    return CommonNetworking.shared
  }
}

protocol CheckLoginDelegate: AnyObject {
  func checkLoginPopup(checkUser: Bool)
}

extension CheckLoginDelegate where Self: UIViewController {
  func checkLoginPopup(checkUser: Bool){
    var title, desc, leftButtonTitle: String
    if checkUser {
      title = "재로그인이 필요해요"
      desc = "보안을 위해 자동 로그아웃됐어요.\n다시 로그인해주세요."
      leftButtonTitle = "나중에"
    } else {
      title = "로그인이 필요해요"
      desc = "계속하시려면 로그인을 해주세요!"
      leftButtonTitle = "취소"
    }
    
    let popupVC = PopupViewController(
      title: title,
      desc: desc,
      leftButtonTitle: leftButtonTitle,
      rightButtonTilte: "로그인"
    )
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true) {
        self.dismiss(animated: true)
      }
    }

    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
}
