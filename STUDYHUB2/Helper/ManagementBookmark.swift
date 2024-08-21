
import UIKit

protocol BookMarkDelegate: CommonNetworkingProtocol {
  func bookmarkTapped(postId: Int)
}

extension BookMarkDelegate {
  func bookmarkTapped(postId: Int){
    commonNetworking.moyaNetworking(
      networkingChoice: .changeBookMarkStatus(postId), needCheckToken: true
    ) {
      let statusCode = $0.map { $0.statusCode }
      // 코드 받아서 예외처리
      print(statusCode)
    }
  }
}

protocol MoveToBookmarkView: UIViewController {
  func moveToBookmarkView(_ sender: UIBarButtonItem)
}

extension MoveToBookmarkView {
  func moveToBookmarkView(_ sender: UIBarButtonItem) {
    let bookmarkViewController = BookmarkViewController()
    bookmarkViewController.navigationItem.title = "북마크"
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    bookmarkViewController.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(bookmarkViewController, animated: true)
  }
}
