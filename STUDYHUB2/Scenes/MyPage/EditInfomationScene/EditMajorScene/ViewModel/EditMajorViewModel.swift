
import Foundation

import RxSwift
import RxFlow
import RxRelay


/// 학과입력 ViewModel
final class EditMajorViewModel: EditUserInfoViewModel, Stepper {
  var steps: PublishRelay<Step> = PublishRelay<Step>()
  
  
  var disposeBag: DisposeBag = DisposeBag()
  
  /// 입력된 학과
  let enteredMajor = PublishRelay<String>()
  
  /// 입력된 학과와 관련있는 학과들
  let matchedMajors = PublishRelay<[String]>()
    
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
  }
  
  
  /// 학과 검색하기
  /// - Parameter major: 검색할 학과
  func searchMajorFromPlist(_ major: String){
    loadMajors(major)
    enteredMajor.accept(major)
  }
  
  
  /// plist에서 일치하는 학과 불러오기
  /// - Parameter enteredMajor: 입력된 학과
  private func loadMajors(_ enteredMajor: String) {
    if let majors = DataLoaderFromPlist.loadMajorsWithCodes() {
      let filteredMajors = majors.filter { (key, value) -> Bool in
        key.contains(enteredMajor)
      }
      matchedMajors.accept(filteredMajors.keys.map({ $0 }))
    }
  }
  
  
  /// 변경된 학과 저장하기
  /// - Parameter major: 저장할 학과
  func storeMajorToServer(_ major: String){
    UserProfileManager.shared.changeMajorWithRx(major: major)
      .subscribe(onNext: { isChanged in
        if isChanged {
          ToastPopupManager.shared.showToast(message: "학과가 변경됐어요.")
          self.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
          
          self.updateUserData(major: major)
        } else {
          ToastPopupManager.shared.showToast(message: "학과 변경에 실패했어요.\n다시 시도해주세요!")
        }
      }, onError: { _ in
        self.steps.accept(AppStep.navigation(.popupScreenIsRequired(popupCase: .checkError)))
      })
      .disposed(by: disposeBag)
//    
//    UserProfileManager.shared.changeMajor(major: major) { result in
//      if result {
//        ToastPopupManager.shared.showToast(message: "학과가 변경됐어요.")
//        self.steps.accept(AppStep.navigation(.popCurrentScreen(animate: true)))
//        
//        self.updateUserData(major: major)
//      }else {
//        ToastPopupManager.shared.showToast(message: "학과 변경에 실패했어요.\n다시 시도해주세요!")
//      }
//    }
  }
  
  
  /// 현재 학과 가져오기
  /// - Returns: 현재 학과
  func getCurrentmajor() -> String{
    return Utils.convertMajor(userData.value?.major ?? "없음", toEnglish: false) ?? "없음"
  }
  
  
  /// 이전 학과와 동일여부 체크
  /// - Parameter major: 이전에 선택했던 학과
  /// - Returns: 동일 여부
  func checkCurrentMajor(_ major: String) -> Bool{
    let beforeMajor = getCurrentmajor()
    
    return major == beforeMajor ? false : true
  }
}

