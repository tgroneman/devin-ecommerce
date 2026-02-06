import XCTest
import UIKit
@testable import E_Commerce_App_Project__Tabbed_

class UIViewValidatorTests: XCTestCase {

    func testAttachValidatorToTextField() {
        let textField = UITextField()
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        textField.ajw_attachValidator(validator)
        XCTAssertNotNil(textField)
    }

    func testAttachMultipleValidatorsToTextField() {
        let textField = UITextField()
        let validator1 = AJWValidator.validator(with: .string)
        validator1.addValidationToEnsurePresence(withInvalidMessage: "Required")
        let validator2 = AJWValidator.validator(with: .string)
        validator2.addValidationToEnsureMinimumLength(3, invalidMessage: "Too short")
        textField.ajw_attachValidator(validator1)
        textField.ajw_attachValidator(validator2)
        XCTAssertNotNil(textField)
    }

    func testRemoveValidatorsFromTextField() {
        let textField = UITextField()
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        textField.ajw_attachValidator(validator)
        textField.ajw_removeValidators()
        XCTAssertNotNil(textField)
    }

    func testAttachValidatorToTextView() {
        let textView = UITextView()
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        textView.ajw_attachValidator(validator)
        XCTAssertNotNil(textView)
    }

    func testRemoveValidatorsFromTextView() {
        let textView = UITextView()
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        textView.ajw_attachValidator(validator)
        textView.ajw_removeValidators()
        XCTAssertNotNil(textView)
    }

    func testTextFieldValidationTriggered() {
        let textField = UITextField()
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        var stateChanged = false
        validator.validatorStateChangedHandler = { _ in
            stateChanged = true
        }
        textField.ajw_attachValidator(validator)
        textField.text = "hello"
        textField.sendActions(for: .editingChanged)
        XCTAssertTrue(stateChanged)
    }

    func testTextFieldValidationWithEmptyText() {
        let textField = UITextField()
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        textField.ajw_attachValidator(validator)
        textField.text = ""
        textField.sendActions(for: .editingChanged)
        XCTAssertEqual(validator.state, .invalid)
    }

    func testTextFieldValidationWithValidText() {
        let textField = UITextField()
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        textField.ajw_attachValidator(validator)
        textField.text = "valid"
        textField.sendActions(for: .editingChanged)
        XCTAssertEqual(validator.state, .valid)
    }
}
