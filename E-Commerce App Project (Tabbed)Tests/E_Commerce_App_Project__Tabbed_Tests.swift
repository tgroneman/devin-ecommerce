import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class E_Commerce_App_Project__Tabbed_Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testItemsSharedInstance() {
        let instance = Items.sharedInstance
        XCTAssertNotNil(instance)
        XCTAssertTrue(instance is Items)
    }

    func testCategoryItemListSharedInstance() {
        let instance = CategoryItemList.sharedInstance
        XCTAssertNotNil(instance)
        XCTAssertTrue(instance is CategoryItemList)
    }

    func testShoppingCartSharedInstance() {
        let instance = ShoppingCart.sharedInstance
        XCTAssertNotNil(instance)
        XCTAssertTrue(instance is ShoppingCart)
    }

    func testAccountOperationsSharedInstance() {
        let instance = AccountOperations.sharedInstance
        XCTAssertNotNil(instance)
        XCTAssertTrue(instance is AccountOperations)
    }

    func testItemsAllItemsIsArray() {
        let items = Items.sharedInstance.allItems
        XCTAssertTrue(items is [Item])
    }

    func testCategoryItemListHasCategories() {
        let catList = CategoryItemList.sharedInstance
        XCTAssertTrue(catList.tvCategoryItemsList is [Item])
        XCTAssertTrue(catList.laptopCategoryItemsList is [Item])
        XCTAssertTrue(catList.mobileCategoryItemsList is [Item])
        XCTAssertTrue(catList.desktopCategoryItemsList is [Item])
        XCTAssertTrue(catList.tabletCategoryItemsList is [Item])
    }
}
