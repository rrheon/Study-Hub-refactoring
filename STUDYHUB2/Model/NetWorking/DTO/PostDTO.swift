
import Foundation

// MARK: - 추천 검색어

struct RecommendList: Codable {
  let recommendList: [String]
}

// MARK: - 포스트 전체조회

struct PostDataContent: Codable {
  var postDataByInquiries: PostDataByInquiries
  let totalCount: Int
}

struct PostDataByInquiries: Codable {
  var content: [PostData]
  let pageable: Pageable
  let size, number, numberOfElements: Int
  let sort: Sort
  let first, empty: Bool
  var last: Bool
}

// 포스트 전체조회 content

struct PostData: Codable {
  let postId, studyPerson, penalty, remainingSeat: Int
  let major, title: String
  let filteredGender, penaltyWay: String?
  let studyStartDate, studyEndDate, createdDate: [Int]?
  let close, bookmarked: Bool
  let userData: UserData
  
  enum CodingKeys: String, CodingKey {
    case postId, major, title, studyStartDate, studyEndDate, createdDate,
         studyPerson, filteredGender, penalty, penaltyWay, remainingSeat,
         close, userData, bookmarked
  }
}


// MARK: - 게시글 단건조회

struct PostDetailData: Codable {
  let postId: Int
  let title: String
  let createdDate: [Int]
  let content, major: String
  let studyPerson: Int
  let filteredGender, studyWay: String?
  let penalty: Int
  let penaltyWay: String?
  let studyStartDate, studyEndDate: [Int]
  let remainingSeat: Int
  let chatUrl: String
  let studyId: Int
  let postedUser: PostedUser
  let relatedPost: [RelatedPost]
  var close, apply, usersPost, bookmarked: Bool
  
  enum CodingKeys: String, CodingKey {
    case postId, title, createdDate, content, major, studyPerson, filteredGender,
         studyWay, penalty, penaltyWay, studyStartDate, studyEndDate, remainingSeat
    case chatUrl, studyId, postedUser, relatedPost, close, apply, usersPost, bookmarked
  }
}

// 🔹 작성자 정보 구조체
struct PostedUser: Codable {
  let userId: Int
  let major: String
  let nickname: String
  let imageUrl: String
}

// 🔹 관련 게시글 구조체
struct RelatedPost: Codable {
  let postId: Int
  let title: String
  let major: String
  let remainingSeat: Int
  let relatedUser: RelatedUser
  
  enum CodingKeys: String, CodingKey {
    case postId, title, major, remainingSeat
    case relatedUser = "userData"  // ✅ JSON에서는 "userData"로 전달됨
  }
}

// 🔹 관련 게시글 작성자 정보
struct RelatedUser: Codable {
  let userId: Int
  let major: String
  let nickname: String
  let imageUrl: String
}



// MARK: - 게시글 생성 시

struct CreateStudyRequest: Codable {
    var chatUrl: String = ""
    var close: Bool = false
    var content: String = ""
    var gender: String = ""
    var major: String = ""
    var penalty: Int = 0
    var penaltyWay: String? = nil
    var studyEndDate: String = ""
    var studyPerson: Int = 0
    var studyStartDate: String = ""
    var studyWay: String = ""
    var title: String = ""
}




// MARK: - 게시글 수정 시

struct UpdateStudyRequest: Codable {
 var chatUrl: String = ""
  var close: Bool = false
  var content: String = ""
  var gender: String = ""
  var major: String = ""
  var penalty: Int = 0
  var penaltyWay: String? = nil
  var postId: Int = 0
  var studyEndDate: String = ""
  var studyPerson: Int = 0
  var studyStartDate: String = ""
  var studyWay: String = ""
  var title: String = ""
  
  // CreateStudyRequest에서 변환하는 이니셜라이저 추가
  init(from createStudy: CreateStudyRequest, postId: Int) {
      self.chatUrl = createStudy.chatUrl
      self.close = createStudy.close
      self.content = createStudy.content
      self.gender = createStudy.gender
      self.major = createStudy.major
      self.penalty = createStudy.penalty
      self.penaltyWay = createStudy.penaltyWay
      self.studyEndDate = createStudy.studyEndDate
      self.studyPerson = createStudy.studyPerson
      self.studyStartDate = createStudy.studyStartDate
      self.studyWay = createStudy.studyWay
      self.title = createStudy.title
      self.postId = postId
  }
}


// MARK: - 내가 쓴 게시글

struct MyPostData: Codable {
  let posts: Posts
  let totalCount: Int
}

// MARK: - Posts

struct Posts: Codable {
  let myPostcontent: [MyPostcontent]
  let empty, first, last: Bool
  let number, numberOfElements: Int
  let pageable: Pageable
  let size: Int
  let sort: Sort
  
  enum CodingKeys: String, CodingKey {
    case myPostcontent = "content"
    case empty, first, last, number, numberOfElements, pageable, size, sort
  }
}

// MARK: - MyPostcontent

struct MyPostcontent: Codable {
  var close: Bool
  let content, major: String
  let postID, remainingSeat, studyId: Int
  let title: String
  
  enum CodingKeys: String, CodingKey {
    case close, content, major
    case postID = "postId"
    case remainingSeat, title, studyId
  }
}

// MARK: - Pageable

struct Pageable: Codable {
  let sort: Sort
  let pageNumber, pageSize, offset: Int
  let unpaged, paged: Bool
}

// MARK: - Sort

struct Sort: Codable {
  let empty, sorted, unsorted: Bool
}

struct PostResponse: Codable {
  let response: String
}

//
//extension CreateStudyRequest: Equatable {}
//
//extension PostDetailData {
//  func toCreateStudyRequest() -> CreateStudyRequest {
//    return CreateStudyRequest(
//      chatUrl: self.chatURL,
//      close: self.close,
//      content: self.content,
//      gender: self.filteredGender,
//      major: self.major,
//      penalty: self.penalty,
//      penaltyWay: self.penaltyWay,
//      studyEndDate: formatDate(self.studyEndDate),
//      studyPerson: self.studyPerson,
//      studyStartDate: formatDate(self.studyStartDate),
//      studyWay: self.studyWay,
//      title: self.title
//    )
//  }
//  
//  private func formatDate(_ date: [Int]) -> String {
//    return String(format: "%04d-%02d-%02d", date[0], date[1], date[2])
//  }
//}
