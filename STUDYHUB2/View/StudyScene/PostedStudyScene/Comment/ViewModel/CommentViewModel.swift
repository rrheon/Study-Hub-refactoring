//
//  CommentViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/21/24.
//

import Foundation

import RxRelay

final class CommentViewModel {
  let commentManager = CommentManager.shared
  var isNeedFetch: PublishRelay<Bool>?

  init(isNeedFetch: PublishRelay<Bool>?) {
    self.isNeedFetch = isNeedFetch
  }
  
}
