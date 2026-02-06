import UIKit
import ObjectiveC

private var AJWValidatorsKey: UInt8 = 0

extension UIView {

    private var ajw_validators: [AJWValidator]? {
        get {
            return objc_getAssociatedObject(self, &AJWValidatorsKey) as? [AJWValidator]
        }
        set {
            objc_setAssociatedObject(self, &AJWValidatorsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func ajw_attachValidator(_ validator: AJWValidator) {
        if self is UITextField {
            ajw_attachTextFieldValidator()
        } else if self is UITextView {
            ajw_attachTextViewValidator()
        } else {
            assertionFailure("Tried to add AJWValidator to unsupported control type of class \(type(of: self)).")
            return
        }

        if ajw_validators == nil {
            ajw_validators = []
        }
        ajw_validators?.append(validator)
    }

    func ajw_removeValidators() {
        ajw_validators?.removeAll()
        NotificationCenter.default.removeObserver(self)
    }

    private func ajw_attachTextFieldValidator() {
        if let textField = self as? UITextField {
            textField.addTarget(self, action: #selector(ajw_validateTextFieldForChange(_:)), for: .editingChanged)
        }
    }

    @objc private func ajw_validateTextFieldForChange(_ textField: UITextField) {
        ajw_validators?.forEach { validator in
            validator.validate(textField.text)
        }
    }

    private func ajw_attachTextViewValidator() {
        NotificationCenter.default.addObserver(self, selector: #selector(ajw_validateTextViewForChange(_:)), name: UITextView.textDidChangeNotification, object: self)
    }

    @objc private func ajw_validateTextViewForChange(_ notification: Notification) {
        guard let textView = notification.object as? UITextView else { return }
        ajw_validators?.forEach { validator in
            validator.validate(textView.text)
        }
    }
}
