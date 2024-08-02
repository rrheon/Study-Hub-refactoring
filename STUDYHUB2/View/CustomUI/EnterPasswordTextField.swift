//
//  EnterPasswordTextField.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 7/29/24.
//

import UIKit

final class EnterPasswordTextField: AuthTextField {
  var failContent: String
  var successContent: String

  init(setValue: SetAuthTextFieldValue,
       failContent: String = "사용할 수 없는 비밀번호예요. (10자리 이상, 특수문자 포함 필수)",
       successContent: String = "사용 가능한 비밀번호예요") {
      self.failContent = failContent
      self.successContent = successContent
      super.init(setValue: setValue)
  }

  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override func textFieldDidChange() {
      guard let context = super.getTextFieldValue(), !context.isEmpty else { return }
      let isPasswordValid = isValidPassword(password: context)
      let color = isPasswordValid ? UIColor.g_10 : UIColor.r50
      let content = isPasswordValid ? successContent : failContent

      super.alertLabelSetting(hidden: false, title: content, textColor: color, underLineColor: color)
  }

  override func textFieldEnd() {
      guard let context = super.getTextFieldValue(), !context.isEmpty else { return }
      let isPasswordValid = isValidPassword(password: context)
      let color = isPasswordValid ? UIColor.g100 : UIColor.r50
      let content = isPasswordValid ? successContent : nil
      let alertLabelHidden = isPasswordValid

      super.alertLabelSetting(hidden: alertLabelHidden, title: content ?? "", textColor: color, underLineColor: color)
  }
}
