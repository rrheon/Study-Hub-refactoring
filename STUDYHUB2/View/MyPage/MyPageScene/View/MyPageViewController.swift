
import UIKit

import SnapKit
import Kingfisher
// 전처리
#if DEBUG

import SwiftUI
@available(iOS 13.0, *)

// UIViewControllerRepresentable을 채택
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    // update
    // _ uiViewController: UIViewController로 지정
    func updateUIViewController(_ uiViewController: UIViewController , context: Context) {
        
    }
    // makeui
    func makeUIViewController(context: Context) -> UIViewController {
    // Preview를 보고자 하는 Viewcontroller 이름
    // e.g.)

      return MyPageViewController(true)
    }
}

struct ViewController_Previews: PreviewProvider {
    
    @available(iOS 13.0, *)
    static var previews: some View {
        // UIViewControllerRepresentable에 지정된 이름.
        ViewControllerRepresentable()

// 테스트 해보고자 하는 기기
            .previewDevice("iPhone 11")
    }
}
#endif

final class MyPageViewController: CommonNavi {
  let viewModel: MyPageViewModel
  
  private var userInfoView: UserInfoView
  private var userActivityView: UserActivityView
  private lazy var serviceView = ServiceView()
  
  override init(_ checkLoginStatus: Bool) {
    self.viewModel = MyPageViewModel(checkLoginStatus)
    self.userInfoView = UserInfoView(viewModel)
    self.userActivityView = UserActivityView(viewModel)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
     
    setupNavigationbar()
    setupLayout()
    makeUI()
  }

  func setupLayout(){
    // 추가하기 전에 addSubview 체크
    [
      userInfoView,
      userActivityView,
      serviceView
    ].forEach {
      view.addSubview($0)
    }
  }

  func makeUI(){
    userInfoView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    userActivityView.snp.makeConstraints {
      $0.top.equalTo(userInfoView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(119)
    }
    
    serviceView.snp.makeConstraints {
      $0.top.equalTo(userActivityView.snp.bottom).offset(110)
      $0.leading.equalTo(userInfoView.snp.leading).offset(15)
      $0.height.equalTo(250)
    }
  }

  func setupNavigationbar(){
    leftButtonSetting(imgName: "MyPageImg", activate: false)
    rightButtonSetting(imgName: "BookMarkImg")
  }
}

  
//  override func rightButtonTapped(_ sender: UIBarButtonItem) {
//    let data = BookMarkData(
//      loginStatus: viewModel.checkLoginStatus.value,
//      isNeedFetch: nil
//    )
//    moveToBookmarkView(sender, data: data)
//  }
  

extension MyPageViewController: MoveToBookmarkView {}
