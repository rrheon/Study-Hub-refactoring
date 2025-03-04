
import Foundation

import Moya
import RxRelay
import RxFlow

final class NotificationViewModel: Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  
  var noticeDatas = BehaviorRelay<[ExpandedNoticeContent]>(value: [])
  
  init() {
    self.getNoticeData(page: 0, size: 5)
  }
  
  func getNoticeData(page: Int, size: Int){
    ToStudyHubManager.shared.fetchNotice { noticeData in
      let filteredDatas = noticeData.content.map { ExpandedNoticeContent(noticeContent: $0) }
      self.noticeDatas.accept(filteredDatas)
    }
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
