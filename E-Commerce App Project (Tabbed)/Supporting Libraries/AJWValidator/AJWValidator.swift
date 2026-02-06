import Foundation

@objc enum AJWValidatorType: UInt {
    case generic
    case string
    case numeric
}

@objc enum AJWValidatorState: UInt {
    case invalid
    case valid
    case waitingForRemote
}

typealias AJWValidatorStateChangeHandler = (AJWValidatorState) -> Void

@objc protocol AJWValidatorDelegate: AnyObject {
    @objc optional func validator(_ validator: AJWValidator, remoteValidationAtURL url: URL, receivedResult remoteConditionValid: Bool)
    @objc optional func validator(_ validator: AJWValidator, remoteValidationAtURL url: URL, failedWithError error: Error)
}

let AJWValidatorRegularExpressionPatternEmail = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z\u{200C}\u{200B}{2,6})$"
let AJWValidatorRegularExpressionPatternContainsNumber = ".*\\d.*"

class AJWValidator: NSObject {

    weak var delegate: AJWValidatorDelegate?
    var validatorStateChangedHandler: AJWValidatorStateChangeHandler?

    private(set) var state: AJWValidatorState = .valid {
        didSet {
            validatorStateChangedHandler?(state)
        }
    }

    var ruleCount: UInt {
        return UInt(rules.count)
    }

    var errorMessages: [String] {
        return mutableErrorMessages
    }

    private var validatorType: AJWValidatorType
    var rules: [AJWValidatorRule] = []
    var localConditionsSatisfied: Bool = true
    private var mutableErrorMessages: [String] = []

    static func validator() -> AJWValidator {
        return AJWValidator(type: .generic)
    }

    static func validator(with type: AJWValidatorType) -> AJWValidator {
        switch type {
        case .generic:
            return AJWValidator(type: .generic)
        case .string:
            return AJWStringValidator()
        case .numeric:
            return AJWNumericValidator()
        }
    }

    init(type: AJWValidatorType = .generic) {
        self.validatorType = type
        super.init()
    }

    func addValidationRule(_ rule: AJWValidatorRule) {
        rules.append(rule)
    }

    func addValidationToEnsurePresence(withInvalidMessage message: String) {
        raiseIncompatibilityException()
    }

    func addValidationToEnsureMinimumLength(_ minLength: Int, invalidMessage message: String) {
        raiseIncompatibilityException()
    }

    func addValidationToEnsureMaximumLength(_ maxLength: Int, invalidMessage message: String) {
        raiseIncompatibilityException()
    }

    func addValidationToEnsureRange(withMinimum min: NSNumber, maximum max: NSNumber, invalidMessage message: String) {
        raiseIncompatibilityException()
    }

    func addValidationToEnsureInstanceIsTheSame(as otherInstance: AnyObject, invalidMessage message: String) {
        let rule = AJWValidatorEqualRule(type: .equal, invalidMessage: message, otherInstance: otherInstance)
        addValidationRule(rule)
    }

    func addValidationToEnsureRegularExpressionIsMet(withPattern pattern: String, invalidMessage message: String) {
        raiseIncompatibilityException()
    }

    func addValidationToEnsureValidEmail(withInvalidMessage message: String) {
        raiseIncompatibilityException()
    }

    func addValidationToEnsureCustomConditionIsSatisfied(block: @escaping AJWValidatorCustomRuleBlock, invalidMessage message: String) {
        let rule = AJWValidatorCustomRule(type: .custom, block: block, invalidMessage: message)
        addValidationRule(rule)
    }

    func addValidationToEnsureRemoteConditionIsSatisfied(at url: URL, invalidMessage message: String) {
        weak var weakSelf = self
        let rule = AJWValidatorRemoteRule(type: .remote, serviceURL: url, invalidMessage: message) { remoteConditionSatisfied, error in
            if error == nil {
                if remoteConditionSatisfied {
                    weakSelf?.removeValidationMessage(message)
                    if weakSelf?.localConditionsSatisfied == true {
                        weakSelf?.state = .valid
                    } else {
                        weakSelf?.state = .invalid
                    }
                } else {
                    weakSelf?.state = .invalid
                }
                weakSelf?.delegate?.validator?(weakSelf!, remoteValidationAtURL: url, receivedResult: remoteConditionSatisfied)
            } else {
                weakSelf?.state = .invalid
                weakSelf?.delegate?.validator?(weakSelf!, remoteValidationAtURL: url, failedWithError: error!)
            }
        }
        addValidationRule(rule)
    }

    func addValidationToEnsureStringContainsNumber(withInvalidMessage message: String) {
        raiseIncompatibilityException()
    }

    func raiseIncompatibilityException() {
        fatalError("AJWValidator Error: Attempted to add validation rule that is not compatible for this validator type.")
    }

    func isValid() -> Bool {
        return state == .valid
    }

    func validate(_ instance: Any?) {
        ajwValidate(instance)
    }

    func ajwValidate(_ instance: Any?) {
        ajwValidate(instance, parameters: nil)
    }

    func validate(_ instance: Any?, parameters: [String: Any]?) {
        ajwValidate(instance, parameters: parameters)
    }

    func ajwValidate(_ instance: Any?, parameters: [String: Any]?) {
        clearErrorMessages()
        localConditionsSatisfied = true
        var newState: AJWValidatorState = .valid

        for rule in rules {
            if rule.type == .remote {
                if let remoteRule = rule as? AJWValidatorRemoteRule {
                    addErrorMessage(for: rule)
                    newState = .waitingForRemote
                    remoteRule.startRequestToValidateInstance(instance, withParams: parameters)
                }
            } else {
                if !rule.isValidationRuleSatisfied(instance) {
                    addErrorMessage(for: rule)
                    localConditionsSatisfied = false
                    newState = .invalid
                }
            }
        }

        state = newState
    }

    private func addErrorMessage(for rule: AJWValidatorRule) {
        mutableErrorMessages.append(rule.errorMessage)
    }

    private func clearErrorMessages() {
        mutableErrorMessages.removeAll()
    }

    func removeValidationMessage(_ message: String) {
        mutableErrorMessages.removeAll { $0 == message }
    }
}
