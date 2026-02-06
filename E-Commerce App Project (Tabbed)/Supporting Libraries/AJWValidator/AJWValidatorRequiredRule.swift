import Foundation

class AJWValidatorRequiredRule: AJWValidatorRule {

    override func isValidationRuleSatisfied(_ instance: Any?) -> Bool {
        guard let string = instance as? String else { return false }
        return string.count > 0
    }
}
