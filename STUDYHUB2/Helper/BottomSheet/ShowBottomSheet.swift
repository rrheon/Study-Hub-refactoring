//
//  ShowBottomSheet.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/18/24.
//

import UIKit

protocol ShowBottomSheet {
  func showBottomSheet(bottomSheetVC: UIViewController, size: Double)
}

extension ShowBottomSheet {
  func showBottomSheet(bottomSheetVC: UIViewController, size: Double){
    if #available(iOS 15.0, *) {
      if let sheet = bottomSheetVC.sheetPresentationController {
        if #available(iOS 16.0, *) {
          sheet.detents = [.custom(resolver: { context in
            return size
          })]
        } else {
          // Fallback on earlier versions
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
  }
}
