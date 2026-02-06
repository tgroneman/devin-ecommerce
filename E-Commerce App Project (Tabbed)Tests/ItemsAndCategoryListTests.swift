import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class ItemsTests: XCTestCase {

    func testSharedInstance() {
        let instance = Items.sharedInstance
        XCTAssertNotNil(instance)
    }

    func testSharedInstanceIsSameObject() {
        let a = Items.sharedInstance
        let b = Items.sharedInstance
        XCTAssertTrue(a === b)
    }

    func testAllItemsNotEmpty() {
        let items = Items.sharedInstance.allItems
        XCTAssertFalse(items.isEmpty)
    }

    func testAllItemsAreItems() {
        let items = Items.sharedInstance.allItems
        for item in items {
            XCTAssertFalse(item.itemName.isEmpty)
        }
    }

    func testAllItemsHaveCategory() {
        let items = Items.sharedInstance.allItems
        for item in items {
            XCTAssertFalse(item.itemCategory.isEmpty)
        }
    }

    func testAllItemsHavePrice() {
        let items = Items.sharedInstance.allItems
        for item in items {
            XCTAssertGreaterThan(item.price, 0)
        }
    }

    func testAllItemsHaveID() {
        let items = Items.sharedInstance.allItems
        for item in items {
            XCTAssertGreaterThan(item.ID.intValue, 0)
        }
    }

    func testAllItemsHaveBrand() {
        let items = Items.sharedInstance.allItems
        for item in items {
            XCTAssertFalse(item.brand.isEmpty)
        }
    }

    func testAllItemsHavePhotoURL() {
        let items = Items.sharedInstance.allItems
        for item in items {
            XCTAssertFalse(item.photoURL.isEmpty)
        }
    }

    func testItemCategories() {
        let items = Items.sharedInstance.allItems
        let categories = Set(items.map { $0.itemCategory })
        XCTAssertTrue(categories.contains("Television"))
        XCTAssertTrue(categories.contains("Laptops"))
        XCTAssertTrue(categories.contains("Desktop"))
        XCTAssertTrue(categories.contains("Mobile"))
        XCTAssertTrue(categories.contains("Tablet"))
    }

    func testItemCount() {
        let items = Items.sharedInstance.allItems
        XCTAssertGreaterThan(items.count, 0)
    }

    func testAllItemsHaveNonZeroPrice() {
        let items = Items.sharedInstance.allItems
        for item in items {
            XCTAssertGreaterThanOrEqual(item.price, 0)
        }
    }
}

class CategoryItemListTests: XCTestCase {

    func testSharedInstance() {
        let instance = CategoryItemList.sharedInstance
        XCTAssertNotNil(instance)
    }

    func testSharedInstanceIsSameObject() {
        let a = CategoryItemList.sharedInstance
        let b = CategoryItemList.sharedInstance
        XCTAssertTrue(a === b)
    }

    func testTVCategoryNotEmpty() {
        let catList = CategoryItemList.sharedInstance
        XCTAssertFalse(catList.tvCategoryItemsList.isEmpty)
    }

    func testLaptopCategoryNotEmpty() {
        let catList = CategoryItemList.sharedInstance
        XCTAssertFalse(catList.laptopCategoryItemsList.isEmpty)
    }

    func testDesktopCategoryNotEmpty() {
        let catList = CategoryItemList.sharedInstance
        XCTAssertFalse(catList.desktopCategoryItemsList.isEmpty)
    }

    func testMobileCategoryNotEmpty() {
        let catList = CategoryItemList.sharedInstance
        XCTAssertFalse(catList.mobileCategoryItemsList.isEmpty)
    }

    func testTabletCategoryNotEmpty() {
        let catList = CategoryItemList.sharedInstance
        XCTAssertFalse(catList.tabletCategoryItemsList.isEmpty)
    }

    func testTVCategoryItemsHaveCorrectCategory() {
        let catList = CategoryItemList.sharedInstance
        for item in catList.tvCategoryItemsList {
            XCTAssertEqual(item.itemCategory, "Television")
        }
    }

    func testLaptopCategoryItemsHaveCorrectCategory() {
        let catList = CategoryItemList.sharedInstance
        for item in catList.laptopCategoryItemsList {
            XCTAssertEqual(item.itemCategory, "Laptops")
        }
    }

    func testDesktopCategoryItemsHaveCorrectCategory() {
        let catList = CategoryItemList.sharedInstance
        for item in catList.desktopCategoryItemsList {
            XCTAssertEqual(item.itemCategory, "Desktop")
        }
    }

    func testMobileCategoryItemsHaveCorrectCategory() {
        let catList = CategoryItemList.sharedInstance
        for item in catList.mobileCategoryItemsList {
            XCTAssertEqual(item.itemCategory, "Mobile")
        }
    }

    func testTabletCategoryItemsHaveCorrectCategory() {
        let catList = CategoryItemList.sharedInstance
        for item in catList.tabletCategoryItemsList {
            XCTAssertEqual(item.itemCategory, "Tablet")
        }
    }

    func testAllCategoryItemsCoverAllItems() {
        let catList = CategoryItemList.sharedInstance
        let totalCategorized = catList.tvCategoryItemsList.count
            + catList.laptopCategoryItemsList.count
            + catList.desktopCategoryItemsList.count
            + catList.mobileCategoryItemsList.count
            + catList.tabletCategoryItemsList.count
        let allItems = Items.sharedInstance.allItems.count
        XCTAssertEqual(totalCategorized, allItems)
    }

    func testCategoryItemsAreItemObjects() {
        let catList = CategoryItemList.sharedInstance
        for item in catList.tvCategoryItemsList {
            XCTAssertFalse(item.itemName.isEmpty)
            XCTAssertGreaterThan(item.price, 0)
        }
    }
}
