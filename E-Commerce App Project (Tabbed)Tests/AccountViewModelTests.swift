import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class AccountViewModelTests: XCTestCase {

    var viewModel: AccountViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AccountViewModel()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "SessionLoggedInuserEmail")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "SessionLoggedInuserEmail")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
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
            "firstName": "Alice",
            "lastName": "Wonder",
            "usersEmail": "alice@example.com",
            "phone": "9876543210",
            "country": "UK",
            "state": "London",
            "city": "London",
            "postalCode": "SW1A 1AA",
            "address": "10 Downing St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        viewModel.loadUserData()

        XCTAssertEqual(viewModel.userFirstName, "Alice")
        XCTAssertEqual(viewModel.userLastName, "Wonder")
        XCTAssertEqual(viewModel.userEmail, "alice@example.com")
        XCTAssertEqual(viewModel.userPhone, "9876543210")
        XCTAssertEqual(viewModel.userCountry, "UK")
        XCTAssertEqual(viewModel.userState, "London")
        XCTAssertEqual(viewModel.userCity, "London")
        XCTAssertEqual(viewModel.userPostalCode, "SW1A 1AA")
        XCTAssertEqual(viewModel.userAddress, "10 Downing St")
    }

    func testLoadUserDataEmpty() {
        viewModel.loadUserData()
        XCTAssertEqual(viewModel.userFirstName, "")
        XCTAssertEqual(viewModel.userLastName, "")
        XCTAssertEqual(viewModel.userEmail, "")
        XCTAssertEqual(viewModel.userPhone, "")
        XCTAssertEqual(viewModel.userCountry, "")
        XCTAssertEqual(viewModel.userState, "")
        XCTAssertEqual(viewModel.userCity, "")
        XCTAssertEqual(viewModel.userPostalCode, "")
        XCTAssertEqual(viewModel.userAddress, "")
    }

    func testLogout() {
        UserDefaults.standard.set(true, forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.set("user@test.com", forKey: "SessionLoggedInuserEmail")
        UserDefaults.standard.set(["key": "value"], forKey: "LoggedInUsersDetail")

        viewModel.logout()

        XCTAssertFalse(UserDefaults.standard.bool(forKey: "SeesionUserLoggedIN"))
        XCTAssertEqual(UserDefaults.standard.string(forKey: "SessionLoggedInuserEmail"), "")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "LoggedInUsersDetail"), "")
    }

    func testLogoutWhenAlreadyLoggedOut() {
        UserDefaults.standard.set(false, forKey: "SeesionUserLoggedIN")
        viewModel.logout()
        XCTAssertFalse(UserDefaults.standard.bool(forKey: "SeesionUserLoggedIN"))
    }

    func testUserDataIsNilInitially() {
        XCTAssertNil(viewModel.userData)
    }

    func testLoadUserDataPartialData() {
        let userData: [String: Any] = ["firstName": "Bob"]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        viewModel.loadUserData()
        XCTAssertEqual(viewModel.userFirstName, "Bob")
        XCTAssertEqual(viewModel.userLastName, "")
        XCTAssertEqual(viewModel.userEmail, "")
    }
}
