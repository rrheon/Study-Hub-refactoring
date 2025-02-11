//
//  UICollectionView+Ext.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 2/11/25.
//

import UIKit

/// CollectionViewCell의 CellID
extension UICollectionViewCell {
  static var cellID: String {
    String(describing: Self.self)
  }
}
