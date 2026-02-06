import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = HomeViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testSliderImageNames() {
        XCTAssertEqual(viewModel.sliderImageNames.count, 4)
        XCTAssertEqual(viewModel.sliderImageNames[0], "image1.jpg")
        XCTAssertEqual(viewModel.sliderImageNames[1], "image2.png")
        XCTAssertEqual(viewModel.sliderImageNames[2], "image4.jpg")
        XCTAssertEqual(viewModel.sliderImageNames[3], "image5.jpg")
    }

    func testInitialSliderIndex() {
        XCTAssertEqual(viewModel.sliderIndex, 0)
    }

    func testLoadCategories() {
        viewModel.loadCategories()
        XCTAssertTrue(viewModel.tvCategory is [Item])
        XCTAssertTrue(viewModel.laptopCategoryItemsList is [Item])
        XCTAssertTrue(viewModel.mobileCategoryItemsList is [Item])
        XCTAssertTrue(viewModel.desktopCategoryItemsList is [Item])
        XCTAssertTrue(viewModel.tabletCategoryItemsList is [Item])
    }

    func testNumberOfItemsForTag0() {
        viewModel.loadCategories()
        let count = viewModel.numberOfItems(forCollectionViewTag: 0)
        XCTAssertEqual(count, viewModel.tvCategory.count)
    }

    func testNumberOfItemsForTag1() {
        viewModel.loadCategories()
        let count = viewModel.numberOfItems(forCollectionViewTag: 1)
        XCTAssertEqual(count, viewModel.laptopCategoryItemsList.count)
    }

    func testNumberOfItemsForTag2() {
        viewModel.loadCategories()
        let count = viewModel.numberOfItems(forCollectionViewTag: 2)
        XCTAssertEqual(count, viewModel.desktopCategoryItemsList.count)
    }

    func testNumberOfItemsForTag3() {
        viewModel.loadCategories()
        let count = viewModel.numberOfItems(forCollectionViewTag: 3)
        XCTAssertEqual(count, viewModel.mobileCategoryItemsList.count)
    }

    func testNumberOfItemsForTag4() {
        viewModel.loadCategories()
        let count = viewModel.numberOfItems(forCollectionViewTag: 4)
        XCTAssertEqual(count, viewModel.tabletCategoryItemsList.count)
    }

    func testNumberOfItemsForInvalidTag() {
        viewModel.loadCategories()
        let count = viewModel.numberOfItems(forCollectionViewTag: 99)
        XCTAssertEqual(count, 0)
    }

    func testCategoryNameForTag0() {
        XCTAssertEqual(viewModel.categoryName(forCollectionViewTag: 0), "Television")
    }

    func testCategoryNameForTag1() {
        XCTAssertEqual(viewModel.categoryName(forCollectionViewTag: 1), "Laptop")
    }

    func testCategoryNameForTag2() {
        XCTAssertEqual(viewModel.categoryName(forCollectionViewTag: 2), "Desktop")
    }

    func testCategoryNameForTag3() {
        XCTAssertEqual(viewModel.categoryName(forCollectionViewTag: 3), "Mobile")
    }

    func testCategoryNameForTag4() {
        XCTAssertEqual(viewModel.categoryName(forCollectionViewTag: 4), "Tablet")
    }

    func testCategoryNameForInvalidTag() {
        XCTAssertEqual(viewModel.categoryName(forCollectionViewTag: 99), "")
    }

    func testCategoryItemsForTag0() {
        viewModel.loadCategories()
        let items = viewModel.categoryItems(forCollectionViewTag: 0)
        XCTAssertEqual(items.count, viewModel.tvCategory.count)
    }

    func testCategoryItemsForTag1() {
        viewModel.loadCategories()
        let items = viewModel.categoryItems(forCollectionViewTag: 1)
        XCTAssertEqual(items.count, viewModel.laptopCategoryItemsList.count)
    }

    func testCategoryItemsForTag2() {
        viewModel.loadCategories()
        let items = viewModel.categoryItems(forCollectionViewTag: 2)
        XCTAssertEqual(items.count, viewModel.desktopCategoryItemsList.count)
    }

    func testCategoryItemsForTag3() {
        viewModel.loadCategories()
        let items = viewModel.categoryItems(forCollectionViewTag: 3)
        XCTAssertEqual(items.count, viewModel.mobileCategoryItemsList.count)
    }

    func testCategoryItemsForTag4() {
        viewModel.loadCategories()
        let items = viewModel.categoryItems(forCollectionViewTag: 4)
        XCTAssertEqual(items.count, viewModel.tabletCategoryItemsList.count)
    }

    func testCategoryItemsForInvalidTag() {
        viewModel.loadCategories()
        let items = viewModel.categoryItems(forCollectionViewTag: 99)
        XCTAssertTrue(items.isEmpty)
    }

    func testAdvanceSliderIndex() {
        viewModel.sliderIndex = 0
        viewModel.advanceSliderIndex()
        XCTAssertEqual(viewModel.sliderIndex, 1)
    }

    func testAdvanceSliderIndexWrapsAround() {
        viewModel.sliderIndex = viewModel.sliderImageNames.count - 1
        viewModel.advanceSliderIndex()
        XCTAssertEqual(viewModel.sliderIndex, 0)
    }

    func testAdvanceSliderIndexMiddle() {
        viewModel.sliderIndex = 2
        viewModel.advanceSliderIndex()
        XCTAssertEqual(viewModel.sliderIndex, 3)
    }

    func testFormatPrice() {
        let result = viewModel.formatPrice(599.99)
        XCTAssertEqual(result, "$599.99")
    }

    func testFormatPriceZero() {
        let result = viewModel.formatPrice(0)
        XCTAssertEqual(result, "$0")
    }

    func testFormatPriceWholeNumber() {
        let result = viewModel.formatPrice(100)
        XCTAssertEqual(result, "$100")
    }
}
