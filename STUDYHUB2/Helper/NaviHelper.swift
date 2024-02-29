//
//  NaviHelper.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/10/31.
//

import UIKit

class NaviHelper: UIViewController {
  let bookmarkManager = BookmarkManager.shared
  let loginManager = LoginManager.shared
  
  private let postID: Int?
  
  let majorSet = ["공연예술과", "IBE전공", "건설환경공학", "건축공학",
                  "경영학부", "경제학과", "국어교육과", "국어국문학과",
                  "기계공학과","데이터과학과","도시건축학","도시공학과",
                  "도시행정학과","독어독문학과","동북아통상전공","디자인학부",
                  "무역학부","문헌정보학과","물리학과","미디어커뮤니케이션학과",
                  "바이오-로봇 시스템 공학과","법학부", "불어불문학과","사회복지학과",
                  "산업경영공학과","생명공학부(나노바이오공학전공)","생명공학부(생명공학전공)",
                  "생명과학부(분자의생명전공)","생명과학부(생명과학전공)","서양화전공(조형예술학부)",
                  "세무회계학과","소비자학과","수학과","수학교육과", "스마트물류공학전공", "스포츠과학부",
                  "신소재공학과","안전공학과","에너지화학공학","역사교육과","영어교육과","영어영문학과",
                  "운동건강학부","유아교육과","윤리교육과","일본지역문화학과","일어교육과","임베디드시스템공과",
                  "전기공학과","전자공학과","정보통신학과","정치외교학과","중어중국학과","창의인개발학과",
                  "체육교육과","컴퓨터공학부","테크노경영학과","패션산업학과","한국화전공(조형예술학부)",
                  "해양학과","행정학과","화학과","환경공학"]
  
  var bookmarkList: [Int] = []

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
    
    bottomSheetVC.modifyPostButtonAction = { [weak self] in
      bottomSheetVC.dismiss(animated: true) {
        self?.modifyPost()
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
  
  func modifyPost(){
    print("수정하자")
  }
  
  // MARK: - 네비게이션 바 제목설정
  func settingNavigationTitle(title: String,
                              font: String = "Pretendard-Bold",
                              size: CGFloat = 18){
    self.navigationItem.title = title
    self.navigationController?.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: font, size: size)!
    ]
  }
  
  // MARK: - 북마크 리스트 가져오기
  func fetchBookmarkList(_ postId: Int,
                         _ userId: Int,
                         completion: @escaping () -> Void){
    bookmarkManager.searchSingleBookmark(postId: postId,
                                         userId: userId) { reulst in
      
    }
  }
  
  func bookmarkButtonTapped(_ postId: Int,
                            _ userId: Int,
                            completion: @escaping () -> Void){
    bookmarkManager.bookmarkTapped(postId) {
      completion()
    }
  }
  
  func checkLoginStatus(checkUser: Bool){
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
      rightButtonTilte: "로그인")
    
    popupVC.popupView.rightButtonAction = {
      self.dismiss(animated: true) {
        self.dismiss(animated: true)
      }
    }

    popupVC.modalPresentationStyle = .overFullScreen
    self.present(popupVC, animated: false)
  }
  
  func loginStatus(completion: @escaping (Bool) -> Void){
    loginManager.refreshAccessToken { result in
      completion(result)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool{
    textField.resignFirstResponder()
    return true
  }
}
