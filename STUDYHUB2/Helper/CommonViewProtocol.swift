//
//  CommonViewProtocol.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 8/25/24.
//

import Foundation

import RxRelay

protocol CommonViewData {
  var isUserLogin: Bool { get }
  var isNeedFechData: PublishRelay<Bool>? { get }
}
