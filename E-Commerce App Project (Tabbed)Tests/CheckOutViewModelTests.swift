import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class CheckOutViewModelTests: XCTestCase {

    var viewModel: CheckOutViewModel!
    var cart: ShoppingCart!

    override func setUp() {
        super.setUp()
        cart = ShoppingCart.sharedInstance
        cart.clearCart()
        viewModel = CheckOutViewModel()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        UserDefaults.standard.removeObject(forKey: "cartTotalAmount")
        UserDefaults.standard.removeObject(forKey: "paymentMethodUsed")
        UserDefaults.standard.removeObject(forKey: "pdfFilePath")
    }

    override func tearDown() {
        cart.clearCart()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        UserDefaults.standard.removeObject(forKey: "cartTotalAmount")
        UserDefaults.standard.removeObject(forKey: "paymentMethodUsed")
        UserDefaults.standard.removeObject(forKey: "pdfFilePath")
        viewModel = nil
        super.tearDown()
    }

    func testIsUserLoggedInFalse() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        XCTAssertFalse(viewModel.isUserLoggedIn)
    }

    func testIsUserLoggedInTrue() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        XCTAssertTrue(viewModel.isUserLoggedIn)
    }

    func testLoadUserData() {
        let userData: [String: Any] = [
            "firstName": "John",
            "lastName": "Doe",
            "usersEmail": "john@example.com",
            "phone": "1234567890",
            "country": "USA",
            "city": "NYC",
            "state": "NY",
            "postalCode": "10001",
            "address": "123 Main St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        viewModel.loadUserData()
        XCTAssertNotNil(viewModel.userData)
    }

    func testUserDataFields() {
        let userData: [String: Any] = [
            "firstName": "John",
            "lastName": "Doe",
            "usersEmail": "john@example.com",
            "phone": "1234567890",
            "country": "USA",
            "city": "NYC",
            "state": "NY",
            "postalCode": "10001",
            "address": "123 Main St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        viewModel.loadUserData()

        XCTAssertEqual(viewModel.userFirstName, "John")
        XCTAssertEqual(viewModel.userLastName, "Doe")
        XCTAssertEqual(viewModel.userEmail, "john@example.com")
        XCTAssertEqual(viewModel.userPhone, "1234567890")
        XCTAssertEqual(viewModel.userCountry, "USA")
        XCTAssertEqual(viewModel.userCity, "NYC")
        XCTAssertEqual(viewModel.userState, "NY")
        XCTAssertEqual(viewModel.userPostalCode, "10001")
        XCTAssertEqual(viewModel.userAddress, "123 Main St")
    }

    func testUserDataFieldsWithNoData() {
        viewModel.loadUserData()
        XCTAssertEqual(viewModel.userFirstName, "")
        XCTAssertEqual(viewModel.userLastName, "")
        XCTAssertEqual(viewModel.userEmail, "")
        XCTAssertEqual(viewModel.userPhone, "")
        XCTAssertEqual(viewModel.userCountry, "")
        XCTAssertEqual(viewModel.userCity, "")
        XCTAssertEqual(viewModel.userState, "")
        XCTAssertEqual(viewModel.userPostalCode, "")
        XCTAssertEqual(viewModel.userAddress, "")
    }

    func testFormattedTotal() {
        UserDefaults.standard.set("500", forKey: "cartTotalAmount")
        XCTAssertEqual(viewModel.formattedTotal, "$500")
    }

    func testFormattedTotalEmpty() {
        let formatted = viewModel.formattedTotal
        XCTAssertTrue(formatted.hasPrefix("$"))
    }

    func testSelectPaymentMethodBkash() {
        viewModel.selectPaymentMethod(.bkash)
        XCTAssertTrue(viewModel.bkashChecked)
        XCTAssertFalse(viewModel.rocketChecked)
        XCTAssertFalse(viewModel.cashOnDeliveryChecked)
    }

    func testSelectPaymentMethodRocket() {
        viewModel.selectPaymentMethod(.rocket)
        XCTAssertFalse(viewModel.bkashChecked)
        XCTAssertTrue(viewModel.rocketChecked)
        XCTAssertFalse(viewModel.cashOnDeliveryChecked)
    }

    func testSelectPaymentMethodCashOnDelivery() {
        viewModel.selectPaymentMethod(.cashOnDelivery)
        XCTAssertFalse(viewModel.bkashChecked)
        XCTAssertFalse(viewModel.rocketChecked)
        XCTAssertTrue(viewModel.cashOnDeliveryChecked)
    }

    func testSelectPaymentMethodNone() {
        viewModel.selectPaymentMethod(.bkash)
        viewModel.selectPaymentMethod(.none)
        XCTAssertFalse(viewModel.bkashChecked)
        XCTAssertFalse(viewModel.rocketChecked)
        XCTAssertFalse(viewModel.cashOnDeliveryChecked)
    }

    func testToggleBkashOn() {
        viewModel.toggleBkash()
        XCTAssertTrue(viewModel.bkashChecked)
    }

    func testToggleBkashOff() {
        viewModel.toggleBkash()
        viewModel.toggleBkash()
        XCTAssertFalse(viewModel.bkashChecked)
    }

    func testToggleRocketOn() {
        viewModel.toggleRocket()
        XCTAssertTrue(viewModel.rocketChecked)
    }

    func testToggleRocketOff() {
        viewModel.toggleRocket()
        viewModel.toggleRocket()
        XCTAssertFalse(viewModel.rocketChecked)
    }

    func testToggleCashOnDeliveryOn() {
        viewModel.toggleCashOnDelivery()
        XCTAssertTrue(viewModel.cashOnDeliveryChecked)
    }

    func testToggleCashOnDeliveryOff() {
        viewModel.toggleCashOnDelivery()
        viewModel.toggleCashOnDelivery()
        XCTAssertFalse(viewModel.cashOnDeliveryChecked)
    }

    func testToggleBkashDeselectsOthers() {
        viewModel.selectPaymentMethod(.rocket)
        viewModel.toggleBkash()
        XCTAssertTrue(viewModel.bkashChecked)
        XCTAssertFalse(viewModel.rocketChecked)
    }

    func testIsPaymentMethodSelectedFalse() {
        UserDefaults.standard.set("", forKey: "paymentMethodUsed")
        XCTAssertFalse(viewModel.isPaymentMethodSelected)
    }

    func testIsPaymentMethodSelectedTrue() {
        viewModel.selectPaymentMethod(.bkash)
        XCTAssertTrue(viewModel.isPaymentMethodSelected)
    }

    func testFinishCheckout() {
        let item = Item()
        item.ID = 1
        item.price = 100
        cart.addItem(item)
        viewModel.selectPaymentMethod(.bkash)
        _ = cart.total()

        viewModel.finishCheckout()

        XCTAssertEqual(UserDefaults.standard.string(forKey: "cartTotalAmount"), "")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "paymentMethodUsed"), "")
        XCTAssertTrue(cart.itemsInCart().isEmpty)
    }

    func testSetPDFFilePath() {
        viewModel.setPDFFilePath("/tmp/test.pdf")
        XCTAssertEqual(viewModel.pdfFilePath, "/tmp/test.pdf")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "pdfFilePath"), "/tmp/test.pdf")
    }

    func testCartItems() {
        let item = Item()
        item.ID = 1
        item.price = 100
        cart.addItem(item)
        XCTAssertEqual(viewModel.cartItems.count, 1)
    }

    func testCartItemsEmpty() {
        XCTAssertTrue(viewModel.cartItems.isEmpty)
    }

    func testPaymentMethodEnum() {
        XCTAssertEqual(CheckOutViewModel.PaymentMethod.bkash.rawValue, "Bkash")
        XCTAssertEqual(CheckOutViewModel.PaymentMethod.rocket.rawValue, "Rocket")
        XCTAssertEqual(CheckOutViewModel.PaymentMethod.cashOnDelivery.rawValue, "Cash On Delivery")
        XCTAssertEqual(CheckOutViewModel.PaymentMethod.none.rawValue, "")
    }

    func testSelectPaymentMethodSavesToDefaults() {
        viewModel.selectPaymentMethod(.bkash)
        XCTAssertEqual(UserDefaults.standard.string(forKey: "paymentMethodUsed"), "Bkash")
    }

    func testGetHTMLString() {
        let htmlString = viewModel.getHTMLString()
        XCTAssertNotNil(htmlString)
    }

    func testInitialPaymentState() {
        XCTAssertFalse(viewModel.bkashChecked)
        XCTAssertFalse(viewModel.rocketChecked)
        XCTAssertFalse(viewModel.cashOnDeliveryChecked)
    }

    func testInitialPDFFilePath() {
        XCTAssertEqual(viewModel.pdfFilePath, "")
    }
}
