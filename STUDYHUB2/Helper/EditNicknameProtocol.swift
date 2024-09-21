
import UIKit

protocol EditNicknameProtocol: UITextFieldDelegate {
  var characterCountLabel: UILabel { get }
  var characterLimit: Int { get }
}

extension EditNicknameProtocol {
  var characterLimit: Int {
    return 10
  }
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let currentText = textField.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    let changedText = currentText.replacingCharacters(in: stringRange, with: string)
    
    characterCountLabel.text = "\(changedText.count)/\(characterLimit)"
    characterCountLabel.changeColor(wantToChange: "\(changedText.count)", color: .white)
    
    return changedText.count <= characterLimit
  }
}
