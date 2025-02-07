
import Foundation

import RxRelay

final class EditMajorViewModel: EditUserInfoViewModel {
 
  let enteredMajor = PublishRelay<String>()
  let matchedMajors = PublishRelay<[String]>()
  
  let isSuccessChangeMajor = PublishRelay<Bool>()
  
  override init(userData: BehaviorRelay<UserDetailData?>) {
    super.init(userData: userData)
  }
  
  func searchMajorFromPlist(_ major: String){
    loadMajors(major)
    enteredMajor.accept(major)
  }
  
  private func loadMajors(_ enteredMajor: String) {
    let majorDatas = DataLoaderFromPlist()
    if let majors = majorDatas.loadMajorsWithCodes() {
      let filteredMajors = majors.filter { (key, value) -> Bool in
        key.contains(enteredMajor)
      }
      matchedMajors.accept(filteredMajors.keys.map({ $0 }))
    }
  }
  
  func storeMajorToServer(_ major: String){
    guard let major = convertMajor(major, toEnglish: true) else { return }
//    
//    commonNetworking.moyaNetworking(
//      networkingChoice: .editUserMaojr(major),
//      needCheckToken: true) { result in
//        switch result {
//        case .success(let response):
//          print(response.response)
//          self.isSuccessChangeMajor.accept(true)
//          self.updateUserData(major: major)
//        case let .failure(error):
//          print(error.localizedDescription)
//          self.isSuccessChangeMajor.accept(false)
//        }
//      }
  }
  
  func getCurrentmajor() -> String{
    return self.convertMajor(userData.value?.major ?? "없음", toEnglish: false) ?? "없음"
  }
  
  func checkCurrentMajor(_ major: String) -> Bool{
    let beforeMajor = getCurrentmajor()
    
    return major == beforeMajor ? false : true
  }
}

extension EditMajorViewModel: ConvertMajor{}
