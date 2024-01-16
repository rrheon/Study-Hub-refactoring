//
//  NaviHelper.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/31.
//

import UIKit

class NaviHelper: UIViewController {
  private let postID: Int?
  
  init(postID: Int? = nil) {
    self.postID = postID
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    let bottomSheetVC = BottomSheet(postID: postID ?? 0,
                                    checkMyPost: true,
                                    firstButtonTitle: "삭제하기",
                                    secondButtonTitle: "수정하기")
    // 네비게이션바에서 바텀시트 열고 첫번째 버튼 누르면 postid전달이 안된다
    bottomSheetVC.deletePostButtonAction = { [weak self] in
      bottomSheetVC.dismiss(animated: true) {
        self?.deletePost()
      }
    }
    
    if #available(iOS 15.0, *) {
      if let sheet = bottomSheetVC.sheetPresentationController {
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
    present(bottomSheetVC, animated: true, completion: nil)
  }
  
  func deletePost(){
    print("삭제하자")
  }
  
}
