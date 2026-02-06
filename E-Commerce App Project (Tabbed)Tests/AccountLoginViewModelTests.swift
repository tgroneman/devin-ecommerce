import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class AccountLoginViewModelTests: XCTestCase {

    var viewModel: AccountLoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AccountLoginViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testValidationHelper() {
        let helper = viewModel.validationHelper
        XCTAssertNotNil(helper)
    }

    func testAccountOps() {
        let ops = viewModel.accountOps
        XCTAssertNotNil(ops)
    }

    func testValidateEmailValid() {
        XCTAssertTrue(viewModel.validateEmail("user@example.com"))
    }

    func testValidateEmailInvalid() {
        XCTAssertFalse(viewModel.validateEmail("invalid"))
    }

    func testValidateEmailEmpty() {
        XCTAssertFalse(viewModel.validateEmail(""))
    }

    func testValidateEmailWithSubdomain() {
        XCTAssertTrue(viewModel.validateEmail("user@sub.domain.com"))
    }

    func testEncryptPassword() {
        let encrypted = viewModel.encryptPassword("password123")
        XCTAssertFalse(encrypted.isEmpty)
        XCTAssertEqual(encrypted.count, 40)
    }

    func testEncryptPasswordConsistency() {
        let encrypted1 = viewModel.encryptPassword("test")
        let encrypted2 = viewModel.encryptPassword("test")
        XCTAssertEqual(encrypted1, encrypted2)
    }

    func testEncryptPasswordDifferentInputs() {
        let encrypted1 = viewModel.encryptPassword("password1")
        let encrypted2 = viewModel.encryptPassword("password2")
        XCTAssertNotEqual(encrypted1, encrypted2)
    }

    func testEncryptEmptyPassword() {
        let encrypted = viewModel.encryptPassword("")
        XCTAssertFalse(encrypted.isEmpty)
        XCTAssertEqual(encrypted.count, 40)
    }
}
