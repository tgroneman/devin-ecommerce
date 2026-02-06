import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class AccountCRUDViewModelTests: XCTestCase {

    var viewModel: AccountCRUDViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AccountCRUDViewModel()
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        viewModel = nil
        super.tearDown()
    }

    func testValidationHelper() {
        XCTAssertNotNil(viewModel.validationHelper)
        XCTAssertTrue(viewModel.validationHelper is Validation)
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
            "firstName": "Jane",
            "lastName": "Smith",
            "usersEmail": "jane@example.com",
            "phone": "5551234567",
            "country": "Canada",
            "state": "Ontario",
            "city": "Toronto",
            "postalCode": "M5H 2N2",
            "address": "456 Elm St"
        ]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        viewModel.loadUserData()

        XCTAssertEqual(viewModel.editFirstName, "Jane")
        XCTAssertEqual(viewModel.editLastName, "Smith")
        XCTAssertEqual(viewModel.editEmail, "jane@example.com")
        XCTAssertEqual(viewModel.editPhone, "5551234567")
        XCTAssertEqual(viewModel.editCountry, "Canada")
        XCTAssertEqual(viewModel.editState, "Ontario")
        XCTAssertEqual(viewModel.editCity, "Toronto")
        XCTAssertEqual(viewModel.editPostalCode, "M5H 2N2")
        XCTAssertEqual(viewModel.editAddress, "456 Elm St")
    }

    func testLoadUserDataNoData() {
        viewModel.loadUserData()
        XCTAssertEqual(viewModel.editFirstName, "")
        XCTAssertEqual(viewModel.editLastName, "")
        XCTAssertEqual(viewModel.editEmail, "")
        XCTAssertEqual(viewModel.editPhone, "")
        XCTAssertEqual(viewModel.editCountry, "")
        XCTAssertEqual(viewModel.editState, "")
        XCTAssertEqual(viewModel.editCity, "")
        XCTAssertEqual(viewModel.editPostalCode, "")
        XCTAssertEqual(viewModel.editAddress, "")
    }

    func testValidateEmailValid() {
        XCTAssertTrue(viewModel.validateEmail("test@example.com"))
    }

    func testValidateEmailInvalid() {
        XCTAssertFalse(viewModel.validateEmail("notanemail"))
    }

    func testAccountOps() {
        XCTAssertNotNil(viewModel.accountOps)
        XCTAssertTrue(viewModel.accountOps is AccountOperations)
    }

    func testEncryptPassword() {
        let encrypted = viewModel.encryptPassword("mypassword")
        XCTAssertFalse(encrypted.isEmpty)
        XCTAssertEqual(encrypted.count, 40)
    }

    func testEncryptPasswordConsistency() {
        let e1 = viewModel.encryptPassword("abc")
        let e2 = viewModel.encryptPassword("abc")
        XCTAssertEqual(e1, e2)
    }

    func testStoredUserEmail() {
        let userData: [String: Any] = ["usersEmail": "stored@example.com"]
        UserDefaults.standard.set(userData, forKey: "LoggedInUsersDetail")
        viewModel.loadUserData()
        XCTAssertEqual(viewModel.storedUserEmail, "stored@example.com")
    }

    func testStoredUserEmailNoData() {
        viewModel.loadUserData()
        XCTAssertEqual(viewModel.storedUserEmail, "")
    }

    func testUserDataIsNilInitially() {
        XCTAssertNil(viewModel.userData)
    }
}
