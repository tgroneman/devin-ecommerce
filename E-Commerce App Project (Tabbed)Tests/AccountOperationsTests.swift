import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class AccountOperationsTests: XCTestCase {

    var accountOps: AccountOperations!

    override func setUp() {
        super.setUp()
        accountOps = AccountOperations()
    }

    override func tearDown() {
        accountOps = nil
        UserDefaults.standard.removeObject(forKey: "SeesionUserLoggedIN")
        UserDefaults.standard.removeObject(forKey: "SessionLoggedInuserEmail")
        UserDefaults.standard.removeObject(forKey: "LoggedInUsersDetail")
        super.tearDown()
    }

    func testSharedInstance() {
        let instance1 = AccountOperations.sharedInstance
        let instance2 = AccountOperations.sharedInstance
        XCTAssertTrue(instance1 === instance2)
    }

    func testSha1KnownValue() {
        let result = accountOps.sha1("hello")
        XCTAssertEqual(result, "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d")
    }

    func testSha1EmptyString() {
        let result = accountOps.sha1("")
        XCTAssertEqual(result, "da39a3ee5e6b4b0d3255bfef95601890afd80709")
    }

    func testSha1Password() {
        let result = accountOps.sha1("password123")
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 40)
    }

    func testSha1DifferentInputs() {
        let result1 = accountOps.sha1("test1")
        let result2 = accountOps.sha1("test2")
        XCTAssertNotEqual(result1, result2)
    }

    func testSha1Consistency() {
        let result1 = accountOps.sha1("consistent")
        let result2 = accountOps.sha1("consistent")
        XCTAssertEqual(result1, result2)
    }

    func testValidateEmailValid() {
        XCTAssertTrue(accountOps.validateEmailAccount("user@example.com"))
        XCTAssertTrue(accountOps.validateEmailAccount("test.user@domain.org"))
        XCTAssertTrue(accountOps.validateEmailAccount("a@b.co"))
    }

    func testValidateEmailInvalid() {
        XCTAssertFalse(accountOps.validateEmailAccount(""))
        XCTAssertFalse(accountOps.validateEmailAccount("notanemail"))
        XCTAssertFalse(accountOps.validateEmailAccount("@domain.com"))
        XCTAssertFalse(accountOps.validateEmailAccount("user@"))
        XCTAssertFalse(accountOps.validateEmailAccount("user@.com"))
    }

    func testValidateEmailEdgeCases() {
        XCTAssertTrue(accountOps.validateEmailAccount("user+tag@example.com"))
        XCTAssertTrue(accountOps.validateEmailAccount("first.last@sub.domain.com"))
    }

    func testGetURLSession() {
        let session = accountOps.getURLSession()
        XCTAssertNotNil(session)
    }

    func testGetURLSessionReturnsSameInstance() {
        let session1 = accountOps.getURLSession()
        let session2 = accountOps.getURLSession()
        XCTAssertTrue(session1 === session2)
    }

    func testSendRequestToServerWithInvalidData() {
        let expectation = self.expectation(description: "Callback should be called")

        let invalidData: [String: Any] = [:]
        accountOps.sendRequestToServer(invalidData) { error, success, message in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testSha1SpecialCharacters() {
        let result = accountOps.sha1("!@#$%^&*()")
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 40)
    }

    func testSha1LongString() {
        let longString = String(repeating: "a", count: 1000)
        let result = accountOps.sha1(longString)
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 40)
    }

    func testSha1UnicodeString() {
        let result = accountOps.sha1("Hello world")
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 40)
    }

    func testIsNSObject() {
        XCTAssertNotNil(accountOps as AnyObject)
    }
}
