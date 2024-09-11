
import UIKit

final class SimilarComponent: UIView {
  private lazy var similarPostLabel = createLabel(
    title: "이 글과 비슷한 스터디예요",
    textColor: .black,
    fontType: "Pretendard-SemiBold",
    fontSize: 18
  )
  
  private lazy var similarCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 50
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.backgroundColor = .white
    view.clipsToBounds = false
    return view
  }()
  
  private lazy var similarPostStackView = createStackView(axis: .vertical, spacing: 20)
  
  private lazy var bookmarkButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "BookMarkLightImg"), for: .normal)
    return button
  }()
  
  private lazy var participateButton = StudyHubButton(title: "참여하기")
}

extension SimilarComponent: CreateUIprotocol{}
