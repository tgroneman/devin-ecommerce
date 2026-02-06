import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class ItemTests: XCTestCase {

    var item: Item!

    override func setUp() {
        super.setUp()
        item = Item()
    }

    override func tearDown() {
        item = nil
        super.tearDown()
    }

    func testDefaultValues() {
        XCTAssertEqual(item.itemName, "")
        XCTAssertEqual(item.photoURL, "")
        XCTAssertEqual(item.quality, "")
        XCTAssertEqual(item.itemCategory, "")
        XCTAssertEqual(item.brand, "")
        XCTAssertEqual(item.price, 0)
        XCTAssertEqual(item.sale, 0)
        XCTAssertEqual(item.ID, 0)
        XCTAssertEqual(item.cartAddedQuantity, 0)
    }

    func testSetProperties() {
        item.itemName = "Test Product"
        item.photoURL = "https://example.com/photo.jpg"
        item.quality = "High Quality"
        item.itemCategory = "Television"
        item.brand = "Samsung"
        item.price = 599.99
        item.sale = 1
        item.ID = 42
        item.cartAddedQuantity = 3

        XCTAssertEqual(item.itemName, "Test Product")
        XCTAssertEqual(item.photoURL, "https://example.com/photo.jpg")
        XCTAssertEqual(item.quality, "High Quality")
        XCTAssertEqual(item.itemCategory, "Television")
        XCTAssertEqual(item.brand, "Samsung")
        XCTAssertEqual(item.price, 599.99)
        XCTAssertEqual(item.sale, 1)
        XCTAssertEqual(item.ID, 42)
        XCTAssertEqual(item.cartAddedQuantity, 3)
    }

    func testIsNSObject() {
        XCTAssertTrue(item is NSObject)
    }

    func testMultipleItems() {
        let item2 = Item()
        item.itemName = "Item A"
        item2.itemName = "Item B"
        XCTAssertNotEqual(item.itemName, item2.itemName)
    }

    func testPriceCalculation() {
        item.price = 100.50
        item.cartAddedQuantity = 3
        let total = item.price * item.cartAddedQuantity
        XCTAssertEqual(total, 301.50)
    }

    func testSaleAsNSNumber() {
        item.sale = NSNumber(value: 1)
        XCTAssertEqual(item.sale.intValue, 1)
        XCTAssertTrue(item.sale.boolValue)

        item.sale = NSNumber(value: 0)
        XCTAssertEqual(item.sale.intValue, 0)
        XCTAssertFalse(item.sale.boolValue)
    }

    func testIDAsNSNumber() {
        item.ID = NSNumber(value: 99)
        XCTAssertEqual(item.ID.intValue, 99)
        XCTAssertEqual(item.ID.stringValue, "99")
    }
}
