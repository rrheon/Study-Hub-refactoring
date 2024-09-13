import Foundation

import RxSwift
import RxRelay

final class CreateStudyViewModel: CommonViewModel {
  var postedData = BehaviorRelay<PostDetailData?>(value: nil)
  
  lazy var chatLinkValue = BehaviorRelay<String?>(value: nil)
  lazy var studyTitleValue = BehaviorRelay<String?>(value: nil)
  lazy var studyIntroduceValue = BehaviorRelay<String?>(value: nil)
  
  var isMoveToSeletMajor = PublishRelay<Bool>()
  var selectedMajor = BehaviorRelay<String?>(value: nil)
  
  lazy var studyMemberValue = BehaviorRelay<Int?>(value: nil)
  
  var isAllGenderButton = BehaviorRelay<Bool>(value: false)
  var isMaleOnlyButton = BehaviorRelay<Bool>(value: false)
  var isFemaleOnlyButton = BehaviorRelay<Bool>(value: false)
  var seletedGenderValue = BehaviorRelay<String?>(value: nil)
  
  var isMixButton = BehaviorRelay<Bool>(value: false)
  var isContactButton = BehaviorRelay<Bool>(value: false)
  var isUntactButton = BehaviorRelay<Bool>(value: false)
  var seletedStudyWayValue = BehaviorRelay<String?>(value: nil)
  
  var isFineButton = BehaviorRelay<Bool>(value: false)
  var isNoFineButton = BehaviorRelay<Bool>(value: false)
  lazy var fineTypeValue = BehaviorRelay<String>(value: "")
  lazy var fineAmountValue = BehaviorRelay<Int>(value: 0)
  
  var isStartDateButton = BehaviorRelay<Bool>(value: false)
  var isEndDateButton = BehaviorRelay<Bool>(value: false)
  var startDate = BehaviorRelay<String>(value: "선택하기")
  var endDate = BehaviorRelay<String>(value: "선택하기")
  
  var seletedDate: String? = nil
  var selectedDay: Int = 0
  var currentPage: Date? = nil
  
  var isCompleteButtonActivate = BehaviorRelay<Bool>(value: false)
  var isSuccessCreateStudy = PublishRelay<String>()
  var isSuccessModifyStudy = PublishRelay<Bool>()
  
  init(_ data: BehaviorRelay<PostDetailData?>? = nil) {
    super.init()
    
    if let data = data {
      self.postedData = data
    }
    
    setupBindings()
  }

  
  func setupBindings() {
    let basicInfo = Observable.combineLatest(
      chatLinkValue.asObservable(),
      studyTitleValue.asObservable(),
      studyIntroduceValue.asObservable(),
      selectedMajor.asObservable(),
      studyMemberValue.asObservable(),
      seletedStudyWayValue.asObservable(),
      seletedGenderValue.asObservable()
    )
    
    let fineInfo = Observable.combineLatest(
      startDate.asObservable(),
      endDate.asObservable(),
      isFineButton.asObservable(),
      isNoFineButton.asObservable(),
      fineTypeValue.asObservable(),
      fineAmountValue.asObservable()
    )
    
    Observable.combineLatest(basicInfo, fineInfo)
      .subscribe(onNext: { [weak self] (basicInfo, fineInfo) in
        guard let self = self else { return }
        
        let (link, title, introduce, major, member, studyWay, gender) = basicInfo
        let (startDate, endDate, isFine, isNoFine, fineType, fineAmount) = fineInfo
        
        let isDataFilled = [
          link,
          title,
          introduce,
          major,
          studyWay,
          gender].allSatisfy {
            $0?.isEmpty == false
          }
        let isDatesSelected = startDate != "선택하기" && endDate != "선택하기"
        let isFineDataValid = isFine && !fineType.isEmpty && fineAmount > 0
        let isNoFineDataValid = isNoFine && fineType.isEmpty && fineAmount == 0
        
        if isDataFilled &&
            member != nil &&
            isDatesSelected &&
            (isFineDataValid || isNoFineDataValid) {
          self.isCompleteButtonActivate.accept(true)
        } else {
          self.isCompleteButtonActivate.accept(false)
        }
      })
      .disposed(by: disposeBag)
  }
  
  func createPostValue() -> CreateStudyRequest{
    let value = CreateStudyRequest(
      chatUrl: chatLinkValue.value ?? "",
      close: false,
      content: studyIntroduceValue.value ?? "",
      gender: seletedGenderValue.value ?? "",
      major: convertMajor(selectedMajor.value ?? "", toEnglish: true) ?? "",
      penalty: fineAmountValue.value,
      penaltyWay: fineTypeValue.value,
      studyEndDate: endDate.value,
      studyPerson: studyMemberValue.value ?? 0,
      studyStartDate: startDate.value,
      studyWay: seletedStudyWayValue.value ?? "",
      title: studyTitleValue.value ?? ""
    )
    return value
  }
  
  func updatePostValue() -> UpdateStudyRequest{
    let value = UpdateStudyRequest(
      chatUrl: chatLinkValue.value ?? "",
      close: false,
      content: studyIntroduceValue.value ?? "",
      gender: seletedGenderValue.value ?? "",
      major: convertMajor(selectedMajor.value ?? "", toEnglish: true) ?? "",
      penalty: fineAmountValue.value,
      penaltyWay: fineTypeValue.value,
      postId: postedData.value?.postID ?? 0,
      studyEndDate: endDate.value,
      studyPerson: studyMemberValue.value ?? 0,
      studyStartDate: startDate.value,
      studyWay: seletedStudyWayValue.value ?? "",
      title: studyTitleValue.value ?? ""
    )
    return value
  }

  func createOrModifyPost(){
    let mode = (postedData.value == nil) ? "POST" : "PUT"
    switch mode {
    case "POST":
      let value = createPostValue()
      return createPost(value) {
        self.isSuccessCreateStudy.accept($0)
      }
    case "PUT":
      let updateRequestValue = updatePostValue()
      return modifyMyPost(updateRequestValue) {
        self.isSuccessModifyStudy.accept($0)
        self.fetchSinglePostDatas(updateRequestValue.postId) { updatedPostValue in
          self.postedData.accept(updatedPostValue)
        }
      }
    default:
      return
    }
  }
  
  func changeDate(_ date: [Int]) -> String{
    let convertedDate = "\(date[0])-\(date[1])-\(date[2])"
    let changedDate = convertedDate.convertDateString(from: .format3, to: "yyyy-MM-dd")
    return changedDate
  }
}

extension CreateStudyViewModel: ManagementDate {}
extension CreateStudyViewModel: ConvertMajor {}
extension CreateStudyViewModel: CreatePost {}
extension CreateStudyViewModel: ModifyPost {}
extension CreateStudyViewModel: PostDataFetching {}
