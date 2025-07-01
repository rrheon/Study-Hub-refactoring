//
//  ViewModelType.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 6/23/25.
//

import Foundation

import RxSwift

/// ViewModel InOut Protocol
protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  var disposeBag: DisposeBag { get set }
  
  func transform(input: Input) -> Output
}
