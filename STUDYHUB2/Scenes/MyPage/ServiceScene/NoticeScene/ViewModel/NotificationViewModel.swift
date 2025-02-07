
import Foundation

import Moya
import RxRelay

final class NotificationViewModel {
  
  var noticeDatas = BehaviorRelay<[ExpandedNoticeContent]>(value: [])
  
  init() {
    getNoticeData(page: 0, size: 5)
  }
  
  func getNoticeData(page: Int, size: Int){
//    commonNetworking.moyaNetworking(
//      networkingChoice: .getNotice(page: page, size: size)
//    ) { result in
//      switch result {
//      case .success(let response):
//        do {
//          let noticeData = try JSONDecoder().decode(NoticeData.self, from: response.data)
//          let filteredDatas = noticeData.content.map { ExpandedNoticeContent(noticeContent: $0) }
//          self.noticeDatas.accept(filteredDatas)
//        } catch {
//          print("Failed to decode JSON: \(error)")
//        }
//      case .failure(let response):
//        print(response.response)
//      }
//    }
  }
  
  func noticeCellTapped(_ title: String){
    var updatedNotices = noticeDatas.value
    
    if let index = updatedNotices.firstIndex(where: { $0.noticeContent.title == title }) {
      updatedNotices[index].isExpanded.toggle()
    }
    self.noticeDatas.accept(updatedNotices)
  }
  
  func calculateContentHeight(content: String, width: CGFloat = 300) -> CGFloat {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 17.0)
    label.text = "    \(content)"
    let size = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    return size.height
  }
  
  func test(){
    let testDatas = [
      NoticeContent(noticeID: 1, title: "test1", content: "오늘", createdDate: [2024,01,02]),
      NoticeContent(noticeID: 2, title: "test2", content: "test2", createdDate: [2024,01,02]),
      NoticeContent(noticeID: 3, title: "test3", content: "test3", createdDate: [2024,01,03])
    ]
    
    let test = testDatas.map { ExpandedNoticeContent(noticeContent: $0)}
    
    self.noticeDatas.accept(test)
  }
}
