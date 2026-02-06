import UIKit

class Validation: NSObject {

    func requiredMinLengthValidator(_ requiredErrorMessage: String, integerForMinLength minLength: Int, minLengthErrorMessage: String, withLabelForValidationRules validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: NSLocalizedString(requiredErrorMessage, comment: ""))
        validator.addValidationToEnsureMinimumLength(minLength, invalidMessage: NSLocalizedString(minLengthErrorMessage, comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .valid:
                self?.handleValid(validationStatusLabel)
            case .invalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .waitingForRemote:
                self?.handleWaiting()
            @unknown default:
                break
            }
        }
        return validator
    }

    func equalityValidator(_ password: AnyObject, with validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureInstanceIsTheSame(as: password, invalidMessage: NSLocalizedString("Should be equal to 'password'", comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .valid:
                self?.handleValid(validationStatusLabel)
            case .invalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .waitingForRemote:
                self?.handleWaiting()
            @unknown default:
                break
            }
        }
        return validator
    }

    func emailValidator(_ validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureValidEmail(withInvalidMessage: "Must be a valid email address!")
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .valid:
                self?.handleValid(validationStatusLabel)
            case .invalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .waitingForRemote:
                self?.handleWaiting()
            @unknown default:
                break
            }
        }
        return validator
    }

    func phoneValidator(_ validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureRegularExpressionIsMet(withPattern: "^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*$", invalidMessage: NSLocalizedString("Please check your phone no again!", comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .valid:
                self?.handleValid(validationStatusLabel)
            case .invalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .waitingForRemote:
                self?.handleWaiting()
            @unknown default:
                break
            }
        }
        return validator
    }

    func requiredValidator(_ errorMessage: String, withLabelForValidationRules validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsurePresence(withInvalidMessage: NSLocalizedString(errorMessage, comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .valid:
                self?.handleValid(validationStatusLabel)
            case .invalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .waitingForRemote:
                self?.handleWaiting()
            @unknown default:
                break
            }
        }
        return validator
    }

    func minLengthValidator(_ errorMessage: String, withLabelForValidationRules validationStatusLabel: UILabel) -> AJWValidator {
        let validator = AJWValidator.validator(with: .string)
        validator.addValidationToEnsureMinimumLength(6, invalidMessage: NSLocalizedString(errorMessage, comment: ""))
        validator.validatorStateChangedHandler = { [weak self] newState in
            switch newState {
            case .valid:
                self?.handleValid(validationStatusLabel)
            case .invalid:
                self?.handleInvalid(validator, withLabelForError: validationStatusLabel)
            case .waitingForRemote:
                self?.handleWaiting()
            @unknown default:
                break
            }
        }
        return validator
    }

    private func handleValid(_ validationStatusLabel: UILabel) {
        validationStatusLabel.isHidden = false
        let validGreen = UIColor(red: 0.27, green: 0.63, blue: 0.27, alpha: 1)
        validationStatusLabel.backgroundColor = validGreen.withAlphaComponent(0.3)
        validationStatusLabel.text = NSLocalizedString("No errors", comment: "")
        validationStatusLabel.textColor = validGreen
        validationStatusLabel.isHidden = true
    }

    private func handleInvalid(_ validator: AJWValidator, withLabelForError validationStatusLabel: UILabel) {
        validationStatusLabel.isHidden = false
        let invalidRed = UIColor(red: 0.89, green: 0.18, blue: 0.16, alpha: 1)
        validationStatusLabel.backgroundColor = invalidRed.withAlphaComponent(0.3)
        validationStatusLabel.text = validator.errorMessages.joined(separator: " \n")
        validationStatusLabel.textColor = invalidRed
    }

    private func handleWaiting() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
}
