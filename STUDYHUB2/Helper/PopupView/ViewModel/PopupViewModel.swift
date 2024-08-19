//
//  PopupViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/19/24.
//

import Foundation

import RxRelay

final class PopupViewModel: CommonViewModel{
  var dataSubject: PublishRelay<String>
  let isActivateEndButton: Bool
  
  init(isActivateEndButton: Bool, dataStrem: PublishRelay<String>) {
    self.isActivateEndButton = isActivateEndButton
    self.dataSubject = dataStrem
  }
}

