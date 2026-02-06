import Foundation

enum AJWValidatorRuleType: UInt {
    case required
    case minLength
    case maxLength
    case stringRange
    case numericRange
    case equal
    case email
    case regex
    case remote
    case custom
    case stringContainsNumber
}

func AJWValidatorRuleDefaultErrorMessage(for type: AJWValidatorRuleType) -> String {
    switch type {
    case .required: return "String is required."
    case .minLength: return "String is too short."
    case .maxLength: return "String is too long."
    case .email: return "String isn't a valid email address."
    case .regex: return "String doesn't match a pattern."
    case .remote: return "String doesn't satisfy a remote condition."
    case .custom: return "String doesn't satisfy a custom condition."
    case .stringRange: return "String character length is not in the correct range."
    case .numericRange: return "Number is not in the correct range.."
    case .equal: return "Instance should be identical to another instance"
    case .stringContainsNumber: return "String requires a numeric character."
    }
}

class AJWValidatorRule: NSObject {

    private(set) var type: AJWValidatorRuleType
    private(set) var errorMessage: String

    init(type: AJWValidatorRuleType, invalidMessage message: String?) {
        self.type = type
        self.errorMessage = message ?? AJWValidatorRuleDefaultErrorMessage(for: type)
        super.init()
    }

    func isValidationRuleSatisfied(_ instance: Any?) -> Bool {
        return false
    }
}
