import Foundation

class AJWValidatorEqualRule: AJWValidatorRule {

    private var otherInstance: AnyObject?

    init(type: AJWValidatorRuleType, invalidMessage message: String?, otherInstance: AnyObject?) {
        self.otherInstance = otherInstance
        super.init(type: type, invalidMessage: message)
    }

    override func isValidationRuleSatisfied(_ instance: Any?) -> Bool {
        guard let instance = instance as? NSObject, let other = otherInstance as? NSObject else { return false }
        return instance.isEqual(other)
    }
}
