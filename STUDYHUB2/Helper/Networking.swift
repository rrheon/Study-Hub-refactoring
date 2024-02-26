//
//  Networking.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2023/12/22.
//

import UIKit

import Moya

// MARK: - networkingAPI
enum networkingAPI {
  // 토큰관련
  case refreshAccessToken(_ refreshToken: String)
  
  // 유저 프로필 이미지 관련
  case storeImage(_ image: UIImage)
  case deleteImage
  
  // 유저정보 수정
  case createNewAccount(accountData: CreateAccount)
  case editUserNickName(_nickname: String)
  case editUserMaojr(_major: String)
  case editUserPassword(_checkPassword: Bool, email: String, _password: String)
  case verifyPassword(_password: String)
  case verifyEmail(_code: String, _email: String)
  case checkEmailDuplication(_email: String)
  case sendEmailCode(_email: String)
  case deleteID
  
  // 댓글 관련
  case getCommentList(_postId: Int, _page: Int, _size: Int)
  case writeComment(_content: String, _postId: Int)
  case deleteComment(_commentId: Int)
  case modifyComment(_commentId: Int, _content: String)
  case getPreviewCommentList(_postid: Int)
  
  // 게시글관련
  case getMyPostList(_page: Int, _size: Int)
  case createMyPost(_ data: CreateStudyRequest)
  case modifyMyPost(_data: UpdateStudyRequest)
  case deleteMyPost(_postId: Int)
  case searchSinglePost(_postId: Int)
  case searchPostList(_hot: String, text: String,
                      page: Int, size: Int,
                      titleAndMajor: String)
  case recommendSearch(_keyword: String)
  case closePost(_ postId: Int)
  
  // 스터디 참여 신청 관련
  case participateStudy(introduce: String, studyId: Int)
  case getMyParticipateList(page: Int, size: Int)
  case getMyReqeustList(page: Int, size: Int)
  case deleteMyRequest(studyId:Int)
  case searchParticipateInfo(inspection: String, page: Int, size: Int, studyId: Int)
  case acceptParticipate(acceptPersonData: AcceptStudy)
  case rejectParticipate(rejectPersonData: RejectStudy)
  case getRejectReason(_ studyId: Int)
  
  // 북마크 관련
  case changeBookMarkStatus(_ postId: Int)
  case searchSingleBookMark(_ postId: Int, _ userId: Int)
  case searchBookMarkList(page: Int, size: Int)
  case deleteAllBookMark
  
  // 문의하기
  case inquiryQuestion(content: String, title: String, toEmail: String)
  case getNotice(page: Int, size: Int)
}

extension networkingAPI: TargetType {
  // MARK: - baseURL
  var baseURL: URL {
    return URL(string: "https://study-hub.site:443/api")!
  }
  
  // MARK: - path
  var path: String {
    switch self {
      // 토큰관련
    case .refreshAccessToken(_refreshToken: _):
      return "/jwt/v1/accessToken"
      
      // 유저 프로필 이미지 관련
    case .storeImage(_image: _):
      return "/v1/users/image"
    case .deleteImage:
      return "/v1/users/image"
      
      // 유저정보 수정
    case .createNewAccount(accountData: _):
      return "/v1/users/signup"
    case .editUserNickName(_nickname: _):
      return "/v1/users/nickname"
    case .editUserMaojr(_major: _):
      return "/v1/users/major"
    case .editUserPassword(_checkPassword: _,email : _, _password: _):
      return "/v2/users/password"
    case .verifyPassword(_password: _):
      return "/v1/users/password/verify"
    case .verifyEmail(_code:_, _email: _):
      return "/v1/email/verify"
    case .checkEmailDuplication(_email: _):
      return "/v1/email/duplication"
    case .sendEmailCode(_email: _):
      return "/v1/email"
    case .deleteID:
      return "/v1/users"
      
      // 댓글관련
    case .writeComment(_content: _ , _postId: _):
      return "/v1/comments"
    case .getCommentList(let postId, _page: _, _size: _):
      return "/v1/comments/\(postId)"
    case .deleteComment(let commentId):
      return "/v1/comments/\(commentId)"
    case .modifyComment(let commentId, let content):
      return "/v1/comments"
    case .getPreviewCommentList(let postId):
      return "/v1/comments/\(postId)/preview"
      
      // 게시글 관련
    case .getMyPostList(_page: _, _size: _):
      return "/v1/study-posts/mypost"
    case .createMyPost(_):
      return "/v1/study-posts"
    case .deleteMyPost(let postId):
      return "/v1/study-posts/\(postId)"
    case .modifyMyPost(_data: _):
      return "/v1/study-posts"
    case .searchPostList(_hot: _, text: _, page: _, size: _, titleAndMajor: _):
      return "/v2/study-posts"
    case .searchSinglePost(let postId):
      return "/v2/study-posts/\(postId)"
    case .recommendSearch(_keyword: _):
      return "/v1/study-post/recommend"
    case .closePost(let postId):
      return "/v1/study-posts/\(postId)/close"
      
      // 스터디 신청관련
    case .participateStudy(introduce: _, studyId: _):
      return "/v1/study"
    case .getMyParticipateList(page: _, size: _):
      return "/v1/participated-study"
    case .searchParticipateInfo(inspection: _, page: _, size: _, studyId: _):
      return "/v2/study"
    case .acceptParticipate(acceptPersonData: _):
      return "/v1/study-accept"
    case .rejectParticipate(rejectPersonData: _):
      return "/v1/study-reject"
    case .getMyReqeustList(page: _, size: _):
      return "/v1/study-request"
    case .deleteMyRequest(let studyId):
      return "/v1/study/\(studyId)"
    case .getRejectReason(_):
      return "/v1/reject"
      
      // 북마크 관련
    case .changeBookMarkStatus(let postId):
      return "/v1/bookmark/\(postId)"
    case .searchSingleBookMark(let postId, _):
      return "/v1/bookmark/\(postId)"
    case .searchBookMarkList(page: _, size: _):
      return "/v1/study-posts/bookmarked"
    case .deleteAllBookMark:
      return "/v1/bookmark"
      
      
      // 문의하기
    case .inquiryQuestion(content: _, title: _, toEmail: _):
      return "/v1/email/question"
    case .getNotice(page: _, size: _):
      return "/v1/announce"
    }
  }
  
  // MARK: - method
  var method: Moya.Method {
    switch self {
    case .searchSinglePost(_postId: _),
        .getCommentList(_postId: _, _page: _, _size: _),
        .getMyPostList(_page: _, _size: _),
        .recommendSearch(_keyword: _),
        .searchPostList(_hot: _, text: _,
                        page: _, size: _, titleAndMajor: _),
        .getMyParticipateList(page: _, size: _),
        .searchParticipateInfo(inspection: _, page: _, size: _, studyId: _),
        .searchBookMarkList(page: _, size: _),
        .getMyReqeustList(page: _, size: _),
        .getRejectReason(_),
        .searchSingleBookMark(_, _),
        .getPreviewCommentList(_postid: _),
        .getNotice(page: _, size: _):
      return .get
      
    case .storeImage(_image: _),
        .editUserNickName(_nickname: _),
        .editUserMaojr(_major: _),
        .editUserPassword(_checkPassword: _, email: _, _password: _),
        .modifyComment(_commentId: _, _content: _),
        .modifyMyPost(_data: _),
        .closePost(_),
        .rejectParticipate(rejectPersonData: _),
        .acceptParticipate(acceptPersonData: _):
      return .put
      
    case .deleteImage,
        .deleteID,
        .deleteComment(_commentId: _),
        .deleteMyPost(_postId: _),
        .deleteMyRequest(studyId: _),
        .deleteAllBookMark:
      return .delete
      
    case .verifyPassword(_password: _),
        .verifyEmail(_code: _, _email: _),
        .checkEmailDuplication(_email: _),
        .sendEmailCode(_email: _),
        .writeComment(_content: _, _postId: _),
        .refreshAccessToken(_refreshToken: _),
        .createNewAccount(accountData: _),
        .participateStudy(introduce: _, studyId: _),
        .changeBookMarkStatus(_),
        .inquiryQuestion(content: _, title: _, toEmail: _),
        .createMyPost(_):
      return .post
    }
  }
  
  // MARK: - task
  var task: Moya.Task {
    switch self {
      // 파라미터로 요청
    case .storeImage(let image):
      let imageData = image.jpegData(compressionQuality: 0.5)
      let formData = MultipartFormBodyPart(provider: .data(imageData!), name: "image",
                                           fileName: "image.jpg", mimeType: "image/jpeg")
      return .uploadMultipartFormData([formData])
      
      // 바디에 요청
    case .editUserNickName(let nickname):
      let params = EditNickName(nickname: nickname)
      return .requestJSONEncodable(params)
    case .editUserMaojr(let major):
      let params = EditMajor(major: major)
      return .requestJSONEncodable(params)
    case .editUserPassword(let checkPassword, let email, let password):
      let params = EditPassword(auth: checkPassword, email: email, password: password)
      return .requestJSONEncodable(params)
    case .verifyPassword(let password):
      let params = VerifyPassword(password: password)
      return .requestJSONEncodable(params)
      
    case .verifyEmail(let code, let email):
      let params = VerifyEmail(authCode: code, email: email)
      return .requestJSONEncodable(params)
    case .checkEmailDuplication(let email):
      let params = CheckEmailDuplication(email: email)
      return .requestJSONEncodable(params)
    case .sendEmailCode(let email):
      let params = CheckEmailDuplication(email: email)
      return .requestJSONEncodable(params)
      
    case.writeComment(let content, let postId):
      let params = WriteComment(content: content, postId: postId)
      return .requestJSONEncodable(params)
      
    case .getCommentList(_postId: _, let page, let size):
      let params: [String : Any] = [ "page": page, "size": size]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .modifyComment(let commentId, let content):
      let parmas = ModifyComment(commentId: commentId, content: content)
      return .requestJSONEncodable(parmas)
      
    case .modifyMyPost(let data):
      return .requestJSONEncodable(data)
      
    case .getMyPostList(let page, let size):
      let params: [String : Any] = [ "page": page, "size": size]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .recommendSearch(let keyword):
      let params: [String : Any] = [ "keyword" : keyword]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .searchPostList(let hot, let text, let page, let size, let titleAndMajor):
      let parmas: [String: Any] = [
        "hot" : hot,
        "inquiryText": text,
        "page":page,
        "size": size,
        "titleAndMajor": titleAndMajor
      ]
      return .requestParameters(parameters: parmas, encoding: URLEncoding.queryString)
      
    case .refreshAccessToken(let refreshToken):
      let params = RefreshAccessToken(refreshToken: refreshToken)
      return .requestJSONEncodable(params)
      
    case .createNewAccount(let accountData):
      return .requestJSONEncodable(accountData)
      
    case .participateStudy(let introduce, let studyId):
      let params: [String: Any] = [
        "introduce": introduce,
        "studyId": studyId
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .getMyParticipateList(let page, let size):
      let parmas: [String: Any] = [
        "page": page,
        "size": size
      ]
      return .requestParameters(parameters: parmas, encoding: URLEncoding.queryString)
      
    case .searchParticipateInfo(let inspection, let page, let size, let studyId):
      let params: [String: Any] = [
        "inspection": inspection,
        "page": page,
        "size": size,
        "studyId": studyId
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .searchBookMarkList(let page, let size):
      let parmas: [String: Any] = [
        "page": page,
        "size": size
      ]
      return .requestParameters(parameters: parmas, encoding: URLEncoding.queryString)
      
    case .inquiryQuestion(let content, let title, let toEmail):
      let params = InquiryDTO(content: content, title: title, toEmail: toEmail)
      return .requestJSONEncodable(params)
      
    case .createMyPost(let data):
      return .requestJSONEncodable(data)
      
    case .acceptParticipate(let acceptData):
      return .requestJSONEncodable(acceptData)
      
    case .rejectParticipate(let rejectData):
      return .requestJSONEncodable(rejectData)
      
    case .getMyReqeustList(let page, let size):
      let params: [String: Any] = [
        "page": page,
        "size": size
      ]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .getRejectReason(let studyId):
      let params: [String: Any] = ["studyId": studyId]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .searchSingleBookMark(let userId):
      let params: [String: Any] = ["userId": userId]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .getNotice(let page, let size):
      let params: [String: Any] = ["page": page, "size": size]
      return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
      
    case .deleteID,
        .searchSinglePost(_postId: _),
        .deleteImage,
        .deleteComment(_commentId: _),
        .deleteMyPost(_postId: _),
        .closePost(_),
        .changeBookMarkStatus(_),
        .deleteMyRequest(studyId: _),
        .deleteAllBookMark,
        .getPreviewCommentList(_postid: _):
      return .requestPlain
      
    }
  }
  
  // MARK: - headers
  var headers: [String : String]? {
    //    LoginManager.shared.refreshAccessToken { result in
    //      switch result {
    //        case true:
    //          print("pass")
    //      case false:
    //          print("fail")
    //      }
    //
    //    }
    guard let accessToken = TokenManager.shared.loadAccessToken() else { return nil }
    switch self {
    case .checkEmailDuplication(_email: _),
        .sendEmailCode(_email: _),
        .getCommentList(_postId: _, _page: _, _size: _),
        .recommendSearch(_keyword: _),
        .refreshAccessToken(_refreshToken: _),
        .createNewAccount(accountData: _),
        .searchParticipateInfo(inspection: _ ,page: _, size: _, studyId: _),
        .inquiryQuestion(content: _, title: _, toEmail: _),
        .editUserPassword(_checkPassword: _, email: _, _password: _),
        .getPreviewCommentList(_postid: _),
        .getNotice(page: _, size: _):
      return ["Content-type": "application/json"]
      
    case .verifyEmail(_code: _, _email: _):
      return ["Accept" : "application/json"]
      
    case .writeComment(_content: _, _postId: _),
        .modifyComment(_commentId: _, _content: _),
        .getMyPostList(_page: _, _size: _),
        .modifyMyPost(_data: _),
        .closePost(_),
        .searchSinglePost(_postId: _),
        .participateStudy(introduce: _, studyId: _),
        .getMyParticipateList(page: _, size: _),
        .changeBookMarkStatus(_),
        .searchBookMarkList(page: _, size: _),
        .createMyPost(_),
        .rejectParticipate(rejectPersonData: _),
        .acceptParticipate(acceptPersonData: _),
        .getMyReqeustList(page: _, size: _),
        .getRejectReason(_),
        .searchSingleBookMark(_, _),
        .searchPostList(_hot: _, text: _, page: _,
                        size: _, titleAndMajor: _):
      return ["Content-type": "application/json",
              "Authorization": "\(accessToken)"]
      
    case .storeImage(_image: _):
      return [ "Content-Type" : "multipart/form-data",
               "Authorization": "\(accessToken)" ]
    case .deleteImage,
        .deleteID ,
        .verifyPassword(_),
        .deleteComment(_commentId: _),
        .deleteMyPost(_postId: _),
        .deleteMyRequest(studyId: _),
        .deleteAllBookMark,
        .editUserMaojr(_major: _):
      return [ "Authorization": "\(accessToken)"]
      
    default:
      return ["Content-type": "application/json",
              "Content-Type" : "multipart/form-data",
              "Accept": "application/json",
              "Authorization": "\(accessToken)"]
    }
  }
}

final class Networking {
  static let networkinhShared = Networking()
  
  let tokenManager = TokenManager.shared
  
  typealias NetworkCompletion<T: Codable> = (Result<T, NetworkError>) -> Void
  
  // 네트워킹 요청을 생성하는 메서드
  func createRequest<T: Codable>(url: URL,
                                 method: String,
                                 tokenNeed: Bool,
                                 createPostData: T?) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    if tokenNeed == true {
      guard let token = tokenManager.loadAccessToken() else { return request}
      request.setValue("\(token)", forHTTPHeaderField: "Authorization")
      
      if createPostData != nil {
        guard let uploadData = try? JSONEncoder().encode(createPostData) else { return request }
        request.httpBody = uploadData
      }
    }
    
    return request
  }
  
  // API 응답을 디코딩하는 메서드
  func decodeResponse<T: Codable>(data: Data, completion: NetworkCompletion<T>) {
    do {
      let decoder = JSONDecoder()
      let responseData = try decoder.decode(T.self, from: data)
      completion(.success(responseData))
    } catch {
      print("JSON Parsing Error:", error)
      completion(.failure(.parseError))
    }
  }
  
  // 네트워킹 요청하는 메서드
  func fetchData<T: Codable>(type: String,
                             apiVesrion: String,
                             urlPath: String,
                             queryItems: [URLQueryItem]?,
                             tokenNeed: Bool,
                             createPostData: T?,
                             completion: @escaping NetworkCompletion<T>) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "study-hub.site"
    urlComponents.port = 443
    urlComponents.path = "/api/" + apiVesrion + urlPath
    
    urlComponents.queryItems = queryItems
    
    guard let url = urlComponents.url else {
      print("Invalid URL")
      completion(.failure(.networkingError))
      return
    }
    
    let request = createRequest(url: url,
                                method: type,
                                tokenNeed: tokenNeed,
                                createPostData: createPostData)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        print("Networking Error:", error)
        completion(.failure(.networkingError))
        return
      }
      
      guard let safeData = data else {
        print("No Data")
        completion(.failure(.dataError))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        print("Invalid Response")
        completion(.failure(.networkingError))
        return
      }
      
      print("Response Status Code:", httpResponse.statusCode)
      
      self.decodeResponse(data: safeData, completion: completion)
    }.resume()
  }
}
