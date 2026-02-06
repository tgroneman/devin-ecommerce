import Foundation

class ThankYouViewModel {

    private let defaults: UserDefaults

    init() {
        defaults = UserDefaults.standard
    }

    var pdfFilePath: String {
        return defaults.value(forKey: "pdfFilePath") as? String ?? ""
    }

    var userEmail: String {
        return defaults.value(forKey: "SessionLoggedInuserEmail") as? String ?? ""
    }

    var pdfFileURL: URL {
        return URL(fileURLWithPath: pdfFilePath)
    }
}
