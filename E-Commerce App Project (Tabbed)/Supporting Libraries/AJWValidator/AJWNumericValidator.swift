import Foundation

class AJWNumericValidator: AJWValidator {

    init() {
        super.init(type: .numeric)
    }

    override func addValidationToEnsureRange(withMinimum min: NSNumber, maximum max: NSNumber, invalidMessage message: String) {
        let rule = AJWValidatorRangeRule(type: .numericRange, invalidMessage: message, minimum: min, maximum: max)
        addValidationRule(rule)
    }
}
