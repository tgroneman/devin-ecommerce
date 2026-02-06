import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class SaleViewModelTests: XCTestCase {

    var viewModel: SaleViewModel!

    override func setUp() {
        super.setUp()
        viewModel = SaleViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testInitialSaleItemsEmpty() {
        XCTAssertTrue(viewModel.saleItemsList.isEmpty)
    }

    func testLoadSaleItems() {
        viewModel.loadSaleItems()
        XCTAssertTrue(viewModel.saleItemsList is [Item])
    }

    func testNumberOfSaleItemsBeforeLoad() {
        XCTAssertEqual(viewModel.numberOfSaleItems, 0)
    }

    func testNumberOfSaleItemsAfterLoad() {
        viewModel.loadSaleItems()
        XCTAssertEqual(viewModel.numberOfSaleItems, viewModel.saleItemsList.count)
    }

    func testSaleItemsHaveSaleFlag() {
        viewModel.loadSaleItems()
        for item in viewModel.saleItemsList {
            XCTAssertNotEqual(item.sale.intValue, 0)
        }
    }

    func testItemAtIndex() {
        viewModel.loadSaleItems()
        if viewModel.numberOfSaleItems > 0 {
            let item = viewModel.item(at: 0)
            XCTAssertNotNil(item)
            XCTAssertTrue(item is Item)
        }
    }

    func testFormatPrice() {
        let result = viewModel.formatPrice(299.99)
        XCTAssertEqual(result, "$299.99")
    }

    func testFormatPriceZero() {
        let result = viewModel.formatPrice(0)
        XCTAssertEqual(result, "$0")
    }

    func testFormatPriceWholeNumber() {
        let result = viewModel.formatPrice(500)
        XCTAssertEqual(result, "$500")
    }

    func testLoadSaleItemsMultipleTimes() {
        viewModel.loadSaleItems()
        let firstCount = viewModel.numberOfSaleItems
        viewModel.loadSaleItems()
        let secondCount = viewModel.numberOfSaleItems
        XCTAssertEqual(firstCount, secondCount)
    }
}
