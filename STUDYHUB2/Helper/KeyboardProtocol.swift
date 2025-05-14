//
//  KeyboardProtocol.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/24/25.
//

import UIKit
import RxSwift
import RxCocoa


/// 키보드 관련 프로토콜
protocol KeyboardProtocol {
  var disposeBag: DisposeBag { get }
  func registerKeyboard()
  func registerTapGesture()
}

extension KeyboardProtocol where Self: UIViewController {
  func registerKeyboard() {
    // 키보드 보이기 전
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillShowNotification)
      .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
      .map { $0.cgRectValue.height }
      .subscribe(onNext: { [weak self] keyboardHeight in
        guard let self = self else { return }
                
        if self.view.frame.origin.y == 0 {
          self.view.frame.origin.y -= keyboardHeight
          print(#fileID, #function, #line," - 키보드 올리기")

        }
      })
      .disposed(by: disposeBag)
    
    // 키보드 숨기기 전
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        
        if self.view.frame.origin.y != 0 {
          self.view.frame.origin.y = 0
        }
      })
      .disposed(by: disposeBag)
  }

  // 탭 제스쳐
  func registerTapGesture(){
    let tapBackground = UITapGestureRecognizer()
    tapBackground.rx.event
      .subscribe(onNext: { [weak self] _ in
        self?.view.endEditing(true)
      })
      .disposed(by: disposeBag)
    
    tapBackground.cancelsTouchesInView = false
    view.addGestureRecognizer(tapBackground)
  }
}
