
import UIKit

final class ServiceUseInfoViewContrller: NaviHelper {
  
  private lazy var mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "serviceImage")
    
    return imageView
  }()
  
  private lazy var scrollView = UIScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    makeUI()
    navigationItemSetting()
  }
  
  func makeUI() {
    scrollView.addSubview(mainImageView)
    view.addSubview(scrollView)
    
    mainImageView.contentMode = .scaleAspectFit
    
    mainImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    if let imageSize = mainImageView.image?.size {
      let aspectRatio = imageSize.width / imageSize.height
      let imageViewWidth = view.frame.width
      let imageViewHeight = imageViewWidth / aspectRatio
      mainImageView.snp.makeConstraints { make in
        make.width.equalTo(imageViewWidth)
        make.height.equalTo(imageViewHeight)
      }
      scrollView.contentSize = CGSize(width: imageViewWidth, height: imageViewHeight)
    }
  }
  
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    settingNavigationTitle(title: "서비스 이용약관")
    navigationItem.rightBarButtonItem = .none
  }
}

