import Foundation

class AJWStringValidator: AJWValidator {

    init() {
        super.init(type: .string)
    }

    override func addValidationToEnsurePresence(withInvalidMessage message: String) {
        let rule = AJWValidatorRequiredRule(type: .required, invalidMessage: message)
        addValidationRule(rule)
    }

    override func addValidationToEnsureMinimumLength(_ minLength: Int, invalidMessage message: String) {
        let rule = AJWValidatorRangeRule(type: .stringRange, invalidMessage: message, minimum: NSNumber(value: minLength), maximum: NSNumber(value: Int.max))
        addValidationRule(rule)
    }

    override func addValidationToEnsureMaximumLength(_ maxLength: Int, invalidMessage message: String) {
        let rule = AJWValidatorRangeRule(type: .stringRange, invalidMessage: message, minimum: NSNumber(value: 0), maximum: NSNumber(value: maxLength))
        addValidationRule(rule)
    }

    override func addValidationToEnsureRange(withMinimum min: NSNumber, maximum max: NSNumber, invalidMessage message: String) {
        let rule = AJWValidatorRangeRule(type: .stringRange, invalidMessage: message, minimum: min, maximum: max)
        addValidationRule(rule)
    }

    override func addValidationToEnsureRegularExpressionIsMet(withPattern pattern: String, invalidMessage message: String) {
        let rule = AJWValidatorRegularExpressionRule(type: .regex, invalidMessage: message, pattern: pattern)
        addValidationRule(rule)
    }

    override func addValidationToEnsureValidEmail(withInvalidMessage message: String) {
        let rule = AJWValidatorRegularExpressionRule(type: .email, invalidMessage: message, pattern: AJWValidatorRegularExpressionPatternEmail)
        addValidationRule(rule)
    }

    override func addValidationToEnsureStringContainsNumber(withInvalidMessage message: String) {
        let rule = AJWValidatorRegularExpressionRule(type: .stringContainsNumber, invalidMessage: message, pattern: AJWValidatorRegularExpressionPatternContainsNumber)
        addValidationRule(rule)
    }
}
