import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class ThankYouViewModelTests: XCTestCase {

    var viewModel: ThankYouViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ThankYouViewModel()
        UserDefaults.standard.removeObject(forKey: "pdfFilePath")
        UserDefaults.standard.removeObject(forKey: "SessionLoggedInuserEmail")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "pdfFilePath")
        UserDefaults.standard.removeObject(forKey: "SessionLoggedInuserEmail")
        viewModel = nil
        super.tearDown()
    }

    func testPdfFilePathDefault() {
        XCTAssertEqual(viewModel.pdfFilePath, "")
    }

    func testPdfFilePathSet() {
        UserDefaults.standard.set("/path/to/invoice.pdf", forKey: "pdfFilePath")
        XCTAssertEqual(viewModel.pdfFilePath, "/path/to/invoice.pdf")
    }

    func testUserEmailDefault() {
        XCTAssertEqual(viewModel.userEmail, "")
    }

    func testUserEmailSet() {
        UserDefaults.standard.set("test@example.com", forKey: "SessionLoggedInuserEmail")
        XCTAssertEqual(viewModel.userEmail, "test@example.com")
    }

    func testPdfFileURL() {
        UserDefaults.standard.set("/tmp/test.pdf", forKey: "pdfFilePath")
        let url = viewModel.pdfFileURL
        XCTAssertEqual(url.path, "/tmp/test.pdf")
    }

    func testPdfFileURLWithEmptyPath() {
        let url = viewModel.pdfFileURL
        XCTAssertNotNil(url)
    }

    func testPdfFileURLIsFileURL() {
        UserDefaults.standard.set("/documents/invoice.pdf", forKey: "pdfFilePath")
        XCTAssertTrue(viewModel.pdfFileURL.isFileURL)
    }
}
