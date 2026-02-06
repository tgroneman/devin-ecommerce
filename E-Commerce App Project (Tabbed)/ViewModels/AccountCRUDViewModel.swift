import Foundation

class AccountCRUDViewModel {

    private let accountOperations: AccountOperations
    private let validator: Validation
    private let defaults: UserDefaults

    private(set) var userData: [String: Any]?

    init() {
        accountOperations = AccountOperations()
        validator = Validation()
        defaults = UserDefaults.standard
    }

    var validationHelper: Validation {
        return validator
    }

    var isUserLoggedIn: Bool {
        return defaults.bool(forKey: "SeesionUserLoggedIN")
    }

    func loadUserData() {
        userData = defaults.dictionary(forKey: "LoggedInUsersDetail")
    }

    var editFirstName: String { return userData?["firstName"] as? String ?? "" }
    var editLastName: String { return userData?["lastName"] as? String ?? "" }
    var editEmail: String { return userData?["usersEmail"] as? String ?? "" }
    var editPhone: String { return userData?["phone"] as? String ?? "" }
    var editCountry: String { return userData?["country"] as? String ?? "" }
    var editState: String { return userData?["state"] as? String ?? "" }
    var editCity: String { return userData?["city"] as? String ?? "" }
    var editPostalCode: String { return userData?["postalCode"] as? String ?? "" }
    var editAddress: String { return userData?["address"] as? String ?? "" }

    func validateEmail(_ email: String) -> Bool {
        return accountOperations.validateEmailAccount(email)
    }

    var accountOps: AccountOperations {
        return accountOperations
    }

    func encryptPassword(_ password: String) -> String {
        return accountOperations.sha1(password)
    }

    var storedUserEmail: String {
        return (userData?["usersEmail"] as? String) ?? ""
    }
}
