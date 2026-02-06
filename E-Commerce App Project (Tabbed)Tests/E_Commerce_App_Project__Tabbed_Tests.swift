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
    }

    func testCategoryItemListSharedInstance() {
        let instance = CategoryItemList.sharedInstance
        XCTAssertNotNil(instance)
    }

    func testShoppingCartSharedInstance() {
        let instance = ShoppingCart.sharedInstance
        XCTAssertNotNil(instance)
    }

    func testAccountOperationsSharedInstance() {
        let instance = AccountOperations.sharedInstance
        XCTAssertNotNil(instance)
    }

    func testItemsAllItemsIsArray() {
        let items = Items.sharedInstance.allItems
        XCTAssertNotNil(items)
    }

    func testCategoryItemListHasCategories() {
        let catList = CategoryItemList.sharedInstance
        XCTAssertNotNil(catList.tvCategoryItemsList)
        XCTAssertNotNil(catList.laptopCategoryItemsList)
        XCTAssertNotNil(catList.mobileCategoryItemsList)
        XCTAssertNotNil(catList.desktopCategoryItemsList)
        XCTAssertNotNil(catList.tabletCategoryItemsList)
    }
}
