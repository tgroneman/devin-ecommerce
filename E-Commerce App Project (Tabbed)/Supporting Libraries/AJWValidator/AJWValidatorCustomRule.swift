import Foundation

typealias AJWValidatorCustomRuleBlock = (Any?) -> Bool

class AJWValidatorCustomRule: AJWValidatorRule {

    private(set) var block: AJWValidatorCustomRuleBlock

    init(type: AJWValidatorRuleType, block: @escaping AJWValidatorCustomRuleBlock, invalidMessage message: String?) {
        self.block = block
        super.init(type: type, invalidMessage: message)
    }

    override func isValidationRuleSatisfied(_ instance: Any?) -> Bool {
        return block(instance)
    }
}
