
import Foundation

import Kingfisher


protocol ManagementImage {
  func getUserProfileImage(
    width: Int,
    hegiht: Int,
    imageURL: URL,
    completion: @escaping (Result<UIImage, Error>) -> Void)
  
  func settingProfileImage(
    profile: UIImageView,
    result: Result<UIImage, any Error>,
    radious: CGFloat)
}

extension ManagementImage {
  func getUserProfileImage(
    width: Int = 56,
    hegiht: Int = 56,
    imageURL: URL,
    completion: @escaping (Result<UIImage, Error>) -> Void) {
      let processor = ResizingImageProcessor(referenceSize: CGSize(width: width, height: hegiht))
      
      KingfisherManager.shared.cache.removeImage(forKey: imageURL.absoluteString)
      
      KingfisherManager.shared.retrieveImage(
        with: imageURL,
        options: [.processor(processor)]
      ) { result in
        switch result {
        case .success(let value):
          completion(.success(value.image))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }

  func settingProfileImage(
    profile: UIImageView,
    result: Result<UIImage, any Error>,
    radious: CGFloat){
    DispatchQueue.main.async {
      switch result {
      case .success(let image):
        profile.image = image
        profile.layer.cornerRadius = radious
        profile.clipsToBounds = true
      case .failure(let error):
        print("Failed to load user profile image: \(error)")
      }
    }
  }
}
