//
//  PopupViewModel.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/19/24.
//

import Foundation

import RxRelay

final class PopupViewModel{
  var dataSubject: PublishRelay<PopupActionType>
  let isActivateEndButton: Bool
  
  init(isActivateEndButton: Bool, dataStrem: PublishRelay<PopupActionType>) {
    self.isActivateEndButton = isActivateEndButton
    self.dataSubject = dataStrem
  }
}

