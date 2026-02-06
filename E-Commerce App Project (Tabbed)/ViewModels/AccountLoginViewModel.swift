import Foundation

class AccountLoginViewModel {

    private let accountOperations: AccountOperations
    private let validator: Validation

    init() {
        accountOperations = AccountOperations()
        validator = Validation()
    }

    var validationHelper: Validation {
        return validator
    }

    var accountOps: AccountOperations {
        return accountOperations
    }

    func validateEmail(_ email: String) -> Bool {
        return accountOperations.validateEmailAccount(email)
    }

    func encryptPassword(_ password: String) -> String {
        return accountOperations.sha1(password)
    }
}
