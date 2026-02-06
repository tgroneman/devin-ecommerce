import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class AJWValidatorTests: XCTestCase {

    func testGenericValidatorCreation() {
        let validator = AJWValidator.validator()
        XCTAssertNotNil(validator)
        XCTAssertTrue(validator.isValid())
    }

    func testStringValidatorCreation() {
        let validator = AJWValidator.validator(with: .string)
        XCTAssertNotNil(validator)
        XCTAssertTrue(validator.isValid())
    }

    func testNumericValidatorCreation() {
        let validator = AJWValidator.validator(with: .numeric)
        XCTAssertNotNil(validator)
        XCTAssertTrue(validator.isValid())
    }

    func testInitialStateIsValid() {
        let validator = AJWValidator.validator(with: .string)
        XCTAssertEqual(validator.state, .valid)
        XCTAssertTrue(validator.isValid())
    }

    func testInitialRuleCountIsZero() {
        let validator = AJWValidator.validator(with: .string)
        XCTAssertEqual(validator.ruleCount, 0)
    }

    func testInitialErrorMessagesEmpty() {
        let validator = AJWValidator.validator(with: .string)
        XCTAssertTrue(validator.errorMessages.isEmpty)
    }

    func testStringValidatorPresenceRule() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        XCTAssertEqual(validator.ruleCount, 1)
    }

    func testStringValidatorPresenceValid() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        validator.validate("hello")
        XCTAssertEqual(validator.state, .valid)
        XCTAssertTrue(validator.errorMessages.isEmpty)
    }

    func testStringValidatorPresenceInvalid() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        validator.validate("")
        XCTAssertEqual(validator.state, .invalid)
        XCTAssertEqual(validator.errorMessages.count, 1)
        XCTAssertEqual(validator.errorMessages.first, "Required")
    }

    func testStringValidatorMinLength() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureMinimumLength(5, invalidMessage: "Too short")
        validator.validate("hi")
        XCTAssertEqual(validator.state, .invalid)
        validator.validate("hello")
        XCTAssertEqual(validator.state, .valid)
    }

    func testStringValidatorMaxLength() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureMaximumLength(5, invalidMessage: "Too long")
        validator.validate("hello!")
        XCTAssertEqual(validator.state, .invalid)
        validator.validate("hi")
        XCTAssertEqual(validator.state, .valid)
    }

    func testStringValidatorRange() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureRange(withMinimum: NSNumber(value: 3), maximum: NSNumber(value: 10), invalidMessage: "Out of range")
        validator.validate("ab")
        XCTAssertEqual(validator.state, .invalid)
        validator.validate("abcde")
        XCTAssertEqual(validator.state, .valid)
    }

    func testStringValidatorEmail() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureValidEmail(withInvalidMessage: "Invalid email")
        validator.validate("user@example.com")
        XCTAssertEqual(validator.state, .valid)
        validator.validate("notanemail")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testStringValidatorRegex() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureRegularExpressionIsMet(withPattern: "^[0-9]+$", invalidMessage: "Not a number")
        validator.validate("12345")
        XCTAssertEqual(validator.state, .valid)
        validator.validate("abc")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testStringValidatorContainsNumber() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureStringContainsNumber(withInvalidMessage: "Must contain number")
        validator.validate("abc123")
        XCTAssertEqual(validator.state, .valid)
        validator.validate("abcdef")
        XCTAssertEqual(validator.state, .invalid)
    }

    func testEqualityRule() {
        let reference = "password123" as NSString
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureInstanceIsTheSame(as: reference, invalidMessage: "Must match")
        validator.validate("password123" as NSString)
        XCTAssertEqual(validator.state, .valid)
        validator.validate("different" as NSString)
        XCTAssertEqual(validator.state, .invalid)
    }

    func testCustomRule() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureCustomConditionIsSatisfied(block: { instance in
            guard let str = instance as? String else { return false }
            return str.count > 3
        }, invalidMessage: "Custom fail")
        validator.validate("ab")
        XCTAssertEqual(validator.state, .invalid)
        validator.validate("abcde")
        XCTAssertEqual(validator.state, .valid)
    }

    func testNumericValidatorRange() {
        let validator = AJWValidator.validator(with: .numeric)
        validator.addValidationToEnsureRange(withMinimum: NSNumber(value: 1), maximum: NSNumber(value: 100), invalidMessage: "Out of range")
        validator.validate(NSNumber(value: 50))
        XCTAssertEqual(validator.state, .valid)
        validator.validate(NSNumber(value: 200))
        XCTAssertEqual(validator.state, .invalid)
    }

    func testNumericValidatorRangeAtBoundary() {
        let validator = AJWValidator.validator(with: .numeric)
        validator.addValidationToEnsureRange(withMinimum: NSNumber(value: 1), maximum: NSNumber(value: 100), invalidMessage: "Out of range")
        validator.validate(NSNumber(value: 1))
        XCTAssertEqual(validator.state, .valid)
        validator.validate(NSNumber(value: 100))
        XCTAssertEqual(validator.state, .valid)
    }

    func testMultipleRules() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        validator.addValidationToEnsureMinimumLength(3, invalidMessage: "Too short")
        XCTAssertEqual(validator.ruleCount, 2)
        validator.validate("")
        XCTAssertEqual(validator.state, .invalid)
        XCTAssertEqual(validator.errorMessages.count, 2)
    }

    func testStateChangeHandler() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        var lastState: AJWValidatorState?
        validator.validatorStateChangedHandler = { state in
            lastState = state
        }
        validator.validate("hello")
        XCTAssertEqual(lastState, .valid)
        validator.validate("")
        XCTAssertEqual(lastState, .invalid)
    }

    func testRemoveValidationMessage() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        validator.validate("")
        XCTAssertFalse(validator.errorMessages.isEmpty)
        validator.removeValidationMessage("Required")
        XCTAssertTrue(validator.errorMessages.isEmpty)
    }

    func testValidateNil() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        validator.validate(nil)
        XCTAssertEqual(validator.state, .invalid)
    }

    func testValidateWithParameters() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        validator.validate("hello", parameters: ["key": "value"])
        XCTAssertEqual(validator.state, .valid)
    }

    func testRevalidation() {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: "Required")
        validator.validate("")
        XCTAssertEqual(validator.state, .invalid)
        XCTAssertFalse(validator.errorMessages.isEmpty)
        validator.validate("now valid")
        XCTAssertEqual(validator.state, .valid)
        XCTAssertTrue(validator.errorMessages.isEmpty)
    }
}

class AJWValidatorRuleTests: XCTestCase {

    func testRequiredRuleSatisfied() {
        let rule = AJWValidatorRequiredRule(type: .required, invalidMessage: "Required")
        XCTAssertTrue(rule.isValidationRuleSatisfied("hello"))
    }

    func testRequiredRuleNotSatisfied() {
        let rule = AJWValidatorRequiredRule(type: .required, invalidMessage: "Required")
        XCTAssertFalse(rule.isValidationRuleSatisfied(""))
    }

    func testRequiredRuleNilInstance() {
        let rule = AJWValidatorRequiredRule(type: .required, invalidMessage: "Required")
        XCTAssertFalse(rule.isValidationRuleSatisfied(nil))
    }

    func testRangeRuleStringValid() {
        let rule = AJWValidatorRangeRule(type: .stringRange, invalidMessage: "Range", minimum: NSNumber(value: 3), maximum: NSNumber(value: 10))
        XCTAssertTrue(rule.isValidationRuleSatisfied("hello"))
    }

    func testRangeRuleStringTooShort() {
        let rule = AJWValidatorRangeRule(type: .stringRange, invalidMessage: "Range", minimum: NSNumber(value: 3), maximum: NSNumber(value: 10))
        XCTAssertFalse(rule.isValidationRuleSatisfied("ab"))
    }

    func testRangeRuleStringTooLong() {
        let rule = AJWValidatorRangeRule(type: .stringRange, invalidMessage: "Range", minimum: NSNumber(value: 3), maximum: NSNumber(value: 5))
        XCTAssertFalse(rule.isValidationRuleSatisfied("toolongstring"))
    }

    func testRangeRuleNumericValid() {
        let rule = AJWValidatorRangeRule(type: .numericRange, invalidMessage: "Range", minimum: NSNumber(value: 1), maximum: NSNumber(value: 100))
        XCTAssertTrue(rule.isValidationRuleSatisfied(NSNumber(value: 50)))
    }

    func testRangeRuleNumericOutOfRange() {
        let rule = AJWValidatorRangeRule(type: .numericRange, invalidMessage: "Range", minimum: NSNumber(value: 1), maximum: NSNumber(value: 100))
        XCTAssertFalse(rule.isValidationRuleSatisfied(NSNumber(value: 200)))
    }

    func testRangeRuleNumericNil() {
        let rule = AJWValidatorRangeRule(type: .numericRange, invalidMessage: "Range", minimum: NSNumber(value: 1), maximum: NSNumber(value: 100))
        XCTAssertFalse(rule.isValidationRuleSatisfied(nil))
    }

    func testRegexRuleSatisfied() {
        let rule = AJWValidatorRegularExpressionRule(type: .regex, invalidMessage: "Regex", pattern: "^[0-9]+$")
        XCTAssertTrue(rule.isValidationRuleSatisfied("12345"))
    }

    func testRegexRuleNotSatisfied() {
        let rule = AJWValidatorRegularExpressionRule(type: .regex, invalidMessage: "Regex", pattern: "^[0-9]+$")
        XCTAssertFalse(rule.isValidationRuleSatisfied("abc"))
    }

    func testRegexRuleNil() {
        let rule = AJWValidatorRegularExpressionRule(type: .regex, invalidMessage: "Regex", pattern: "^[0-9]+$")
        XCTAssertFalse(rule.isValidationRuleSatisfied(nil))
    }

    func testEmailRegex() {
        let rule = AJWValidatorRegularExpressionRule(type: .email, invalidMessage: "Email", pattern: AJWValidatorRegularExpressionPatternEmail)
        XCTAssertTrue(rule.isValidationRuleSatisfied("test@example.com"))
        XCTAssertFalse(rule.isValidationRuleSatisfied("invalid"))
    }

    func testEqualRuleSatisfied() {
        let reference = "test" as NSString
        let rule = AJWValidatorEqualRule(type: .equal, invalidMessage: "Equal", otherInstance: reference)
        XCTAssertTrue(rule.isValidationRuleSatisfied("test" as NSString))
    }

    func testEqualRuleNotSatisfied() {
        let reference = "test" as NSString
        let rule = AJWValidatorEqualRule(type: .equal, invalidMessage: "Equal", otherInstance: reference)
        XCTAssertFalse(rule.isValidationRuleSatisfied("other" as NSString))
    }

    func testCustomRuleSatisfied() {
        let rule = AJWValidatorCustomRule(type: .custom, block: { instance in
            guard let str = instance as? String else { return false }
            return str.hasPrefix("test")
        }, invalidMessage: "Custom")
        XCTAssertTrue(rule.isValidationRuleSatisfied("testing"))
    }

    func testCustomRuleNotSatisfied() {
        let rule = AJWValidatorCustomRule(type: .custom, block: { instance in
            guard let str = instance as? String else { return false }
            return str.hasPrefix("test")
        }, invalidMessage: "Custom")
        XCTAssertFalse(rule.isValidationRuleSatisfied("hello"))
    }

    func testBaseRuleErrorMessage() {
        let rule = AJWValidatorRule(type: .required, invalidMessage: "Custom message")
        XCTAssertEqual(rule.errorMessage, "Custom message")
    }

    func testBaseRuleDefaultErrorMessage() {
        let rule = AJWValidatorRule(type: .required, invalidMessage: nil)
        XCTAssertEqual(rule.errorMessage, "String is required.")
    }

    func testBaseRuleAlwaysFalse() {
        let rule = AJWValidatorRule(type: .required, invalidMessage: nil)
        XCTAssertFalse(rule.isValidationRuleSatisfied("anything"))
    }

    func testDefaultErrorMessages() {
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .required), "String is required.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .minLength), "String is too short.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .maxLength), "String is too long.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .email), "String isn't a valid email address.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .regex), "String doesn't match a pattern.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .remote), "String doesn't satisfy a remote condition.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .custom), "String doesn't satisfy a custom condition.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .stringRange), "String character length is not in the correct range.")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .numericRange), "Number is not in the correct range..")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .equal), "Instance should be identical to another instance")
        XCTAssertEqual(AJWValidatorRuleDefaultErrorMessage(for: .stringContainsNumber), "String requires a numeric character.")
    }

    func testRangeRuleDefaultType() {
        let rule = AJWValidatorRangeRule(type: .required, invalidMessage: "test", minimum: NSNumber(value: 0), maximum: NSNumber(value: 10))
        XCTAssertFalse(rule.isValidationRuleSatisfied("test"))
    }
}
