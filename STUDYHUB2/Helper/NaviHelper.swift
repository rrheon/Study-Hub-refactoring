//
//  NaviHelper.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/31.
//

import UIKit

class NaviHelper: UIViewController {
  // MARK: - navi 설정
  func navigationItemSetting() {
    let homeImg = UIImage(named: "LeftArrow")?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(image: homeImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(leftButtonTapped(_:)))
    
    let rightButtonImg = UIImage(named: "RightButtonImg")?.withRenderingMode(.alwaysOriginal)
    let rightButton = UIBarButtonItem(image: rightButtonImg,
                                      style: .plain,
                                      target: self,
                                      action: #selector(rightButtonTapped))
    
    
    self.navigationController?.navigationBar.barTintColor =  .black
    self.navigationController?.navigationBar.backgroundColor = .black
    self.navigationController?.navigationBar.isTranslucent = false
    
    self.navigationItem.leftBarButtonItem = leftButton
    self.navigationItem.rightBarButtonItem = rightButton
    
  }
  
  @objc func leftButtonTapped(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func rightButtonTapped() {
    if self.presentedViewController == nil {
      let viewControllerToPresent = BottomSheet(postID: 1,
                                                firstButtonTitle: "삭제하기",
                                                secondButtonTitle: "수정하기")
      if #available(iOS 15.0, *) {
        if let sheet = viewControllerToPresent.sheetPresentationController {
          if #available(iOS 16.0, *) {
            sheet.detents = [.custom(resolver: { context in
              return 228.0
            })]
          } else {
          }
          sheet.largestUndimmedDetentIdentifier = nil
          sheet.prefersScrollingExpandsWhenScrolledToEdge = false
          sheet.prefersEdgeAttachedInCompactHeight = true
          sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
          sheet.preferredCornerRadius = 20
        }
      } else {
        // Fallback on earlier versions
      }
      present(viewControllerToPresent, animated: true, completion: nil)
    }
  }
}
