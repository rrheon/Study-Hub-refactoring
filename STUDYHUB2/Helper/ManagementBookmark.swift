
import UIKit

protocol BookMarkDelegate: CommonNetworkingProtocol {
  func bookmarkTapped(postId: Int)
}

extension BookMarkDelegate {
  func bookmarkTapped(postId: Int){
    commonNetworking.moyaNetworking(
      networkingChoice: .changeBookMarkStatus(postId),
      needCheckToken: true
    ) {
      let statusCode = $0.map { $0.statusCode }
      // 코드 받아서 예외처리
      print(statusCode)
    }
  }
}

protocol MoveToBookmarkView: UIViewController {
  func moveToBookmarkView(_ sender: UIBarButtonItem, data: BookMarkDataProtocol)
}

extension MoveToBookmarkView {
  func moveToBookmarkView(_ sender: UIBarButtonItem, data: BookMarkDataProtocol) {
    let bookmarkViewController = BookmarkViewController(data)
    bookmarkViewController.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(bookmarkViewController, animated: true)
  }
}
