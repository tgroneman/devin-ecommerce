import XCTest
@testable import E_Commerce_App_Project__Tabbed_

class SingleItemViewModelTests: XCTestCase {

    var viewModel: SingleItemViewModel!
    var cart: ShoppingCart!

    override func setUp() {
        super.setUp()
        cart = ShoppingCart.sharedInstance
        cart.clearCart()
        viewModel = SingleItemViewModel()
    }

    override func tearDown() {
        cart.clearCart()
        viewModel = nil
        super.tearDown()
    }

    private func makeItem(id: Int = 1, name: String = "Test Product", price: Double = 299.99) -> Item {
        let item = Item()
        item.ID = NSNumber(value: id)
        item.itemName = name
        item.price = price
        item.itemCategory = "Television"
        item.brand = "Samsung"
        item.quality = "HD"
        item.photoURL = "https://example.com/photo.jpg"
        item.cartAddedQuantity = 0
        return item
    }

    func testConfigureWithItem() {
        let item = makeItem()
        viewModel.configure(with: item)
        XCTAssertEqual(viewModel.itemName, "Test Product")
        XCTAssertEqual(viewModel.itemCategory, "Television")
        XCTAssertEqual(viewModel.itemBrand, "Samsung")
        XCTAssertEqual(viewModel.itemQuality, "HD")
        XCTAssertEqual(viewModel.itemID, NSNumber(value: 1))
        XCTAssertEqual(viewModel.itemPrice, NSNumber(value: 299.99))
    }

    func testIsInCartFalse() {
        let item = makeItem()
        viewModel.configure(with: item)
        XCTAssertFalse(viewModel.isInCart)
    }

    func testIsInCartTrue() {
        let item = makeItem()
        viewModel.configure(with: item)
        viewModel.addToCart()
        XCTAssertTrue(viewModel.isInCart)
    }

    func testAddToCart() {
        let item = makeItem()
        viewModel.configure(with: item)
        viewModel.addToCart()
        XCTAssertEqual(item.cartAddedQuantity, 1)
        XCTAssertTrue(cart.containsItem(item))
    }

    func testAddToCartMultipleTimes() {
        let item = makeItem()
        viewModel.configure(with: item)
        viewModel.addToCart()
        viewModel.addToCart()
        XCTAssertEqual(item.cartAddedQuantity, 2)
    }

    func testRemoveFromCart() {
        let item = makeItem()
        viewModel.configure(with: item)
        viewModel.addToCart()
        viewModel.addToCart()
        viewModel.removeFromCart()
        XCTAssertEqual(item.cartAddedQuantity, 1)
    }

    func testFormatPriceWithValue() {
        let result = viewModel.formatPrice(NSNumber(value: 599.99))
        XCTAssertEqual(result, "$599.99")
    }

    func testFormatPriceWithNil() {
        let result = viewModel.formatPrice(nil)
        XCTAssertEqual(result, "$0")
    }

    func testFormatPriceZero() {
        let result = viewModel.formatPrice(NSNumber(value: 0))
        XCTAssertEqual(result, "$0")
    }

    func testFormattedPrice() {
        let item = makeItem(price: 499.99)
        viewModel.configure(with: item)
        XCTAssertEqual(viewModel.formattedPrice, "$499.99")
    }

    func testFormattedID() {
        let item = makeItem(id: 42)
        viewModel.configure(with: item)
        XCTAssertEqual(viewModel.formattedID, "42")
    }

    func testFormattedIDBeforeConfigure() {
        XCTAssertEqual(viewModel.formattedID, "")
    }

    func testItemObjectIsSet() {
        let item = makeItem()
        viewModel.configure(with: item)
        XCTAssertTrue(viewModel.itemObject === item)
    }

    func testConfigureWithDifferentItems() {
        let item1 = makeItem(id: 1, name: "Item A", price: 100)
        let item2 = makeItem(id: 2, name: "Item B", price: 200)

        viewModel.configure(with: item1)
        XCTAssertEqual(viewModel.itemName, "Item A")

        viewModel.configure(with: item2)
        XCTAssertEqual(viewModel.itemName, "Item B")
        XCTAssertEqual(viewModel.itemPrice, NSNumber(value: 200))
    }
}
