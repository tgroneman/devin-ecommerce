import Foundation

class AJWValidatorRegularExpressionRule: AJWValidatorRule {

    private var pattern: String

    init(type: AJWValidatorRuleType, invalidMessage message: String?, pattern: String) {
        self.pattern = pattern
        super.init(type: type, invalidMessage: message)
    }

    override func isValidationRuleSatisfied(_ instance: Any?) -> Bool {
        guard let string = instance as? String else { return false }
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: string)
    }
}
