import Foundation

class CheckOutViewModel {

    private let cart: ShoppingCart
    private let defaults: UserDefaults

    private(set) var userData: [String: Any]?
    private(set) var pdfFilePath: String = ""

    var bkashChecked: Bool = false
    var rocketChecked: Bool = false
    var cashOnDeliveryChecked: Bool = false

    init() {
        cart = ShoppingCart.sharedInstance
        defaults = UserDefaults.standard
    }

    var isUserLoggedIn: Bool {
        return defaults.bool(forKey: "SeesionUserLoggedIN")
    }

    func loadUserData() {
        userData = defaults.dictionary(forKey: "LoggedInUsersDetail")
    }

    var formattedTotal: String {
        return "$\(defaults.value(forKey: "cartTotalAmount") ?? "")"
    }

    var userFirstName: String { return userData?["firstName"] as? String ?? "" }
    var userLastName: String { return userData?["lastName"] as? String ?? "" }
    var userEmail: String { return userData?["usersEmail"] as? String ?? "" }
    var userPhone: String { return userData?["phone"] as? String ?? "" }
    var userCountry: String { return userData?["country"] as? String ?? "" }
    var userCity: String { return userData?["city"] as? String ?? "" }
    var userState: String { return userData?["state"] as? String ?? "" }
    var userPostalCode: String { return userData?["postalCode"] as? String ?? "" }
    var userAddress: String { return userData?["address"] as? String ?? "" }

    enum PaymentMethod: String {
        case bkash = "Bkash"
        case rocket = "Rocket"
        case cashOnDelivery = "Cash On Delivery"
        case none = ""
    }

    func selectPaymentMethod(_ method: PaymentMethod) {
        bkashChecked = method == .bkash
        rocketChecked = method == .rocket
        cashOnDeliveryChecked = method == .cashOnDelivery
        defaults.set(method.rawValue, forKey: "paymentMethodUsed")
        defaults.synchronize()
    }

    func toggleBkash() {
        if !bkashChecked {
            selectPaymentMethod(.bkash)
        } else {
            selectPaymentMethod(.none)
        }
    }

    func toggleRocket() {
        if !rocketChecked {
            selectPaymentMethod(.rocket)
        } else {
            selectPaymentMethod(.none)
        }
    }

    func toggleCashOnDelivery() {
        if !cashOnDeliveryChecked {
            selectPaymentMethod(.cashOnDelivery)
        } else {
            selectPaymentMethod(.none)
        }
    }

    var isPaymentMethodSelected: Bool {
        return (defaults.value(forKey: "paymentMethodUsed") as? String) != ""
    }

    func getHTMLString() -> String {
        let pdfLogoUrl = "https://apiforios.appendtech.com/logo.png"

        guard let filePath = Bundle.main.path(forResource: "invoice", ofType: "html"),
              let singleItemFilePath = Bundle.main.path(forResource: "single_item", ofType: "html") else {
            return ""
        }

        var strHTML = (try? String(contentsOfFile: filePath, encoding: .utf8)) ?? ""
        let itemsInCartArray = cart.itemsInCart()

        var allItemsHTMLArray: [String] = []
        for item in itemsInCartArray {
            var srtItemHTML = (try? String(contentsOfFile: singleItemFilePath, encoding: .utf8)) ?? ""
            srtItemHTML = srtItemHTML.replacingOccurrences(of: "#productName", with: item.itemName)
            srtItemHTML = srtItemHTML.replacingOccurrences(of: "#quantity", with: "\(NSNumber(value: item.cartAddedQuantity))")
            srtItemHTML = srtItemHTML.replacingOccurrences(of: "#price", with: "\(NSNumber(value: item.price))")
            allItemsHTMLArray.append(srtItemHTML)
        }
        let allItemsHTMLString = allItemsHTMLArray.joined(separator: "\n")

        strHTML = strHTML.replacingOccurrences(of: "#ITEMS#", with: allItemsHTMLString)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: Date())

        let ownerInfo = "ICTcom<br>An E-commerce App Project<br>Developed BY: Rony Banik (Arko)<br>"
        strHTML = strHTML.replacingOccurrences(of: "#ownerInfo", with: ownerInfo)
        strHTML = strHTML.replacingOccurrences(of: "#appIcon", with: pdfLogoUrl)
        strHTML = strHTML.replacingOccurrences(of: "#invoiceDate", with: dateString)
        strHTML = strHTML.replacingOccurrences(of: "#cartTotal", with: (defaults.value(forKey: "cartTotalAmount") as? String) ?? "")
        strHTML = strHTML.replacingOccurrences(of: "#firstName", with: userFirstName)
        strHTML = strHTML.replacingOccurrences(of: "#lastName", with: userLastName)
        strHTML = strHTML.replacingOccurrences(of: "#email", with: userEmail)
        strHTML = strHTML.replacingOccurrences(of: "#phone", with: userPhone)
        strHTML = strHTML.replacingOccurrences(of: "#country", with: userCountry)
        strHTML = strHTML.replacingOccurrences(of: "#city", with: userCity)
        strHTML = strHTML.replacingOccurrences(of: "#state", with: userState)
        strHTML = strHTML.replacingOccurrences(of: "#postalCode", with: userPostalCode)
        strHTML = strHTML.replacingOccurrences(of: "#address", with: userAddress)
        strHTML = strHTML.replacingOccurrences(of: "#paymentMethod", with: (defaults.value(forKey: "paymentMethodUsed") as? String) ?? "")

        return strHTML
    }

    func finishCheckout() {
        defaults.set("", forKey: "cartTotalAmount")
        defaults.set("", forKey: "paymentMethodUsed")
        defaults.synchronize()
        cart.clearCart()
    }

    func setPDFFilePath(_ path: String) {
        pdfFilePath = path
        defaults.set(path, forKey: "pdfFilePath")
        defaults.synchronize()
    }

    var cartItems: [Item] {
        return cart.itemsInCart()
    }
}
