import Foundation

class AccountViewModel {

    private let defaults: UserDefaults

    private(set) var userData: [String: Any]?

    init() {
        defaults = UserDefaults.standard
    }

    var isUserLoggedIn: Bool {
        return defaults.bool(forKey: "SeesionUserLoggedIN")
    }

    func loadUserData() {
        userData = defaults.dictionary(forKey: "LoggedInUsersDetail")
    }

    var userFirstName: String { return userData?["firstName"] as? String ?? "" }
    var userLastName: String { return userData?["lastName"] as? String ?? "" }
    var userEmail: String { return userData?["usersEmail"] as? String ?? "" }
    var userPhone: String { return userData?["phone"] as? String ?? "" }
    var userCountry: String { return userData?["country"] as? String ?? "" }
    var userState: String { return userData?["state"] as? String ?? "" }
    var userCity: String { return userData?["city"] as? String ?? "" }
    var userPostalCode: String { return userData?["postalCode"] as? String ?? "" }
    var userAddress: String { return userData?["address"] as? String ?? "" }

    func logout() {
        defaults.set(false, forKey: "SeesionUserLoggedIN")
        defaults.set("", forKey: "SessionLoggedInuserEmail")
        defaults.set("", forKey: "LoggedInUsersDetail")
        defaults.synchronize()
    }
}
