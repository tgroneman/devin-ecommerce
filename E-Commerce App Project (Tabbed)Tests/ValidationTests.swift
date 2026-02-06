import XCTest
import UIKit
@testable import E_Commerce_App_Project__Tabbed_

class ValidationTests: XCTestCase {

    var validation: Validation!
    var label: UILabel!

    override func setUp() {
        super.setUp()
        validation = Validation()
        label = UILabel()
    }

    override func tearDown() {
        validation = nil
        label = nil
        super.tearDown()
    }

    func testRequiredMinLengthValidatorCreation() {
        let validator = validation.requiredMinLengthValidator("Required!", integerForMinLength: 3, minLengthErrorMessage: "Too short!", withLabelForValidationRules: label)
        XCTAssertNotNil(validator)
        XCTAssertEqual(validator.ruleCount, 2)
    }

    func testRequiredMinLengthValidatorValid() {
        let validator = validation.requiredMinLengthValidator("Required!", integerForMinLength: 3, minLengthErrorMessage: "Too short!", withLabelForValidationRules: label)
        validator.validate("hello")
        XCTAssertNotNil(validator.state)
    }

    func testRequiredMinLengthValidatorTooShort() {
        let validator = validation.requiredMinLengthValidator("Required!", integerForMinLength: 5, minLengthErrorMessage: "Too short!", withLabelForValidationRules: label)
        validator.validate("ab")
        XCTAssertEqual(validator.state, .invalid)
        XCTAssertFalse(validator.isValid())
    }

    func testRequiredMinLengthValidatorEmpty() {
        let validator = validation.requiredMinLengthValidator("Required!", integerForMinLength: 3, minLengthErrorMessage: "Too short!", withLabelForValidationRules: label)
        validator.validate("")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testRequiredMinLengthValidatorExactLength() {
        let validator = validation.requiredMinLengthValidator("Required!", integerForMinLength: 3, minLengthErrorMessage: "Too short!", withLabelForValidationRules: label)
        validator.validate("abc")
        XCTAssertNotNil(validator.state)
    }

    func testEqualityValidatorCreation() {
        let password = "test123" as NSString
        let validator = validation.equalityValidator(password, with: label)
        XCTAssertNotNil(validator)
        XCTAssertEqual(validator.ruleCount, 1)
    }

    func testEqualityValidatorMatch() {
        let password = "test123" as NSString
        let validator = validation.equalityValidator(password, with: label)
        validator.validate("test123" as NSString)
        XCTAssertEqual(validator.state, .valid)
    }

    func testEqualityValidatorMismatch() {
        let password = "test123" as NSString
        let validator = validation.equalityValidator(password, with: label)
        validator.validate("different" as NSString)
        XCTAssertEqual(validator.state, .invalid)
    }

    func testEmailValidatorCreation() {
        let validator = validation.emailValidator(label)
        XCTAssertNotNil(validator)
    }

    func testEmailValidatorValid() {
        let validator = validation.emailValidator(label)
        validator.validate("user@example.com")
        XCTAssertEqual(validator.state, .valid)
    }

    func testEmailValidatorInvalid() {
        let validator = validation.emailValidator(label)
        validator.validate("notanemail")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testEmailValidatorEmpty() {
        let validator = validation.emailValidator(label)
        validator.validate("")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testPhoneValidatorCreation() {
        let validator = validation.phoneValidator(label)
        XCTAssertNotNil(validator)
    }

    func testPhoneValidatorValid() {
        let validator = validation.phoneValidator(label)
        validator.validate("1234567890")
        XCTAssertEqual(validator.state, .valid)
    }

    func testPhoneValidatorValidWithPlus() {
        let validator = validation.phoneValidator(label)
        validator.validate("+1234567890")
        XCTAssertEqual(validator.state, .valid)
    }

    func testPhoneValidatorInvalid() {
        let validator = validation.phoneValidator(label)
        validator.validate("abc")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testRequiredValidatorCreation() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        XCTAssertNotNil(validator)
    }

    func testRequiredValidatorWithInput() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("something")
        XCTAssertEqual(validator.state, .valid)
    }

    func testRequiredValidatorEmpty() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testMinLengthValidatorCreation() {
        let validator = validation.minLengthValidator("Too short!", withLabelForValidationRules: label)
        XCTAssertNotNil(validator)
    }

    func testMinLengthValidatorValid() {
        let validator = validation.minLengthValidator("Too short!", withLabelForValidationRules: label)
        validator.validate("abcdef")
        XCTAssertNotNil(validator.state)
    }

    func testMinLengthValidatorTooShort() {
        let validator = validation.minLengthValidator("Too short!", withLabelForValidationRules: label)
        validator.validate("abc")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testMinLengthValidatorExactLength() {
        let validator = validation.minLengthValidator("Too short!", withLabelForValidationRules: label)
        validator.validate("abcdef")
        XCTAssertNotNil(validator.state)
    }

    func testValidStateUpdatesLabel() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("test")
        XCTAssertTrue(label.isHidden)
    }

    func testInvalidStateUpdatesLabel() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("")
        XCTAssertFalse(label.isHidden)
        XCTAssertNotNil(label.text)
    }

    func testInvalidStateLabelHasErrorText() {
        let validator = validation.requiredValidator("Field is required!", withLabelForValidationRules: label)
        validator.validate("")
        XCTAssertFalse(label.text?.isEmpty ?? true)
    }

    func testValidStateLabelColor() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("valid input")
        XCTAssertTrue(label.isHidden)
    }

    func testInvalidStateLabelColor() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("")
        XCTAssertNotNil(label.textColor)
    }

    func testMultipleValidations() {
        let validator = validation.requiredMinLengthValidator("Required!", integerForMinLength: 3, minLengthErrorMessage: "Too short!", withLabelForValidationRules: label)
        validator.validate("ab")
        XCTAssertEqual(validator.state, .invalid)
        validator.validate("abcdef")
        XCTAssertNotNil(validator.state)
    }

    func testErrorMessagesOnInvalid() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("")
        XCTAssertFalse(validator.errorMessages.isEmpty)
    }

    func testErrorMessagesClearedOnValid() {
        let validator = validation.requiredValidator("Required!", withLabelForValidationRules: label)
        validator.validate("")
        XCTAssertFalse(validator.errorMessages.isEmpty)
        validator.validate("valid")
        XCTAssertTrue(validator.errorMessages.isEmpty)
    }
}
