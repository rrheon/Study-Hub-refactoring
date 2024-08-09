import UIKit

import SnapKit

final class DetailsViewController: NaviHelper {

  // MARK: - 화면구성
  private let headerContentStackView: UIStackView = {
    let headerContentStackView = UIStackView()
    headerContentStackView.axis = .vertical
    headerContentStackView.spacing = 0
    return headerContentStackView
  }()
  
  private let largeImageView: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 6"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  
  private let largeImage2View: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 8"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  
  private let largeImage3View: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 9"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  
  private let largeImage4View: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 10"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  
  private let largeImage5View: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 11"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  
  private let largeImage6View: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 12"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  
  private let largeImage7View: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 13"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  private let largeImage8View: UIImageView = {
    let largeImageView = UIImageView(image: UIImage(named: "Image 14"))
    largeImageView.contentMode = .scaleAspectFill
    largeImageView.clipsToBounds = true
    return largeImageView
  }()
  
  lazy var writeButton: UIButton = {
    let writeButton = UIButton(type: .system)
    writeButton.setTitle("작성하기", for: .normal)
    writeButton.setTitleColor(.white, for: .normal)
    writeButton.backgroundColor = UIColor(hexCode: "FF5935")
    writeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    writeButton.layer.cornerRadius = 10
    writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
    return writeButton
  }()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    return scrollView
  }()
  
  // MARK: - viewdidload
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItemSetting()
    
    setUpLayout()
    makeUI()
  }
  
  // MARK: - navigationbar
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    navigationItem.rightBarButtonItem = .none
    settingNavigationTitle(title: "내용",
                           font: "Pretendard-Bold",
                           size: 18)
  }
  
  // MARK: - setupLayout
  func setUpLayout(){
    view.backgroundColor = .black
    view.addSubview(scrollView)

    
    let imageViews = [largeImageView, largeImage2View, largeImage3View, largeImage4View,
                      largeImage5View, largeImage6View, largeImage7View, largeImage8View]
    for imageView in imageViews {
      headerContentStackView.addArrangedSubview(imageView)
    }
    headerContentStackView.addArrangedSubview(writeButton)
    
    scrollView.addSubview(headerContentStackView)
    scrollView.backgroundColor = .white
  }

  // MARK: - makeui
  func makeUI(){
    headerContentStackView.snp.makeConstraints { make in
      make.top.equalTo(scrollView)
      make.leading.trailing.bottom.equalTo(scrollView)
      make.width.equalTo(scrollView)
    }
    
    largeImageView.snp.makeConstraints { make in
      make.height.equalTo(305)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    largeImage2View.snp.makeConstraints { make in
      make.height.equalTo(650)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    largeImage3View.snp.makeConstraints { make in
      make.height.equalTo(600)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    largeImage4View.snp.makeConstraints { make in
      make.height.equalTo(900)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    largeImage5View.snp.makeConstraints { make in
      make.height.equalTo(300)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    largeImage6View.snp.makeConstraints { make in
      make.height.equalTo(400)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    largeImage7View.snp.makeConstraints { make in
      make.height.equalTo(700)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    largeImage8View.snp.makeConstraints { make in
      make.height.equalTo(250)
      make.leading.trailing.equalTo(headerContentStackView)
    }
    
    writeButton.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.top.equalTo(largeImage8View.snp.bottom).offset(40)
      make.leading.equalTo(headerContentStackView).offset(20)
      make.trailing.equalTo(headerContentStackView)
      make.height.equalTo(55)
      make.width.equalTo(400)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.trailing.bottom.equalTo(view)
    }
    
  }

  // MARK: - 작성하기버튼
  @objc func writeButtonTapped() {
    loginStatus { loginCheck in
      if loginCheck {
        let createStudyVC = CreateStudyViewController()
        createStudyVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(createStudyVC, animated: true)
      } else {
        let popupVC = PopupViewController(
          title: "로그인이 필요해요",
          desc: "계속하시려면 로그인을 해주세요!",
          leftButtonTitle: "취소",
          rightButtonTilte: "로그인")
        
        popupVC.popupView.rightButtonAction = {
          self.dismiss(animated: true) {
            self.dismiss(animated: true)
          }
        }
        
        popupVC.modalPresentationStyle = .overFullScreen
        self.present(popupVC, animated: false)
      }
    }
  }
}
