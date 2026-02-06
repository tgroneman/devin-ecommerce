import Foundation

class AJWValidatorRangeRule: AJWValidatorRule {

    private var min: NSNumber
    private var max: NSNumber

    init(type: AJWValidatorRuleType, invalidMessage message: String?, minimum: NSNumber, maximum: NSNumber) {
        self.min = minimum
        self.max = maximum
        super.init(type: type, invalidMessage: message)
    }

    override func isValidationRuleSatisfied(_ instance: Any?) -> Bool {
        switch type {
        case .numericRange:
            guard let number = instance as? NSNumber else { return false }
            let numberToValidate = number.floatValue
            let minVal = min.floatValue
            let maxVal = max.floatValue
            return numberToValidate >= minVal && numberToValidate <= maxVal
        case .stringRange:
            guard let string = instance as? String else { return false }
            let minChars = min.intValue
            let maxChars = max.intValue
            return string.count >= minChars && string.count <= maxChars
        default:
            return false
        }
    }
}
