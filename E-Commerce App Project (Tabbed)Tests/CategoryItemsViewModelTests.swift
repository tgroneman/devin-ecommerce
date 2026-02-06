import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class CategoryItemsViewModelTests: XCTestCase {

    var viewModel: CategoryItemsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CategoryItemsViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    private func makeItem(id: Int, name: String, price: Double = 100.0) -> Item {
        let item = Item()
        item.ID = NSNumber(value: id)
        item.itemName = name
        item.price = price
        item.itemCategory = "Television"
        return item
    }

    func testInitialState() {
        XCTAssertTrue(viewModel.categoryItemsList.isEmpty)
        XCTAssertEqual(viewModel.categoryName, "")
        XCTAssertEqual(viewModel.numberOfItems, 0)
    }

    func testConfigure() {
        let items = [makeItem(id: 1, name: "A"), makeItem(id: 2, name: "B")]
        viewModel.configure(items: items, name: "Television")
        XCTAssertEqual(viewModel.categoryItemsList.count, 2)
        XCTAssertEqual(viewModel.categoryName, "Television")
    }

    func testNumberOfItems() {
        let items = [makeItem(id: 1, name: "A"), makeItem(id: 2, name: "B"), makeItem(id: 3, name: "C")]
        viewModel.configure(items: items, name: "Test")
        XCTAssertEqual(viewModel.numberOfItems, 3)
    }

    func testItemAtIndex() {
        let items = [makeItem(id: 1, name: "First"), makeItem(id: 2, name: "Second")]
        viewModel.configure(items: items, name: "Test")
        XCTAssertEqual(viewModel.item(at: 0).itemName, "First")
        XCTAssertEqual(viewModel.item(at: 1).itemName, "Second")
    }

    func testFormatPrice() {
        XCTAssertEqual(viewModel.formatPrice(199.99), "$199.99")
    }

    func testFormatPriceZero() {
        XCTAssertEqual(viewModel.formatPrice(0), "$0")
    }

    func testFormatPriceWholeNumber() {
        XCTAssertEqual(viewModel.formatPrice(100), "$100")
    }

    func testConfigureEmptyItems() {
        viewModel.configure(items: [], name: "Empty")
        XCTAssertEqual(viewModel.numberOfItems, 0)
        XCTAssertEqual(viewModel.categoryName, "Empty")
    }

    func testReconfigure() {
        let items1 = [makeItem(id: 1, name: "A")]
        viewModel.configure(items: items1, name: "First")
        XCTAssertEqual(viewModel.numberOfItems, 1)

        let items2 = [makeItem(id: 2, name: "B"), makeItem(id: 3, name: "C")]
        viewModel.configure(items: items2, name: "Second")
        XCTAssertEqual(viewModel.numberOfItems, 2)
        XCTAssertEqual(viewModel.categoryName, "Second")
    }
}
